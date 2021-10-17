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
	'server/main.lua',
	'server/sv_armory.lua',
	'server/handcuff.lua',
	'server/sv_speedzone.lua',
	'server/sv_bracelet.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'@es_extended/client/shared/entityiter.lua',
	'client/main.lua',
	'client/cl_armory.lua',
	'client/handcuff.lua',
	'client/cl_speedzone.lua',
	'client/cl_bracelet.lua',
	'client/shield.lua',
}

dependencies {
	'es_extended',
	'fl_billing'
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'