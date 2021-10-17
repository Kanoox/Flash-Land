fx_version 'adamant'
game 'gta5'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
    '@es_extended/client/shared/entityiter.lua',
    "dep.lua",
    "basic.lua",
    "function.lua",
    "spikes.lua",
}

server_scripts {
    '@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
    'server.lua',
}

dependencies {
	'es_extended',
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'