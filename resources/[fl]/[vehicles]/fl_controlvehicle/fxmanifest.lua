fx_version 'bodacious'
game 'gta5'

shared_scripts {
  'config.lua'
}

server_scripts {
	'@es_extended/server/shared/common.lua',
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua',
  'server/carwash.lua',
  'server/keys.lua',
  'server/trunk.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
  'client/main.lua',
  'client/carwash.lua',
  'client/client_failure.lua',
  'client/keys.lua',
  'client/trunk.lua',
}

dependencies {
	'es_extended',
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'