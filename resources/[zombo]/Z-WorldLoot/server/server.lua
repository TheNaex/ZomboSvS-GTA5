QBCore = exports['qb-core']:GetCoreObject()

local lootCooldown = {}

-- Función para generar objeto aleatorio basado en rareza
local function GenerateRandomLoot(lootItems)
    local totalRarity = 0
    for _, item in ipairs(lootItems) do
        totalRarity = totalRarity + item.rarity
    end

    local randomRarity = math.random(0, totalRarity)
    local currentRarity = 0

    for _, item in ipairs(lootItems) do
        currentRarity = currentRarity + item.rarity
        if randomRarity <= currentRarity then
            return item.name
        end
    end
end

-- Evento para obtener loot
RegisterNetEvent('loot-system:getLoot', function(lootPoint)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local lootPointKey = tostring(lootPoint.coords.x) .. tostring(lootPoint.coords.y) .. tostring(lootPoint.coords.z)

    if lootCooldown[lootPointKey] and os.time() - lootCooldown[lootPointKey] < Config.LootCooldown then
        TriggerClientEvent('QBCore:Notify', src, "Este punto de loot aún está en cooldown", 'error', 1500)
    else
        local randomItem = GenerateRandomLoot(lootPoint.items)
        Player.Functions.AddItem(randomItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randomItem], 'add')
        TriggerClientEvent('actualizarSkillBuscar', src, 1) -- Manda el up de habilidad al cliente
        lootCooldown[lootPointKey] = os.time()
    end
end)