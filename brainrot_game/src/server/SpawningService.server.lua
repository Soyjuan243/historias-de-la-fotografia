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

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.Adornee = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = brainrot

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "¡" .. data.Name .. "!"
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.FredokaOne
    text.TextSize = 14
    text.Parent = billboard

    brainrot:SetAttribute("TypeID", typeID)
    brainrot:SetAttribute("IsCollected", false)

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

    task.delay(DESPAWN_TIME, function()
        if brainrot and brainrot.Parent and not brainrot:GetAttribute("IsCollected") then
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

print("[Server] Spawning Service: Random placement & standing upright enabled.")
