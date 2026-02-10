local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local BrainrotManager = require(ServerScriptService:WaitForChild("BrainrotManager"))
local Events = require(Shared:WaitForChild("Events"))

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

local function spawnBrainrot(player, typeID)
    local data = BrainrotData.Types[typeID]
    if not data then return end

    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local brainrot
    local modelTemplate = Models and Models:FindFirstChild(typeID)

    if modelTemplate then
        brainrot = modelTemplate:Clone()
        brainrot.Name = "AdminSpawned_" .. typeID

        -- Normalizar rotación para cálculo de tamaño
        brainrot:PivotTo(CFrame.Angles(0, 0, math.rad(-90)))
        local modelSize = brainrot:GetExtentsSize()
        local pivotOffset = modelSize.Y / 2

        -- Posicionar frente al jugador
        local spawnCFrame = root.CFrame * CFrame.new(0, 0, -5) * CFrame.new(0, pivotOffset, 0) * CFrame.Angles(0, 0, math.rad(-90))
        brainrot:PivotTo(spawnCFrame)

        local function anchorRecursive(obj)
            if obj:IsA("BasePart") then
                obj.Anchored = true
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = true
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
        brainrot:PivotTo(root.CFrame * CFrame.new(0, 2, -5))
        brainrot.Anchored = true
        brainrot.CanCollide = false
        brainrot.CanTouch = false
        brainrot.BrickColor = BrickColor.new("Bright yellow")
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

    -- Anuncio global
    local msg = string.format("%s ha spawneado un brainrot con rareza %s y el nombre %s",
        player.Name, data.Category or "Común", data.Name or "???")

    Events.get("SystemMessage"):FireAllClients(msg)
    print("[AdminCommand] " .. msg)
end

local function onChatted(player, message)
    if not isAuthorized(player) then return end

    local args = string.split(message, " ")
    local command = args[1]:lower()

    if command == "/spawn" and args[2] then
        local typeID = args[2]
        spawnBrainrot(player, typeID)
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
