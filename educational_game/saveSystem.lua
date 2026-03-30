local saveSystem = {}
local json = require("serialize") -- Simple Lua table serializer

saveSystem.data = {
    xp = 0,
    rank = "Junior",
    luauProgress = 1,
    csharpProgress = 1,
    achievements = {},
    stats = {
        errors = 0,
        completedPuzzles = 0,
        examScores = {},
        errorHistory = {},
        recommendations = {}
    }
}

function saveSystem.save()
    local success, message = love.filesystem.write("save.json", json.encode(saveSystem.data))
    return success
end

function saveSystem.load()
    if love.filesystem.getInfo("save.json") then
        local content = love.filesystem.read("save.json")
        saveSystem.data = json.decode(content)
    end
end

function saveSystem.addXP(amount)
    saveSystem.data.xp = saveSystem.data.xp + amount
    saveSystem.updateRank()
end

function saveSystem.updateRank()
    local xp = saveSystem.data.xp
    local oldRank = saveSystem.data.rank

    if xp >= 5000 then
        saveSystem.data.rank = "Architect"
    elseif xp >= 3000 then
        saveSystem.data.rank = "Senior"
    elseif xp >= 1000 then
        saveSystem.data.rank = "Mid"
    else
        saveSystem.data.rank = "Junior"
    end

    return oldRank ~= saveSystem.data.rank
end

function saveSystem.logError(levelTitle, input)
    table.insert(saveSystem.data.stats.errorHistory, {
        level = levelTitle,
        input = input,
        time = os.time()
    })
    if #saveSystem.data.stats.errorHistory > 10 then
        table.remove(saveSystem.data.stats.errorHistory, 1)
    end
    saveSystem.generateRecommendation(levelTitle)
end

function saveSystem.generateRecommendation(levelTitle)
    local rec = "Sigue practicando los conceptos de: " .. levelTitle
    saveSystem.data.stats.recommendations = {rec}
end

function saveSystem.completeLevel(campaign, index, score)
    local key = campaign .. "Progress"
    if index >= saveSystem.data[key] then
        saveSystem.data[key] = index + 1
        saveSystem.addXP(100)
        saveSystem.data.stats.completedPuzzles = saveSystem.data.stats.completedPuzzles + 1

        -- Achievements
        if saveSystem.data.stats.completedPuzzles == 1 then
            table.insert(saveSystem.data.achievements, "Primeros Pasos")
        elseif saveSystem.data.stats.completedPuzzles == 50 then
            table.insert(saveSystem.data.achievements, "Graduado")
        end

        saveSystem.save()
        return true
    end
    return false
end

return saveSystem
