local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local HttpService = game:GetService("HttpService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")

-- We need a way to find the BrainrotManager to respawn brainrots
-- Since BrainrotManager is a ModuleScript in ServerScriptService.Server
local BrainrotManager = nil

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
    money.Value = (data and data.Money) or 100
    money.Parent = leaderstats

    -- Save brainrot levels for restoration (JSON encoded as tables aren't supported in attributes)
    local levels = (data and data.BrainrotLevels) or {1, 1, 1, 1, 1}
    player:SetAttribute("BrainrotLevels", HttpService:JSONEncode(levels))

    print("Data loaded for " .. player.Name)

    -- In a real game, we would spawn brainrots specific to this player here.
    -- For this demo, we use the global platforms.
end

local function saveData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local userId = player.UserId
    local data = {
        Money = leaderstats.Money.Value,
        BrainrotLevels = {}
    }

    -- Collect current levels from platforms (simplified for demo)
    -- In a multi-player game, platforms would belong to players.
    local Platforms = Workspace:FindFirstChild("Platforms")
    if Platforms then
        for i = 1, 5 do
            local platform = Platforms:FindFirstChild("Platform_" .. i)
            if platform then
                local brainrot = nil
                for _, child in ipairs(platform:GetChildren()) do
                    if child:GetAttribute("IsBrainrot") then
                        brainrot = child
                        break
                    end
                end
                if brainrot then
                    table.insert(data.BrainrotLevels, brainrot:GetAttribute("Level") or 1)
                else
                    table.insert(data.BrainrotLevels, 1)
                end
            end
        end
    end

    local success, err = pcall(function()
        PlayerDataStore:SetAsync("User_" .. userId, data)
    end)

    if not success then
        warn("Failed to save data for " .. player.Name .. ": " .. err)
    else
        print("Data saved for " .. player.Name)
    end
end

Players.PlayerAdded:Connect(loadData)
Players.PlayerRemoving:Connect(saveData)

-- Autosave every 5 minutes
task.spawn(function()
    while true do
        task.wait(300)
        for _, player in ipairs(Players:GetPlayers()) do
            saveData(player)
        end
    end
end)

game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        saveData(player)
    end
end)

print("[Server] Data Service initialized.")
