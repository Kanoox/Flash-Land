fx_version "bodacious"
game "gta5"

files {
	"nui/**/*",
}

ui_page "nui/radar.html"

server_scripts {
	'@es_extended/server/shared/common.lua',
	"sv_exports.lua",
}

client_scripts {
	'@es_extended/client/shared/common.lua',
	'@es_extended/client/shared/natives.lua',
	"config.lua",
	"cl_utils.lua",
	"cl_radar.lua",
	"cl_plate_reader.lua",
}

server_export "TogglePlateLock"

dependencies {
	'es_extended',
}

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'