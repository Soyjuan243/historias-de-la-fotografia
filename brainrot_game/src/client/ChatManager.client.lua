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
local function createAnnouncementGui()
    local screen = Instance.new("ScreenGui")
    screen.Name = "AnnouncementGui"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 100
    screen.Parent = playerGui

    local label = Instance.new("TextLabel")
    label.Name = "MessageLabel"
    label.Size = UDim2.new(1, 0, 0.15, 0)
    label.Position = UDim2.new(0, 0, 0.02, 0) -- Higher up
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = Color3.new(1, 1, 1) -- White
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 35
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.TextScaled = false -- Don't scale, use fixed size for cleaner look like in image
    label.Parent = screen

    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0.1, 0)
    uiPadding.PaddingRight = UDim.new(0.1, 0)
    uiPadding.Parent = label

    return label
end

local announcementLabel = createAnnouncementGui()

local function showScreenAnnouncement(text)
    announcementLabel.Text = text
    announcementLabel.TextTransparency = 1
    announcementLabel.TextStrokeTransparency = 1

    local fadeIn = TweenService:Create(announcementLabel, TweenInfo.new(0.5), {
        TextTransparency = 0,
        TextStrokeTransparency = 0
    })

    fadeIn:Play()

    task.delay(5, function()
        local fadeOut = TweenService:Create(announcementLabel, TweenInfo.new(1), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        })
        fadeOut:Play()
    end)
end

local function displaySystemMessage(text)
    -- Mostrar en pantalla
    showScreenAnnouncement(text)

    -- Intentar usar el sistema moderno (TextChatService)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        -- En TextChatService, los mensajes del sistema se pueden enviar a canales
        -- Pero DisplaySystemMessage es un método del canal.
        -- Buscamos el canal general
        local generalChannel = TextChatService:WaitForChild("TextChannels"):FindFirstChild("RBXGeneral")
        if generalChannel then
            generalChannel:DisplaySystemMessage("<font color='#FFD700'>[SISTEMA]</font> " .. text)
        else
            -- Fallback si no hay canal general
            warn("[ChatManager] No se encontró el canal RBXGeneral")
        end
    else
        -- Sistema antiguo (Legacy Chat)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[SISTEMA] " .. text,
            Color = Color3.fromRGB(255, 215, 0), -- Oro
            Font = Enum.Font.FredokaOne,
            TextSize = 18
        })
    end
end

-- Escuchar eventos del servidor
Events.get("SystemMessage").OnClientEvent:Connect(displaySystemMessage)

print("[Client] Chat Manager: Active.")
