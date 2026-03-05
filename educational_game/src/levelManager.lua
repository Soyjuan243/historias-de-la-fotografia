local levelManager = {}

levelManager.campaigns = {
    luau = {},
    csharp = {}
}

levelManager.currentCampaign = "luau"
levelManager.currentLevelIndex = 1

function levelManager.loadCampaignData(name, data)
    levelManager.campaigns[name] = data
end

function levelManager.setCampaign(name)
    if levelManager.campaigns[name] then
        levelManager.currentCampaign = name
    end
end

function levelManager.getCurrentLevel()
    local campaign = levelManager.campaigns[levelManager.currentCampaign]
    if campaign then
        return campaign[levelManager.currentLevelIndex]
    end
    return nil
end

function levelManager.nextLevel()
    local campaign = levelManager.campaigns[levelManager.currentCampaign]
    if campaign and levelManager.currentLevelIndex < #campaign then
        levelManager.currentLevelIndex = levelManager.currentLevelIndex + 1
        return true
    end
    return false
end

function levelManager.isExamLevel()
    return levelManager.currentLevelIndex % 10 == 0
end

return levelManager
