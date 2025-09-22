QBCore = exports['qb-core']:GetCoreObject()

local engineAllowedToStart = {}


--------------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------------
RegisterNetEvent('cargarcoches')
AddEventHandler('cargarcoches', function(data)
    -- Imprimir los datos recibidos para depuración
    print("Recibiendo datos del vehículo desde el servidor...")
    print("Modelo: " .. data.model .. ", Posición: X:" .. data.pos.x .. " Y:" .. data.pos.y .. " Z:" .. data.pos.z .. ", Heading: " .. data.heading)
    print("Salud del Motor: " .. data.health .. ", Combustible: " .. data.fuel)
    print("Colores: Color1: " .. data.colors.color1 .. ", Color2: " .. data.colors.color2)
    if data.owner then
        print("Propietario: " .. data.owner)
    end

    local hash = GetHashKey(data.model)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(1)
    end

    local veh = CreateVehicle(hash, data.pos.x, data.pos.y, data.pos.z, data.heading, true, false)
    SetVehicleEngineHealth(veh, data.health)  -- Ajusta la salud del motor
	SetEntityAsMissionEntity(veh, true, true)
    -- Ajustar el nivel de combustible
    if data.fuel then
        SetVehicleFuelLevel(veh, data.fuel)
    end
    SetVehicleColours(veh, data.colors.color1, data.colors.color2)

    -- Configurar el estado del motor basado en el valor recibido y prevenir el encendido automático
    SetVehicleEngineOn(veh, data.engine == 1, false, true)
	-- Hacer el vehículo indirigible si el motor está apagado
    if data.engine == 0 then
        SetVehicleUndriveable(veh, true)
    end

    -- Confirmar que el vehículo ha sido creado
    if DoesEntityExist(veh) then
        print("Vehículo creado con éxito: " .. data.model)
    else
        print("Error al crear el vehículo: " .. data.model)
    end
    
    -- Lógica para el 'owner', si es necesario
    -- ...
end)

-----------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
local function toggleCarEngine()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle) -- Obtener el Network ID del vehículo
        local engineState = not GetIsVehicleEngineRunning(vehicle)

        -- Encender o apagar el motor y ajustar la dirigibilidad basado en el estado del motor
        SetVehicleEngineOn(vehicle, engineState, true, true)
        SetVehicleUndriveable(vehicle, not engineState) -- Hace el vehículo indirigible si el motor está apagado

        -- Actualizar el estado en engineAllowedToStart
        engineAllowedToStart[vehicleNetId] = engineState

        -- Nuevo sistema de notificacion del motor encendido/apagado
        local action = engineState and "encendido" or "apagado"
        local type = engineState and "encendido" or "apagado"
        local title = "Motor " .. action
        local message = "Has " .. action .. " el motor del vehículo."
        --QBCore.Functions.Notify("Has " .. action .. " el motor del vehículo.", engineState and 'success' or 'error', 1000)
        QBCore.Functions.Notify(message, type, 500) -- Ajustar tiempo de notificación a 500 ms
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 244) then -- M key
            toggleCarEngine()
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Un pequeño delay para no sobrecargar el ciclo
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle) -- Usar Network ID como clave

            -- Asegúrate de que la lógica para definir engineAllowedToStart[vehicleNetId] exista en alguna parte del script
            -- Por ejemplo, al entrar en el vehículo y decidir si el motor puede arrancarse o no

            if not engineAllowedToStart[vehicleNetId] and GetIsVehicleEngineRunning(vehicle) then
                SetVehicleEngineOn(vehicle, false, false, true)
            end
        end
    end
end)
---------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
Citizen.CreateThread(function() -- Consumo de gasolina del vehículo
    while true do
        Citizen.Wait(5000)  -- Intervalo de 5 segundos
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleFuelLevel = GetVehicleFuelLevel(vehicle)

            if vehicleFuelLevel and vehicleFuelLevel > 0 then
                local consumptionRate = Config.GlobalConsumptionRate
                -- Determina el consumo basado en si el vehículo está parado
                local consumo
                if IsVehicleStopped(vehicle) then
                    consumo = consumptionRate / 2
                else
                    consumo = consumptionRate
                end
                local newFuelLevel = vehicleFuelLevel - consumo
                SetVehicleFuelLevel(vehicle, newFuelLevel)

                if newFuelLevel <= 0 then
                    SetVehicleEngineOn(vehicle, false, false, false)
                    -- QBCore.Functions.Notify("Este vehículo no tiene gasolina", "error")
                    -- Nuevo sistema de notificación
                    exports['Z-Notificacion']:Notify("error", "Sin Gasolina", "Este vehículo no tiene gasolina", 2, true)
                end
            end
        end
    end
end)



----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------