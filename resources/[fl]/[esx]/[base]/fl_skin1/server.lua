RegisterNetEvent('fl_skin:save')
AddEventHandler('fl_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE discord = @discord', {
		['@skin'] = json.encode(skin),
		['@discord'] = xPlayer.discord
	})
end)

ESX.RegisterServerCallback('fl_skin:getPlayerSkin', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT skin FROM users WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

ESX.RegisterServerCallback('fl_skin:getPlayerSkinFaction', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT skin FROM users WHERE discord = @discord', {
		['@discord'] = xPlayer.discord
	}, function(users)
		local user, skin = users[1]

		local factionSkin = {
			skin_male = xPlayer.faction.skin_male,
			skin_female = xPlayer.faction.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, factionSkin)
	end)
end)