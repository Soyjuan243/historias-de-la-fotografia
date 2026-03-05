local sceneManager = require("src.sceneManager")
local themeManager = require("src.themeManager")
local levelManager = require("src.levelManager")
local puzzleSystem = require("src.puzzleSystem")
local validator = require("src.validator")
local saveSystem = require("src.saveSystem")
local ui = require("src.ui.base")
local button = require("src.ui.button")
local scroll = require("src.ui.scroll")

local levelScene = {}
local buttons = {}
local theoryScroll, puzzleScroll
local cursorTimer = 0
local combo = 0
local hintsUsed = 0
local showCursor = true

local function loadLevel()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    -- Sync progress
    local key = levelManager.currentCampaign .. "Progress"
    levelManager.currentLevelIndex = saveSystem.data[key] or 1

    -- Check for exam
    if levelManager.isExamLevel() then
        sceneManager.switch("exam")
        return
    end

    puzzleSystem.reset()

    theoryScroll = scroll.new(20, 80, w/2 - 30, h - 160)
    puzzleScroll = scroll.new(w/2 + 10, 80, w/2 - 30, h - 160)

    buttons = {}
    table.insert(buttons, button.new("VALIDAR", w - 150, h - 60, 130, 40, function()
        local level = levelManager.getCurrentLevel()
        if puzzleSystem.check(validator, level.solution) then
            saveSystem.completeLevel(levelManager.currentCampaign, levelManager.currentLevelIndex)
            combo = combo + 1
            saveSystem.addXP(10 * combo) -- Combo bonus
            if not levelManager.nextLevel() then
                sceneManager.switch("certificate", levelManager.currentCampaign)
            else
                loadLevel()
            end
        else
            combo = 0
            saveSystem.data.stats.errors = saveSystem.data.stats.errors + 1
            saveSystem.logError(level.title, puzzleSystem.currentInput)
        end
    end, {0.2, 0.6, 0.2}))

    table.insert(buttons, button.new("PISTA", w - 150, h - 110, 130, 40, function()
        if hintsUsed < 3 then
            local level = levelManager.getCurrentLevel()
            puzzleSystem.feedback = "Pista: " .. level.solution:sub(1, 5) .. "..."
            hintsUsed = hintsUsed + 1
        end
    end, {0.6, 0.6, 0.2}))

    table.insert(buttons, button.new("VOLVER", 20, h - 60, 100, 40, function()
        sceneManager.switch("campaignSelect")
    end))
end

function levelScene.enter()
    loadLevel()
end

function levelScene.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, b in ipairs(buttons) do
        b:update(mx, my)
    end

    cursorTimer = cursorTimer + dt
    if cursorTimer > 0.5 then
        cursorTimer = 0
        showCursor = not showCursor
    end
end

local function playSound(name)
    -- Placeholder for sound logic
    -- if sounds[name] then sounds[name]:play() end
end

function levelScene.draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local theme = themeManager.currentTheme
    love.graphics.clear(theme.background)

    local level = levelManager.getCurrentLevel() or {title = "Cargando...", theory = "", puzzle = ""}

    ui.title(level.title or "", 20, 20)

    -- Theory Panel
    ui.panel(theoryScroll.x, theoryScroll.y, theoryScroll.w, theoryScroll.h, themeManager.getColor("theory"))
    theoryScroll:draw(function(x, y, limit)
        love.graphics.printf(level.theory or "", x, y, limit)
        local _, lines = love.graphics.getFont():getWrap(level.theory or "", limit)
        local height = #lines * love.graphics.getFont():getHeight()

        love.graphics.printf("\nEJEMPLO:\n" .. (level.example or ""), x, y + height + 20, limit)
        theoryScroll.contentHeight = height + 200 -- Rough estimate
    end)

    -- Puzzle Panel
    ui.panel(puzzleScroll.x, puzzleScroll.y, puzzleScroll.w, puzzleScroll.h, {0.05, 0.05, 0.05, 0.9})
    puzzleScroll:draw(function(x, y, limit)
        love.graphics.printf("RETO:\n" .. (level.puzzle or ""), x, y, limit)

        local inputY = y + 100
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("> " .. puzzleSystem.currentInput .. (showCursor and "|" or ""), x, inputY)

        if puzzleSystem.feedback ~= "" then
            local color = puzzleSystem.isCorrect and themeManager.getColor("correct") or themeManager.getColor("incorrect")
            love.graphics.setColor(color)
            love.graphics.print(puzzleSystem.feedback, x, inputY + 40)
        end
    end)

    for _, b in ipairs(buttons) do
        b:draw()
    end

    -- Stats
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("XP: " .. saveSystem.data.xp .. " | RANGO: " .. saveSystem.data.rank, w - 300, 25)
    love.graphics.print("COMBO: x" .. combo .. " | PISTAS: " .. (3 - hintsUsed), w - 300, 45)
end

function levelScene.textinput(t)
    puzzleSystem.currentInput = puzzleSystem.currentInput .. t
    playSound("write")
end

function levelScene.keypressed(key)
    if key == "backspace" then
        puzzleSystem.currentInput = puzzleSystem.currentInput:sub(1, -2)
    elseif key == "return" then
        -- Trigger validation?
    end
end

function levelScene.mousepressed(x, y, btn)
    for _, b in ipairs(buttons) do
        if b:mousepressed(x, y, btn) then break end
    end
end

function levelScene.wheelmoved(x, y)
    if love.mouse.getX() < love.graphics.getWidth()/2 then
        theoryScroll:wheelmoved(y)
    else
        puzzleScroll:wheelmoved(y)
    end
end

return levelScene
