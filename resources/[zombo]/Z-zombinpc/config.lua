--[[ Default Config Settings ]]--
Config = {}
Config.Debug 				= true				-- Set to true for debuging.
Config.NoPeds 				= true					-- Set to true for no peds.
Config.MuteAmbience 			= true					-- Set to true to mute ambience.
Config.NotHealthRecharge 		= true					-- Set true to not all health auto recharge.

--[[ Zombie Spawn Config Settings ]]--


Config.ZombieFollowDistance     = 40    -- Zombies empezarán a seguir al jugador dentro de esta distancia
Config.ZombieDeactivateDistance = 60    -- los zombies dejan de perseguir al jugador si están a más de 60 metros de distancia




--[[ Zombie Loot Config Settings ]]--
Config.ZombieDropLoot 			= true  				-- For zombies to drop loot, set to true.
Config.RandomChance 			= math.random(1, 150)  			-- Random number for giveaway chance.
Config.ItemAmount 			= 1 					-- Random number for the ammout of item given.
Config.AddtionalItem 			= true	 				-- Set to true to give extra item on loot.
Config.AddItem 				= 'firstaid' 				-- Extra item to give player.
Config.AddItemAmount 			= 1 					-- Random number for the ammout of extra item given.
Config.ProbabilityItemLoot 		= 52 					-- 53-33 = 20%

--[[ Zombie Loot Items Config Settings ]]--
Config.Items = {
	[1] = "weapon_dagger",
	[2] = "weapon_hatchet",
	[3] = "weapon_snowball",
	[4] = "shotgun_ammo",
	[5] = "pistol_ammo",
	[6] = "security_card_01",
	[7] = "security_card_02",
	[8] = "sandwich",
	[9] = "kurkakola",
	[10] = "meth",
	[11] = "weed_skunk",
	[12] = "weed_ak47",
	[13] = "plastic",
	[14] = "lockpick",
	[15] = "bandage",
	[16] = "rolex",
	[18] = "lighter",
	[19] = "zombie_brain",
	[20] = "zombie_heart",
	[21] = "zombie_lungs",
	[22] = "zombie_arm",
	[23] = "zombie_foot",
	[24] = "fishbait",
	
}

--[[ Zombie Safezone Config Settings ]]--
Config.SafeZone 			= true					-- Set to true to activate for safezones.
Config.SafeZoneRadioBlip 		= false					-- Set to true to activate safezone blips.

--[[ Zombie Safezone Location Settings ]]--
Config.SafeZoneCoords = {

	{x = 61.01, y = 3717.86, z = 39.75, radio = 190}, -- Zona Segura Stab City
	{x = -814.89, y = 181.95, z = 76.85, radio = 20}, -- PDM Motorsports

}

Config.ZombieSpawns = {
    { coords = vector3(1595.52, 3624.36, 35.15), count = 1 },
    --{ coords = vector3(100.0, -1034.0, 29.0), count = 3 },
    -- Añadir más ubicaciones según sea necesario
}