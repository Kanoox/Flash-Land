fx_version 'adamant'
game 'gta5'

dependency 'es_extended'

shared_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	"dependencies/RMenu.lua",
	"dependencies/menu/RageUI.lua",
	"dependencies/menu/Menu.lua",
	"dependencies/menu/MenuController.lua",
	"dependencies/components/*.lua",
	"dependencies/menu/elements/*.lua",
	"dependencies/menu/items/*.lua",

	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'@fl_weaponitems/config.lua',
	'client/main.lua',
	'client/other.lua',
	'client/categories.lua',
}

dependencies {
	'es_extended',
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'