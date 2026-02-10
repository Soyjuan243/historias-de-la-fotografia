local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v4") -- Increment version for stability

local function loadData(player)
    local userId = player.UserId
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync("User_" .. userId)
    end)

    if not success then
        warn("Failed to load data for " .. player.Name)
        data = nil
    end

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local money = Instance.new("NumberValue")
    money.Name = "Money"
    money.Value = (data and data.Money) or 500
    money.Parent = leaderstats

    local owned = (data and data.OwnedBrainrots) or {"Common1", "Common2"}
    player:SetAttribute("OwnedBrainrots", HttpService:JSONEncode(owned))

    local platformStates = (data and data.PlatformStates) or {}
    player:SetAttribute("PlatformStates", HttpService:JSONEncode(platformStates))

    print("Data loaded for " .. player.Name)
end

local function saveData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local userId = player.UserId

    local platformStates = {}
    local Platforms = Workspace:FindFirstChild("Platforms")
    if Platforms then
        for _, platform in ipairs(Platforms:GetChildren()) do
            if platform:GetAttribute("OwnerID") == player.UserId then
                local brainrot = nil
                for _, child in ipairs(platform:GetChildren()) do
                    if child:GetAttribute("IsBrainrot") then
                        brainrot = child
                        break
                    end
                end
                if brainrot then
                    platformStates[platform.Name] = {
                        TypeID = brainrot:GetAttribute("BrainrotType"),
                        Level = brainrot:GetAttribute("Level")
                    }
                end
            end
        end
    end

    -- Use UpdateAsync for better reliability in production
    pcall(function()
        PlayerDataStore:UpdateAsync("User_" .. userId, function(oldData)
            return {
                Money = leaderstats.Money.Value,
                OwnedBrainrots = HttpService:JSONDecode(player:GetAttribute("OwnedBrainrots") or "[]"),
                PlatformStates = platformStates
            }
        end)
    end)
end

Players.PlayerAdded:Connect(loadData)
for _, player in ipairs(Players:GetPlayers()) do loadData(player) end

Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        saveData(player)
    end
end)

print("[Server] Data Service: Production-ready logic active.")
