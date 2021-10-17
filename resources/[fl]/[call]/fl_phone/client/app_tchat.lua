RegisterNetEvent("fl_phone:tchat_receive")
AddEventHandler("fl_phone:tchat_receive", function(message)
	SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("fl_phone:tchat_channel")
AddEventHandler("fl_phone:tchat_channel", function(channel, messages)
	SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
	TriggerServerEvent('fl_phone:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
	TriggerServerEvent('fl_phone:tchat_channel', data.channel)
end)
