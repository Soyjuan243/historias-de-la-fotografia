local sceneManager = require("sceneManager")
local themeManager = require("themeManager")
local ui = require("ui_base")
local button = require("ui_button")

local menuScene = {}
local buttons = {}

function menuScene.enter()
    local cx, cy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    buttons = {}
    table.insert(buttons, button.new("INICIAR AVENTURA", cx - 100, cy, 200, 50, function()
        sceneManager.switch("campaignSelect")
    end))
    table.insert(buttons, button.new("SALIR", cx - 100, cy + 70, 200, 50, function()
        love.event.quit()
    end))
end

function menuScene.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, b in ipairs(buttons) do
        b:update(mx, my)
    end
end

function menuScene.draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- Background gradient or simple color
    love.graphics.clear(0.05, 0.05, 0.1)

    ui.title("PLATAFORMA EDUCATIVA INTERACTIVA", w/2 - 250, h/4)
    ui.label("Domina Luau y C# desde cero", w/2 - 100, h/4 + 40)

    for _, b in ipairs(buttons) do
        b:draw()
    end
end

function menuScene.mousepressed(x, y, btn)
    for _, b in ipairs(buttons) do
        if b:mousepressed(x, y, btn) then break end
    end
end

return menuScene
