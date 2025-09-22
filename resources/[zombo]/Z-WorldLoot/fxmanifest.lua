fx_version 'cerulean'
game 'gta5'

description 'WorldLoot by Zombo'
version '0.1.7'
author 'Naex'


shared_scripts {
    'config.lua',  -- Carga primero la configuración
}

server_script 'server/server.lua'
client_scripts { 'client/client.lua' }


lua54 'yes'
