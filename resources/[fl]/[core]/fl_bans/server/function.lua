function GetPlayerTokens(playerId)
    local tokens = {}

    if GetNumPlayerTokens(playerId) > 0 then
        for i=0, GetNumPlayerTokens(playerId) - 1 do
            table.insert(tokens, GetPlayerToken(playerId, i))
        end
    end

    return tokens
end

function sendToDiscord(canal, message)
	PerformHttpRequest(canal, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

function ban(source, license, identifier, liveid, xblid, discord, playerip, targetplayername, sourceplayername, duree, reason, permanent)
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', {
		['@playername'] = ("%"..targetplayername.."%")
	}, function(data)
		if not data[1] then
			local expiration = duree * 86400 --calcul total expiration (en secondes)
			local timeat = os.time()
			local added = os.date()

			if expiration < os.time() then
				expiration = os.time() + expiration
			end

			table.insert(BanList, {
				license = license,
				identifier = identifier,
				liveid = liveid,
				xblid = xblid,
				discord = discord,
				playerip = playerip,
				reason = reason,
				expiration = expiration,
				permanent = permanent
			})

			MySQL.Async.execute('INSERT INTO banlist (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)', {
				['@license'] = license,
				['@identifier'] = identifier,
				['@liveid'] = liveid,
				['@xblid'] = xblid,
				['@discord'] = discord,
				['@playerip'] = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason'] = reason,
				['@expiration'] = expiration,
				['@timeat'] = timeat,
				['@permanent'] = permanent,
			}, function() end)

			if permanent == 0 then
				SendMessage(source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
			else
				SendMessage(source, (Text.youban .. targetplayername .. Text.permban .. reason))
			end

			if permanent == 0 then
				message = (tostring(targetplayername)..Text.isban.." "..duree..Text.forr..reason.." "..Text.by.." "..tostring(sourceplayername).."```"..tostring(identifier).."\n"..tostring(license).."\n"..tostring(liveid).."\n"..tostring(xblid).."\n"..tostring(discord).."\n"..tostring(playerip).."```")
			else
				message = (tostring(targetplayername)..Text.isban.." "..Text.permban..reason.." "..Text.by.." "..tostring(sourceplayername).."```"..tostring(identifier).."\n"..tostring(license).."\n"..tostring(liveid).."\n"..tostring(xblid).."\n"..tostring(discord).."\n"..tostring(playerip).."```")
			end
			sendToDiscord(Config.webhookban, message)

			MySQL.Async.execute('INSERT INTO banlisthistory (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)', {
				['@license'] = license,
				['@identifier'] = identifier,
				['@liveid'] = liveid,
				['@xblid'] = xblid,
				['@discord'] = discord,
				['@playerip'] = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason'] = reason,
				['@added'] = added,
				['@expiration'] = expiration,
				['@timeat'] = timeat,
				['@permanent'] = permanent,
			}, function() end)
			BanListHistoryLoad = false
		else
			SendMessage(source, (targetplayername .. Text.alreadyban .. reason))
		end
	end)
end

function SendMessage(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist ', message } } )
	else
		print(message)
	end
end

function LoadBanList()
	MySQL.Async.fetchAll('SELECT * FROM banlist', {}, function (NewBanList)
		BanList = NewBanList
    end)
end

function LoadBanListHistory()
	MySQL.Async.fetchAll('SELECT * FROM banlisthistory', {}, function(NewBanListHistory)
		BanListHistory = NewBanListHistory
    end)
end

function DeleteBans(license)
	MySQL.Async.execute('DELETE FROM banlist WHERE license = @license', {
		  ['@license'] = license
	}, function()
		LoadBanList()
	end)
end

function CheckForBans(player)
	if GetPlayerIdentifiers(player) then
		local license, steamID, liveid, xblid, discord, playerip  = "N/A","N/A","N/A","N/A","N/A","N/A"

		for k,v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		for i = 1, #BanList, 1 do
			if ((tostring(BanList[i].license)) == tostring(license)
				or (tostring(BanList[i].identifier)) == tostring(steamID)
				or (tostring(BanList[i].liveid)) == tostring(liveid)
				or (tostring(BanList[i].xblid)) == tostring(xblid)
				or (tostring(BanList[i].discord)) == tostring(discord)
				or (tostring(BanList[i].playerip)) == tostring(playerip))
			then
				if tonumber(BanList[i].permanent) == 1 then
					DropPlayer(player, Text.yourban .. BanList[i].reason)
					break
				elseif tonumber(BanList[i].expiration) > os.time() then
					local tempsrestant = ((tonumber(BanList[i].expiration)) - os.time())/60
					if tempsrestant > 0 then
						DropPlayer(player, Text.yourban .. BanList[i].reason)
						break
					end
				elseif tonumber(BanList[i].expiration) < os.time() and tonumber(BanList[i].permanent) == 0 then
					DeleteBans(license)
					break
				end
			end
		end
	end
end