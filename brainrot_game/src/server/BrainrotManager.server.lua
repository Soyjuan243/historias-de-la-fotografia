local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

local BrainrotManager = {}

function BrainrotManager.spawnBrainrot(typeID, platform)
    local data = BrainrotData.Types[typeID]
    if not data then return end

    local brainrot = Instance.new("Part")
    brainrot.Name = data.Name
    brainrot.Size = Vector3.new(4, 4, 4)
    brainrot.Position = platform.Position + Vector3.new(0, 3, 0)
    brainrot.Anchored = true
    brainrot.BrickColor = BrickColor.new("Bright yellow")
    brainrot.Parent = platform

    brainrot:SetAttribute("IsBrainrot", true)
    brainrot:SetAttribute("BrainrotType", typeID)
    brainrot:SetAttribute("Level", 1)
    brainrot:SetAttribute("Income", data.BaseIncome)
    brainrot:SetAttribute("UpgradeCost", data.BaseUpgradeCost)
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
            local moneyStat = player.leaderstats.Money
            moneyStat.Value = moneyStat.Value + money
            brainrot:SetAttribute("GeneratedMoney", 0)
            print(player.Name .. " collected $" .. money)
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
        local cost = brainrot:GetAttribute("UpgradeCost") or 0
        local moneyStat = player.leaderstats.Money

        if moneyStat.Value >= cost then
            moneyStat.Value = moneyStat.Value - cost

            local currentLevel = brainrot:GetAttribute("Level") or 1
            local newLevel = currentLevel + 1

            local typeID = brainrot:GetAttribute("BrainrotType")
            local data = BrainrotData.Types[typeID]

            -- Progression Math: 1.5x income, 1.8x cost per level
            local newIncome = math.floor(data.BaseIncome * (1.5 ^ (newLevel - 1)))
            local newCost = math.floor(data.BaseUpgradeCost * (1.8 ^ (newLevel - 1)))

            brainrot:SetAttribute("Level", newLevel)
            brainrot:SetAttribute("Income", newIncome)
            brainrot:SetAttribute("UpgradeCost", newCost)

            print(player.Name .. " upgraded " .. data.Name .. " to level " .. newLevel)
        end
    end
end)

-- Initial Demo Placement
task.spawn(function()
    local Platforms = Workspace:WaitForChild("Platforms")
    -- Wait for platforms to be created by PlatformManager
    repeat task.wait() until #Platforms:GetChildren() >= 5

    local platformList = Platforms:GetChildren()
    local brainrotTypes = {"Common1", "Common2", "Common3", "Common4", "Common5"}

    for i = 1, 5 do
        BrainrotManager.spawnBrainrot(brainrotTypes[i], platformList[i])
    end
end)

return BrainrotManager
