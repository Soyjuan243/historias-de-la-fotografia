-- Entry point for the Educational Platform
local sceneManager = require("src.sceneManager")
local themeManager = require("src.themeManager")
local saveSystem = require("src.saveSystem")
local levelManager = require("src.levelManager")

function love.load()
    -- Initialize random seed
    math.randomseed(os.time())

    -- Load campaign data
    levelManager.loadCampaignData("luau", require("src.data.luau_levels"))
    levelManager.loadCampaignData("csharp", require("src.data.csharp_levels"))

    -- Register scenes
    sceneManager.register("menu", require("src.scenes.menuScene"))
    sceneManager.register("campaignSelect", require("src.scenes.campaignSelect"))
    sceneManager.register("level", require("src.scenes.levelScene"))
    sceneManager.register("exam", require("src.scenes.examScene"))
    sceneManager.register("certificate", require("src.scenes.certificateScene"))

    -- Load save data
    saveSystem.load()

    -- Initial scene
    sceneManager.switch("menu")
end

function love.update(dt)
    if sceneManager then
        sceneManager.update(dt)
    end
end

function love.draw()
    if sceneManager then
        sceneManager.draw()
    else
        love.graphics.print("Initializing educational platform...", 400, 300)
    end
end

function love.keypressed(key)
    if sceneManager then
        sceneManager.keypressed(key)
    end
end

function love.mousepressed(x, y, button)
    if sceneManager then
        sceneManager.mousepressed(x, y, button)
    end
end

function love.wheelmoved(x, y)
    if sceneManager then
        sceneManager.wheelmoved(x, y)
    end
end

function love.textinput(text)
    if sceneManager then
        sceneManager.textinput(text)
    end
end
