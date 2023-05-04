-- matexture (gui)

love.conf = function(t)
    t.identity              = "matexture"
    t.appendidentity        = false

    t.console               = true

    t.accelerometerjoystick = true
    t.audio.mixwithsystem   = true

    t.window.title          = "Untitled"
    t.window.icon           = nil
    t.window.width          = 800
    t.window.height         = 600
    t.window.resizable      = false
    t.window.minwidth       = 1
    t.window.minheight      = 1
    t.window.vsync          = 1
    t.window.msaa           = 0

    t.modules.audio         = false
    t.modules.data          = false
    t.modules.joystick      = false
    t.modules.math          = false
    t.modules.physics       = false
    t.modules.sound         = false
    t.modules.system        = false
    t.modules.thread        = false
    t.modules.timer         = false
    t.modules.touch         = false
    t.modules.video         = false
end
