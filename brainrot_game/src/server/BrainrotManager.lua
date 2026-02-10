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

-- Helper to create the 'Collector' part on the platform
local function createCollectorPad(platform)
    if platform:FindFirstChild("CollectorPad") then return end

    local pad = Instance.new("Part")
    pad.Name = "CollectorPad"
    pad.Size = Vector3.new(6, 0.5, 6)
    pad.Position = platform.Position + Vector3.new(0, 0.5, 0)
    pad.Anchored = true
    pad.CanCollide = false
    pad.Transparency = 0.5
    pad.BrickColor = BrickColor.new("Bright green")
    pad.Parent = platform

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 80, 0, 30)
    billboard.Adornee = pad
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 1, 0)
    billboard.Parent = pad

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "$0"
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.FredokaOne
    text.TextScaled = true
    text.Parent = billboard

    pad.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        if player then
            local ownerId = platform:GetAttribute("OwnerID")
            if ownerId ~= 0 and ownerId ~= player.UserId then return end

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
        end
    end)

    task.spawn(function()
        while pad and pad.Parent do
            local brainrot = nil
            for _, child in ipairs(platform:GetChildren()) do
                if child:GetAttribute("IsBrainrot") then
                    brainrot = child
                    break
                end
            end
            if brainrot then
                local money = brainrot:GetAttribute("GeneratedMoney") or 0
                text.Text = "$" .. Utils.formatNumber(money)
            else
                text.Text = ""
            end
            task.wait(0.5)
        end
    end)
end

function BrainrotManager.setupPlatformPrompt(platform)
    if platform:FindFirstChild("PlacementPrompt") then return end

    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "PlacementPrompt"
    prompt.ActionText = "Colocar Personaje"
    prompt.ObjectText = platform.Name
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.HoldDuration = 0.5
    prompt.MaxActivationDistance = 10
    prompt.RequiresLineOfSight = false
    prompt.Parent = platform

    prompt.Triggered:Connect(function(player)
        local character = player.Character
        if not character then return end

        local tool = character:FindFirstChildWhichIsA("Tool")
        if tool and tool:GetAttribute("IsBrainrotTool") then
            local typeID = tool:GetAttribute("BrainrotType")

            local ownerId = platform:GetAttribute("OwnerID") or 0
            if ownerId ~= 0 and ownerId ~= player.UserId then return end
            if platform:GetAttribute("IsOccupied") then return end

            BrainrotManager.spawnBrainrot(typeID, platform, 1)
            platform:SetAttribute("OwnerID", player.UserId)

            tool:Destroy()

            local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
            local owned = HttpService:JSONDecode(ownedStr)
            for i, id in ipairs(owned) do
                if id == typeID then
                    table.remove(owned, i)
                    break
                end
            end
            player:SetAttribute("OwnedBrainrots", HttpService:JSONEncode(owned))
        end
    end)

    task.spawn(function()
        while prompt and prompt.Parent do
            prompt.Enabled = not platform:GetAttribute("IsOccupied")
            task.wait(1)
        end
    end)
end

function BrainrotManager.giveAndEquip(player, typeID, skipDataUpdate)
    local data = BrainrotData.Types[typeID]
    if not data then return end

    if not skipDataUpdate then
        local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
        local owned = HttpService:JSONDecode(ownedStr)
        table.insert(owned, typeID)
        player:SetAttribute("OwnedBrainrots", HttpService:JSONEncode(owned))
    end

    local tool = Instance.new("Tool")
    tool.Name = data.Name
    tool:SetAttribute("IsBrainrotTool", true)
    tool:SetAttribute("BrainrotType", typeID)
    tool.RequiresHandle = false

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        tool.Parent = character
    else
        tool.Parent = player:FindFirstChild("Backpack")
    end

    return tool
end

-- ALIAS to prevent Mismatch
function BrainrotManager.addToInventory(player, typeID)
    return BrainrotManager.giveAndEquip(player, typeID)
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
        brainrot.Name = data.Name or "Brainrot"

        -- Calculate precise positioning on platform
        local modelSize = brainrot:GetExtentsSize()
        local platformSize = platform.Size
        local pivotOffset = (platformSize.Y / 2) + (modelSize.Y / 2)

        brainrot:PivotTo(platform.CFrame * CFrame.new(0, pivotOffset, 0))

        if brainrot:IsA("BasePart") then
            brainrot.Anchored = true
            brainrot.CanCollide = false
        end
        for _, p in ipairs(brainrot:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Anchored = true
                p.CanCollide = false
            end
        end
    else
        brainrot = Instance.new("Part")
        brainrot.Name = data.Name or "Brainrot"
        brainrot.Size = Vector3.new(4, 4, 4)
        local platformSize = platform.Size
        brainrot:PivotTo(platform.CFrame * CFrame.new(0, (platformSize.Y/2) + 2, 0))
        brainrot.Anchored = true
        brainrot.CanCollide = false
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

    createCollectorPad(platform)

    return brainrot
end

-- Remote Listeners
Events.get("UpgradeBrainrot").OnServerEvent:Connect(function(player, platform)
    if not platform or not platform:IsDescendantOf(Workspace.Platforms) then return end
    if platform:GetAttribute("OwnerID") ~= player.UserId then return end

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

Events.get("RemoveBrainrot").OnServerEvent:Connect(function(player, platform)
    if not platform or not platform:IsDescendantOf(Workspace.Platforms) then return end
    if platform:GetAttribute("OwnerID") ~= player.UserId then return end

    local brainrot = nil
    for _, child in ipairs(platform:GetChildren()) do
        if child:GetAttribute("IsBrainrot") then
            brainrot = child
            break
        end
    end

    if brainrot then
        local typeID = brainrot:GetAttribute("BrainrotType")
        BrainrotManager.addToInventory(player, typeID)

        brainrot:Destroy()
        platform:SetAttribute("IsOccupied", false)
        platform:SetAttribute("BrainrotID", "")
        platform:SetAttribute("OwnerID", 0)
    end
end)

local function onPlayerAdded(player)
    local Platforms = Workspace:WaitForChild("Platforms")

    for _, p in ipairs(Platforms:GetChildren()) do
        createCollectorPad(p)
        BrainrotManager.setupPlatformPrompt(p)
        if not p:GetAttribute("OwnerID") then p:SetAttribute("OwnerID", 0) end
    end

    while not player:GetAttribute("PlatformStates") do
        task.wait()
    end

    -- 1. Restore platform brainrots
    local states = HttpService:JSONDecode(player:GetAttribute("PlatformStates"))
    for platformName, state in pairs(states) do
        local platform = Platforms:FindFirstChild(platformName)
        if platform and not platform:GetAttribute("IsOccupied") then
            BrainrotManager.spawnBrainrot(state.TypeID, platform, state.Level)
            platform:SetAttribute("OwnerID", player.UserId)
        end
    end

    -- 2. Restore Backpack tools
    local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
    local owned = HttpService:JSONDecode(ownedStr)
    for _, typeID in ipairs(owned) do
        BrainrotManager.giveAndEquip(player, typeID, true) -- true = skip data update as it's already in data
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(onPlayerAdded, player)
end

return BrainrotManager
