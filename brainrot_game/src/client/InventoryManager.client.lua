local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Create Inventory UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InventoryGui"
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "INVENTARIO DE BRAINROTS"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.FredokaOne
title.TextSize = 20
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.new(0, 110, 0, 110)
layout.Parent = scroll

-- Toggle Button
local toggle = Instance.new("TextButton")
toggle.Name = "ToggleInventory"
toggle.Text = "INVENTARIO"
toggle.Size = UDim2.new(0, 120, 0, 40)
toggle.Position = UDim2.new(0, 10, 1, -50)
toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.FredokaOne
toggle.TextSize = 18
toggle.Parent = screenGui

toggle.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function updateInventory()
    -- Clear existing buttons
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
    local owned = HttpService:JSONDecode(ownedStr)

    for _, typeID in ipairs(owned) do
        local data = BrainrotData.Types[typeID]
        if data then
            local btn = Instance.new("TextButton")
            btn.Name = typeID
            btn.Text = data.Name .. "\n(Común)"
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.FredokaOne
            btn.TextSize = 14
            btn.Parent = scroll

            btn.MouseButton1Click:Connect(function()
                -- Select for placement
                _G.SelectedBrainrot = typeID
                print("Seleccionado: " .. data.Name)
                frame.Visible = false
            end)
        end
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- Listen for attribute changes
player:GetAttributeChangedSignal("OwnedBrainrots"):Connect(updateInventory)
updateInventory()
