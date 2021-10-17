BanList = {}
BanListHistory = {}
BanListLoad = false
BanListHistoryLoad = false

CreateThread(function()
	while true do
		Wait(1000)
        if not BanListLoad then
			LoadBanList()
			if BanList ~= {} then
				print(Text.banlistloaded)
				BanListLoad = true
			else
				print(Text.starterror)
			end
		end

		if not BanListHistoryLoad then
			LoadBanListHistory()
            if BanListHistory ~= {} then
				print(Text.historyloaded)
				BanListHistoryLoad = true
			else
				print(Text.starterror)
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(30 * 1000)

		MySQL.Async.fetchAll('SELECT * FROM banlist', {}, function(NewBanList)
			if #NewBanList ~= #BanList then
				BanList = NewBanList

				LoadBanListHistory()
				for _, playerId in pairs(GetPlayers()) do
					CheckForBans(playerId)
				end
			end
		end)
	end
end)

--How to use from server side : TriggerEvent("fl_bans:currentlyCheating", "Auto-Cheat Custom Reason",TargetId)
RegisterServerEvent('fl_bans:currentlyCheating')
AddEventHandler('fl_bans:currentlyCheating', function(reason,servertarget)
	local license,identifier,liveid,xblid,discord,playerip,target
	local duree = 0
	local reason = reason

	if not reason then reason = "Auto Anti-Cheat" end

	if tostring(source) == "" then
		target = tonumber(servertarget)
	else
		target = source
	end

	if target and target > 0 then
		local ping = GetPlayerPing(target)

		if ping and ping > 0 then
			if duree and duree < 365 then
				local sourceplayername = "FL-AC"
				local targetplayername = GetPlayerName(target)
					for k,v in ipairs(GetPlayerIdentifiers(target))do
						if string.sub(v, 1, string.len("license:")) == "license:" then
							license = v
						elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
							identifier = v
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

				if duree > 0 then
					ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
					DropPlayer(target, Text.yourban .. reason)
				else
					ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
					DropPlayer(target, Text.yourpermban .. reason)
				end

			else
				print("BanSql Error : Auto-Cheat-Ban time invalid.")
			end
		else
			print("BanSql Error : Auto-Cheat-Ban target are not online.")
		end
	else
		print("BanSql Error : Auto-Cheat-Ban have recive invalid id.")
	end
end)

AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local license,steamID,liveid,xblid,discord,playerip  = "N/A","N/A","N/A","N/A","N/A","N/A"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
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

	--Si Banlist pas chargée
	if Banlist == {} then
		Citizen.Wait(1000)
	end

	for i = 1, #BanList, 1 do
		if  (tostring(BanList[i].license) == tostring(license)
			or tostring(BanList[i].identifier) == tostring(steamID)
			or tostring(BanList[i].liveid) == tostring(liveid)
			or tostring(BanList[i].xblid) == tostring(xblid)
			or tostring(BanList[i].discord) == tostring(discord)
			or tostring(BanList[i].playerip) == tostring(playerip))
		then

			if tonumber(BanList[i].permanent) == 1 then

				setKickReason(Text.yourpermban .. BanList[i].reason)
				CancelEvent()
				break

			elseif tonumber(BanList[i].expiration) > os.time() then

				local tempsrestant = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day = (tempsrestant / 60) / 24
					local hrs = (day - math.floor(day)) * 24
					local minutes = (hrs - math.floor(hrs)) * 60
					local txtday = math.floor(day)
					local txthrs = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day = (tempsrestant / 60) / 24
					local hrs = tempsrestant / 60
					local minutes = (hrs - math.floor(hrs)) * 60
					local txtday = math.floor(day)
					local txthrs = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday = 0
					local txthrs = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				end

			elseif tonumber(BanList[i].expiration) < os.time() and tonumber(BanList[i].permanent) == 0 then

				DeleteBans(license)
				break
			end
		end
	end
end)

AddEventHandler('esx:playerLoaded',function(source)
	CreateThread(function()
		Wait(5000)
		local license,steamID,liveid,xblid,discord,playerip
		local playername = GetPlayerName(source)

		for k,v in ipairs(GetPlayerIdentifiers(source))do
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

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `license` = @license', {
			['@license'] = license
		}, function(data)
			local found = false
			for i=1, #data, 1 do
				if data[i].license == license then
					found = true
				end
			end

			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (license, identifier, liveid, xblid, discord, playerip, playername) VALUES (@license, @identifier, @liveid, @xblid, @discord, @playerip, @playername)', {
					['@license'] = license,
					['@identifier'] = steamID,
					['@liveid'] = liveid,
					['@xblid'] = xblid,
					['@discord'] = discord,
					['@playerip'] = playerip,
					['@playername'] = playername
				}, function() end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `identifier` = @identifier, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `license` = @license', {
					['@license'] = license,
					['@identifier'] = steamID,
					['@liveid'] = liveid,
					['@xblid'] = xblid,
					['@discord'] = discord,
					['@playerip'] = playerip,
					['@playername'] = playername
				}, function() end)
			end
		end)

		CheckForBans(source)
	end)
end)