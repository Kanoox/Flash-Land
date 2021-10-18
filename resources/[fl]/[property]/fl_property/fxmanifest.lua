fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
}

client_scripts {
	-- RageUI Version 1.4
	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
	"src/menu/windows/*.lua",
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'@es_extended/client/shared/entityiter.lua',
	'config_doors.lua',
	'@fl_weaponitems/config.lua',
	'@fl_menu/client/categories.lua',
	'client/*.lua',
	'client/**/*.lua',
}

dependencies {
	'es_extended',
	'bob74_ipl',
}





