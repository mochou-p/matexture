-- matexture

local io = require("io")

local cli = {
    reset = "\27[0m",
    red   = "\27[31m",
    green = "\27[32m",
    cyan  = "\27[36m"
}

local err = function(message)
    print("["..cli.red.."error"..cli.reset.."] "..message)
end

local usage = function()
    print("["..cli.cyan.."usage"..cli.reset.."] gui: 'lua matexture.lua'")
    print("["..cli.cyan.."usage"..cli.reset.."] cli: 'lua matexture.lua 3 3 2'")
end

local path = ""
local cmd  = "love "

if #arg == 0 then
    path = "gui/."
    cmd  = cmd..path
elseif #arg == 3 then
    path = "cli/."
    cmd  = cmd..path.." "..arg[1].." "..arg[2].." "..arg[3]
else
    err("please provide 3 bit counts for color channels, or run the gui version")
    usage()
    return
end

path = path:sub(1, #path - 1).."main.lua"

local fd = io.open(path)

if fd == nil then
    err("failed to open '"..path.."'")
    return
end

fd:close()

fd = io.popen(cmd, "r")

if fd == nil then
    err("failed to run '"..cmd.."'")
    return
end

fd:close()
