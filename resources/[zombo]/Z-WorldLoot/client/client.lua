QBCore = exports['qb-core']:GetCoreObject()

-- Crear y mostrar objetos de mochila en puntos de loot
local function CreateLootObject(lootPoint)
    local objectModel = GetHashKey(lootPoint.objectModel)
    RequestModel(objectModel)
    while not HasModelLoaded(objectModel) do
        Citizen.Wait(1)
    end

    local lootBag = CreateObject(objectModel, lootPoint.coords.x, lootPoint.coords.y, lootPoint.coords.z, false, false, true)
    PlaceObjectOnGroundProperly(lootBag)
    FreezeEntityPosition(lootBag, true)

    return lootBag
end

-- Evento para buscar en la mochila
RegisterNetEvent('loot-system:searchLoot', function(coords, lootPoint)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local skillPoints = exports["Z-skills"]:GetCurrentSkill("Buscar")["Current"]
    local searchTime = 5000 -- Tiempo base de búsqueda

    -- Ajustar searchTime basado en los puntos de habilidad actuales
    for _, skillLevel in ipairs(Config.SkillLevels) do
        if skillPoints >= skillLevel.Min and skillPoints <= skillLevel.Max then
            searchTime = searchTime - skillLevel.Reduction
            break
        end
    end

    searchTime = math.max(searchTime, 1000) -- Asegura un tiempo mínimo de búsqueda

    -- Mensaje de depuración
    print("Tiempo de búsqueda ajustado: " .. searchTime .. " ms, basado en " .. skillPoints .. " puntos de habilidad.")

    if #(playerCoords - vector3(coords.x, coords.y, coords.z)) < 1.5 then
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_BUM_WASH', 0, true)
        QBCore.Functions.Progressbar('search_loot', 'Buscando...', searchTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            ClearPedTasks(playerPed)
            TriggerServerEvent('loot-system:getLoot', lootPoint)
            PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true) -- Añade sonido al completar búsqueda
        end, function()
            ClearPedTasks(playerPed)
            TriggerEvent('origen_notify:ShowNotification', "Búsqueda cancelada")
        end)
    else
        TriggerEvent('origen_notify:ShowNotification', "Estás demasiado lejos de la mochila")
    end
end)

RegisterNetEvent('actualizarSkillBuscar')
AddEventHandler('actualizarSkillBuscar', function(puntos)
    exports["Z-skills"]:UpdateSkill("Buscar", puntos)
end)

-- Comprobar proximidad a los puntos de loot y gestionar la visualización de mochilas
Citizen.CreateThread(function()
    local lootBags = {}
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for i, lootPoint in ipairs(Config.LootPoints) do
            local distance = #(playerCoords - vector3(lootPoint.coords.x, lootPoint.coords.y, lootPoint.coords.z))
            if distance < 25.0 then -- Ajustar distancia según necesidad
                if not lootBags[i] then
                    lootBags[i] = CreateLootObject(lootPoint)
                end
            else
                if lootBags[i] then
                    DeleteObject(lootBags[i])
                    lootBags[i] = nil
                end
            end
            if distance < 2.5 then
                QBCore.Functions.DrawText3D(lootPoint.coords.x, lootPoint.coords.y, lootPoint.coords.z, "[E] Buscar")
                if IsControlJustReleased(0, 38) then -- Tecla E
                    TriggerEvent('loot-system:searchLoot', vector3(lootPoint.coords.x, lootPoint.coords.y, lootPoint.coords.z), lootPoint)
                end
            end
        end
    end
end)