fx_version 'bodacious'
game 'gta5'

ui_page 'html/index.html'

server_script {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}

client_script {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client.lua',
}

files {
	'html/**/*',
}

dependencies {
	'es_extended',
}





