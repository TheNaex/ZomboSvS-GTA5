local QBCore = exports['qb-core']:GetCoreObject()

-- Evento cuando el jugador entra en una zona segura
RegisterNetEvent('safezone:entered', function(zoneName)
    local src = source
    local msg = "Ahora estás en " .. zoneName .. ", una zona segura. Cualquier acto delictivo será castigado."
    TriggerClientEvent('QBCore:Notify', src, msg, 'primary')
end)

-- Evento cuando el jugador sale de una zona segura
RegisterNetEvent('safezone:left', function()
    local src = source
    TriggerClientEvent('QBCore:Notify', src, "Has salido de la zona segura.", 'error')
end)
