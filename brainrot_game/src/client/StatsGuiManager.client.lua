local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

local function createStatsGui(brainrot)
    if brainrot:FindFirstChild("StatsGui") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "StatsGui"
    billboard.Size = UDim2.new(4, 0, 2, 0)
    billboard.Adornee = brainrot
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 50

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = billboard

    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container

    -- Name (White)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.LayoutOrder = 1
    nameLabel.Size = UDim2.new(1, 0, 0.25, 0)
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = true
    nameLabel.Parent = container

    -- Level (Blue)
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.LayoutOrder = 2
    levelLabel.Size = UDim2.new(1, 0, 0.25, 0)
    levelLabel.TextColor3 = Color3.new(0.2, 0.6, 1)
    levelLabel.BackgroundTransparency = 1
    levelLabel.TextScaled = true
    levelLabel.Parent = container

    -- Category (Green)
    local categoryLabel = Instance.new("TextLabel")
    categoryLabel.Name = "CategoryLabel"
    categoryLabel.LayoutOrder = 3
    categoryLabel.Size = UDim2.new(1, 0, 0.25, 0)
    categoryLabel.TextColor3 = Color3.new(0, 1, 0)
    categoryLabel.BackgroundTransparency = 1
    categoryLabel.TextScaled = true
    categoryLabel.Parent = container

    -- Income (Green Big)
    local incomeLabel = Instance.new("TextLabel")
    incomeLabel.Name = "IncomeLabel"
    incomeLabel.LayoutOrder = 4
    incomeLabel.Size = UDim2.new(1, 0, 0.25, 0)
    incomeLabel.TextColor3 = Color3.new(0, 0.8, 0)
    incomeLabel.BackgroundTransparency = 1
    incomeLabel.TextScaled = true
    incomeLabel.Font = Enum.Font.SourceSansBold
    incomeLabel.Parent = container

    billboard.Parent = brainrot

    local function update()
        local typeID = brainrot:GetAttribute("BrainrotType")
        local level = brainrot:GetAttribute("Level") or 1
        local income = brainrot:GetAttribute("Income") or 0

        local data = BrainrotData.Types[typeID]
        if data then
            nameLabel.Text = data.Name
            levelLabel.Text = "Nivel " .. level
            categoryLabel.Text = data.Category
            incomeLabel.Text = "$" .. income .. "/seg"
        end
    end

    brainrot:GetAttributeChangedSignal("Level"):Connect(update)
    brainrot:GetAttributeChangedSignal("Income"):Connect(update)
    update()
end

-- Monitor Workspace for Brainrots
Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:GetAttribute("IsBrainrot") then
        createStatsGui(descendant)
    end
end)

-- Handle existing brainrots
for _, descendant in ipairs(Workspace:GetDescendants()) do
    if descendant:GetAttribute("IsBrainrot") then
        createStatsGui(descendant)
    end
end

print("[Client] Stats GUI Manager initialized.")
