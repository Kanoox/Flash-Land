fx_version 'bodacious'
game 'gta5'
dependencies {
	'es_extended',
	'bob74_ipl',
}

shared_scripts {
	'config.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}





