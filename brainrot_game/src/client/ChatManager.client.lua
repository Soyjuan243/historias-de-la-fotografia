local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear GUI de Anuncio en pantalla si no existe
-- Contenedor de anuncios
local announcementScreen = Instance.new("ScreenGui")
announcementScreen.Name = "AnnouncementGui"
announcementScreen.ResetOnSpawn = false
announcementScreen.DisplayOrder = 100
announcementScreen.Parent = playerGui

local activeLabels = {}

local function showScreenAnnouncement(text)
    -- Crear una nueva etiqueta para cada mensaje para permitir que se apilen o no se sobrepongan
    local label = Instance.new("TextLabel")
    label.Name = "AnnouncementMessage"
    label.Size = UDim2.new(1, 0, 0.05, 0)
    -- Posición inicial (arriba)
    label.Position = UDim2.new(0, 0, -0.1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1) -- Blanco
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 35
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextTransparency = 1
    label.TextStrokeTransparency = 1
    label.Parent = announcementScreen

    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0.05, 0)
    uiPadding.PaddingRight = UDim.new(0.05, 0)
    uiPadding.Parent = label

    -- Si es un mensaje de sistema, ponerlo en Oro
    if text:find("%[SISTEMA%]") or text:find("%[GLOBAL%]") then
        label.TextColor3 = Color3.fromRGB(255, 215, 0) -- Oro
    end

    table.insert(activeLabels, label)

    -- Ajustar posiciones de labels activos
    for i, activeLabel in ipairs(activeLabels) do
        local targetY = 0.02 + ((#activeLabels - i) * 0.06)
        TweenService:Create(activeLabel, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 0, targetY, 0)
        }):Play()
    end

    -- Fade In
    TweenService:Create(label, TweenInfo.new(0.5), {
        TextTransparency = 0,
        TextStrokeTransparency = 0.5
    }):Play()

    -- Desvanecer y destruir después de un tiempo
    task.delay(7, function()
        local fadeOut = TweenService:Create(label, TweenInfo.new(1), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            local index = table.find(activeLabels, label)
            if index then
                table.remove(activeLabels, index)
            end
            label:Destroy()
        end)
    end)
end

local function displaySystemMessage(text)
    print("[Client] Recibido SystemMessage:", text)
    -- Mostrar siempre en pantalla (GUI propia)
    showScreenAnnouncement(text)

    -- Intentar enviar al chat
    task.spawn(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local textChannels = TextChatService:FindFirstChild("TextChannels") or TextChatService:WaitForChild("TextChannels", 5)
            if textChannels then
                local generalChannel = textChannels:FindFirstChild("RBXGeneral") or textChannels:WaitForChild("RBXGeneral", 5)
                if generalChannel then
                    generalChannel:DisplaySystemMessage("<font color='#FFD700'>[SISTEMA]</font> " .. text)
                    return
                end
            end
        end

        -- Fallback: StarterGui (Legacy) o si falla TextChatService
        pcall(function()
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[SISTEMA] " .. text,
                Color = Color3.fromRGB(255, 215, 0), -- Oro
                Font = Enum.Font.FredokaOne,
                TextSize = 18
            })
        end)
    end)
end

-- Escuchar eventos del servidor
Events.get("SystemMessage").OnClientEvent:Connect(displaySystemMessage)

print("[Client] Chat Manager: Active.")
