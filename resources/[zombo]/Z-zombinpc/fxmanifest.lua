fx_version 'cerulean'
games { 'gta5' }

author 'Naex'
description 'Zombie System for ZomboSvS'
version '0.3.1'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client.lua',
	'client/zonasclient.lua'
	
}

server_scripts {
    'server/server.lua',
	'server/zonaserver.lua'
}

lua54 'yes'