fx_version 'cerulean'
game 'gta5'

client_scripts {
	-- RageUI Version 1.4
	"src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",
    "src/client/components/*.lua",
    "src/client/menu/elements/*.lua",
    "src/client/menu/items/*.lua",
    "src/client/menu/panels/*.lua",
	"src/client/menu/windows/*.lua",

	'@fl_polyzone/client/client.lua',
	'@fl_polyzone/client/zone/BoxZone.lua',
	'@fl_polyzone/client/zone/EntityZone.lua',
	'@fl_polyzone/client/zone/CircleZone.lua',
	'@fl_polyzone/client/zone/ComboZone.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	"server_main.lua",

	"jobs/police/server.lua",
	"jobs/police/notifs/server.lua",
	
	"jobs/server_jobs.lua",
	"jobs/police/appels/server.lua",

}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'@es_extended/client/shared/entityiter.lua',

	"client_main.lua",
	"jobs/client_jobs.lua",


	"modules/utils/utils.lua",
	"modules/interactions/markers.lua",
	"modules/interactions/jobs.lua",
	"modules/utils/RegisterAppelJob.lua",

	"jobs/police/config.lua",
	"jobs/police/shield.lua",
	"jobs/police/client.lua",
	"jobs/police/chiens.lua",
	"jobs/police/appels/client.lua",
	"jobs/police/notifs/function.lua",
	"jobs/police/notifs/client.lua",
	'jobs/police/hud/configuration.lua',
	'jobs/police/hud/client.lua',

	"modules/menu/menus.lua",
}

ui_page('jobs/police/hud/html/index.html')

files({
	'jobs/police/hud/html/index.html',
	'jobs/police/hud/html/listener.js',
	'jobs/police/hud/html/styles.css',
	'jobs/police/hud/html/font-face.css',
	'jobs/police/hud/html/dynamic.css'
})

dependencies {
	'mysql-async'
}









