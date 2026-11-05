-- NEBULA public entry point. The URL tracks the main branch.
local source = game:HttpGet("https://raw.githubusercontent.com/6ixl/nebula-visuals/main/main.lua")
local fn, err = loadstring(source, "NEBULA")
assert(fn, err)
return fn()
