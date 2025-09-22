local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

	--[[ Config Zombie Models ]]--
	local Models = {
		"u_f_m_corpse_01",
		"u_f_y_corpse_01",
		"u_m_y_corpse_01",
		"u_m_y_zombie_01",
		"mp_f_cocaine_01",
		"mp_m_cocaine_01",
		"mp_f_meth_01",
		"mp_m_meth_01",
		"s_m_y_factory_01",
		"u_m_o_filmnoir",
	}
  
	--[[ Config Zombie Walk Styles  ]]--		  
	local walks = {
		"move_m@drunk@verydrunk",
		"move_m@drunk@moderatedrunk",
		"move_m@drunk@a",
		"anim_group_move_ballistic",
	}

	--[[ Load Players  ]]--
	players = {}

		RegisterNetEvent("qb-zombies:playerupdate")
		AddEventHandler("qb-zombies:playerupdate", function(mPlayers)
			players = mPlayers
		end)

---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
------------------------------------------------------------------------------------			
-- ------------------[[ Load Zombies ]]--------------------------------------------
entitys = {} -- Asegura que esta lista esté inicializada antes de su uso


Citizen.CreateThread(function()
  RegisterNetEvent("ZombieSync")
  AddEventHandler("ZombieSync", function()
    -- Configuraciones iniciales o sincronización de estados pueden ir aquí
    AddRelationshipGroup("zombie")
    SetRelationshipBetweenGroups(0, GetHashKey("zombie"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(2, GetHashKey("PLAYER"), GetHashKey("zombie"))
  end)

  while true do
    Citizen.Wait(5000) -- Revisa cada 5 segundos para no sobrecargar cada frame
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)

    for _, spawnInfo in ipairs(Config.ZombieSpawns) do
      local zombiesInArea = 0
      
      -- Contar cuántos zombies ya existen en esta área para no exceder el límite
      for i = #entitys, 1, -1 do
        local entity = entitys[i]
        if DoesEntityExist(entity) then
          local zombieCoords = GetEntityCoords(entity)
          local distanceToPlayer = #(playerCoords - zombieCoords)
          
          if distanceToPlayer < Config.ZombieFollowDistance then
            -- Configura el zombie para que persiga al jugador si está vivo y no está en el agua
            if not IsPedDeadOrDying(entity, true) then
              TaskGoToEntity(entity, playerPed, -1, 0.0, 2.0, 1073741824.0, 0)
            end
          end
          
          if Vdist(zombieCoords, spawnInfo.coords) < 50 then
            zombiesInArea = zombiesInArea + 1
          end

          -- Elimina el zombie si está en el agua
          if IsEntityInWater(entity) then
            DeleteEntityAndCleanup(entity, i)
          end
        else
          table.remove(entitys, i) -- Limpia los zombies que ya no existen de la lista
        end
      end

      -- Generar nuevos zombies si es necesario
      while zombiesInArea < spawnInfo.count do
        GenerateZombie(spawnInfo, entitys, Models, walks)
        zombiesInArea = zombiesInArea + 1
      end
    end
  end
end)
		
function DeleteEntityAndCleanup(entity, index)
  local model = GetEntityModel(entity)
  SetEntityAsNoLongerNeeded(entity)
  SetModelAsNoLongerNeeded(model)
  DeleteEntity(entity)
  table.remove(entitys, index)
end

function GenerateZombie(spawnInfo, entityList, modelList, walkStyles)
    local modelIndex = math.random(#modelList)
    local EntityModel = modelList[modelIndex]
    RequestModel(GetHashKey(EntityModel))
    while not HasModelLoaded(GetHashKey(EntityModel)) do
        Citizen.Wait(1)
    end

    local offsetX = math.random(-20, 20)
    local offsetY = math.random(-20, 20)
    local posX, posY, posZ = table.unpack(spawnInfo.coords + vector3(offsetX, offsetY, 0))
    
    -- Selecciona un estilo de caminar antes de crear el ped para asegurar que 'walk' está definido
    local walk = walkStyles[math.random(1, #walkStyles)]          
    RequestAnimSet(walk)
    while not HasAnimSetLoaded(walk) do
        Citizen.Wait(1)
    end

    local entity = CreatePed(4, GetHashKey(EntityModel), posX, posY, posZ, 0.0, true, false)

    -- Configuración IA Zombie
    SetPedMaxHealth(entity, 140)
    SetEntityHealth(entity, 140)
    SetEntityMaxSpeed(entity, 75.0)
    SetPedPathCanUseClimbovers(entity, true)
    SetPedPathCanUseLadders(entity, false)
    SetPedHearingRange(entity, 200)
    SetPedMovementClipset(entity, walk, 1.4) -- Aplica el estilo de caminar
    TaskWanderStandard(entity, 1.0, 10)
	SetCanAttackFriendly(entity, false, false)
	SetPedCanEvasiveDive(entity, false)
	SetPedCombatAbility(entity, 100)
	SetPedAsEnemy(entity,false)
	SetPedAlertness(entity,3)
	SetPedIsDrunk(entity, true)
	SetPedCanPlayAmbientAnims(entity, false)
	SetPedCanPlayGestureAnims(entity, false)
	SetPedConfigFlag(entity,100,1)
	ApplyPedDamagePack(entity,"BigHitByVehicle", 0.0, 9.0)
	ApplyPedDamagePack(entity,"SCR_Dumpster", 0.0, 9.0)
	ApplyPedDamagePack(entity,"SCR_Torture", 0.0, 9.0)
	DisablePedPainAudio(entity, true)
	SetPedRandomProps(entity)
	StopPedSpeaking(entity, true)
	SetEntityAsMissionEntity(entity, true, true)
	SetAiMeleeWeaponDamageModifier(0.01)
	SetPedShootRate(entity,  750)
	SetPedCombatAttributes(entity, 46, true)
	SetPedFleeAttributes(entity, 0, 0)
	SetPedCombatRange(entity, 2)
	SetPedCombatMovement(entity, 46)
	TaskCombatPed(entity, GetPlayerPed(-1), 0,16)
	--TaskLeaveVehicle(entity, vehicle, 0)
	SetBlockingOfNonTemporaryEvents(entity, true) -- Stops them breaking anims and acting fruity when a gun is aimed at them
  
    if not NetworkGetEntityIsNetworked(entity) then
        NetworkRegisterEntityAsNetworked(entity)
    end
    table.insert(entityList, entity)
end
		
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
					--[[ Limpieza automatica de cadaveres Zombie ]]--
Citizen.CreateThread(function() -- Chekea si el zombie esta muerto y si lo esta limpia el cadaver
    while true do
        Citizen.Wait(1000) -- Chequea cada segundo para optimizar el rendimiento
        for i = #entitys, 1, -1 do
            local entity = entitys[i]
            if DoesEntityExist(entity) and IsPedDeadOrDying(entity, true) then
                -- Espera 10 segundos antes de eliminar el cadáver del zombie
                Citizen.Wait(10000)
                DeleteEntityAndCleanup(entity, i)
            end
        end
    end
end)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
					--[[ Zombie deja de perseguir jugador ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000) -- Ajusta este tiempo según necesidades de rendimiento y jugabilidad
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        for i, entity in ipairs(entitys) do -- Asume que 'entitys' es la lista de zombies
            if DoesEntityExist(entity) then
                local zombieCoords = GetEntityCoords(entity)
                local distance = #(playerCoords - zombieCoords)

                if distance > Config.ZombieDeactivateDistance then
                    -- Detén la persecución si el zombie está a más de la distancia configurada del jugador
                    ClearPedTasks(entity) -- Detiene las tareas actuales del zombie, incluida la persecución
                else

                end
            end
        end
    end
end)
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
					--[[ Sonido Zombie cuando jugador cerca ]]--
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        local playSound = false

        for _, entity in pairs(entitys) do
            if DoesEntityExist(entity) and not IsPedDeadOrDying(entity, 1) then
                local pedCoords = GetEntityCoords(entity)
                if #(playerCoords - pedCoords) <= 10.0 then
                    playSound = true
                    break  -- No es necesario seguir buscando más entidades si ya se encontró una cerca
                end
            end
        end

        if playSound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, "Codzombie", 1.0)
        end

        Citizen.Wait(playSound and 10000 or 30000)  -- Espera menos si se reprodujo un sonido, más si no
    end
end)
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
					--[[ Mordida zombie a jugador ]]--
-- Pre-carga del diccionario de animaciones
local animDict = "misscarsteal4@actor"
RequestAnimDict(animDict)
while not HasAnimDictLoaded(animDict) do
    Citizen.Wait(100)
end

Citizen.CreateThread(function()
    local biteCooldown = {} -- Cooldown para evitar mordidas constantes

    while true do
        Citizen.Wait(500) -- Ajusta para optimizar rendimiento
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        for i, entity in ipairs(entitys) do
            if DoesEntityExist(entity) and not IsPedDeadOrDying(entity, 1) then
                local pedCoords = GetEntityCoords(entity)
                local dist = Vdist(playerCoords, pedCoords)

                if dist < 0.6 and not biteCooldown[entity] then
                    if not IsPedRagdoll(entity) and not IsPedGettingUp(entity) then
                        TaskPlayAnim(entity, animDict, "stumble", 1.0, 1.0, 500, 9, 1.0, false, false, false)
                        SetEntityHealth(playerPed, GetEntityHealth(playerPed) - 2)

                        -- Implementar cooldown para la mordida
                        biteCooldown[entity] = true
                        Citizen.SetTimeout(2000, function() -- Cooldown de 2 segundos antes de permitir otra mordida
                            biteCooldown[entity] = nil
                        end)
                    end
                end
            end
        end
    end
end)
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--[[ No Health Recharge Function ]]--
if Config.NotHealthRecharge then
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
end

--[[ Mute Ambience Function ]]--
if Config.MuteAmbience then
	StartAudioScene('CHARACTER_CHANGE_IN_SKY_SCENE')
end

--[[ Set Player Stats Function ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)  -- El bucle se ejecuta cada frame

        RestorePlayerStamina(PlayerId(), 1.0)  -- Restaura completamente la resistencia del jugador

        SetPlayerMeleeWeaponDamageModifier(PlayerId(), 0.1)  -- Reduce el daño de armas cuerpo a cuerpo a un 10%
        SetPlayerMeleeWeaponDefenseModifier(PlayerId(), 0.0)  -- Establece la defensa contra armas cuerpo a cuerpo en 0
        SetPlayerWeaponDamageModifier(PlayerId(), 0.4)  -- Reduce el daño de todas las armas a un 40%
        SetPlayerTargetingMode(2)  -- Cambia el modo de apuntado del jugador
    end
end)

-- Función para el saqueo de zombis
if Config.ZombieDropLoot then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            for i, entity in pairs(entitys) do
                local playerCoords = GetEntityCoords(GetPlayerPed(-1))
                local pedCoords = GetEntityCoords(entity)

                if not DoesEntityExist(entity) then
                    table.remove(entitys, i)
                end

                -- Verifica si el zombi está muerto y si el jugador lo mató
                if IsPedDeadOrDying(entity, true) and GetPedSourceOfDeath(entity) == PlayerPedId() then
                    -- Verifica la distancia entre el jugador y el zombi muerto
                    if not IsPedInAnyVehicle(PlayerPedId(), false) and Vdist(playerCoords, pedCoords) < 4.0 then
                        QBCore.Functions.DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 0.2, '[~g~E~w~] Para buscar')

                        -- Si el jugador presiona la tecla E (interactuar)
                        if IsControlJustReleased(1, 51) then
                            -- Animación de búsqueda
                            local animDict = "random@domestic"
                            RequestAnimDict(animDict)
                            while not HasAnimDictLoaded(animDict) do
                                Citizen.Wait(1)
                            end
                            TaskPlayAnim(PlayerPedId(), animDict, "pickup_low", 8.0, -8, 2000, 2, 0, 0, 0, 0)
                            Citizen.Wait(2000)

                            -- Probabilidad de encontrar botín
                            local randomChance = math.random(1, 100)
                            if randomChance < Config.ProbabilityItemLoot then
                                TriggerServerEvent('qb-zombies:itemloot')
                            elseif randomChance >= Config.ProbabilityItemLoot then
                                QBCore.Functions.Notify('La criatura no tenia nada!', 'error')
                            end
                            
                            -- Limpieza y eliminación del zombi
                            ClearPedSecondaryTask(GetPlayerPed(-1))
                            local model = GetEntityModel(entity)
                            SetEntityAsNoLongerNeeded(entity)
                            SetModelAsNoLongerNeeded(model)
                            DeleteEntity(entity)
                            table.remove(entitys, i)
                        end
                    end
                end
            end
        end
    end)
