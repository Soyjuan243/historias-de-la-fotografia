local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))

local Models = ReplicatedStorage:FindFirstChild("Models")

local SPAWN_INTERVAL = 10
local DESPAWN_TIME = 30

local commonIDs = {"Common1", "Common2", "Common3", "Common4", "Common5"}

-- Optimization: Cache spawn points on startup
local cachedSpawnParts = {}

local function updateSpawnCache()
    cachedSpawnParts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "spawn1" and obj:IsA("BasePart") then
            table.insert(cachedSpawnParts, obj)
        end
    end
end

-- Initial cache and monitor for new spawns
updateSpawnCache()
Workspace.DescendantAdded:Connect(function(desc)
    if desc.Name == "spawn1" and desc:IsA("BasePart") then table.insert(cachedSpawnParts, desc) end
end)

local function getRandomPositionInPart(part)
    local size = part.Size
    local rx = (math.random() - 0.5) * (size.X * 0.8) -- Use 80% to avoid edges
    local rz = (math.random() - 0.5) * (size.Z * 0.8)
    local topY = size.Y / 2

    -- Return CFrame to preserve orientation if the part is rotated
    return part.CFrame * CFrame.new(rx, topY, rz)
end

local function spawnWithinArea()
    if #cachedSpawnParts == 0 then return end

    local spawnPart = cachedSpawnParts[math.random(1, #cachedSpawnParts)]
    local typeID = commonIDs[math.random(1, #commonIDs)]
    local data = BrainrotData.Types[typeID]

    if not data then return end

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = "Spawned_" .. typeID
        local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)

        -- Positioning: Calculate model height to spawn exactly on top
        local modelSize = brainrot:GetExtentsSize()
        local pivotOffset = modelSize.Y / 2

        brainrot:PivotTo(getRandomPositionInPart(spawnPart) * CFrame.new(0, pivotOffset, 0) * randomRotation)

        if brainrot:IsA("BasePart") then
            brainrot.Anchored = true
            brainrot.CanCollide = false
        end
        for _, p in ipairs(brainrot:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Anchored = true
                p.CanCollide = false
            end
        end
    else
        brainrot = Instance.new("Part")
        brainrot.Name = "Spawned_" .. typeID
        brainrot.Size = Vector3.new(2, 2, 2)
        brainrot:PivotTo(getRandomPositionInPart(spawnPart) * CFrame.new(0, 1, 0) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0))
        brainrot.Anchored = true
        brainrot.CanCollide = false
        brainrot.BrickColor = BrickColor.new("Bright green")
    end

    brainrot.Parent = Workspace

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "NameBillboard"
    nameBillboard.Size = UDim2.new(0, 150, 0, 40)
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
    nameText.TextSize = 16
    nameText.Parent = nameBillboard

    local nameStroke = Instance.new("UIStroke")
    nameStroke.Thickness = 2
    nameStroke.Parent = nameText

    local timerBillboard = Instance.new("BillboardGui")
    timerBillboard.Name = "TimerBillboard"
    timerBillboard.Size = UDim2.new(0, 100, 0, 50)
    timerBillboard.Adornee = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot
    timerBillboard.AlwaysOnTop = true
    timerBillboard.StudsOffset = Vector3.new(0, 5, 0)
    timerBillboard.Parent = brainrot

    local timerFrame = Instance.new("Frame")
    timerFrame.Size = UDim2.new(0, 80, 0, 35)
    timerFrame.Position = UDim2.new(0.5, -40, 0.5, -17)
    timerFrame.BackgroundTransparency = 1
    timerFrame.Parent = timerBillboard

    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 30, 0, 30)
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
    timerText.Size = UDim2.new(0.6, 0, 1, 0)
    timerText.Position = UDim2.new(0.4, 0, 0, 0)
    timerText.BackgroundTransparency = 1
    timerText.Text = DESPAWN_TIME .. "s"
    timerText.TextColor3 = Color3.new(0, 0, 0)
    timerText.Font = Enum.Font.FredokaOne
    timerText.TextSize = 24
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

print("[Server] Spawning Service: Optimized area detection.")
