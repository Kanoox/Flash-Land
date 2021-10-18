fx_version 'adamant'
game 'gta5'
description 'Pablo Z. Core'
version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"server_main.lua",

	"modules/staffmode/staff.lua",
	"modules/staffmode/server.lua",

}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
  '@es_extended/client/shared/entityiter.lua',
	-- RageUI Version 1
	"src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",
    "src/client/components/*.lua",
    "src/client/menu/elements/*.lua",
    "src/client/menu/items/*.lua",
    "src/client/menu/panels/*.lua",
	"src/client/menu/windows/*.lua",
	
	-- 
	"client_main.lua",
	"modules/commands/client.lua",

	"modules/utils/utils.lua",


	"modules/staffmode/staff.lua",
	"modules/staffmode/client.lua",

	"modules/menu/menus.lua",


	"jobs/client_inventory.lua",

}

dependencies {
	'mysql-async'
}


