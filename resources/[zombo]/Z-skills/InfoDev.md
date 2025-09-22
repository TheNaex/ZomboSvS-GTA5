
### [ Using mz-skills ]
!. To Update a skill please use the following export:
```lua
    exports["mz-skills"]:UpdateSkill(skill, amount)
```
 For example, to update "Searching" from bin-diving (as used with mz-bins)
```lua
    exports["mz-skills"]:UpdateSkill("Searching", 1)
```
 You can randomise the amount of skill gained, for example: 
 ```lua
    local searchgain = math.random(1, 3)
    exports["mz-skills"]:UpdateSkill("Searching", searchgain)
```

----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

La exportación para verificar si una habilidad es igual o mayor que un valor en particular es la siguiente:

    exports["mz-skills"]:CheckSkill(skill, val)

----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
Puedes usar esto para bloquear contenido detrás de un nivel particular, por ejemplo:

exports["mz-skills"]:CheckSkill("Searching", 100, function(hasskill)
    if hasskill then
        TriggerEvent('mz-bins:client:Reward')
    else
        QBCore.Functions.Notify('You need at least 100XP in Searching to do this.', "error", 3500)
    end
end)

	exports["Z-skills"]:CheckSkill("Buscar", 0, function(hasskill)
       if hasskill then searchTime = 5000 end
     end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

La exportación para obtener la habilidad actual de un jugador para interactuar con otros scripts es la siguiente:

    exports["mz-skills"]:GetCurrentSkill(skill)
	local skillPoints = exports["Z-skills"]:GetCurrentSkill("Buscar")["Current"]

--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------


- For radial menu access to "skills" command add this to qb-radialmenu/config.lua - line 296 and following:
```lua
    [3] = {
        id = 'skills',
        title = 'Check Skills',
        icon = 'triangle-exclamation',
        type = 'client',
        event = 'mz-skills:client:CheckSkills',
        shouldClose = true,
    },
```

### [ Previews ]

<p align="center">
    <img src="https://raw.githubusercontent.com/Kingsage311/Kingsage311/main/assets/skillzcustom.png"/>
</p>
