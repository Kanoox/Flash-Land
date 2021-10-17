fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'@es_extended/locale.lua',
}

client_scripts {
    '@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	'@es_extended/client/shared/entityiter.lua',
    'global/pmenu.lua',
    'global/functions.lua',
    'script/calls/client.lua'
}

server_scripts {
	'@es_extended/server/shared/common.lua',
	'@mysql-async/lib/MySQL.lua',
    'script/calls/server.lua'
}

dependencies {
	'es_extended',
}

files {

    'stream/recul/weaponautoshotgun.meta',
    'stream/recul/weaponbullpuprifle.meta',
    'stream/recul/weaponcombatpdw.meta',
    'stream/recul/weaponcompactrifle.meta',
    'stream/recul/weapondbshotgun.meta',
    'stream/recul/weaponfirework.meta', 
    'stream/recul/weapongusenberg.meta',
    'stream/recul/weaponheavypistol.meta',
    'stream/recul/weaponheavyshotgun.meta',
    'stream/recul/weaponmachinepistol.meta',
    'stream/recul/weaponmarksmanpistol.meta',
    'stream/recul/weaponmarksmanrifle.meta',
    'stream/recul/weaponminismg.meta',
    'stream/recul/weaponmusket.meta',
    'stream/recul/weaponrevolver.meta',
    'stream/recul/weapons_assaultrifle_mk2.meta',
    'stream/recul/weapons_bullpuprifle_mk2.meta',
    'stream/recul/weapons_carbinerifle_mk2.meta',
    'stream/recul/weapons_combatmg_mk2.meta',
    'stream/recul/weapons_heavysniper_mk2.meta',
    'stream/recul/weapons_marksmanrifle_mk2.meta',
    'stream/recul/weapons_pumpshotgun_mk2.meta',
    'stream/recul/weapons_revolver_mk2.meta',
    'stream/recul/weapons_smg_mk2.meta',
    'stream/recul/weapons_snspistol_mk2.meta',
    'stream/recul/weapons_specialcarbine_mk2.meta',
    'stream/recul/weaponsnspistol.meta',
    'stream/recul/weaponspecialcarbine.meta',
    'stream/recul/weaponvintagepistol.meta',
}

data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponautoshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponbullpuprifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponcombatpdw.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponcompactrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapondbshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponfirework.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapongusenberg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponheavyshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponmachinepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponmarksmanpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponmarksmanrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponminismg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponmusket.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_assaultrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_bullpuprifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_carbinerifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_combatmg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_heavysniper_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_marksmanrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_pumpshotgun_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_revolver_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_smg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_snspistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weapons_specialcarbine_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponsnspistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponspecialcarbine.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'stream/recul/weaponvintagepistol.meta'


client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'