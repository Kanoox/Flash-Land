

SetHttpHandler(function(req, res)
	local decodedPath = urldecode(req.path)

	if string.startwith(req.path, '/wipe/') then
		local discord = 'discord:' .. string.sub(req.path, string.len('/wipe/')+1)
		print('Wipe de : ' .. tostring(discord))

		local source = ESX.GetSourceFromIdentifier(discord)
		if source then
			print('Déconnexion du joueur pour un wipe (ID:' .. tostring(source) .. ')...')
			DropPlayer(source, "Wipe en cours ...")
			Citizen.Wait(1000)
		end

		local wipeCommand = 'DELETE FROM billing WHERE discord = @discord; ' ..
							'DELETE FROM datastore_data WHERE owner = @discord; ' ..
							'DELETE FROM dpkeybinds WHERE id = @discord; ' ..
							'DELETE FROM jsfour_criminalrecord WHERE discord = @discord; ' ..
							'DELETE FROM jsfour_criminaluserinfo WHERE discord = @discord; ' ..
							'DELETE FROM lrp_registromedico WHERE discord = @discord; ' ..
							'DELETE FROM lrp_registromedicoinfo WHERE discord = @discord; ' ..
							'DELETE FROM vehicle_keys WHERE discord = @discord; ' ..
							'DELETE FROM phone_users_contacts WHERE discord = @discord; ' ..
							'DELETE FROM users WHERE discord = @discord; ' ..
							'DELETE FROM addon_account_data WHERE owner = @discord; ' ..
							'DELETE FROM addon_inventory_items WHERE owner = @discord; ' ..
							'DELETE FROM owned_vehicles WHERE owner = @discord; ' ..
							'DELETE FROM owned_properties WHERE owner = @discord; ' ..
							'DELETE FROM rented_bikes WHERE owner = @discord; ' ..
							'DELETE FROM rented_vehicles WHERE owner = @discord; ' ..
							'DELETE FROM police_bracelet WHERE target = @discord; ' ..
							'DELETE FROM sheriff_bracelet WHERE target = @discord; ' ..
							'DELETE FROM simcards WHERE owner = @discord; ' ..
							'DELETE FROM licenses_points WHERE owner = @discord; ' ..
							'DELETE FROM sixt_rented_vehicles WHERE owner = @discord;'

		MySQL.Async.execute(wipeCommand, {
			['@discord'] = discord,
		}, function()
			print('Wipe effectué ! ' .. tostring(discord) .. ' -> ' .. tostring(rowsChanged))
			res.send(json.encode({ status = 'ok', rowsChanged = rowsChanged }))
		end)

	else
		res.send(json.encode({'Unknown endpoint : ' .. req.path}))
	end

	return
end)

ESX.RegisterCommand('wipe', 'superadmin', function(xPlayer, args, showError)
	local target = tonumber(args[1])
	if args[1] then
		for k,v in ipairs(GetPlayerIdentifiers(args[1]))do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			end
		end
		local wipeCommand = 'DELETE FROM billing WHERE discord = @discord; ' ..
							'DELETE FROM datastore_data WHERE owner = @discord; ' ..
							'DELETE FROM dpkeybinds WHERE id = @discord; ' ..
							'DELETE FROM jsfour_criminalrecord WHERE discord = @discord; ' ..
							'DELETE FROM jsfour_criminaluserinfo WHERE discord = @discord; ' ..
							'DELETE FROM lrp_registromedico WHERE discord = @discord; ' ..
							'DELETE FROM lrp_registromedicoinfo WHERE discord = @discord; ' ..
							'DELETE FROM vehicle_keys WHERE discord = @discord; ' ..
							'DELETE FROM phone_users_contacts WHERE discord = @discord; ' ..
							'DELETE FROM users WHERE discord = @discord; ' ..
							'DELETE FROM addon_account_data WHERE owner = @discord; ' ..
							'DELETE FROM addon_inventory_items WHERE owner = @discord; ' ..
							'DELETE FROM owned_vehicles WHERE owner = @discord; ' ..
							'DELETE FROM owned_properties WHERE owner = @discord; ' ..
							'DELETE FROM rented_bikes WHERE owner = @discord; ' ..
							'DELETE FROM rented_vehicles WHERE owner = @discord; ' ..
							'DELETE FROM police_bracelet WHERE target = @discord; ' ..
							'DELETE FROM sheriff_bracelet WHERE target = @discord; ' ..
							'DELETE FROM simcards WHERE owner = @discord; ' ..
							'DELETE FROM licenses_points WHERE owner = @discord; ' ..
							'DELETE FROM sixt_rented_vehicles WHERE owner = @discord;'

		MySQL.Async.execute(wipeCommand, {
			['@discord'] = discord,
		}, function()
			print('Wipe effectué ! ' .. tostring(discord) .. ' -> ')
		end)
	    print('Déconnexion du joueur pour un wipe (ID:' .. tostring(target) .. ')...')
		DropPlayer(target, "Wipe en cours ...")
		Citizen.Wait(1000)
	end
end, false, {})

--[[ESX.RegisterCommand({'ban', 'sqlban'}, 'mod', function(xPlayer, args, showError)
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
end, false, {}) -- {{name = "id"}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}}]]--

function string.startwith(String,Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function char_to_hex(c)
	return string.format("%%%02X", string.byte(c))
end

function hex_to_char(x)
	return string.char(tonumber(x, 16))
end

function urlencode(url)
	if url == nil then
		return
	end
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", char_to_hex)
	url = url:gsub(" ", "+")
	return url
end

function urldecode(url)
	if url == nil then
		return
	end
	url = url:gsub("+", " ")
	url = url:gsub("%%(%x%x)", hex_to_char)
	return url
end