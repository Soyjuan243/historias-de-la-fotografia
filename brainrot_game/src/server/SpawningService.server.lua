local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))

local Models = ReplicatedStorage:FindFirstChild("Models")

local SPAWN_INTERVAL = 10
local DESPAWN_TIME = 30

local commonIDs = {"Common1", "Common2", "Common3", "Common4", "Common5", "CommonGold1", "CommonGold2", "CommonGold3", "CommonGold4", "CommonGold5"}
local uncommonIDs = {"Uncommon1", "Uncommon2", "Uncommon3", "Uncommon4", "Uncommon5"}
local rareIDs = {"Rare1", "Rare2", "Rare3", "Rare4", "Rare5"}
local legendaryIDs = {"Legendary1", "Legendary2", "Legendary3", "Legendary4", "Legendary5"}

local spawn1Parts = {}
local spawn2Parts = {}

local function updateSpawnCache()
    spawn1Parts = {}
    spawn2Parts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if obj.Name == "spawn1" then
                table.insert(spawn1Parts, obj)
            elseif obj.Name == "spawn2" then
                table.insert(spawn2Parts, obj)
            end
        end
    end
end

updateSpawnCache()
Workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("BasePart") then
        if desc.Name == "spawn1" then table.insert(spawn1Parts, desc)
        elseif desc.Name == "spawn2" then table.insert(spawn2Parts, desc) end
    end
end)

local function getRandomPositionInPart(part)
    local size = part.Size
    local rx = (math.random() - 0.5) * (size.X * 0.8)
    local rz = (math.random() - 0.5) * (size.Z * 0.8)
    local topY = size.Y / 2
    return part.CFrame * CFrame.new(rx, topY, rz)
end

