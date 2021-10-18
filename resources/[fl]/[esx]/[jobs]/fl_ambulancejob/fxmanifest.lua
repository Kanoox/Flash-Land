fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client/main.lua',
	'client/job.lua'
}

dependencies {
	'es_extended'
}





