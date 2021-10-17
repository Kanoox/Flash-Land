function sanitize(string)
    return string:gsub('%@', '')
end

exports('sanitize', function(string)
    sanitize(string)
end)

RegisterNetEvent("discordLogs")
AddEventHandler("discordLogs", function(message, color, channel)
    discordLog(message, color, channel)
end)

for k, v in pairs(Config.BaseColors) do
	if string.find(v,"#") then
		Config.BaseColors[k] = tonumber(v:gsub("#",""),16)
	else
		Config.BaseColors[k] = v
	end
end

-- Get exports from server side
exports('discord', function(message, id, id2, color, channel)
	-- checking if export is used correctly
	local _message = message
	
	if message == nil then print("^1Error: JD_Logs Export. Invalid message.^0") return end
	if id == nil or id == "PLAYER_ID" or not tonumber(id) then print("^1Error: JD_Logs Export. Invalid player id.^0") return end
	if id == nil or id2 == "PLAYER_2_ID" or not tonumber(id2) then print("^1Error: JD_Logs Export. Invalid second player id.^0") return end
	if color == nil then print("^1Error: JD_Logs Export. Invalid color.^0") return end
	if channel == nil or channel == "" then print("^1Error: JD_Logs Export. Invalid channel.^0") return end

	-- Check if hex or decimal color is used
	if string.find(color,"#") then _color = tonumber(color:gsub("#",""),16) else _color = color end

	if id2 ~= 0 then
		DualPlayerLogs(message, _color, id, id2, channel)
	else
		if id == 0 then
			HidePlayerDetails(message, _color, channel)
		else
			SinglePlayerLogs(message, _color, id, channel)
		end
	end
end)

function HidePlayerDetails(message, color, channel)
	if Config.AllLogs then
		PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({
			username = Config.username, 
			embeds = {{
				["color"] = color, 
				["author"] = {
					["name"] = Config.communtiyName,
					["icon_url"] = Config.communtiyLogo
				},
				["title"] = GetTitle(channel),
				["description"] = "".. message .."",
				["footer"] = {
					["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
					["icon_url"] = Config.FooterIcon,
				},
			}}, 
			avatar_url = Config.avatar
		}), { 
			['Content-Type'] = 'application/json' 
		})
  	end
  	PerformHttpRequest(Config.webhooks[channel], function(err, text, headers) end, 'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = color, 
			["author"] = {
				["name"] = Config.communtiyName,
				["icon_url"] = Config.communtiyLogo
			},
			["title"] = GetTitle(channel),
			["description"] = "".. message .."",
			["footer"] = {
				["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
			},
		}}, 
		avatar_url = Config.avatar
	}), { 
		['Content-Type'] = 'application/json' 
	})
end

function SinglePlayerLogs(message, color, field1, channel)
	local PlayerDetails = GetPlayerDetails(field1)
	if Config.AllLogs then
		PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({
			username = Config.username, 
			embeds = {{
				["color"] = color, 
				["author"] = {
					["name"] = Config.communtiyName,
					["icon_url"] = Config.communtiyLogo
				},
				["title"] = GetTitle(channel),
				["description"] = "".. message .."",
				["footer"] = {
					["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
					["icon_url"] = Config.FooterIcon,
				},
				["fields"] = {
					{
						["name"] = "Player Details: "..GetPlayerName(field1),
						["value"] = PlayerDetails,
						["inline"] = Config.InlineFields
					}
				},
			}}, 
			avatar_url = Config.avatar
		}), { 
			['Content-Type'] = 'application/json' 
		})
  	end
  	PerformHttpRequest(Config.webhooks[channel], function(err, text, headers) end, 'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = color, 
			["author"] = {
				["name"] = Config.communtiyName,
				["icon_url"] = Config.communtiyLogo
			},
			["title"] = GetTitle(channel),
			["description"] = "".. message .."",
			["footer"] = {
				["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
			},
			["fields"] = {
				{
					["name"] = "Player Details: "..GetPlayerName(field1),
					["value"] = PlayerDetails,
					["inline"] = Config.InlineFields
				}
			},
		}}, 
		avatar_url = Config.avatar
	}), { 
		['Content-Type'] = 'application/json' 
	})
end

