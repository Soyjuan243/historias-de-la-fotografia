local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))
local Events = require(Shared:WaitForChild("Events"))
local MessagingService = game:GetService("MessagingService")

local Models = ReplicatedStorage:FindFirstChild("Models")

-- Configuración de usuarios autorizados
local AUTHORIZED_IDS = {
    -- Puedes añadir IDs de usuario aquí
    -- Ejemplo: 12345678,
}

local function isAuthorized(player)
    -- El creador del juego siempre está autorizado
    if player.UserId == game.CreatorId then return true end
    -- Verificar lista de IDs
    for _, id in ipairs(AUTHORIZED_IDS) do
        if player.UserId == id then return true end
    end
    -- Opcional: Verificar rango en grupo si fuera necesario
    -- if player:GetRankInGroup(0000) >= 250 then return true end
    return false
end

local function broadcastGlobalMessage(text)
    local data = {
        Text = text,
        Time = os.time()
    }
    pcall(function()
        MessagingService:PublishAsync("GlobalAnnouncements", data)
    end)
end

-- Subscribe to global messages
MessagingService:SubscribeAsync("GlobalAnnouncements", function(message)
    local data = message.Data
    Events.get("SystemMessage"):FireAllClients(data.Text)
end)

local function spawnBrainrotInSpawn1(player, typeID)
    local data = BrainrotData.Types[typeID]
    if not data then return end

    -- Buscar spawn1
    local spawnParts = {}
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj.Name == "spawn1" and obj:IsA("BasePart") then
            table.insert(spawnParts, obj)
        end
    end

    if #spawnParts == 0 then
        print("[AdminCommand] No se encontró spawn1")
        return
    end

    local spawnPart = spawnParts[math.random(1, #spawnParts)]

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = "AdminSpawned_" .. typeID
        local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)

        -- Aplicar rotación (90, 0, -180)
        brainrot:PivotTo(CFrame.Angles(math.rad(90), 0, math.rad(-180)))
        local modelSize = brainrot:GetExtentsSize()
        local pivotOffset = modelSize.Y / 2

        local correctionRotation = CFrame.Angles(math.rad(90), 0, math.rad(-180))

        -- getRandomPositionInPart logic
        local size = spawnPart.Size
        local rx = (math.random() - 0.5) * (size.X * 0.8)
        local rz = (math.random() - 0.5) * (size.Z * 0.8)
        local targetCFrame = spawnPart.CFrame * CFrame.new(rx, size.Y/2 + pivotOffset, rz) * randomRotation * correctionRotation

        brainrot:PivotTo(targetCFrame)

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

    -- Configurar ProximityPrompt para recolección
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Recoger (Spawn Admin)"
    prompt.ObjectText = data.Name or "Personaje"
    prompt.HoldDuration = 0
    prompt.Parent = (brainrot:IsA("Model") and (brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart"))) or brainrot

    prompt.Triggered:Connect(function(collector)
        if brainrot:GetAttribute("IsCollected") then return end
        brainrot:SetAttribute("IsCollected", true)
        BrainrotManager.addToInventory(collector, typeID)
        brainrot:Destroy()
    end)

    -- Anuncio Inter-Server
    local msg = string.format("%s ha spawneado un brainrot con rareza %s y el nombre %s",
        player.Name, data.Category or "Común", data.Name or "???")

    broadcastGlobalMessage(msg)
end

local function onChatted(player, message)
    if not isAuthorized(player) then return end

    local args = string.split(message, " ")
    local command = args[1]:lower()

    if command == "/spawn" and args[2] then
        local typeID = args[2]
        spawnBrainrotInSpawn1(player, typeID)
    elseif command == "/global" or command == "/announcement" then
        local msgText = table.concat(args, " ", 2)
        if msgText and msgText ~= "" then
            broadcastGlobalMessage("[GLOBAL] " .. player.Name .. ": " .. msgText)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        onChatted(player, msg)
    end)
end)

-- Para jugadores que ya están en el servidor (si se reinicia el script)
for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        onChatted(player, msg)
    end)
end

print("[Server] Admin Commands: Loaded.")