local function selectType(spawnType)
    local roll = math.random(1, 100)
    local targetList = {}

    if spawnType == "spawn1" then
        if roll <= 80 then
            targetList = commonIDs
        else
            targetList = uncommonIDs
        end
    else
        if roll <= 40 then
            targetList = commonIDs
        elseif roll <= 70 then
            targetList = uncommonIDs
        elseif roll <= 90 then
            targetList = rareIDs
        else
            targetList = legendaryIDs
        end
    end

    return targetList[math.random(1, #targetList)]
end

local function spawnWithinArea()
    local allSpawnParts = {}
    for _, p in ipairs(spawn1Parts) do table.insert(allSpawnParts, p) end
    for _, p in ipairs(spawn2Parts) do table.insert(allSpawnParts, p) end

    if #allSpawnParts == 0 then return end

    local spawnPart = allSpawnParts[math.random(1, #allSpawnParts)]
    local spawnType = spawnPart.Name
    local typeID = selectType(spawnType)
    local data = BrainrotData.Types[typeID]

    if not data then return end

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = "Spawned_" .. typeID
        local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)

        local correctionRotation = CFrame.Angles(0, math.rad(180), 0)
        brainrot:PivotTo(correctionRotation)

        local modelSize = brainrot:GetExtentsSize()
        local pivotOffset = modelSize.Y / 2

        brainrot:PivotTo(getRandomPositionInPart(spawnPart) * CFrame.new(0, pivotOffset, 0) * randomRotation * correctionRotation)
        brainrot.Parent = Workspace

        local function anchorRecursive(obj)
            if obj:IsA("BasePart") then
                obj.Anchored = true
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = true
                obj.Massless = true
            end
            for _, child in ipairs(obj:GetChildren()) do
                anchorRecursive(child)
            end
        end
        anchorRecursive(brainrot)
    else
        brainrot = Instance.new("Part")
        brainrot.Name = "Spawned_" .. typeID
        brainrot.Size = Vector3.new(2, 2, 2)
        brainrot:PivotTo(getRandomPositionInPart(spawnPart) * CFrame.new(0, 1, 0) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0))
        brainrot.Anchored = true
        brainrot.CanCollide = false
        brainrot.CanTouch = false
        brainrot.BrickColor = (data.Category == "Legendario" and BrickColor.new("Deep orange")) or (data.Category == "Raro" and BrickColor.new("Bright violet")) or BrickColor.new("Bright green")
    end

    brainrot.Parent = Workspace

    -- UI Billboard for Name
    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "NameBillboard"
    -- Usar Scale para mantener perspectiva
    nameBillboard.Size = UDim2.new(4, 0, 1.2, 0)
    nameBillboard.Adornee = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot
    nameBillboard.AlwaysOnTop = true
    nameBillboard.StudsOffset = Vector3.new(0, 3, 0)
    nameBillboard.Parent = brainrot

    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(1, 0, 1, 0)
    nameText.BackgroundTransparency = 1
    nameText.Text = "¡" .. (data.Name or "???") .. "!"
    nameText.TextColor3 = Color3.new(1, 1, 1)
    nameText.Font = Enum.Font.FredokaOne
    nameText.TextScaled = true
    nameText.Parent = nameBillboard

    local nameStroke = Instance.new("UIStroke")
    nameStroke.Thickness = 2
    nameStroke.Parent = nameText

    -- Timer UI
    local timerBillboard = Instance.new("BillboardGui")
    timerBillboard.Name = "TimerBillboard"
    -- Usar Scale para mantener perspectiva
    timerBillboard.Size = UDim2.new(3, 0, 1.2, 0)
    timerBillboard.Adornee = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot
    timerBillboard.AlwaysOnTop = true
    timerBillboard.StudsOffset = Vector3.new(0, 4.5, 0)
    timerBillboard.Parent = brainrot

    local timerFrame = Instance.new("Frame")
    timerFrame.Size = UDim2.new(1, 0, 1, 0)
    timerFrame.BackgroundTransparency = 1
    timerFrame.Parent = timerBillboard

    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0.3, 0, 1, 0)
    iconFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = timerFrame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconFrame

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0.7, 0, 0.7, 0)
    iconImg.Position = UDim2.new(0.15, 0, 0.15, 0)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = "rbxassetid://6031068433"
    iconImg.Parent = iconFrame

    local timerText = Instance.new("TextLabel")
    timerText.Size = UDim2.new(0.65, 0, 1, 0)
    timerText.Position = UDim2.new(0.35, 0, 0, 0)
    timerText.BackgroundTransparency = 1
    timerText.Text = DESPAWN_TIME .. "s"
    timerText.TextColor3 = Color3.new(0, 0, 0)
    timerText.Font = Enum.Font.FredokaOne
    timerText.TextScaled = true
    timerText.TextXAlignment = Enum.TextXAlignment.Left
    timerText.Parent = timerFrame

    local textStroke = Instance.new("UIStroke")
    textStroke.Thickness = 1.5
    textStroke.Color = Color3.new(1, 1, 1)
    textStroke.Parent = timerText

    brainrot:SetAttribute("TypeID", typeID)
    brainrot:SetAttribute("IsCollected", false)
    brainrot:SetAttribute("TimeLeft", DESPAWN_TIME)

    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Agarrar"
    prompt.ObjectText = data.Name or "Personaje"
    prompt.HoldDuration = 0
    prompt.Parent = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot

    prompt.Triggered:Connect(function(player)
        if brainrot:GetAttribute("IsCollected") then return end
        brainrot:SetAttribute("IsCollected", true)
        BrainrotManager.addToInventory(player, typeID)
        brainrot:Destroy()
    end)

    task.spawn(function()
        local timeLeft = DESPAWN_TIME
        while timeLeft > 0 and brainrot and brainrot.Parent and not brainrot:GetAttribute("IsCollected") do
            task.wait(1)
            timeLeft = timeLeft - 1
            if brainrot and brainrot.Parent then
                brainrot:SetAttribute("TimeLeft", timeLeft)
                timerText.Text = timeLeft .. "s"
            end
        end
        if timeLeft <= 0 and brainrot and brainrot.Parent and not brainrot:GetAttribute("IsCollected") then
            brainrot:Destroy()
        end
    end)
end

task.spawn(function()
    while true do
        spawnWithinArea()
        task.wait(SPAWN_INTERVAL)
    end
end)
