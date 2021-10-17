fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'config.lua',
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/classes/addoninventory.lua',
	'server/classes/datastore.lua',
	'server/cron.lua',
	'server/datastore.lua',
	'server/joblisting.lua',
	'server/licenses.lua',
	'server/commands.lua',
	'server/accessories.lua',
	'server/web.lua',
	'server/blimp.lua',
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'client/*.lua',
}

dependencies {
	'es_extended',
	'fl_skin',
}

exports {
    'RunAtDay',
    'RunAt',
    'GetAccount',
    'GetSharedAccount',
    'GetInventory',
    'GetSharedInventory',
    'GetAllDataStore',
    'GetDataStore',
    'GetDataStoreOwners',
    'GetSharedDataStore',
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'