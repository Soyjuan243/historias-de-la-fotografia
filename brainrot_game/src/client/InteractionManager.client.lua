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
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0.5, -200, 0.7, 0)
frame.BackgroundTransparency = 1
frame.Parent = screenGui

local function createStyledButton(name, position, colors)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0.4, 0)
    btn.Position = position
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.TextScaled = true
    btn.Font = Enum.Font.FredokaOne
    btn.TextColor3 = Color3.new(1, 1, 1)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = btn

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = 90
    gradient.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.new(0,0,0)
    stroke.Parent = btn

    return btn
end

-- Colors based on image
local upgradeColors = {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 170, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 0))
}
local collectColors = {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 0))
}

local upgradeBtn = createStyledButton("UpgradeButton", UDim2.new(0.05, 0, 0, 0), upgradeColors)
upgradeBtn.Parent = frame

local collectBtn = createStyledButton("CollectButton", UDim2.new(0.05, 0, 0.5, 0), collectColors)
collectBtn.Parent = frame

-- Add sub-text for level in upgrade button
local levelText = Instance.new("TextLabel")
levelText.Name = "LevelText"
levelText.Size = UDim2.new(1, 0, 0.3, 0)
levelText.Position = UDim2.new(0, 0, 0.7, 0)
levelText.BackgroundTransparency = 1
levelText.TextColor3 = Color3.new(0, 1, 1) -- Cyan-ish as in image
levelText.TextScaled = true
levelText.Font = Enum.Font.FredokaOne
levelText.Parent = upgradeBtn

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

        local brainrot = nil
        for _, child in ipairs(nearest:GetChildren()) do
            if child:GetAttribute("IsBrainrot") then
                brainrot = child
                break
            end
        end

        if brainrot then
            local level = brainrot:GetAttribute("Level") or 1
            local cost = brainrot:GetAttribute("UpgradeCost") or 0
            local generated = brainrot:GetAttribute("GeneratedMoney") or 0

            if level < 100 then
                upgradeBtn.Text = "$" .. cost
                levelText.Text = "Nivel " .. level .. " > Nivel " .. (level + 1)
                upgradeBtn.Visible = true
            else
                upgradeBtn.Visible = false
            end

            collectBtn.Text = "$" .. generated
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

print("[Client] Interaction Manager updated with new GUI style.")
