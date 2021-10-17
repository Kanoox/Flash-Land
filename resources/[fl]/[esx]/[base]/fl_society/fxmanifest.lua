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
	'server/config_ads.lua',
	'server/ads.lua',
	'server/stocks.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client/main.lua',
	'client/ads.lua',
	'client/stocks.lua',
}

export 'GetSociety'

dependencies {
	'es_extended',
	'fl_base'
}


client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'