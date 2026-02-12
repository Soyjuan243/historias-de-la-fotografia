local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))
local BrainrotData = require(Shared:WaitForChild("BrainrotData"))
local Utils = require(Shared:WaitForChild("Utils"))

-- Configuración del Vendedor
local MERCHANT_NAME = "Comprador de Brainrots"
local SELL_PERCENTAGE = 0.5 -- Vende por el 50% del costo base

local function sellItem(player, typeID)
    local data = BrainrotData.Types[typeID]
    if not data then return false end

    local sellPrice = math.floor(data.BaseUpgradeCost * SELL_PERCENTAGE)

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Money") then
        leaderstats.Money.Value = leaderstats.Money.Value + sellPrice
        return true, sellPrice
    end

    return false
end

-- Remote Event: SellBrainrot
Events.get("SellBrainrot").OnServerEvent:Connect(function(player, action, target)
    local character = player.Character
    if not character then return end

    if action == "Hand" then
        -- Vender lo que tiene en la mano
        local tool = character:FindFirstChildWhichIsA("Tool")
        if tool and tool:GetAttribute("IsBrainrotTool") then
            local typeID = tool:GetAttribute("BrainrotType")
            local success, price = sellItem(player, typeID)

            if success then
                tool:Destroy()
                -- Eliminar del inventario persistente (Atributo)
                local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
                local owned = HttpService:JSONDecode(ownedStr)
                for i, id in ipairs(owned) do
                    if id == typeID then
                        table.remove(owned, i)
                        break
                    end
                end
                player:SetAttribute("OwnedBrainrots", HttpService:JSONEncode(owned))
                -- print(player.Name .. " vendió " .. typeID .. " por $" .. price)
            end
        end
    elseif action == "Inventory" and target then
        -- Vender un item específico del inventario (si no lo tiene equipado)
        local ownedStr = player:GetAttribute("OwnedBrainrots") or "[]"
        local owned = HttpService:JSONDecode(ownedStr)
        local index = -1
        for i, id in ipairs(owned) do
            if id == target then
                index = i
                break
            end
        end

        if index ~= -1 then
            local success, price = sellItem(player, target)
            if success then
                table.remove(owned, index)
                player:SetAttribute("OwnedBrainrots", HttpService:JSONEncode(owned))

                -- También quitar de la mochila si está ahí
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:GetAttribute("IsBrainrotTool") and tool:GetAttribute("BrainrotType") == target then
                            tool:Destroy()
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Remote Event: ExitZone
Events.get("ExitZone").OnServerEvent:Connect(function(player)
    -- Lógica para salir de la zona.
    -- Por ahora lo teletransportamos al Spawn inicial o simplemente le damos un mensaje.
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Buscar un spawn point general o el origen
        local spawnLocation = Workspace:FindFirstChildWhichIsA("SpawnLocation")
        if spawnLocation then
            character:PivotTo(spawnLocation.CFrame + Vector3.new(0, 5, 0))
        else
            character:PivotTo(CFrame.new(0, 10, 0))
        end
        -- print(player.Name .. " salió de la zona.")
    end
end)

-- Crear el NPC Comprador si no existe (opcional, mejor si el usuario lo pone)
local function setupMerchantNPC()
    local merchant = Workspace:FindFirstChild("Comprador")
    if not merchant then
        -- Opcional: Crear un placeholder
        merchant = Instance.new("Part")
        merchant.Name = "Comprador"
        merchant.Size = Vector3.new(4, 6, 4)
        merchant.Position = Vector3.new(-20, 3, -20) -- Posición arbitraria
        merchant.Anchored = true
        merchant.BrickColor = BrickColor.new("Bright blue")
        merchant.Parent = Workspace

        local label = Instance.new("BillboardGui")
        label.Size = UDim2.new(5, 0, 1, 0)
        label.StudsOffset = Vector3.new(0, 4, 0)
        label.AlwaysOnTop = true
        label.Parent = merchant

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Text = MERCHANT_NAME
        text.TextColor3 = Color3.new(1, 1, 0)
        text.BackgroundTransparency = 1
        text.Font = Enum.Font.FredokaOne
        text.TextScaled = true
        text.Parent = label
    end

    -- Añadir ProximityPrompt para interacción
    local prompt = merchant:FindFirstChild("MerchantPrompt")
    if not prompt then
        prompt = Instance.new("ProximityPrompt")
        prompt.Name = "MerchantPrompt"
        prompt.ActionText = "Vender Brainrots"
        prompt.ObjectText = "Comprador"
        prompt.HoldDuration = 0.5
        prompt.Parent = merchant
    end
end

setupMerchantNPC()
