local playingMusic = {}
local playingMusicTargets = {}
local volumes = {}
local distances = {}

Citizen.CreateThread(function()
	while true do
		for netId, musicId in pairs(playingMusic) do
			local object = NetworkGetEntityFromNetworkId(netId)
			local objectCoords = GetEntityCoords(object)
			local routingBucket = GetEntityRoutingBucket(object)

			if DoesEntityExist(object) then
				if playingMusicTargets[netId] then
					for _,anyXPlayer in pairs(ESX.GetAllPlayers()) do
						if anyXPlayer and GetPlayerRoutingBucket(anyXPlayer.source) == routingBucket then
							local dist = #(anyXPlayer.getCoords(true) - objectCoords)
							if dist <= distances[netId] then
								if playingMusicTargets[netId] and playingMusicTargets[netId][anyXPlayer.source] then
									-- ok
								else
									--start playing with volume
									if playingMusicTargets[netId] == nil then playingMusicTargets[netId] = {} end
									anyXPlayer.triggerEvent('fl_hifi:playMusic', musicId, netId)
									anyXPlayer.triggerEvent('fl_hifi:setVolume', volumes[netId], netId)
									anyXPlayer.triggerEvent('fl_hifi:setDistance', distances[netId], netId)
								end
							else
								if playingMusicTargets[netId] and playingMusicTargets[netId][anyXPlayer.source] then
									anyXPlayer.triggerEvent('fl_hifi:stopMusic', netId)
									playingMusicTargets[netId][anyXPlayer.source] = false
								else
									-- ok
								end
							end
						end

						Citizen.Wait(0)
					end
				end
			else
				print('Cleaned unknown object fl_hifi')
				playingMusic[netId] = nil
				volumes[netId] = nil
				distances[netId] = nil
				playingMusicTargets[netId] = nil
				TriggerClientEvent('fl_hifi:stopMusic', -1, netId)
			end

			Citizen.Wait(10)
		end

		Citizen.Wait(100)
	end
end)

ESX.RegisterUsableItem('hifi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hifi', 1)

	TriggerClientEvent('fl_hifi:placeHifi', source)
	xPlayer.showNotification('Vous venez de deposer la chaîne HiFi')
end)

RegisterServerEvent('fl_hifi:removeHifi')
AddEventHandler('fl_hifi:removeHifi', function(netId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local object = NetworkGetEntityFromNetworkId(netId)
	if not object or not DoesEntityExist(object) then
		xPlayer.showNotification('~r~Hifi inconnue ? (removeHifi)')
		return
	end

	if GetEntityModel(object) ~= `prop_boombox_01` then
		xPlayer.showNotification('~r~Pas une chaine hifi (removeHifi)')
		return
	end

	playingMusic[netId] = nil
	volumes[netId] = nil
	distances[netId] = nil
	playingMusicTargets[netId] = nil

	DeleteEntity(object)
	xPlayer.addInventoryItem('hifi', 1)
	TriggerClientEvent('fl_hifi:stopMusic', -1, netId)
end)

RegisterServerEvent('fl_hifi:playMusic')
AddEventHandler('fl_hifi:playMusic', function(id, netId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local object = NetworkGetEntityFromNetworkId(netId)
	if not object or not DoesEntityExist(object) then
		xPlayer.showNotification('~r~Hifi inconnue (playMusic)')
		return
	end

	if GetEntityModel(object) ~= `prop_boombox_01` then
		xPlayer.showNotification('~r~Pas une chaine hifi (playMusic)')
		return
	end

	local routingBucket = GetEntityRoutingBucket(object)

	playingMusic[netId] = id
	playingMusicTargets[netId] = {}
	if not volumes[netId] then
		volumes[netId] = 20
	end

	if not distances[netId] then
		distances[netId] = 50
	end

	local objectCoords = GetEntityCoords(object)

	for _,anyXPlayer in pairs(ESX.GetAllPlayers()) do
		local dist = #(anyXPlayer.getCoords(true) - objectCoords)
		if dist <= distances[netId] and GetPlayerRoutingBucket(anyXPlayer.source) == routingBucket then
			playingMusicTargets[netId][anyXPlayer.source] = true
			anyXPlayer.triggerEvent('fl_hifi:playMusic', id, netId)
		end
	end
end)

RegisterServerEvent('fl_hifi:stopMusic')
AddEventHandler('fl_hifi:stopMusic', function(netId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if netId == nil then
		xPlayer.showNotification('~r~????')
		return
	end
	TriggerClientEvent('fl_hifi:stopMusic', -1, netId)
	playingMusic[netId] = nil
	playingMusicTargets[netId] = nil
	xPlayer.showNotification('~r~Arrêt de la musique')
end)

RegisterServerEvent('fl_hifi:setVolume')
AddEventHandler('fl_hifi:setVolume', function(volume, netId)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fl_hifi:setVolume', -1, volume, netId)
	volumes[netId] = volume
	xPlayer.showNotification('~g~Volume défini sur ' .. tostring(volume) .. '%')
end)

RegisterServerEvent('fl_hifi:setDistance')
AddEventHandler('fl_hifi:setDistance', function(distance, netId)
	if distance < 10 or distance > 50 then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fl_hifi:setDistance', -1, distance, netId)
	distances[netId] = distance
	xPlayer.showNotification('~g~Distance défini sur ' .. tostring(distance) .. 'm')
end)