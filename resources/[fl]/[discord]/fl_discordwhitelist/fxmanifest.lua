fx_version 'bodacious'
game 'gta5'

server_script {
	'@es_extended/server/shared/common.lua',
    "config.lua",
    "perms.lua",
    "server.lua",
}

dependencies {
	'es_extended',
}

client_script '@WaveShield/xDxDxDxDxD.lua'