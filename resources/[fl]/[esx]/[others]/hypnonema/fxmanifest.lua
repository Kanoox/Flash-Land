--[[
 _   _                                                    
| | | |                                                   
| |_| |_   _ _ __  _ __   ___  _ __   ___ _ __ ___   __ _ 
|  _  | | | | '_ \| '_ \ / _ \| '_ \ / _ \ '_ ` _ \ / _` |
| | | | |_| | |_) | | | | (_) | | | |  __/ | | | | | (_| |
\_| |_/\__, | .__/|_| |_|\___/|_| |_|\___|_| |_| |_|\__,_|
        __/ | |                                           
       |___/|_|  

]]--

-- The url to your webserver
-- Hint: This is optional! You may want to stay with the default (https://thiago-dev.github.io/fivem-hypnonema)
hypnonema_url 'https://thiago-dev.github.io/fivem-hypnonema'

-- If you want to see a custom splash screen / poster
hypnonema_poster_url 'https://i.imgur.com/dPaIjEW.jpg'

-- The command someone needs to enter for opening the menu
-- Hint: no spaces, no special characters!
hypnonema_command_name 'hypnonema'

-- Only change if you know what you are doing!
hypnonema_db_connString "Filename=hypnonema.db;Flush=true"

-- Whether logging is enabled or not
hypnonema_logging_enabled 'false'

-- The sync interval in ms
hypnonema_sync_interval '5000'

-- Whether the command should be restricted or not
hypnonema_restrict_command 'true'

--------------------------------------------
--------------------------------------------
fx_version 'bodacious'
game 'gta5'

ui_page 'client/html/index.html'
client_script 'client/Hypnonema.Client.net.dll'
server_script 'server/Hypnonema.Server.net.dll'

files {
    'client/Newtonsoft.Json.dll',
    'client/Hypnonema.Shared.dll',
    'client/html/index.html',
    'client/html/styles.css',
    'client/html/bg.png',
    'client/html/*.js'
}

data_file 'DLC_ITYP_REQUEST' 'stream/v_hypnonema.ytyp'

author 'simpled-dev'
version '1.8.18.28326'
description 'a Cinema Resource for FiveM'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'

client_script '@WaveShield/xDxDxDxDxD.lua'