function DualPlayerLogs(message, color, field1, field2, channel)
	local PlayerDetails = GetPlayerDetails(field1)
	local PlayerDetails2 = GetPlayerDetails(field2)
	if Config.AllLogs then
		PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({
			username = Config.username, 
			embeds = {{
				["color"] = color, 
				["author"] = {
					["name"] = Config.communtiyName,
					["icon_url"] = Config.communtiyLogo
				},
				["title"] = GetTitle(channel),
				["description"] = "".. message .."",
				["footer"] = {
					["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
					["icon_url"] = Config.FooterIcon,
				},
				["fields"] = {
					{
						["name"] = "Player Details: "..GetPlayerName(field1),
						["value"] = PlayerDetails,
						["inline"] = Config.InlineFields
					},
					{
						["name"] = "Player Details: "..GetPlayerName(field2),
						["value"] = PlayerDetails2,
						["inline"] = Config.InlineFields
					}
				},
			}}, 
			avatar_url = Config.avatar
		}), { 
			['Content-Type'] = 'application/json' 
		})
  	end
  	PerformHttpRequest(Config.webhooks[channel], function(err, text, headers) end, 'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = color, 
			["author"] = {
				["name"] = Config.communtiyName,
				["icon_url"] = Config.communtiyLogo
			}, 
			["title"] = GetTitle(channel),
			["description"] = "".. message .."",
			["footer"] = {
				["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
			},
			["fields"] = {
				{
					["name"] = "Player Details: "..GetPlayerName(field1),
					["value"] = PlayerDetails,
					["inline"] = Config.InlineFields
				},
				{
					["name"] = "Player Details: "..GetPlayerName(field2),
					["value"] = PlayerDetails2,
					["inline"] = Config.InlineFields
				}
			},
		}}, 
		avatar_url = Config.avatar
	}), { 
		['Content-Type'] = 'application/json' 
	})
end

function PluginHidePlayerDetails(message, color, channel)
	if string.find(color,"#") then _color = tonumber(color:gsub("#",""),16) else _color = color end
	if Config.AllLogs then
		PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({
			username = Config.username, 
			embeds = {{
				["color"] = _color, 
				["author"] = {
					["name"] = Config.communtiyName,
					["icon_url"] = Config.communtiyLogo
				},
				["title"] = Config.Plugins[channel].icon.." "..channel,
				["description"] = "".. message .."",
				["footer"] = {
					["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
					["icon_url"] = Config.FooterIcon,
				},
			}}, 
			avatar_url = Config.avatar
		}), { 
			['Content-Type'] = 'application/json' 
		})
  	end
  	PerformHttpRequest(Config.Plugins[channel].webhook, function(err, text, headers) end, 'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = _color, 
			["author"] = {
				["name"] = Config.communtiyName,
				["icon_url"] = Config.communtiyLogo
			},
			["title"] = Config.Plugins[channel].icon.." "..channel,
			["description"] = "".. message .."",
			["footer"] = {
				["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
			},
		}}, 
		avatar_url = Config.avatar
	}), { 
		['Content-Type'] = 'application/json' 
	})
end

function PluginSinglePlayerLogs(message, color, field1, channel)
	if string.find(color,"#") then _color = tonumber(color:gsub("#",""),16) else _color = color end
	local PlayerDetails = GetPlayerDetails(field1)
	if Config.AllLogs then
		PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({
			username = Config.username, 
			embeds = {{
				["color"] = _color, 
				["author"] = {
					["name"] = Config.communtiyName,
					["icon_url"] = Config.communtiyLogo
				},
				["title"] = Config.Plugins[channel].icon.." "..channel,
				["description"] = "".. message .."",
				["footer"] = {
					["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
					["icon_url"] = Config.FooterIcon,
				},
				["fields"] = {
					{
						["name"] = "Player Details: "..GetPlayerName(field1),
						["value"] = PlayerDetails,
						["inline"] = Config.InlineFields
					}
				},
			}}, 
			avatar_url = Config.avatar
		}), { 
			['Content-Type'] = 'application/json' 
		})
  	end
  	PerformHttpRequest(Config.Plugins[channel].webhook, function(err, text, headers) end, 'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = _color, 
			["author"] = {
				["name"] = Config.communtiyName,
				["icon_url"] = Config.communtiyLogo
			},
			["title"] = Config.Plugins[channel].icon.." "..channel,
			["description"] = "".. message .."",
			["footer"] = {
				["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
			},
			["fields"] = {
				{
					["name"] = "Player Details: "..GetPlayerName(field1),
					["value"] = PlayerDetails,
					["inline"] = Config.InlineFields
				}
			},
		}}, 
		avatar_url = Config.avatar
	}), { 
		['Content-Type'] = 'application/json' 
	})
