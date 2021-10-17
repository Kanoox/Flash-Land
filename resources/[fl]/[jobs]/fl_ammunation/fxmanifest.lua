fx_version 'bodacious'
game 'gta5'

shared_scripts {
  '@es_extended/locale.lua',
  'locales/*.lua',
  'config.lua',
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
	'@es_extended/config.weapons.lua',
  'client.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
  'server.lua'
}

dependencies {
	'es_extended',
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'