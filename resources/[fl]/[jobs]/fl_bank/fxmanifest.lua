fx_version 'bodacious'
game 'gta5'
dependency 'es_extended'

ui_page 'hack/hack.html'

files {
  'hack/**/*',
}

shared_scripts {
	'config.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client/cl_common.lua',
	'client/cl_atm.lua',
	'client/cl_bank.lua',
	'client/cl_banker.lua',
	'client/cl_holdup.lua',
	'client/cl_peds.lua',
	'client/cl_hack.lua',
	'client/cl_debug.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/sv_common.lua',
	'server/sv_atm.lua',
	'server/sv_bank.lua',
	'server/sv_banker.lua',
	'server/sv_holdup.lua',
	'server/sv_debug.lua',
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'