end

--[[ Set Safe Zone Areas Function  ]]--
if Config.SafeZone then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            for k, v in pairs(Config.SafeZoneCoords) do
                for i, entity in pairs(entitys) do
                    local pedX, pedY, pedZ = table.unpack(GetEntityCoords(entity, true))
                    if Vdist(pedX, pedY, pedZ, v.x, v.y, v.z) < v.radio then
                        SetEntityHealth(entity, 0)
                        SetEntityAsNoLongerNeeded(entity)
                        DeleteEntity(entity)
                        table.remove(entitys, i)
                    end
                end
            end
        end
    end)
end

--[[ Safe Zone Blip Function ]]--
if Config.SafeZoneRadioBlip then
	Citizen.CreateThread(function()
		for k,v in pairs(Config.SafeZoneCoords) do
			local blip = AddBlipForRadius(v.x, v.y, v.z , 50.0) -- you can use a higher number for a bigger zone

			SetBlipHighDetail(blip, true)
			SetBlipColour(blip, 2)
			SetBlipAlpha (blip, 128)

			local blip = AddBlipForCoord(v.x, v.y, v.z)

			SetBlipSprite (blip, v.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.9)
			SetBlipColour (blip, v.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end


--[[ Clear All Zombies Function ]]--
RegisterNetEvent('qb-zombies:clear')
AddEventHandler('qb-zombies:clear', function()
	for i, entity in pairs(entitys) do
		local model = GetEntityModel(entity)
			SetEntityAsNoLongerNeeded(entity)
			SetModelAsNoLongerNeeded(model)
			table.remove(entitys, i)
		end
	end)


--[[ Debug Function  ]]--
if Config.Debug then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			for i, entity in pairs(entitys) do
				local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
				local pedX, pedY, pedZ = table.unpack(GetEntityCoords(entity, false))	
				DrawLine(playerX, playerY, playerZ, pedX, pedY, pedZ, 250,0,0,250)
			end
		end
	end)
end
--[[ Deteccion de disparos ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            local coords = GetEntityCoords(ped)
            TriggerServerEvent('zombies:gunshotDetected', coords)
            --print("Disparo detectado en: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z) -- Mensaje de depuración
        end
    end
end)

RegisterNetEvent('zombies:moveZombieToCoords')
AddEventHandler('zombies:moveZombieToCoords', function(coords)
    for _, zombie in pairs(entitys) do
        local speedType = math.random(1, 3)
        local speed = speedType == 1 and 0.5 or (speedType == 3 and 1.5 or 1.0)
        local heading = math.random(0, 360)
        TaskGoStraightToCoord(zombie, coords.x, coords.y, coords.z, speed, -1, heading, 0.5)

        Citizen.SetTimeout(5000, function() -- Espera 1 segundos antes de reevaluar
            ReevaluateTarget(zombie)
        end)
    end
end)

function ReevaluateTarget(zombie)
    local closestPlayer = nil
    local minDistance = math.huge
    local zombieCoords = GetEntityCoords(zombie)

    for _, player in ipairs(GetActivePlayers()) do
        local playerPed = GetPlayerPed(player)
        if playerPed ~= zombie then
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(zombieCoords - playerCoords)

            if distance < minDistance then
                minDistance = distance
                closestPlayer = playerPed
            end
        end
    end

    -- Si encuentra un jugador cercano, dirige al zombi hacia él
    if closestPlayer and minDistance < 30.0 then -- 30.0 es distancia máxima
        local speedType = math.random(1, 3)
        local speed = speedType == 1 and 0.5 or (speedType == 3 and 1.5 or 1.0)
        TaskGoToEntity(zombie, closestPlayer, -1, 0.0, speed, 1073741824, 0)
    end
end


--[[ No PEDs Function ]]--
if Config.NoPeds then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
				SetVehicleDensityMultiplierThisFrame(0.0)
				SetPedDensityMultiplierThisFrame(0.0)
				SetRandomVehicleDensityMultiplierThisFrame(0.0)
				SetParkedVehicleDensityMultiplierThisFrame(0.0)
				SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
				local playerPed = GetPlayerPed(-1)
				local pos = GetEntityCoords(playerPed) 
				RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);
				SetGarbageTrucks(0)
				SetRandomBoats(0)
				CancelCurrentPoliceReport()
						
			for i=0,20 do
				EnableDispatchService(i, false)
			end
		end
	end)
end
--[[ Limpieza de entidades cuando se cierra el recurso ]]--
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for i, entity in ipairs(entitys) do
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end
    end
end)
--[[ funcion para comando zombitotal]]--
RegisterNetEvent('requestZombieCount', function() ---
    local count = 0
    for _, entity in pairs(entitys) do
        if DoesEntityExist(entity) then
            count = count + 1
        end
    end
    TriggerServerEvent('reportZombieCount', count)
end)
