QBCore = exports['qb-core']:GetCoreObject()

-- Verificar conexión a la base de datos realizando una consulta simple
exports.oxmysql:execute('SELECT 1', {}, function(result)
    if result then
        print('Conexión a la base de datos de vehículos verificada con éxito.')
        
        -- Una vez confirmada la conexión, consulta cuántos vehículos hay listos para cargar
        exports.oxmysql:execute('SELECT COUNT(*) AS total FROM vehiculos', {}, function(vehiculos)
            if vehiculos[1] then
                print('Vehículos listos para cargar: ' .. vehiculos[1].total)
            else
                print('Error al consultar la cantidad de vehículos.')
            end
        end)
    else
        print('Error al verificar la conexión a la base de datos.')
    end
end)
--------------------------------------------------------------------
-------------------------------------------------------------------
--------------------------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
		Citizen.Wait(10000) -- Espera de 10 segundos (10000 milisegundos)
		cargarVehiculos()
    end
end)

----------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------

function cargarVehiculos()
    exports.oxmysql:fetch('SELECT * FROM vehiculos', {}, function(vehiculos)
        if vehiculos and #vehiculos > 0 then
            print('Cargando ' .. #vehiculos .. ' vehículos desde la base de datos...')
            for _, vehiculo in ipairs(vehiculos) do
                -- Emitir un evento al cliente para crear el vehículo con los datos cargados
                print("Disparando evento 'cargarcoches' al cliente con datos del vehículo.")
                TriggerClientEvent('cargarcoches', -1, {
                    owner = vehiculo.owner,  -- Incluir el campo owner
                    model = vehiculo.model,
                    pos = {x = vehiculo.x, y = vehiculo.y, z = vehiculo.z},
                    heading = vehiculo.heading,
                    health = vehiculo.health,
                    fuel = vehiculo.fuel,
                    colors = {color1 = vehiculo.color1, color2 = vehiculo.color2},
                    engine = vehiculo.engine  -- Incluir el estado del motor
                })
                print('Vehículo cargado: Owner: ' .. (vehiculo.owner or 'N/A') ..
                      ', Modelo: ' .. vehiculo.model ..
                      ', Posición: X:' .. vehiculo.x ..
                      ' Y:' .. vehiculo.y ..
                      ' Z:' .. vehiculo.z ..
                      ', Estado del Motor: ' .. (vehiculo.engine and 'Encendido' or 'Apagado'))
            end
        else
            print('No se encontraron vehículos para cargar desde la base de datos.')
        end
    end)
end


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------