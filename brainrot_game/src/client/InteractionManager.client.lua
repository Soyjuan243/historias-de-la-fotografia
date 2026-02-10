local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

local player = Players.LocalPlayer
local Platforms = Workspace:WaitForChild("Platforms")

-- Create the Interaction GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InteractionGui"
screenGui.Enabled = false
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.Text = "Brainrot Actions"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Parent = frame

local collectBtn = Instance.new("TextButton")
collectBtn.Name = "CollectButton"
collectBtn.Size = UDim2.new(0.45, 0, 0.5, 0)
collectBtn.Position = UDim2.new(0.025, 0, 0.4, 0)
collectBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
collectBtn.Text = "💰 Collect"
collectBtn.TextColor3 = Color3.new(1, 1, 1)
collectBtn.TextScaled = true
collectBtn.Parent = frame

local upgradeBtn = Instance.new("TextButton")
upgradeBtn.Name = "UpgradeButton"
upgradeBtn.Size = UDim2.new(0.45, 0, 0.5, 0)
upgradeBtn.Position = UDim2.new(0.525, 0, 0.4, 0)
upgradeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
upgradeBtn.Text = "⬆️ Upgrade"
upgradeBtn.TextColor3 = Color3.new(1, 1, 1)
upgradeBtn.TextScaled = true
upgradeBtn.Parent = frame

local currentPlatform = nil

local function getNearestPlatform()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

    local hrp = character.HumanoidRootPart
    local nearest = nil
    local minDistance = 12

    for _, platform in ipairs(Platforms:GetChildren()) do
        if platform:GetAttribute("IsOccupied") then
            local distance = (hrp.Position - platform.Position).Magnitude
            if distance < minDistance then
                nearest = platform
                minDistance = distance
            end
        end
    end

    return nearest
end

RunService.RenderStepped:Connect(function()
    local nearest = getNearestPlatform()

    if nearest then
        currentPlatform = nearest
        screenGui.Enabled = true

        -- Find the brainrot inside the platform
        local brainrot = nil
        for _, child in ipairs(nearest:GetChildren()) do
            if child:GetAttribute("IsBrainrot") then
                brainrot = child
                break
            end
        end

        if brainrot then
            local cost = brainrot:GetAttribute("UpgradeCost") or 0
            upgradeBtn.Text = "⬆️ Upgrade ($" .. cost .. ")"
        end
    else
        currentPlatform = nil
        screenGui.Enabled = false
    end
end)

collectBtn.MouseButton1Click:Connect(function()
    if currentPlatform then
        Events.get("CollectMoney"):FireServer(currentPlatform)
    end
end)

upgradeBtn.MouseButton1Click:Connect(function()
    if currentPlatform then
        Events.get("UpgradeBrainrot"):FireServer(currentPlatform)
    end
end)

print("[Client] Interaction Manager initialized.")
