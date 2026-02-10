local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))

-- Require BrainrotManager (ModuleScript) to handle inventory addition
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))

local SPAWN_INTERVAL = 15 -- Spawn every 15s
local DESPAWN_TIME = 30   -- Destroy after 30s if not picked up

local commonIDs = {"Common1", "Common2", "Common3", "Common4", "Common5"}

local function spawnAtLocation(locationPart)
    local typeID = commonIDs[math.random(1, #commonIDs)]
    local data = BrainrotData.Types[typeID]

    local brainrot = Instance.new("Part")
    brainrot.Name = "Spawned_" .. typeID
    brainrot.Size = Vector3.new(2, 2, 2)
    brainrot.Position = locationPart.Position + Vector3.new(0, 2, 0)
    brainrot.Anchored = true
    brainrot.CanCollide = false
    brainrot.BrickColor = BrickColor.new("Bright green")
    brainrot.Parent = Workspace

    -- UI logic for the loose brainrot
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.Adornee = brainrot
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
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
    prompt.Parent = brainrot

    prompt.Triggered:Connect(function(player)
        if brainrot:GetAttribute("IsCollected") then return end
        brainrot:SetAttribute("IsCollected", true)

        -- Add to inventory
        BrainrotManager.addToInventory(player, typeID)

        -- Destroy visual representation
        brainrot:Destroy()
    end)

    -- 30 second destruction timer
    task.delay(DESPAWN_TIME, function()
        if brainrot and brainrot.Parent then
            if not brainrot:GetAttribute("IsCollected") then
                brainrot:Destroy()
            end
        end
    end)
end

task.spawn(function()
    while true do
        local spawns = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "spawn1" and obj:IsA("BasePart") then
                table.insert(spawns, obj)
            end
        end

        if #spawns > 0 then
            local loc = spawns[math.random(1, #spawns)]
            spawnAtLocation(loc)
        end

        task.wait(SPAWN_INTERVAL)
    end
end)

print("[Server] Spawning Service initialized.")
