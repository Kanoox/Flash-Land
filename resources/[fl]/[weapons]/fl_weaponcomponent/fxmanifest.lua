fx_version 'adamant'
game 'gta5'

shared_scripts {
	'@es_extended/config.weapons.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'server.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client.lua',
}

dependencies {
	'es_extended',
}





