local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local Utils = require(Shared:WaitForChild("Utils"))

local function createStatsGui(brainrot)
    if brainrot:FindFirstChild("StatsGui") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "StatsGui"
    billboard.Size = UDim2.new(6, 0, 3, 0)
    billboard.Adornee = brainrot
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 60

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = billboard

    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0.02, 0)
    layout.Parent = container

    local function createLabel(name, order, color, sizeY)
        local label = Instance.new("TextLabel")
        label.Name = name
        label.LayoutOrder = order
        label.Size = UDim2.new(1, 0, sizeY or 0.2, 0)
        label.TextColor3 = color
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.FredokaOne

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2.5
        stroke.Color = Color3.new(0,0,0)
        stroke.Parent = label

        label.Parent = container
        return label
    end

    local nameLabel = createLabel("NameLabel", 1, Color3.new(1, 1, 1), 0.22)
    local levelLabel = createLabel("LevelLabel", 2, Color3.fromRGB(0, 220, 255), 0.16)
    local categoryLabel = createLabel("CategoryLabel", 3, Color3.fromRGB(0, 255, 0), 0.16)
    local mutationLabel = createLabel("MutationLabel", 4, Color3.new(1, 1, 1), 0.16)
    local incomeLabel = createLabel("IncomeLabel", 5, Color3.fromRGB(0, 255, 0), 0.22)

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
            if data.Category == "Secreto" then
                categoryLabel.TextColor3 = Color3.new(1, 0, 0)
            else
                categoryLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            end

            mutationLabel.Text = data.Mutation or "Sin mutaciones"

            incomeLabel.Text = "$" .. Utils.formatNumber(income) .. "/s"
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

print("[Client] Stats GUI Manager updated with reference style.")
