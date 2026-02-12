local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear GUI de Anuncio en pantalla si no existe
local announcementScreen = Instance.new("ScreenGui")
announcementScreen.Name = "AnnouncementGui"
announcementScreen.ResetOnSpawn = false
announcementScreen.DisplayOrder = 100
announcementScreen.Parent = playerGui

-- Contenedor principal para los anuncios
local container = Instance.new("Frame")
container.Name = "AnnouncementContainer"
container.Size = UDim2.new(0.8, 0, 0.4, 0)
container.Position = UDim2.new(0.5, 0, 0.1, 0)
container.AnchorPoint = Vector2.new(0.5, 0)
container.BackgroundTransparency = 1
container.Parent = announcementScreen

local listLayout = Instance.new("UIListLayout")
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = container

local function showScreenAnnouncement(text)
    local label = Instance.new("TextLabel")
    label.Name = "AnnouncementMessage"
    label.Size = UDim2.new(1, 0, 0.15, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.FredokaOne
    label.TextScaled = true
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextTransparency = 1
    label.TextStrokeTransparency = 1
    label.Parent = container

    -- Si es un mensaje de sistema, ponerlo en Oro
    if text:find("%[SISTEMA%]") or text:find("%[GLOBAL%]") then
        label.TextColor3 = Color3.fromRGB(255, 215, 0) -- Oro
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
            label:Destroy()
        end)
    end)
end

local function displaySystemMessage(text)
    showScreenAnnouncement(text)
end

-- Escuchar eventos del servidor
Events.get("SystemMessage").OnClientEvent:Connect(displaySystemMessage)
