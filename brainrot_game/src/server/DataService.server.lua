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
    if not leaderstats then
        warn("No leaderstats found for " .. player.Name .. ", skipping save.")
        return
    end

    local userId = player.UserId

    local platformStates = {}
    local Platforms = Workspace:FindFirstChild("Platforms")
    local platformsToClear = {}

    if Platforms then
        for _, platform in ipairs(Platforms:GetChildren()) do
            if platform:GetAttribute("OwnerID") == player.UserId then
                table.insert(platformsToClear, platform)
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
                    print("[DataService] Saving platform:", platform.Name, "with", brainrot:GetAttribute("BrainrotType"))
                end
            end
        end
    end

    local owned = HttpService:JSONDecode(player:GetAttribute("OwnedBrainrots") or "[]")
    print("[DataService] Saving", #owned, "brainrots in inventory for", player.Name)

    -- Use UpdateAsync for better reliability in production
    local success, err = pcall(function()
        PlayerDataStore:UpdateAsync("User_" .. userId, function(oldData)
            return {
                Money = leaderstats.Money.Value,
                OwnedBrainrots = owned,
                PlatformStates = platformStates
            }
        end)
    end)

    if success then
        print("Data successfully saved for " .. player.Name)
        -- Clear platforms from Workspace after save to prevent state duplication/bugs on rejoin
        for _, platform in ipairs(platformsToClear) do
            for _, child in ipairs(platform:GetChildren()) do
                if child:GetAttribute("IsBrainrot") then
                    child:Destroy()
                end
            end
            platform:SetAttribute("IsOccupied", false)
            platform:SetAttribute("BrainrotID", "")
            platform:SetAttribute("OwnerID", 0)
        end
    else
        warn("Failed to save data for " .. player.Name .. ": " .. tostring(err))
    end
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
