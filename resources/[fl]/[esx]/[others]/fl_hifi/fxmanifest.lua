fx_version 'bodacious'
game 'gta5'

ui_page 'html/index.html'

files {
    'html/**/*',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'server.lua'
}

dependencies {
	'es_extended',
}





