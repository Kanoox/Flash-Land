fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'config.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/faction_sv.lua',
	'server/fac_common.lua'
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client/fac_common.lua',
	'client/menufaction_cl.lua'
}

dependencies {
	'es_extended'
}