end

function PluginDualPlayerLogs(message, color, field1, field2, channel)
	if string.find(color,"#") then _color = tonumber(color:gsub("#",""),16) else _color = color end
	local PlayerDetails = GetPlayerDetails(field1)
	local PlayerDetails2 = GetPlayerDetails(field2)
	if Config.AllLogs then
		PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({
			username = Config.username, 
			embeds = {{
				["color"] = _color, 
				["author"] = {
					["name"] = Config.communtiyName,
					["icon_url"] = Config.communtiyLogo
				},
				["title"] = Config.Plugins[channel].icon.." "..channel,
				["description"] = "".. message .."",
				["footer"] = {
					["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
					["icon_url"] = Config.FooterIcon,
				},
				["fields"] = {
					{
						["name"] = "Player Details: "..GetPlayerName(field1),
						["value"] = PlayerDetails,
						["inline"] = Config.InlineFields
					},
					{
						["name"] = "Player Details: "..GetPlayerName(field2),
						["value"] = PlayerDetails2,
						["inline"] = Config.InlineFields
					}
				},
			}}, 
			avatar_url = Config.avatar
		}), { 
			['Content-Type'] = 'application/json' 
		})
  	end
  	PerformHttpRequest(Config.Plugins[channel].webhook, function(err, text, headers) end, 'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = _color, 
			["author"] = {
				["name"] = Config.communtiyName,
				["icon_url"] = Config.communtiyLogo
			}, 
			["title"] = Config.Plugins[channel].icon.." "..channel,
			["description"] = "".. message .."",
			["footer"] = {
				["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
			},
			["timestamp"] = os.date("%x %X %p"),
			["fields"] = {
				{
					["name"] = "Player Details: "..GetPlayerName(field1),
					["value"] = PlayerDetails,
					["inline"] = Config.InlineFields
				},
				{
					["name"] = "Player Details: "..GetPlayerName(field2),
					["value"] = PlayerDetails2,
					["inline"] = Config.InlineFields
				}
			},
		}}, 
		avatar_url = Config.avatar
	}), { 
		['Content-Type'] = 'application/json' 
	})
end

-- Event Handlers

-- Send message when Player connects to the server.
AddEventHandler("playerConnecting", function(name, setReason, deferrals)
	SinglePlayerLogs('**' ..GetPlayerName(source).. '** is connecting to the server.', Config.BaseColors['joins'], source, 'joins')
end)

-- Send message when Player disconnects from the server
AddEventHandler('playerDropped', function(reason)
	SinglePlayerLogs('**' ..GetPlayerName(source).. '** has left the server. (Reason: ' .. reason .. ')', Config.BaseColors['leaving'], source, 'leaving')
end)

-- Send message when Player creates a chat message (Does not show commands)
AddEventHandler('chatMessage', function(source, name, msg)
	SinglePlayerLogs('**' .. sanitize(GetPlayerName(source)) .. '**: `' .. msg..'`', Config.BaseColors['chat'], source, 'chat')
end)

-- Send message when Player died (including reason/killer check) (Not always working)
RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(id,player,killer,DeathReason, Weapon)
	if Weapon == nil then _Weapon = "" else _Weapon = "`"..Weapon.."`" end
	if id == 1 then  -- Suicide/died
        SinglePlayerLogs('**' .. sanitize(GetPlayerName(source)) .. '** `'..DeathReason..'` '.._Weapon, Config.BaseColors['deaths'], source, 'deaths') -- sending to deaths channel
	elseif id == 2 then -- Killed by other player
		DualPlayerLogs('**' .. GetPlayerName(killer) .. '** '..DeathReason..' ' .. GetPlayerName(source).. ' `('.._Weapon..')`', Config.BaseColors['deaths'], killer, source, 'deaths') -- sending to deaths channel
	else -- When gets killed by something else
        SinglePlayerLogs('**' .. GetPlayerName(source) .. '** `died`', Config.BaseColors['deaths'], source, 'deaths') -- sending to deaths channel
	end
end)

-- Send message when Player fires a weapon
RegisterServerEvent('playerShotWeapon')
AddEventHandler('playerShotWeapon', function(weapon)
	local info = GetPlayerDetails(source)
	if Config.weaponLog then
		SinglePlayerLogs('**' .. GetPlayerName(source)  .. '** fired a `' .. weapon .. '`', Config.BaseColors['shooting'], source, 'shooting')
    end
end)

