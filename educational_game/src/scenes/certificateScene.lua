local sceneManager = require("src.sceneManager")
local themeManager = require("src.themeManager")
local ui = require("src.ui.base")
local button = require("src.ui.button")

local certificateScene = {}
local backBtn

function certificateScene.enter(campaign)
    certificateScene.campaign = campaign or "Luau"
    backBtn = button.new("VOLVER AL MENU", love.graphics.getWidth()/2 - 100, 500, 200, 50, function()
        sceneManager.switch("menu")
    end)
end

function certificateScene.draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.clear(0.1, 0.1, 0.1)

    -- Gold border
    love.graphics.setColor(1, 0.8, 0)
    love.graphics.rectangle("line", 50, 50, w - 100, h - 100, 20)

    ui.title("CERTIFICADO DE COMPLETITUD", w/2 - 200, 150)
    ui.label("Se otorga el presente a un programador excepcional", w/2 - 150, 250)
    ui.label("por completar exitosamente el bootcamp de:", w/2 - 120, 280)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.upper(certificateScene.campaign), w/2 - 50, 320, 0, 2, 2)

    backBtn:draw()
end

function certificateScene.update(dt)
    backBtn:update(love.mouse.getPosition())
end

function certificateScene.mousepressed(x, y, b)
    backBtn:mousepressed(x, y, b)
end

return certificateScene
