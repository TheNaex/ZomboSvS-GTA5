fx_version 'cerulean'
game 'gta5'

description 'CarWorld by Zombo'
version '0.0.9'
author 'Naex'


shared_scripts {
    'config.lua',  -- Carga primero la configuración
}

ui_page 'html/carinfo.html'  -- Ruta actualizada a la interfaz NUI

files {
    'html/carinfo.html',  -- Ruta dentro de la carpeta html
    'html/style.css',     -- Ruta dentro de la carpeta html
    'html/script.js'      -- Ruta dentro de la carpeta html
}

server_script 'server/server.lua'
client_scripts { 'client/client.lua' }


lua54 'yes'
