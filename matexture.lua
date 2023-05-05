-- matexture

local io = require("io")

local cli = {
    reset = "\27[0m",
    red   = "\27[31m",
    cyan  = "\27[36m"
}

local usage = function()
    print("["..cli.cyan.."usage"..cli.reset.."] gui: 'lua matexture.lua'")
    print("["..cli.cyan.."usage"..cli.reset.."] cli: 'lua matexture.lua 3 3 2'")
end

local err = function(message, show_usage)
    print("["..cli.red.."error"..cli.reset.."] "..message)
    if show_usage then usage() end
    os.exit(1, true)
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
    err("please provide 3 bit counts for color channels, or run the gui version", true)
end

path = path:sub(1, #path - 1).."main.lua"

local fd = io.open(path)
if fd == nil then err("failed to open '"..path.."'") end

fd:close()

fd = io.popen(cmd, "r")
if fd == nil then err("failed to run '"..cmd.."'") end

fd:close()
