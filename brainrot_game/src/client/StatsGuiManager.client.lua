local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local Utils = require(Shared:WaitForChild("Utils"))

local CATEGORY_COLORS = {
    ["Común"] = Color3.fromRGB(0, 255, 0),
    ["Poco común"] = Color3.fromRGB(0, 150, 255),
    ["Raro"] = Color3.fromRGB(180, 0, 255),
    ["Legendario"] = Color3.fromRGB(255, 170, 0),
    ["Secreto"] = Color3.fromRGB(255, 0, 0)
}

local function createStatsGui(brainrot)
    if brainrot:FindFirstChild("StatsGui") then return end

    local adornee = brainrot
    if brainrot:IsA("Model") then
        adornee = brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart")
    end

    if not adornee then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "StatsGui"
    -- Usar Scale en lugar de Offset para que la GUI mantenga su tamaño respecto al objeto en el mundo 3D
    -- y no se vea gigante al alejarse.
    billboard.Size = UDim2.new(6, 0, 3, 0)
    billboard.Adornee = adornee
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
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
            categoryLabel.TextColor3 = CATEGORY_COLORS[data.Category] or Color3.new(1, 1, 1)

            mutationLabel.Text = data.Mutation or "Sin mutaciones"
            if data.Mutation == "Oro" then
                mutationLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
            else
                mutationLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
            end

            incomeLabel.Text = "$" .. Utils.formatNumber(income) .. "/s"
            incomeLabel.TextColor3 = CATEGORY_COLORS[data.Category] or Color3.fromRGB(0, 255, 0)
        end
    end

    brainrot:GetAttributeChangedSignal("Level"):Connect(update)
    brainrot:GetAttributeChangedSignal("Income"):Connect(update)
    update()
end

Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:GetAttribute("IsBrainrot") then
        createStatsGui(descendant)
    end
end)

for _, descendant in ipairs(Workspace:GetDescendants()) do
    if descendant:GetAttribute("IsBrainrot") then
        createStatsGui(descendant)
    end
end
