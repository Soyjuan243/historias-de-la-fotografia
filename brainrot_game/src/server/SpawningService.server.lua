local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))

local Models = ReplicatedStorage:FindFirstChild("Models")

local SPAWN_INTERVAL = 10
local DESPAWN_TIME = 30
local SPAWN_RANGE = 100

local commonIDs = {"Common1", "Common2", "Common3", "Common4", "Common5"}

local function getRandomPosition()
    local baseplate = Workspace:FindFirstChild("Baseplate") or Workspace:FindFirstChildWhichIsA("BasePart")
    if baseplate then
        local size = baseplate.Size
        local pos = baseplate.Position
        local rx = (math.random() - 0.5) * size.X
        local rz = (math.random() - 0.5) * size.Z
        return Vector3.new(pos.X + rx, pos.Y + size.Y/2 + 2, pos.Z + rz)
    end
    return Vector3.new((math.random() - 0.5) * SPAWN_RANGE * 2, 5, (math.random() - 0.5) * SPAWN_RANGE * 2)
end

local function spawnRandomly()
    local typeID = commonIDs[math.random(1, #commonIDs)]
    local data = BrainrotData.Types[typeID]

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = "Spawned_" .. typeID

        local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
        brainrot:PivotTo(CFrame.new(getRandomPosition()) * randomRotation)

        -- Improved Recursive Anchoring
        if brainrot:IsA("BasePart") then brainrot.Anchored = true end
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
        brainrot.CFrame = CFrame.new(getRandomPosition()) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
        brainrot.Anchored = true
        brainrot.CanCollide = false
        brainrot.BrickColor = BrickColor.new("Bright green")
    end

    brainrot.Parent = Workspace

    -- Name Billboard
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
    nameText.Text = "¡" .. data.Name .. "!"
    nameText.TextColor3 = Color3.new(1, 1, 1)
    nameText.Font = Enum.Font.FredokaOne
    nameText.TextSize = 16
    nameText.Parent = nameBillboard

    local nameStroke = Instance.new("UIStroke")
    nameStroke.Thickness = 2
    nameStroke.Parent = nameText

    -- Timer Billboard (New)
    local timerBillboard = Instance.new("BillboardGui")
    timerBillboard.Name = "TimerBillboard"
    timerBillboard.Size = UDim2.new(0, 100, 0, 50)
    timerBillboard.Adornee = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot
    timerBillboard.AlwaysOnTop = true
    timerBillboard.StudsOffset = Vector3.new(0, 5, 0) -- Above the name
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
    iconCorner.CornerRadius = UDim.new(1, 0) -- Circle
    iconCorner.Parent = iconFrame

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0.7, 0, 0.7, 0)
    iconImg.Position = UDim2.new(0.15, 0, 0.15, 0)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = "rbxassetid://6031068433" -- Clock icon
    iconImg.Parent = iconFrame

    local timerText = Instance.new("TextLabel")
    timerText.Size = UDim2.new(0.6, 0, 1, 0)
    timerText.Position = UDim2.new(0.4, 0, 0, 0)
    timerText.BackgroundTransparency = 1
    timerText.Text = DESPAWN_TIME .. "s"
    timerText.TextColor3 = Color3.new(0, 0, 0) -- Black text as in image
    timerText.Font = Enum.Font.FredokaOne
    timerText.TextSize = 24
    timerText.TextXAlignment = Enum.TextXAlignment.Left
    timerText.Parent = timerFrame

    local textStroke = Instance.new("UIStroke")
    textStroke.Thickness = 1.5
    textStroke.Color = Color3.new(1, 1, 1) -- White stroke for visibility
    textStroke.Parent = timerText

    brainrot:SetAttribute("TypeID", typeID)
    brainrot:SetAttribute("IsCollected", false)
    brainrot:SetAttribute("TimeLeft", DESPAWN_TIME)

    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Agarrar"
    prompt.ObjectText = data.Name
    prompt.HoldDuration = 0
    prompt.Parent = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot

    prompt.Triggered:Connect(function(player)
        if brainrot:GetAttribute("IsCollected") then return end
        brainrot:SetAttribute("IsCollected", true)
        BrainrotManager.addToInventory(player, typeID)
        brainrot:Destroy()
    end)

    -- Countdown Logic
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
        spawnRandomly()
        task.wait(SPAWN_INTERVAL)
    end
end)

print("[Server] Spawning Service: Random placement & standing upright enabled. Countdown timer added.")
