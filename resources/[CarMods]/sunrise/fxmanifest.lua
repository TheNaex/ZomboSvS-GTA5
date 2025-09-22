fx_version 'cerulean'
game 'gta5'

author 'Naex'
description 'Generado Sunrise para FiveM con audio,falta tuneos'

files {
    'data/*.meta',
    'data/*.xml',
    'data/*.dat',
    'data/*.ytyp',
	'audioconfig/sunrise_game.dat151.rel',
	'audioconfig/sunrise_sounds.dat54.rel',
    'sfx/dlc_sunrise/sunrise.awc',
	'sfx/dlc_sunrise/sunrise_npc.awc'
}

data_file 'HANDLING_FILE'            'data/handling*.meta'
data_file 'VEHICLE_LAYOUTS_FILE'    'data/vehiclelayouts*.meta'
data_file 'VEHICLE_METADATA_FILE'    'data/vehicles*.meta'
data_file 'CARCOLS_FILE'            'data/carcols*.meta'
data_file 'VEHICLE_VARIATION_FILE'    'data/carvariations*.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' 'data/*unlocks.meta'
data_file 'PTFXASSETINFO_FILE' 'data/ptfxassetinfo.meta'

data_file 'AUDIO_GAMEDATA' 'audioconfig/sunrise_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/sunrise_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_sunrise'