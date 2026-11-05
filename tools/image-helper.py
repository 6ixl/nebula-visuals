"""Local-only image decoder for NEBULA Spray Paint. No game control or code execution."""
from __future__ import annotations
import argparse, http.client, io, ipaddress, json, socket, ssl, threading, warnings, time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlsplit, urljoin, parse_qs, quote
from PIL import Image, ImageOps

PORT=8766
MAX_BYTES=16*1024*1024
Image.MAX_IMAGE_PIXELS=25_000_000
SLOTS=threading.BoundedSemaphore(2)

def public_target(url):
    p=urlsplit(url)
    if p.scheme!='https' or not p.hostname or p.username or p.password or p.port not in (None,443):
        raise ValueError('Нужна прямая HTTPS-ссылка на изображение, без логина и нестандартного порта.')
    records=socket.getaddrinfo(p.hostname,443,type=socket.SOCK_STREAM)
    addresses=list(dict.fromkeys(r[4][0] for r in records))
    if not addresses or any(not ipaddress.ip_address(ip).is_global for ip in addresses):
        raise ValueError('Ссылки на локальные и внутренние адреса не поддерживаются.')
    return p,addresses[0]

def fetch_image(url):
    deadline=time.monotonic()+40
    for _ in range(4):
        p,ip=public_target(url)
        connection=http.client.HTTPSConnection(p.hostname,443,timeout=12,context=ssl.create_default_context())
        # Pin the validated public IP while retaining TLS hostname verification.
        raw=socket.create_connection((ip,443),timeout=12)
        try:
            connection.sock=ssl.create_default_context().wrap_socket(raw,server_hostname=p.hostname)
            path=quote(p.path or "/",safe="/%:@!$&'()*+,;=-._~")
            if p.query:path+="?"+quote(p.query,safe="=&%/:?@!$'()*+,;~-._")
            connection.request('GET',path,headers={'User-Agent':'NEBULA-Image-Helper/1.0','Accept':'image/*','Accept-Encoding':'identity'})
            response=connection.getresponse()
            if response.status in (301,302,303,307,308):
                target=response.getheader('Location')
                if not target:raise ValueError('Пустое перенаправление ссылки.')
                url=urljoin(url,target);continue
            if response.status!=200:raise ValueError('Сайт вернул HTTP '+str(response.status)+'. Нужна прямая ссылка на фото.')
            size=response.getheader('Content-Length')
            if size and int(size)>MAX_BYTES:raise ValueError('Изображение больше 16 МБ.')
            result=bytearray()
            while True:
                if time.monotonic()>deadline:raise ValueError("Сайт слишком долго передаёт изображение.")
                chunk=response.read(65536)
                if not chunk:break
                result.extend(chunk)
                if len(result)>MAX_BYTES:raise ValueError('Изображение больше 16 МБ.')
            return bytes(result)
        finally:
            connection.close();raw.close()
    raise ValueError('Слишком много перенаправлений.')

def make_plan(data,side=64,colors=256,alpha=32):
    if not 2<=side<=128 or colors not in (2,3,4,6,16,256) or not 1<=alpha<=255:
        raise ValueError('Неверное разрешение, палитра или порог прозрачности.')
    with warnings.catch_warnings():
        warnings.simplefilter('error',Image.DecompressionBombWarning)
        with Image.open(io.BytesIO(data))as original:
            if original.width>12000 or original.height>12000:raise ValueError('Сторона изображения больше 12000 пикселей.')
            original.seek(0)
            image=ImageOps.exif_transpose(original).convert('RGBA')
            ratio=min(side/image.width,side/image.height)
            width=max(1,round(image.width*ratio));height=max(1,round(image.height*ratio))
            image=image.resize((width,height),Image.Resampling.LANCZOS)
    def q(v):return int(round(round(v*(colors-1)/255)*255/(colors-1)))
    pixels=[]
    for y in range(height):
        for x in range(width):
            r,g,b,a=image.getpixel((x,y))
            if a>=alpha:pixels.append([x,y,q(r),q(g),q(b)])
    if not pixels:raise ValueError('Нет видимых пикселей при выбранной прозрачности.')
    return {'format':'nebula-spray-1','width':width,'height':height,'pixels':pixels}

class Handler(BaseHTTPRequestHandler):
    def log_message(self,*args):pass
    def send_json(self,status,data):
        body=json.dumps(data,ensure_ascii=False,separators=(',',':')).encode('utf-8')
        self.send_response(status);self.send_header('Content-Type','application/json; charset=utf-8');self.send_header('Content-Length',str(len(body)));self.send_header('Cache-Control','no-store');self.send_header('X-Content-Type-Options','nosniff');self.end_headers();self.wfile.write(body)
    def do_GET(self):
        host=self.headers.get('Host','').split(':')[0]
        if host not in ('127.0.0.1','localhost')or self.headers.get('Origin')or self.headers.get('Sec-Fetch-Site','none')not in ('none','same-origin'):
            self.send_json(403,{'error':'Local native client only'});return
        p=urlsplit(self.path)
        if p.path=='/health':self.send_json(200,{'service':'nebula-image-helper','version':1});return
        if p.path!='/convert':self.send_json(404,{'error':'Unknown endpoint'});return
        if len(self.path)>8192:self.send_json(400,{'error':'Ссылка слишком длинная.'});return
        if not SLOTS.acquire(blocking=False):self.send_json(429,{'error':'Декодер занят. Повтори через несколько секунд.'});return
        try:
            q=parse_qs(p.query);url=q.get('url',[''])[0]
            side=int(q.get('side',['64'])[0]);colors=int(q.get('colors',['256'])[0]);alpha=int(q.get('alpha',['32'])[0])
            if not 2<=side<=128 or colors not in (2,3,4,6,16,256)or not 1<=alpha<=255:raise ValueError('Неверные параметры изображения.')
            plan=make_plan(fetch_image(url),side,colors,alpha);self.send_json(200,plan)
        except Exception as error:
            if isinstance(error,ValueError):message=str(error)
            else:message='Не удалось прочитать изображение. Проверь прямую ссылку и доступность сайта.'
            self.send_json(400,{'error':message})
        finally:SLOTS.release()

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--port',type=int,default=PORT);args=parser.parse_args()
    server=ThreadingHTTPServer(('127.0.0.1',args.port),Handler)
    print('NEBULA Image Helper',flush=True)
    print('Работает только локально: http://127.0.0.1:'+str(args.port),flush=True)
    print('Вставь HTTPS-ссылку на фото в модуль Spray Paint. Для остановки закрой это окно или нажми Ctrl+C.',flush=True)
    try:server.serve_forever()
    except KeyboardInterrupt:pass
    finally:server.server_close()
if __name__=='__main__':main()
