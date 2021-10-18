fx_version 'bodacious'
game 'gta5'

dependencies {
	'es_extended',
}

shared_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
    '@mysql-async/lib/MySQL.lua',
	'server.lua',
}






