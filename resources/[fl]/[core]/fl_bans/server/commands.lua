


ESX.RegisterCommand({'ban', 'sqlban'}, 'mod', function(xPlayer, args, showError)
	local license,identifier,liveid,xblid,discord,playerip
	local target = tonumber(args[1])
	local duree = tonumber(args[2])
	local reason = table.concat(args, " ",3)

	if args[1] then
		if reason == "" then
			reason = Text.noreason
		end
		if target and target > 0 then
			local ping = GetPlayerPing(target)

			if ping and ping > 0 then
				if duree and duree < 365 then
					local targetplayername = GetPlayerName(target)
					local sourceplayername = ""
						if xPlayer.source ~= 0 then
							sourceplayername = xPlayer.getName()
						else
							sourceplayername = "Console"
						end
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
						ban(xPlayer.source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
						DropPlayer(target, Text.yourban .. reason)
					else
						ban(xPlayer.source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
						DropPlayer(target, Text.yourpermban .. reason)
					end

				else
					SendMessage(xPlayer.source, Text.invalidtime)
				end
			else
				SendMessage(xPlayer.source, Text.invalidid)
			end
		else
			SendMessage(xPlayer.source, Text.invalidid)
		end
	else
		SendMessage(xPlayer.source, Text.cmdban)
	end
end, false, {}) -- {{name = "id"}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}}

ESX.RegisterCommand({'unban', 'sqlunban'}, 'mod', function(xPlayer, args, showError)
	if args[1] then
		local target = table.concat(args, " ")
		MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', {
			['@playername'] = ("%"..target.."%")
		}, function(data)
			if data[1] then
				if #data > 1 then
					SendMessage(xPlayer.source, Text.toomanyresult)
					for i=1, #data, 1 do
						SendMessage(xPlayer.source, data[i].targetplayername)
					end
				else
					MySQL.Async.execute(
					'DELETE FROM banlist WHERE targetplayername = @name',
					{
					  ['@name']  = data[1].targetplayername
					},
						function ()
						LoadBanList()

						local sourceplayername = ""
						if source ~= 0 then
							sourceplayername = GetPlayerName(xPlayer.source)
						else
							sourceplayername = "Console"
						end
						local message = (data[1].targetplayername .. Text.isunban .." ".. Text.by .." ".. sourceplayername)
						sendToDiscord(Config.webhookunban, message)

						SendMessage(xPlayer.source, data[1].targetplayername .. Text.isunban)
					end)
				end
			else
				SendMessage(xPlayer.source, Text.invalidname)
			end

		end)
	else
		SendMessage(xPlayer.source, Text.invalidname)
	end
end, false, {}) -- {name = "name", help = Text.steamname}

ESX.RegisterCommand({'search', 'sqlsearch'}, 'mod', function(xPlayer, args, showError)
	local target = table.concat(args, " ")
	if target ~= "" then
		MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE playername like @playername', {
			['@playername'] = ("%"..target.."%")
		}, function(data)
			if data[1] then
				if #data < 50 then
					for i=1, #data, 1 do
						SendMessage(xPlayer.source, data[i].id.." "..data[i].playername)
					end
				else
					SendMessage(xPlayer.source, Text.toomanyresult)
				end
			else
				SendMessage(xPlayer.source, Text.invalidname)
			end
		end)
	else
		SendMessage(xPlayer.source, Text.invalidname)
	end
end, false, {}) -- {name = "name", help = Text.steamname}

ESX.RegisterCommand({'banoffline', 'sqlbanoffline'}, 'mod', function(xPlayer, args, showError)
	if args ~= "" then
		local target = tonumber(args[1])
		local duree = tonumber(args[2])
		local reason = table.concat(args, " ",3)
		local sourceplayername = ""
		if xPlayer.source ~= 0 then
			sourceplayername = xPlayer.getName()
		else
			sourceplayername = "Console"
		end

		if duree ~= "" then
			if target ~= "" then
				MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE id = @id', {
					['@id'] = target
				}, function(data)
					if data[1] then
						if duree and duree < 365 then
							if reason == "" then
								reason = Text.noreason
							end
							if duree > 0 then --Here if not perm ban
								ban(xPlayer.source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,0) --Timed ban here
							else --Here if perm ban
								ban(xPlayer.source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,1) --Perm ban here
							end
						else
							SendMessage(xPlayer.source, Text.invalidtime)
						end
					else
						SendMessage(xPlayer.source, Text.invalidid)
					end
				end)
			else
				SendMessage(xPlayer.source, Text.invalidname)
			end
		else
			SendMessage(xPlayer.source, Text.invalidtime)
			SendMessage(xPlayer.source, Text.cmdbanoff)
		end
	else
		SendMessage(xPlayer.source, Text.cmdbanoff)
	end
end, false, {}) -- {name = "permid", help = Text.permid}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}

ESX.RegisterCommand({'banhistory', 'sqlbanhistory'}, 'mod', function(xPlayer, args, showError)
	if args[1] and BanListHistory then
	    local nombre = (tonumber(args[1]))
	    local name   = table.concat(args, " ",1)
		if name ~= "" then
			if nombre and nombre > 0 then
				local expiration = BanListHistory[nombre].expiration
				local timeat = BanListHistory[nombre].timeat
				local calcul1 = expiration - timeat
				local calcul2 = calcul1 / 86400
				local calcul2 = math.ceil(calcul2)
				local resultat = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)

				SendMessage(xPlayer.source, (nombre .." : ".. resultat))
			else
				for i = 1, #BanListHistory, 1 do
					if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
						local expiration = BanListHistory[i].expiration
						local timeat = BanListHistory[i].timeat
						local calcul1 = expiration - timeat
						local calcul2 = calcul1 / 86400
						local calcul2 = math.ceil(calcul2)
						local resultat = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2..Text.day.." , "..BanListHistory[i].added)

						SendMessage(xPlayer.source, (i .." : ".. resultat))
					end
				end
			end
		else
			SendMessage(xPlayer.source, Text.invalidname)
		end
	else
		SendMessage(xPlayer.source, Text.cmdhistory)
	end
end, false, {}) -- {name = "name", help = Text.steamname}

ESX.RegisterCommand({'banreload', 'sqlbanreload'}, 'mod', function(xPlayer, args, showError)
	BanListLoad = false
	BanListHistoryLoad = false
	Wait(5000)
	if BanListLoad == true then
	  SendMessage(xPlayer.source, Text.banlistloaded)
	  if BanListHistoryLoad == true then
		  SendMessage(xPlayer.source, Text.historyloaded)
	  end
	else
	  SendMessage(xPlayer.source, Text.loaderror)
	end
end, false, {})