local MAX_REFRESH_TIMECOUNT = 100

local NPC = {}
NPC.__index = NPC

-- Esta función crea un nuevo objeto NPC con el modelo, posición y nombre dados.
function NPC:new(model, position, name)
    local object = {}
    setmetatable(object, NPC)

    object.model = GetHashKey(model)
    object.ped = nil
    object.position = position
    object.name = name

    RequestModel(object.model)

    local timeoutCount = 0

    while not HasModelLoaded(object.model) and timeoutCount < MAX_REFRESH_TIMECOUNT do
        timeoutCount = timeoutCount + 1
        Citizen.Wait(100)
    end

    object.ped = CreatePed(4, object.model, position.x, position.y, position.z - 1, position.w, false, false)
    FreezeEntityPosition(object.ped, true)
    SetEntityInvincible(object.ped, true)
    SetBlockingOfNonTemporaryEvents(object.ped, true)

    -- Configurar qb-target para este NPC
    exports['qb-target']:AddTargetEntity(object.ped, {
        options = {
            {
                type = "client",
                event = "Z-npc:client:StartDialog", -- Evento para mostrar el diálogo HTML
                icon = "fas fa-user", -- Icono de la interacción
                label = "Interactuar",
                -- Pasar el nombre del NPC como argumento
                action = function(entity)
                    TriggerEvent("Z-npc:client:StartDialog", { name = name })
                end
            }
        },
        distance = 2.5 -- Distancia para interactuar
    })

    return object
end

-- Adjunta un prop al NPC.
function NPC:attachProp(propData)
    local propHash = GetHashKey(propData.model)

    RequestModel(propHash)

    local timeoutCount = 0

    while not HasModelLoaded(propHash) and timeoutCount < MAX_REFRESH_TIMECOUNT do
        timeoutCount = timeoutCount + 1
        Citizen.Wait(100)
    end

    local object = CreateObject(propHash, self.position.x, self.position.y, self.position.z, true, true, true)
    AttachEntityToEntity(object, self.ped, GetPedBoneIndex(self.ped, propData.bone and propData.bone or 60309), propData.position.x, propData.position.y, propData.position.z, propData.rotation.x, propData.rotation.y, propData.rotation.z, true, true, false, true, 0, true)
end

-- Reproduce una animación para el NPC.
function NPC:playAnimation(animationDict, animationName)
    RequestAnimDict(animationDict)

    while not HasAnimDictLoaded(animationDict) do
        Citizen.Wait(1000)
    end

    TaskPlayAnim(self.ped, animationDict, animationName, 1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
end

-- Carga un NPC y configura props y animaciones si están especificados en npcData.
local function loadNpc(npcData)
    Citizen.CreateThread(function()
        local npc = NPC:new(npcData.model, npcData.position, npcData.name)

        if npcData.props.enable then
            for _, propData in pairs(npcData.props.list) do
                npc:attachProp(propData)
            end
        end

        if npcData.animation.enable then
            npc:playAnimation(npcData.animation.dict, npcData.animation.name)
        end
    end)
end

-- Carga todos los NPCs desde el archivo de configuración.
for _, npcData in pairs(Config.npcs) do
    loadNpc(npcData)
end

-- Mostrar el diálogo HTML
RegisterNetEvent('Z-npc:client:StartDialog')
AddEventHandler('Z-npc:client:StartDialog', function(data)
    local name = data.name
    print("Nombre del NPC:", name) -- Depuración
    local npcData = nil

    -- Buscar el NPC con el nombre dado
    for _, npc in pairs(Config.npcs) do
        if npc.name == name then
            npcData = npc
            break
        end
    end

    if npcData and npcData.dialog then
        SetNuiFocus(true, true) -- Hacer que el HTML esté en foco
        for _, line in ipairs(npcData.dialog.lines) do
            print("Mostrando línea de diálogo:", line) -- Depuración
            SendNUIMessage({
                type = "openDialog",
                text = line,
            })
            Citizen.Wait(4000) -- Muestra cada línea por 4 segundos
        end
        SendNUIMessage({
            type = "closeDialog"
        })
        SetNuiFocus(false, false) -- Quitar foco del HTML
    else
        print("Datos de diálogo no encontrados o incorrectos") -- Depuración
    end
end)

-- Evento para cerrar el diálogo
RegisterNUICallback('closeDialog', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)






