fx_version 'adamant'
games {'gta5'}

author 'Ruben'

version '1.0'

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	"dependencies/RMenu.lua",

	"dependencies/components/*.lua",

	"dependencies/menu/RageUI.lua",
	"dependencies/menu/Menu.lua",
	"dependencies/menu/MenuController.lua",

	"dependencies/menu/elements/*.lua",
	"dependencies/menu/items/*.lua"
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'config.lua',
	'client/cl_society.lua',
	'client/*.lua'
}

client_script '@WaveShield/xDxDxDxDxD.lua'