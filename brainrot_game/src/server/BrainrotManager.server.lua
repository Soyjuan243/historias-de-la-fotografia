local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

local BrainrotManager = {}

function BrainrotManager.calculateStats(typeID, level)
    local data = BrainrotData.Types[typeID]
    if not data then return 0, 0 end

    local income = math.floor(data.BaseIncome * (1.5 ^ (level - 1)))
    local cost = math.floor(data.BaseUpgradeCost * (1.8 ^ (level - 1)))

    return income, cost
end

function BrainrotManager.spawnBrainrot(typeID, platform, level)
    level = level or 1
    local data = BrainrotData.Types[typeID]
    if not data then return end

    -- Clear existing brainrot if any
    for _, child in ipairs(platform:GetChildren()) do
        if child:GetAttribute("IsBrainrot") then
            child:Destroy()
        end
    end

    local brainrot = Instance.new("Part")
    brainrot.Name = data.Name
    brainrot.Size = Vector3.new(4, 4, 4)
    brainrot.Position = platform.Position + Vector3.new(0, 3, 0)
    brainrot.Anchored = true
    brainrot.BrickColor = BrickColor.new("Bright yellow")
    brainrot.Parent = platform

    local income, cost = BrainrotManager.calculateStats(typeID, level)

    brainrot:SetAttribute("IsBrainrot", true)
    brainrot:SetAttribute("BrainrotType", typeID)
    brainrot:SetAttribute("Level", level)
    brainrot:SetAttribute("Income", income)
    brainrot:SetAttribute("UpgradeCost", cost)
    brainrot:SetAttribute("GeneratedMoney", 0)

    platform:SetAttribute("IsOccupied", true)
    platform:SetAttribute("BrainrotID", typeID)

    return brainrot
end

-- Remote Listeners
Events.get("CollectMoney").OnServerEvent:Connect(function(player, platform)
    if not platform or not platform:IsDescendantOf(Workspace.Platforms) then return end

    local brainrot = nil
    for _, child in ipairs(platform:GetChildren()) do
        if child:GetAttribute("IsBrainrot") then
            brainrot = child
            break
        end
    end

    if brainrot then
        local money = brainrot:GetAttribute("GeneratedMoney") or 0
        if money > 0 then
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                leaderstats.Money.Value = leaderstats.Money.Value + money
                brainrot:SetAttribute("GeneratedMoney", 0)
            end
        end
    end
end)

Events.get("UpgradeBrainrot").OnServerEvent:Connect(function(player, platform)
    if not platform or not platform:IsDescendantOf(Workspace.Platforms) then return end

    local brainrot = nil
    for _, child in ipairs(platform:GetChildren()) do
        if child:GetAttribute("IsBrainrot") then
            brainrot = child
            break
        end
    end

    if brainrot then
        local currentLevel = brainrot:GetAttribute("Level") or 1
        if currentLevel >= 100 then return end

        local cost = brainrot:GetAttribute("UpgradeCost") or 0
        local leaderstats = player:FindFirstChild("leaderstats")

        if leaderstats and leaderstats.Money.Value >= cost then
            leaderstats.Money.Value = leaderstats.Money.Value - cost

            local newLevel = currentLevel + 1
            local typeID = brainrot:GetAttribute("BrainrotType")
            local newIncome, newCost = BrainrotManager.calculateStats(typeID, newLevel)

            brainrot:SetAttribute("Level", newLevel)
            brainrot:SetAttribute("Income", newIncome)
            brainrot:SetAttribute("UpgradeCost", newCost)
        end
    end
end)

-- Initial Placement / Data Restore
local function onPlayerAdded(player)
    local Platforms = Workspace:WaitForChild("Platforms")
    -- Wait for platforms to be created
    repeat task.wait() until #Platforms:GetChildren() >= 5

    -- For this demo, the first player to join sets the levels on the global platforms
    -- In a real game, each player would have their own platforms.

    -- Wait for data to be loaded by DataService
    while not player:GetAttribute("BrainrotLevels") do
        task.wait()
    end

    local brainrotLevels = HttpService:JSONDecode(player:GetAttribute("BrainrotLevels"))
    local platformList = Platforms:GetChildren()
    table.sort(platformList, function(a, b) return a.Name < b.Name end)

    local brainrotTypes = {"Common1", "Common2", "Common3", "Common4", "Common5"}

    for i = 1, 5 do
        if platformList[i] then
            BrainrotManager.spawnBrainrot(brainrotTypes[i], platformList[i], brainrotLevels[i])
        end
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

return BrainrotManager
