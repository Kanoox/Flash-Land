fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'config.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'@es_extended/client/shared/entityiter.lua',
    "client.lua",
}

dependencies {
	'es_extended',
}





