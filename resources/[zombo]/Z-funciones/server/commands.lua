local QBCore = exports['qb-core']:GetCoreObject()

local permissions = {
    ['kill'] = 'admin',
    ['clothing'] = 'admin'
}

-- Comando /kill
RegisterCommand('kill', function(source, args, rawCommand)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    -- Verificar si el jugador es un administrador
    if QBCore.Functions.HasPermission(src, permissions['kill']) or IsPlayerAceAllowed(src, 'command') then
        local targetId = tonumber(args[1])
        if targetId then
            local targetPlayer = QBCore.Functions.GetPlayer(targetId)
            if targetPlayer then
                -- Mata al jugador
                --TriggerClientEvent('commands:client:killPlayer', targetPlayer.PlayerData.source)
				TriggerClientEvent('QBCore:Notify', src, 'desactivado', 'error')
            else
                TriggerClientEvent('QBCore:Notify', src, 'Jugador no encontrado', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'ID inválido', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'No tienes permiso para usar este comando', 'error')
    end
end, false)