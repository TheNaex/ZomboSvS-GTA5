 --- https://s1nyx.github.io/animations-list/
 Config = {
    npcs = {
        {
            name = "gobernadora Sofia", -- Nombre único para el NPC
            position = vector4(78.81, 3707.35, 41.08, 56.11), -- NPC position X, Y, Z, Heading
            model = "a_f_y_soucent_01", -- NPC model
            animation = {
                enable = true, -- Activate the animation for the NPC
                dict = "mp_player_intdrink", -- Dictionary associated to the animation
                name = "loop_bottle" -- Animation's name
            },
            props = {
                enable = true, -- Activate the use of a prop for the NPC
                list = {
                    {
                        model = "prop_ld_flow_bottle", -- Model of the prop
                        position = vec3(0.01, 0.01, 0.01), -- Position of the prop relative to the NPC
                        rotation = vec3(0.0, 0.0, -1.5) -- Rotation of the prop relative to the NPC
                    }
                }
            },
            dialog = { -- Define multiple lines of dialog here
                lines = {
                    "¡Hola!",
                    "¿Cómo estás? Soy la gobernadora Sofía.",
                    "¿Por qué no te das una vuelta por el refugio?",
                    "Así conocerás al resto de supervivientes."
                }
            }
        },
        {
            name = "James", -- Nombre único para el nuevo NPC
            position = vector4(72.26, 3701.73, 39.75, 98.06), -- New NPC position X, Y, Z, Heading
            model = "a_m_m_og_boss_01", -- New NPC model
            animation = {
                enable = true, -- Activate animation for the new NPC
                dict = "amb@code_human_wander_smoking@female@base", -- Dictionary associated to the animation
                name = "base" -- Animation's name
            },
            props = {
                enable = false, -- Disable the use of a prop for the new NPC
                list = {
                    -- No props for the new NPC
                }
            },
            dialog = { -- Define multiple lines of dialog here
                lines = {
                    "Hola... Estoy ocupado, vuelve más tarde."
                }
            }
        }
    }
}




