fx_version 'adamant'

game 'gta5'

shared_scripts {
	'utils.lua',
	'config.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client.lua',
	'names.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}

dependencies {
	'es_extended',
	'skinchanger',
	'fl_skin',
}

files {
	'names/*.json'
}





