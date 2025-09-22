
fx_version "cerulean"
use_experimental_fxv2_oal "yes"
lua54 "yes"
game "gta5"
name "NPC Zombo"
author "Naex"
version '0.0.5'

shared_scripts {
    "config.lua"
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css'
}

client_scripts {
    "client/main.lua"
}

escrow_ignore {
    "**/*.lua"
}
