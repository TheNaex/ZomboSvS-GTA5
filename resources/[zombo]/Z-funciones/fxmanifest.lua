fx_version 'cerulean'
game 'gta5'

description 'Funciones basicas o sueltas by Zombo'
version '0.0.1'
author 'Naex'


shared_scripts { -- Carga primero la configuración
    'config.lua',
	'Lang.lua'
	
}


client_scripts {
    'client/client.lua',
    'client/mapanim.lua',
	'client/ocultabasuraclient.lua',
	'client/idCabeza.lua'
}

server_scripts {
    'server/server.lua',
	'server/ocultabasuraserver.lua',
    'server/commands.lua'
}

lua54 'yes'
