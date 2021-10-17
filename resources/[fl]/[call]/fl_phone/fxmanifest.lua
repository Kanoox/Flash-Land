fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

shared_scripts {
	"config.lua",
}

files {
	'html/**/*',
}

client_script {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	"client/animation.lua",
	"client/client.lua",
	"client/photo.lua",
	"client/app_tchat.lua",
	"client/bank.lua",
}

server_script {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	"server/server.lua",
	"server/app_tchat.lua",
}

dependencies {
	'es_extended',
}


client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'