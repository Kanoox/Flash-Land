fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'config.lua',
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

exports {
	'GetFuel',
	'SetFuel'
}





