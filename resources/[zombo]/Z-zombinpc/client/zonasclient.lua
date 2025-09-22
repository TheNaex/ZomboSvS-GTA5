local QBCore = exports['qb-core']:GetCoreObject()
local inSafeZone = false

-- Configuración de zonas seguras
local safeZones = {
    {
        name = "Stab City",
        pos = vector3(63.05, 3716.91, 39.75),		
        radius = 190.0
    },
    {
        name = "Principal",
        pos = vector3(-814.89, 181.95, 76.85),
        radius = 90.0
    }
}

-- Verificar si el jugador está en una zona segura
function IsPlayerInSafeZone()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    for _, zone in pairs(safeZones) do
        local distance = #(playerPos - zone.pos)
        if distance < zone.radius then
            return true, zone.name
        end
    end

    return false
end

-- Bucle para verificar la ubicación del jugador
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)  -- Verificar cada segundo

        local isInZone, zoneName = IsPlayerInSafeZone()
        if isInZone and not inSafeZone then
            inSafeZone = true
            -- Notificar al servidor que el jugador ha entrado en una zona segura
            TriggerServerEvent('safezone:entered', zoneName)
        elseif not isInZone and inSafeZone then
            inSafeZone = false
            -- Notificar al servidor que el jugador ha salido de una zona segura
            TriggerServerEvent('safezone:left')
        end
    end
end)
