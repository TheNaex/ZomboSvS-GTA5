local QBCore = exports['qb-core']:GetCoreObject()

local hasSpawnedOnce = false -- Mensaje bienvenida


---------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)  -- Ejecutar el código cada frame

        -- Desactivar peatones
        SetPedDensityMultiplierThisFrame(0.0) -- Establece la densidad de peatones a 0
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- Desactiva peatones y eventos aleatorios de peatones

        -- Desactivar vehículos
        SetParkedVehicleDensityMultiplierThisFrame(0.0) -- Desactiva vehículos estacionados
        SetRandomVehicleDensityMultiplierThisFrame(0.0) -- Desactiva vehículos en movimiento
        SetVehicleDensityMultiplierThisFrame(0.0) -- Desactiva todos los vehículos

        -- Desactivar luces
        SetBlackout(true)
    end
end)
-----------------------------------------------------------
--------------------------------------------------------------------
RegisterNetEvent('playerSpawned', function()
    if not hasSpawnedOnce then
        Citizen.Wait(1000) -- Espera para asegurar que los datos del jugador estén cargados
            -- Primer mensaje en rojo
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0 }, -- Color rojo
                multiline = true,
                args = {"Bienvenido a ZomboSvS"}
            })

            -- Segundo mensaje en blanco
            TriggerEvent('chat:addMessage', {
                color = { 255, 255, 255 }, -- Color blanco
                multiline = true,
                args = {"Si tienes alguna duda o necesitas ayuda no olvides visitar nuestro discord"}
            })

            -- Cambiar la bandera a true para evitar que se muestre de nuevo
			 hasSpawnedOnce = true
    end
end)
-----------------------------------------------------------------