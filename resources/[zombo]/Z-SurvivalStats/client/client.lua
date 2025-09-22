-- Variables de ejemplo
local baseTemperature = 21
local currentTemperature = baseTemperature
local temperatureOscillation = 0
local lastMessage = nil

-- Función para enviar los datos al NUI
function updateHUD()
    SendNUIMessage({
        type = "updateHUD",
        temperature = currentTemperature
    })
end

-- Función para obtener la temperatura basada en el clima
function getTemperatureBasedOnWeather()
    local weatherTypes = {
        [GetHashKey("EXTRASUNNY")] = 35,
        [GetHashKey("CLEAR")] = 30,
        [GetHashKey("NEUTRAL")] = 25,
        [GetHashKey("SMOG")] = 20,
        [GetHashKey("FOGGY")] = 18,
        [GetHashKey("OVERCAST")] = 22,
        [GetHashKey("CLOUDS")] = 24,
        [GetHashKey("CLEARING")] = 26,
        [GetHashKey("RAIN")] = 15,
        [GetHashKey("THUNDER")] = 14,
        [GetHashKey("SNOW")] = 0,
        [GetHashKey("BLIZZARD")] = -5,
        [GetHashKey("SNOWLIGHT")] = 1,
        [GetHashKey("XMAS")] = -2
    }

    local _, currentWeatherHash = GetWeatherTypeTransition()
    return weatherTypes[currentWeatherHash] or 21 -- Valor por defecto
end

-- Función para aplicar el efecto de congelación
function applyFreezingEffect(apply)
    if apply then
        SetTimecycleModifier("CAMERA_BW") -- Ejemplo de efecto de congelación
    else
        ClearTimecycleModifier()
    end
end

-- Función para mostrar mensajes al jugador según la temperatura
function showTemperatureMessage(temp)
    local message = nil

    if temp > 35 then
        message = "~r~Te estás muriendo de calor"
    elseif temp > 27 and temp <= 35 then
        message = "~o~Tienes calor"
    elseif temp > 25 and temp <= 27 then
        message = "~y~Tienes algo de frío"
    elseif temp > 20 and temp <= 25 then
        message = "~b~Comienzas a tener frío"
    elseif temp > 10 and temp <= 20 then
        message = "~b~Tienes frío"
    elseif temp > 0 and temp <= 10 then
        message = "~r~Te estás congelando de frío"
    elseif temp > -5 and temp <= 0 then
        message = "~r~Te estás congelando de frío"
    elseif temp > -10 and temp <= -5 then
        message = "~r~Te estás muriendo de frío"
    end

    if message ~= lastMessage then
        ShowNotification(message)
        lastMessage = message
    end
end

-- Función para mostrar notificaciones
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Ejemplo de actualización periódica para el clima
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Actualiza cada minuto
        baseTemperature = getTemperatureBasedOnWeather()
        -- Resetear la oscilación cada vez que se actualiza la base de temperatura
        temperatureOscillation = 0
        currentTemperature = baseTemperature + temperatureOscillation
        print("Actualizando temperatura base según el clima: " .. baseTemperature)
        updateHUD()

        -- Aplica el efecto de congelación si la temperatura es menor a 0
        if currentTemperature < 0 then
            applyFreezingEffect(true)
        else
            applyFreezingEffect(false)
        end

        -- Muestra el mensaje adecuado según la temperatura
        showTemperatureMessage(currentTemperature)
    end
end)

-- Ejemplo de fluctuación de temperatura (opcional)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20000) -- Fluctúa cada 10 segundos
        local change = math.random(-1, 1) -- Cambia la oscilación de la temperatura aleatoriamente entre -1 y 1
        temperatureOscillation = temperatureOscillation + change
        currentTemperature = baseTemperature + temperatureOscillation
        print("Actualizando temperatura oscilante: " .. currentTemperature)
        updateHUD() -- Asegúrate de actualizar el HUD después del cambio

        -- Aplica el efecto de congelación si la temperatura es menor a 0
        if currentTemperature < 0 then
            applyFreezingEffect(true)
        else
            applyFreezingEffect(false)
        end

        -- Muestra el mensaje adecuado según la temperatura
        showTemperatureMessage(currentTemperature)
    end
end)












