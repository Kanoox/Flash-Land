function getIdentity(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)
	  MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `discord` = @discord",
	{
	  ['@discord'] = xPlayer.discord
	},
	function(result)
		if result[1]['firstname'] ~= nil then
			callback({
				discord = result[1]['discord'],
				firstname = result[1]['firstname'],
				lastname = result[1]['lastname'],
				dateofbirth = result[1]['dateofbirth'],
				sex = result[1]['sex'],
				height = result[1]['height']
			})
		else
			callback({
				discord = '',
				firstname = '',
				lastname = '',
				dateofbirth = '',
				sex = '',
				height = ''
			})
	  end
	end)
end

function setIdentity(discord, data, cb)
	MySQL.Async.execute("UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE discord = @discord",
	{
		['@discord'] = discord,
		['@firstname'] = data.firstname,
		['@lastname'] = data.lastname,
		['@dateofbirth'] = data.dateofbirth,
		['@sex'] = data.sex,
		['@height'] = data.height
	},
	function(done)
		if cb then
			cb(true)
		end
	end)
end

function updateIdentity(discord, data, cb)
	MySQL.Async.execute("UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE discord = @discord",
	  {
		['@discord'] = discord,
		['@firstname'] = data.firstname,
		['@lastname'] = data.lastname,
		['@dateofbirth'] = data.dateofbirth,
		['@sex'] = data.sex,
		['@height'] = data.height
	  },
	function(done)
		if cb then
			cb(true)
		end
	end)
end

RegisterNetEvent('fl_identity:setIdentity')
AddEventHandler('fl_identity:setIdentity', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	setIdentity(xPlayer.discord, data, function(cb)
		if cb then
			print('Loading user : ' .. xPlayer.discord)
		else
			print('Failed loading of user')
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source)
	getIdentity(source, function(data)
		if data.firstname == '' then
			print('Starting registration of ' .. tostring(GetPlayerName(source)))
			Citizen.Wait(1000)
			TriggerClientEvent('fl_identity:showRegisterIdentity', source)
		else
			--print('Loading user : ' .. data.firstname .. ' ' .. data.lastname)
		end
	end)
end)