Config = {}

Config.LootCooldown = 300 -- Tiempo de cooldown en segundos (300s = 5min)

-- Puntos de loot y sus objetos
Config.LootPoints = {
    {
        coords = { x = 76.05, y = 3702.18, z = 41.08 },
        items = {
            { name = 'water_bottle', rarity = 50 },
            { name = 'bandage', rarity = 30 },
            { name = 'tosti', rarity = 20 }
        },
        objectModel = 'p_ld_heist_bag_s_1'
    },
    {
        coords = { x = 83.18, y = 3712.48, z = 41.08 },
        items = {
            { name = 'sandwich', rarity = 40 },
            { name = 'pistol_ammo', rarity = 20 },
            { name = 'coffee', rarity = 40 }
        },
        objectModel = 'ch_prop_heist_drill_bag_01a'
    }
    -- Añadir más puntos con sus respectivas listas de objetos
}

Config.SkillLevels = {
    { Min = 0, Max = 100, Reduction = 0 },      -- Nivel 0
    { Min = 101, Max = 200, Reduction = 100 },  -- Nivel 1
    { Min = 201, Max = 300, Reduction = 200 },  -- Nivel 2
    { Min = 301, Max = 400, Reduction = 300 },  -- Nivel 3
    { Min = 401, Max = 500, Reduction = 400 },  -- Nivel 4
    { Min = 501, Max = 600, Reduction = 500 },  -- Nivel 5
    { Min = 601, Max = 800, Reduction = 600 },  -- Nivel 6
    { Min = 801, Max = 1000, Reduction = 700 }, -- Nivel 7
    { Min = 1001, Max = 1200, Reduction = 800 },-- Nivel 8
    { Min = 1201, Max = 1400, Reduction = 900 },-- Nivel 9
    { Min = 1401, Max = 1000000, Reduction = 1000 } -- Nivel 10
}
