local QBCore = exports['qb-core']:GetCoreObject()

players = {}

RegisterServerEvent("qb-zombies:newplayer")
AddEventHandler("qb-zombies:newplayer", function(id)
    players[source] = id
    TriggerClientEvent("qb-zombies:playerupdate", -1, players)
end)

AddEventHandler("playerDropped", function(reason)
    players[source] = nil
    TriggerClientEvent("qb-zombies:clear", source)
    TriggerClientEvent("qb-zombies:playerupdate", -1, players)
end)

AddEventHandler("onResourceStop", function()
	 TriggerClientEvent("qb-zombies:clear", -1)
end)


RegisterServerEvent('qb-zombies:itemloot')
AddEventHandler('qb-zombies:itemloot', function(listKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local ItemAmount = Config.ItemAmount
    local item = math.random(1, #Config.Items)
    for k,v in pairs(Config.Items) do
        if item == k then
            Player.Functions.AddItem(v, ItemAmount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v], 'add')
			TriggerClientEvent("QBCore:Notify", src, 'Has encontrado '..ItemAmount..'x '..QBCore.Shared.Items[v].label..' ','success')
        end
    end
	
    if Config.AddtionalItem then
        local Luck = math.random(1, 8)
        local Odd = math.random(1, 8)
        if Luck == Odd then
            Player.Functions.AddItem(Config.AddItem, Config.AddItemAmount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.AddItem], 'add')
        end
    end
end)

RegisterNetEvent('zombies:gunshotDetected')
AddEventHandler('zombies:gunshotDetected', function(coords)
    TriggerClientEvent('zombies:moveZombieToCoords', -1, coords)
end)


entitys = {}

RegisterServerEvent("RegisterNewZombie")
AddEventHandler("RegisterNewZombie", function(entity)
	TriggerClientEvent("ZombieSync", -1, entity)
	table.insert(entitys, entity)
end)

--------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
local zombieCounts = {}

RegisterCommand("zombitotal", function(source, args, rawCommand)
    local src = source
    local playerPermission = QBCore.Functions.HasPermission(src, "admin")
    if playerPermission then
        zombieCounts = {} -- Reinicia el conteo
        TriggerClientEvent('requestZombieCount', -1) -- Solicita a todos los clientes
        -- Espera unos segundos para recibir las respuestas
        Citizen.SetTimeout(5000, function()
            local totalCount = 0
            for _, count in pairs(zombieCounts) do
                totalCount = totalCount + count
            end
            TriggerClientEvent('chat:addMessage', src, {
                color = {255, 0, 0},
                multiline = true,
                args = {"Admin", "Número total de zombies activos en el servidor: " .. totalCount}
            })
        end)
    else
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Error", "No tienes permiso para usar este comando."}
        })
    end
end, false)

RegisterNetEvent('reportZombieCount')
AddEventHandler('reportZombieCount', function(count)
    local src = source
    zombieCounts[src] = count
end)