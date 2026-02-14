local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RunService = game:GetService("RunService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))
local Events = require(Shared:WaitForChild("Events"))
local TextChatService = game:GetService("TextChatService")

local Models = ReplicatedStorage:FindFirstChild("Models")

-- Configuración de usuarios autorizados
local AUTHORIZED_IDS = {}

local function isAuthorized(player)
    if RunService:IsStudio() then return true end
    if player.UserId == game.CreatorId then return true end
    for _, id in ipairs(AUTHORIZED_IDS) do
        if player.UserId == id then return true end
    end
    return false
end

local function spawnBrainrotInSpawn1(player, typeID)
    local data = BrainrotData.Types[typeID]
    if not data then return end

    local spawnParts = {}
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if (obj.Name == "spawn1" or obj.Name == "spawn2") and obj:IsA("BasePart") then
            table.insert(spawnParts, obj)
        end
    end

    if #spawnParts == 0 then return end
    local spawnPart = spawnParts[math.random(1, #spawnParts)]

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = "AdminSpawned_" .. typeID

        local rotationOffset = data.RotationOffset or Vector3.new(0, 0, 0)
        local correction = CFrame.Angles(-89.5 + math.rad(rotationOffset.X), math.rad(180 + rotationOffset.Y), math.rad(rotationOffset.Z))

        brainrot:PivotTo(correction)

        -- Calcular offset basado en el tamaño del modelo
        local modelSize = brainrot:GetExtentsSize()
        local pivotOffset = modelSize.Y / 2

        local size = spawnPart.Size
        local rx = (math.random() - 0.5) * (size.X * 0.8)
        local rz = (math.random() - 0.5) * (size.Z * 0.8)

        local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)

        local targetCFrame = spawnPart.CFrame * CFrame.new(rx, size.Y/2 + pivotOffset, rz) * randomRotation * correction

        brainrot:PivotTo(targetCFrame)
        brainrot.Parent = game.Workspace

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
        brainrot.Name = "AdminSpawned_" .. typeID
        brainrot.Size = Vector3.new(4, 4, 4)
        brainrot.Anchored = true
        brainrot.CanCollide = false
        brainrot.CanTouch = false
        brainrot.BrickColor = BrickColor.new("Bright yellow")

        local size = spawnPart.Size
        local rx = (math.random() - 0.5) * (size.X * 0.8)
        local rz = (math.random() - 0.5) * (size.Z * 0.8)
        brainrot:PivotTo(spawnPart.CFrame * CFrame.new(rx, size.Y/2 + 2, rz))
    end

    brainrot.Parent = game.Workspace

    local targetPart = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot
    if targetPart then
        local prompt = Instance.new("ProximityPrompt")
        prompt.ActionText = "Recoger (Spawn Admin)"
        prompt.ObjectText = data.Name or "Personaje"
        prompt.HoldDuration = 0
        prompt.Parent = targetPart

        prompt.Triggered:Connect(function(collector)
            if brainrot:GetAttribute("IsCollected") then return end
            brainrot:SetAttribute("IsCollected", true)
            BrainrotManager.addToInventory(collector, typeID)
            brainrot:Destroy()
        end)
    end
end

local function onChatted(player, message)
    if not isAuthorized(player) then return end

    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        if message:sub(1,6):lower() == "/spawn" then
            return
        end
    end

    local args = string.split(message, " ")
    local command = args[1]:lower()

    if command == "/spawn" and args[2] then
        spawnBrainrotInSpawn1(player, args[2])
    end
end

local function setupTextCommands()
    if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then return end

    local commandsFolder = TextChatService:FindFirstChild("TextCommands") or TextChatService

    local spawnCmd = Instance.new("TextChatCommand")
    spawnCmd.Name = "AdminSpawnCommand"
    spawnCmd.PrimaryAlias = "/spawn"
    spawnCmd.Parent = commandsFolder
    spawnCmd.Triggered:Connect(function(originSource, unfilteredText)
        local player = Players:GetPlayerByUserId(originSource.UserId)
        if not player or not isAuthorized(player) then return end

        local args = string.split(unfilteredText, " ")
        if args[2] then
            spawnBrainrotInSpawn1(player, args[2])
        end
    end)
end

setupTextCommands()

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        onChatted(player, msg)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        onChatted(player, msg)
    end)
end