-- Getting exports from clientside
RegisterServerEvent('ClientDiscord')
AddEventHandler('ClientDiscord', function(message, id, id2, color, channel)
	local _message = message
	
	if message == nil then print("^1Error: JD_Logs Export. Invalid message.^0") return end
	if id == nil or id == "PLAYER_ID" or not tonumber(id) then print("^1Error: JD_Logs Export. Invalid player id.^0") return end
	if id == nil or id2 == "PLAYER_2_ID" or not tonumber(id2) then print("^1Error: JD_Logs Export. Invalid second player id.^0") return end
	if color == nil then print("^1Error: JD_Logs Export. Invalid color.^0") return end
	if channel == nil or channel == "" then print("^1Error: JD_Logs Export. Invalid channel.^0") return end

	-- Check if hex or decimal color is used
	if string.find(color,"#") then _color = tonumber(color:gsub("#",""),16) else _color = color end

	if id2 ~= 0 then
		DualPlayerLogs(message, _color, id, id2, channel)
	else
		if id == 0 then
			HidePlayerDetails(message, _color, channel)
		else
			SinglePlayerLogs(message, _color, id, channel)
		end
	end
end)

-- Send message when a resource is being stopped
AddEventHandler('onResourceStop', function (resourceName)
    HidePlayerDetails('**' .. resourceName .. '** has been stopped.', Config.BaseColors['resources'], 'resources')
end)

-- Send message when a resource is being started
AddEventHandler('onResourceStart', function (resourceName)
    Wait(100)
    HidePlayerDetails('**' .. resourceName .. '** has been started.', Config.BaseColors['resources'], 'resources')
end)

function GetPlayerDetails(src)
	local player_id = src
	local ids = ExtractIdentifiers(player_id)
	local postal = getPlayerLocation(player_id)
	if Config.postal then _postal = "\n**Nearest Postal:** ".. postal .."" else _postal = "" end
	if Config.discordID then if ids.discord ~= "" then _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "")..">" else _discordID = "\n**Discord ID:** N/A" end else _discordID = "" end
	if Config.steamID then if ids.steam ~= "" then _steamID ="\n**Steam ID:** " ..ids.steam.."" else _steamID = "\n**Steam ID:** N/A" end else _steamID = "" end
	if Config.steamURL then  if ids.steam ~= "" then _steamURL ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."" else _steamURL = "\n**Steam URL:** N/A" end else _steamURL = "" end
	if Config.license then if ids.license ~= "" then _license ="\n**License:** " ..ids.license else _license = "\n**License :** N/A" end else _license = "" end
	if Config.IP then if ids.ip ~= "" then _ip ="\n**IP:** " ..ids.ip else _ip = "\n**IP :** N/A" end else _ip = "" end
	if Config.playerID then _playerID ="\n**Player ID:** " ..player_id.."" else _playerID = "" end
	return _playerID..''.. _postal ..''.. _discordID..''.._steamID..''.._steamURL..''.._license..''.._ip
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

function getPlayerLocation(src)

local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
local postals = json.decode(raw)
local nearest = nil

local player = src
local ped = GetPlayerPed(player)
local playerCoords = GetEntityCoords(ped)

local x, y = table.unpack(playerCoords)

	local ndm = -1
	local ni = -1
	for i, p in ipairs(postals) do
		local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
		if ndm == -1 or dm < ndm then
			ni = i
			ndm = dm
		end
	end

	if ni ~= -1 then
		local nd = math.sqrt(ndm)
		nearest = {i = ni, d = nd}
	end
	_nearest = postals[nearest.i].code
	return _nearest
end

function GetTitle(channel)
	if Config.TitleIcon[channel] then
		return Config.TitleIcon[channel].." "..firstToUpper(channel)
	else
		return "❓ "..firstToUpper(channel)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

-- version check
Citizen.CreateThread( function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw and Config.versionCheck then
			local v = json.decode(vRaw)
			PerformHttpRequest(
				'https://raw.githubusercontent.com/Prefech/JD_logs/master/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= v.version then
							print(
								([[^1

-------------------------------------------------------
JD_logs
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
^0]]):format(
									rv.version,
									rv.changelog
								)
							)
						end
					else
						print('JD_logs unable to check version')
					end
				end,
				'GET'
			)
		end
	end
)
