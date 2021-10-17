author 'Prefech'
description 'FXServer logs to Discord (https://prefech.com/)'
version '1.3.0'
url 'https://prefech.com'

-- Config
server_script 'config.lua'

-- Server Scripts
server_scripts {
    'server/server.lua',
    'plugins/server/**/*.lua'
} 

--Client Scripts
client_scripts {
    'client/client.lua',
    'plugins/client/**/*.lua'
}

file 'postals.json'
postal_file 'postals.json'
file 'version.json'

game 'gta5'
fx_version 'cerulean'


client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'