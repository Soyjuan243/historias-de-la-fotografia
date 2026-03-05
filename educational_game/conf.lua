function love.conf(t)
    t.window.title = "Educational Platform - Learn Luau & C#"
    t.window.width = 1280
    t.window.height = 720
    t.window.resizable = true
    t.window.minwidth = 800
    t.window.minheight = 600

    t.identity = "educational_platform_pro"

    -- Performance and graphics
    t.window.vsync = 1
    t.window.msaa = 4

    -- Modules
    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = false
    t.modules.window = true
end
