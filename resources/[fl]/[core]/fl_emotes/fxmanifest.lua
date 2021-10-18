fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'config.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'NativeUI.lua',
	'client/*.lua'
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}

dependencies {
	'es_extended',
}

export 'OnEmotePlay'
export 'EmoteCancel'





