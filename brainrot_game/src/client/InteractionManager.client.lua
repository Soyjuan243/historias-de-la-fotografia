local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local Utils = require(Shared:WaitForChild("Utils"))

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Platforms = Workspace:WaitForChild("Platforms")

-- 1. UPGRADE & REMOVE UI (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InteractionGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.65, 0)
frame.BackgroundTransparency = 1
frame.Visible = false
frame.Parent = screenGui

local function createStyledButton(name, position, colors)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0.45, 0)
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
    stroke.Color = Color3.new(0,0,0)
    stroke.Parent = btn

    return btn
end

local upgradeBtn = createStyledButton("UpgradeButton", UDim2.new(0, 0, 0, 0), {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 170, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 0))
})
upgradeBtn.Parent = frame

local levelText = Instance.new("TextLabel")
levelText.Name = "LevelText"
levelText.Size = UDim2.new(1, 0, 0.3, 0)
levelText.Position = UDim2.new(0, 0, 0.7, 0)
levelText.BackgroundTransparency = 1
levelText.TextColor3 = Color3.new(0, 1, 1)
levelText.TextScaled = true
levelText.Font = Enum.Font.FredokaOne
levelText.Parent = upgradeBtn

local removeBtn = createStyledButton("RemoveButton", UDim2.new(0, 0, 0.55, 0), {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
})
removeBtn.Text = "QUITAR"
removeBtn.Parent = frame

local currentPlatform = nil
local currentMerchant = nil
local currentExit = nil

-- New UI for Merchant
local merchantFrame = Instance.new("Frame")
merchantFrame.Size = UDim2.new(0, 300, 0, 150)
merchantFrame.Position = UDim2.new(0.5, -150, 0.65, 0)
merchantFrame.BackgroundTransparency = 1
merchantFrame.Visible = false
merchantFrame.Parent = screenGui

local sellHandBtn = createStyledButton("SellHandButton", UDim2.new(0, 0, 0, 0), {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 0))
})
sellHandBtn.Text = "VENDER MANO"
sellHandBtn.Parent = merchantFrame

local exitBtn = createStyledButton("ExitButton", UDim2.new(0.85, 0, 0.05, 0), {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
})
exitBtn.Size = UDim2.new(0, 100, 0, 40)
exitBtn.Text = "SALIR"
exitBtn.Parent = screenGui

local function getNearestPlatform()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart
    local nearest = nil
    local minDistance = 8

    for _, platform in ipairs(Platforms:GetChildren()) do
        -- Only show if occupied AND owned by me
        if platform:GetAttribute("IsOccupied") and platform:GetAttribute("OwnerID") == player.UserId then
            local distance = (hrp.Position - platform.Position).Magnitude
            if distance < minDistance then
                nearest = platform
                minDistance = distance
            end
        end
    end
    return nearest
end

local function getNearestMerchant()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart

    local merchant = Workspace:FindFirstChild("Comprador")
    if merchant then
        local distance = (hrp.Position - (merchant:IsA("BasePart") and merchant.Position or merchant:GetPivot().Position)).Magnitude
        if distance < 12 then
            return merchant
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    local character = player.Character
    local isHoldingSomething = character and character:FindFirstChildWhichIsA("Tool") ~= nil

    local nearest = getNearestPlatform()
    local nearestMerchant = getNearestMerchant()

    -- Merchant Logic
    if nearestMerchant then
        currentMerchant = nearestMerchant
        local character = player.Character
        local tool = character and character:FindFirstChildWhichIsA("Tool")

        if tool and tool:GetAttribute("IsBrainrotTool") then
            merchantFrame.Visible = true
            frame.Visible = false
        else
            merchantFrame.Visible = false
        end
    else
        currentMerchant = nil
        merchantFrame.Visible = false
    end

    if nearest then
        currentPlatform = nearest
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

            if level < 100 then
                upgradeBtn.Text = "$" .. Utils.formatNumber(cost)
                levelText.Text = "Nivel " .. level .. " > Nivel " .. (level + 1)
                upgradeBtn.Visible = true
            else
                upgradeBtn.Visible = false
            end

            -- Hide UI if player is holding a tool (to not clutter placement prompt)
            frame.Visible = not isHoldingSomething
        else
            frame.Visible = false
        end
    else
        currentPlatform = nil
        frame.Visible = false
    end
end)

upgradeBtn.MouseButton1Click:Connect(function()
    if currentPlatform then
        Events.get("UpgradeBrainrot"):FireServer(currentPlatform)
    end
end)

removeBtn.MouseButton1Click:Connect(function()
    if currentPlatform then
        Events.get("RemoveBrainrot"):FireServer(currentPlatform)
    end
end)

sellHandBtn.MouseButton1Click:Connect(function()
    Events.get("SellBrainrot"):FireServer("Hand")
end)

exitBtn.MouseButton1Click:Connect(function()
    Events.get("ExitZone"):FireServer()
end)

-- print("[Client] Interaction Manager updated with merchant and exit logic.")
