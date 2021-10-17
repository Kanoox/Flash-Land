function TchatGetMessageChannel(channel, cb)
	MySQL.Async.fetchAll("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time ASC LIMIT 100", {
			['@channel'] = channel
	}, cb)
end

function TchatAddMessage(channel, message)
	MySQL.Async.insert("INSERT INTO phone_app_chat (`channel`, `message`) VALUES(@channel, @message);", {
		['@channel'] = channel,
		['@message'] = message
	}, function(id)
		MySQL.Async.fetchAll('SELECT * from phone_app_chat WHERE `id` = @id;', { ['@id'] = id }, function(reponse)
			TriggerClientEvent('fl_phone:tchat_receive', -1, reponse[1])
		end)
	end)
end

RegisterNetEvent('fl_phone:tchat_channel')
AddEventHandler('fl_phone:tchat_channel', function(channel)
	local source = source
	TchatGetMessageChannel(channel, function(messages)
		TriggerClientEvent('fl_phone:tchat_channel', source, channel, messages)
	end)
end)

RegisterNetEvent('fl_phone:tchat_addMessage')
AddEventHandler('fl_phone:tchat_addMessage', function(channel, message)
	TchatAddMessage(channel, message)
end)