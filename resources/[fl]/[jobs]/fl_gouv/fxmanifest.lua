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
	'server.lua'
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client.lua'
}

dependencies {
	'es_extended',
	'fl_billing'
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'