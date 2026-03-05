local sceneManager = require("src.sceneManager")
local themeManager = require("src.themeManager")
local levelManager = require("src.levelManager")
local saveSystem = require("src.saveSystem")
local puzzleSystem = require("src.puzzleSystem")
local validator = require("src.validator")
local ui = require("src.ui.base")
local button = require("src.ui.button")

local examScene = {}
local currentQuestion = 1
local correctAnswers = 0
local totalQuestions = 5
local buttons = {}
local examFinished = false

function examScene.enter()
    currentQuestion = 1
    correctAnswers = 0
    examFinished = false
    puzzleSystem.reset()

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    buttons = {}
    table.insert(buttons, button.new("SIGUIENTE", w/2 - 50, h - 100, 100, 40, function()
        if not examFinished then
            local level = levelManager.getCurrentLevel()
            if puzzleSystem.check(validator, level.solution) then
                correctAnswers = correctAnswers + 1
            end

            if currentQuestion < totalQuestions then
                currentQuestion = currentQuestion + 1
                levelManager.currentLevelIndex = levelManager.currentLevelIndex + 1
                puzzleSystem.reset()
            else
                examFinished = true
            end
        else
            if (correctAnswers / totalQuestions) >= 0.6 then
                saveSystem.addXP(500)
                -- Mark exam level as complete to break loop
                saveSystem.completeLevel(levelManager.currentCampaign, levelManager.currentLevelIndex)
                sceneManager.switch("level")
            else
                -- Fail logic, restart exam or level
                levelManager.currentLevelIndex = levelManager.currentLevelIndex - 4
                sceneManager.switch("level")
            end
        end
    end))
end

function examScene.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, b in ipairs(buttons) do
        b:update(mx, my)
    end
end

function examScene.draw()
    local theme = themeManager.currentTheme
    love.graphics.clear(theme.background)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    if not examFinished then
        local level = levelManager.getCurrentLevel()
        ui.title("EXAMEN: PREGUNTA " .. currentQuestion .. "/" .. totalQuestions, 20, 20)

        ui.panel(50, 80, w - 100, h - 200, {0.1, 0.1, 0.1, 0.9})
        love.graphics.printf(level.theory or "", 70, 100, w - 140)
        love.graphics.printf("RETO: " .. level.puzzle, 70, 200, w - 140)

        love.graphics.print("> " .. puzzleSystem.currentInput, 70, 250)
    else
        ui.title("RESULTADOS DEL EXAMEN", w/2 - 150, h/3)
        local score = (correctAnswers / totalQuestions) * 100
        ui.label(string.format("Calificación: %.1f%%", score), w/2 - 50, h/2)

        if score >= 60 then
            ui.label("¡APROBADO!", w/2 - 40, h/2 + 40, themeManager.getColor("correct"))
        else
            ui.label("REPROBADO. Debes repetir.", w/2 - 80, h/2 + 40, themeManager.getColor("incorrect"))
        end
    end

    for _, b in ipairs(buttons) do
        b:draw()
    end
end

function examScene.textinput(t)
    if not examFinished then
        puzzleSystem.currentInput = puzzleSystem.currentInput .. t
    end
end

function examScene.keypressed(key)
    if key == "backspace" and not examFinished then
        puzzleSystem.currentInput = puzzleSystem.currentInput:sub(1, -2)
    end
end

function examScene.mousepressed(x, y, btn)
    for _, b in ipairs(buttons) do
        if b:mousepressed(x, y, btn) then break end
    end
end

return examScene
