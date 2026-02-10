local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Utils = require(Shared:WaitForChild("Utils"))

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyHud"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

-- Main Container
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, 200, 0, 60)
container.Position = UDim2.new(0, 20, 1, -80) -- Bottom left
container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
container.BackgroundTransparency = 0.2
container.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = container

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 0, 0)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = container

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
})
gradient.Rotation = 90
gradient.Parent = container

-- Icon
local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.Size = UDim2.new(0, 40, 0, 40)
icon.Position = UDim2.new(0, 10, 0.5, -20)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://6031068433"
icon.ImageColor3 = Color3.fromRGB(0, 255, 100)
icon.Parent = container

-- Money Text
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(1, -60, 1, 0)
moneyLabel.Position = UDim2.new(0, 60, 0, 0)
moneyLabel.BackgroundTransparency = 1
moneyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyLabel.Text = "$0"
moneyLabel.Font = Enum.Font.FredokaOne
moneyLabel.TextSize = 28
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = container

local textStroke = Instance.new("UIStroke")
textStroke.Thickness = 2
textStroke.Color = Color3.new(0,0,0)
textStroke.Parent = moneyLabel

-- Logic
local leaderstats = player:WaitForChild("leaderstats")
local moneyValue = leaderstats:WaitForChild("Money")

local currentDisplayedMoney = moneyValue.Value

local function updateDisplay(newVal)
    local diff = newVal - currentDisplayedMoney
    if diff == 0 then return end

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local valObj = Instance.new("NumberValue")
    valObj.Value = currentDisplayedMoney

    valObj.Changed:Connect(function()
        moneyLabel.Text = "$" .. Utils.formatNumber(math.floor(valObj.Value))
    end)

    local tween = TweenService:Create(valObj, tweenInfo, {Value = newVal})
    tween:Play()

    tween.Completed:Connect(function()
        currentDisplayedMoney = newVal
        moneyLabel.Text = "$" .. Utils.formatNumber(newVal)
        valObj:Destroy()
    end)

    -- Pop effect
    local popTween = TweenService:Create(container, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 215, 0, 65)})
    popTween:Play()
    popTween.Completed:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(0, 200, 0, 60)}):Play()
    end)
end

moneyValue.Changed:Connect(updateDisplay)
moneyLabel.Text = "$" .. Utils.formatNumber(moneyValue.Value)

print("[Client] Money HUD initialized with smooth animations.")
