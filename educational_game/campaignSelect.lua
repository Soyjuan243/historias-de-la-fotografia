local sceneManager = require("sceneManager")
local themeManager = require("themeManager")
local levelManager = require("levelManager")
local ui = require("ui_base")
local button = require("ui_button")

local campaignSelect = {}
local buttons = {}

function campaignSelect.enter()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    buttons = {}

    -- Luau Button
    table.insert(buttons, button.new("CAMPAÑA LUAU (ROBLOX)", w/4 - 150, h/2 - 50, 300, 100, function()
        themeManager.setTheme("luau")
        levelManager.setCampaign("luau")
        sceneManager.switch("level")
    end, {0.5, 0.2, 0.8}))

    -- C# Button
    table.insert(buttons, button.new("CAMPAÑA C# (UNITY)", 3*w/4 - 150, h/2 - 50, 300, 100, function()
        themeManager.setTheme("csharp")
        levelManager.setCampaign("csharp")
        sceneManager.switch("level")
    end, {0.2, 0.5, 0.8}))

    -- Back Button
    table.insert(buttons, button.new("VOLVER", w/2 - 50, h - 100, 100, 40, function()
        sceneManager.switch("menu")
    end))
end

function campaignSelect.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, b in ipairs(buttons) do
        b:update(mx, my)
    end
end

function campaignSelect.draw()
    love.graphics.clear(0.05, 0.05, 0.1)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    ui.title("SELECCIONA TU LENGUAJE", w/2 - 150, h/4)

    for _, b in ipairs(buttons) do
        b:draw()
    end
end

function campaignSelect.mousepressed(x, y, btn)
    for _, b in ipairs(buttons) do
        if b:mousepressed(x, y, btn) then break end
    end
end

return campaignSelect
