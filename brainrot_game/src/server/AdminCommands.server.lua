local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RunService = game:GetService("RunService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))
local Events = require(Shared:WaitForChild("Events"))
local MessagingService = game:GetService("MessagingService")
local TextChatService = game:GetService("TextChatService")

local Models = ReplicatedStorage:FindFirstChild("Models")
local ServerId = game.JobId

-- Configuración de usuarios autorizados
local AUTHORIZED_IDS = {
    -- Puedes añadir IDs de usuario aquí
    -- Ejemplo: 12345678,
}

local function isAuthorized(player)
    -- Facilitar pruebas en Studio
    if RunService:IsStudio() then return true end
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
    -- Verificación de seguridad básica antes de mandar
    if not text or text == "" then return end

    local data = {
        Text = text,
        Time = os.time(),
        SourceId = ServerId
    }

    -- Fire locally first so the sender server sees it immediately
    Events.get("SystemMessage"):FireAllClients(text)

    pcall(function()
        MessagingService:PublishAsync("GlobalAnnouncements", data)
    end)
end

-- Subscribe to global messages
pcall(function()
    MessagingService:SubscribeAsync("GlobalAnnouncements", function(message)
        local data = message.Data

        -- To avoid duplicate messages on the sender server
        if data.SourceId == ServerId and ServerId ~= "" then
            return
        end

        Events.get("SystemMessage"):FireAllClients(data.Text)
    end)
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
        return
    end

    local spawnPart = spawnParts[math.random(1, #spawnParts)]

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = "AdminSpawned_" .. typeID
        local randomRotation = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)

        -- Aplicar rotación (90, 0, 90)
        brainrot:PivotTo(CFrame.Angles(math.rad(90), 0, math.rad(90)))
        local modelSize = brainrot:GetExtentsSize()
        local pivotOffset = modelSize.Y / 2

        local correctionRotation = CFrame.Angles(math.rad(90), 0, math.rad(90))

        -- getRandomPositionInPart logic
        local size = spawnPart.Size
        local rx = (math.random() - 0.5) * (size.X * 0.8)
        local rz = (math.random() - 0.5) * (size.Z * 0.8)
        local targetCFrame = spawnPart.CFrame * CFrame.new(rx, size.Y/2 + pivotOffset, rz) * randomRotation * correctionRotation

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

    -- Si es TextChatService, ignoramos Chatted para evitar doble ejecución de comandos
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        -- Solo si el mensaje parece un comando registrado
        if message:sub(1,6):lower() == "/spawn" or message:sub(1,7):lower() == "/global" then
            return
        end
    end

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

-- Configuración de TextChatService (Moderno)
local function setupTextCommands()
    -- Solo si se usa TextChatService
    if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then return end

    local commandsFolder = TextChatService:FindFirstChild("TextCommands")
    if not commandsFolder then
        -- En algunos entornos no existe, lo creamos o usamos TextChatService directamente
        commandsFolder = TextChatService
    end

    -- Comando /spawn
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

    -- Comando /global
    local globalCmd = Instance.new("TextChatCommand")
    globalCmd.Name = "AdminGlobalCommand"
    globalCmd.PrimaryAlias = "/global"
    globalCmd.SecondaryAlias = "/announcement"
    globalCmd.Parent = commandsFolder
    globalCmd.Triggered:Connect(function(originSource, unfilteredText)
        local player = Players:GetPlayerByUserId(originSource.UserId)
        if not player or not isAuthorized(player) then return end

        local args = string.split(unfilteredText, " ")
        local msgText = table.concat(args, " ", 2)
        if msgText and msgText ~= "" then
            broadcastGlobalMessage("[GLOBAL] " .. player.Name .. ": " .. msgText)
        end
    end)
end

setupTextCommands()

-- Fallback para Legacy Chat
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        -- Si es TextChatService, el evento Chatted puede dispararse pero preferimos TextChatCommand
        -- Sin embargo, lo dejamos como fallback seguro
        onChatted(player, msg)
    end)
end)

-- Para jugadores que ya están en el servidor (si se reinicia el script)
for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        onChatted(player, msg)
    end)
end
