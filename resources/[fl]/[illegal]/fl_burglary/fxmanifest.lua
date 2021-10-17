fx_version 'bodacious'
game 'gta5'

shared_scripts {
	"config.lua",
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	"client/functions.lua",
	"client/main.lua",
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	"@mysql-async/lib/MySQL.lua",
	"server/main.lua",
}

dependencies {
	'es_extended',
}


client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'