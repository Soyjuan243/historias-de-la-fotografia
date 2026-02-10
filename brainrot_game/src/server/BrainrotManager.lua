local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local Utils = require(Shared:WaitForChild("Utils"))

local Models = ReplicatedStorage:FindFirstChild("Models")

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

    for _, child in ipairs(platform:GetChildren()) do
        if child:GetAttribute("IsBrainrot") then
            child:Destroy()
        end
    end

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = data.Name
        brainrot:PivotTo(CFrame.new(platform.Position + Vector3.new(0, 3, 0)))

        if brainrot:IsA("BasePart") then brainrot.Anchored = true end
        for _, p in ipairs(brainrot:GetDescendants()) do
            if p:IsA("BasePart") then p.Anchored = true end
        end
    else
        brainrot = Instance.new("Part")
        brainrot.Name = data.Name
        brainrot.Size = Vector3.new(4, 4, 4)
        brainrot.Position = platform.Position + Vector3.new(0, 3, 0)
        brainrot.Anchored = true
        brainrot.BrickColor = BrickColor.new("Bright yellow")
    end

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

function BrainrotManager.addToInventory(player, typeID)
    local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
    local owned = HttpService:JSONDecode(ownedStr)
    table.insert(owned, typeID)
    player:SetAttribute("OwnedBrainrots", HttpService:JSONEncode(owned))
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

Events.get("PlaceBrainrot").OnServerEvent:Connect(function(player, platform, typeID)
    if not platform or not platform:IsDescendantOf(Workspace.Platforms) then return end
    if platform:GetAttribute("IsOccupied") then return end

    local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
    local owned = HttpService:JSONDecode(ownedStr)

    local ownsIt = false
    local index = -1
    for i, id in ipairs(owned) do
        if id == typeID then
            ownsIt = true
            index = i
            break
        end
    end

    if ownsIt then
        -- Remove from inventory when placing
        table.remove(owned, index)
        player:SetAttribute("OwnedBrainrots", HttpService:JSONEncode(owned))

        BrainrotManager.spawnBrainrot(typeID, platform, 1)
    end
end)

Events.get("RemoveBrainrot").OnServerEvent:Connect(function(player, platform)
    if not platform or not platform:IsDescendantOf(Workspace.Platforms) then return end
    if not platform:GetAttribute("IsOccupied") then return end

    local brainrot = nil
    for _, child in ipairs(platform:GetChildren()) do
        if child:GetAttribute("IsBrainrot") then
            brainrot = child
            break
        end
    end

    if brainrot then
        local typeID = brainrot:GetAttribute("BrainrotType")
        -- Return to inventory
        BrainrotManager.addToInventory(player, typeID)

        -- Cleanup
        brainrot:Destroy()
        platform:SetAttribute("IsOccupied", false)
        platform:SetAttribute("BrainrotID", "")

        print("[BrainrotManager] Removed " .. typeID .. " from platform.")
    end
end)

local function onPlayerAdded(player)
    local Platforms = Workspace:WaitForChild("Platforms")

    while not player:GetAttribute("PlatformStates") do
        task.wait()
    end

    local states = HttpService:JSONDecode(player:GetAttribute("PlatformStates"))
    for platformName, state in pairs(states) do
        local platform = Platforms:FindFirstChild(platformName)
        if platform then
            BrainrotManager.spawnBrainrot(state.TypeID, platform, state.Level)
        end
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(onPlayerAdded, player)
end

return BrainrotManager
