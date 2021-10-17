local lastEntity = nil
local currentAction = nil
local currentData = nil
local baseVolume = 20
local baseDistance = 50

RegisterNetEvent('fl_hifi:placeHifi')
AddEventHandler('fl_hifi:placeHifi', function()
	PlayAnimation("anim@heists@money_grab@briefcase", "put_down_case")
	Citizen.Wait(1000)
	ClearPedTasks(PlayerPedId())

	ESX.Game.SpawnObject('prop_boombox_01', GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 0.5, function(object)
		PlaceObjectOnGroundProperly(object)
		FreezeEntityPosition(object, true)
		SetEntityAsMissionEntity(object, 1, 1)
    end)
end)

RegisterNetEvent('fl_hifi:playMusic')
AddEventHandler('fl_hifi:playMusic', function(id, netId)
	if currentlyPlayingNetId ~= nil and currentlyPlayingNetId ~= netId then
		ESX.ShowNotification('~r~Multiple source audio non supporté pour les hifi !')
	end

	currentlyPlayingNetId = netId

	SendNUIMessage({
		transactionType = 'playSound',
		transactionData = id
	})

	SendNUIMessage({
		transactionType = 'volume',
		transactionData = baseVolume
	})
end)

RegisterNetEvent('fl_hifi:stopMusic')
AddEventHandler('fl_hifi:stopMusic', function(netId)
	if currentlyPlayingNetId ~= netId then return end
	currentlyPlayingNetId = nil

	SendNUIMessage({
		transactionType = 'stopSound'
	})
end)

RegisterNetEvent('fl_hifi:setVolume')
AddEventHandler('fl_hifi:setVolume', function(volume, netId)
	if currentlyPlayingNetId ~= netId then return end

	baseVolume = volume
	SendNUIMessage({
		transactionType = 'volume',
		transactionData = volume
	})
end)

RegisterNetEvent('fl_hifi:setDistance')
AddEventHandler('fl_hifi:setDistance', function(distance, netId)
	if currentlyPlayingNetId ~= netId then return end
	baseDistance = distance
end)

RegisterNUICallback('errorCallback', function(data, cb)
	local errorType = data.errorType

	if errorType == 2 then
		-- wrong video id
		ESX.ShowNotification('~r~ID de vidéo inconnu')
	elseif errorType == 5 then
		-- error html 5
		ESX.ShowNotification('~r~Lecteur HTML 5 inconnu')
	elseif errorType == 100 then
		-- doesn't exist
		ESX.ShowNotification('~r~Musique inconnue (Privée / Supprimée)')
	elseif errorType == 101 or errorType == 150 then
		ESX.ShowNotification('~r~Embed pas permis par youtube :/')
	else
		ESX.ShowNotification('~r~Erreur de lecture audio')
	end

	TriggerServerEvent('fl_hifi:stopMusic', currentData)
    cb('ok')
end)

function OpenHifiMenu()
	local elements = {
		{label = 'Ramasser la chaîne HiFi', value = 'get_hifi'},
	}

	if currentlyPlayingNetId ~= nil then
		table.insert(elements, {label = 'Régler le son', value = 'volume', rightLabel = baseVolume .. '%', description = "Changer la volume du son dans la zone d'écoute"})
		table.insert(elements, {label = 'Régler la distance', value = 'distance', rightLabel = baseDistance .. 'm', description = "Changer la distance à laquelle vous entendez la musique"})
		table.insert(elements, {label = 'Changer de musique', value = 'play', description = "Remplacer la musique en cours de lecture"})
		table.insert(elements, {label = 'Stopper la musique', value = 'stop', description = "Arrête la musique en cours"})
	else
		table.insert(elements, {label = 'Jouer de la musique', value = 'play', description = "Joue une musique sur youtube (mettre l'id du lien)"})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'hifi', {
		title   = 'Chaîne HiFi',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'get_hifi' then
				menu.close()
				PlayAnimation("anim@heists@narcotics@trash", "pickup")
				Citizen.Wait(700)

				TriggerServerEvent('fl_hifi:removeHifi', currentData)
				currentData = nil

				Citizen.Wait(500)
				ClearPedTasks(PlayerPedId())
		elseif data.current.value == 'play' then
			OpenPlaySongDialog()
		elseif data.current.value == 'stop' then
			TriggerServerEvent('fl_hifi:stopMusic', currentData)
			menu.close()
		elseif data.current.value == 'volume' then
			OpenVolumeDialog()
		elseif data.current.value == 'distance' then
			OpenDistanceDialog()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVolumeDialog()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setvolume', {
		title = 'Entrez le niveau du volume (entre 0 et 100)',
	}, function(data, menu)
		local value = tonumber(data.value)
		if value < 1 or value > 100 then
			ESX.ShowNotification('Le volume doit être entre 0 et 100')
		else
			TriggerServerEvent('fl_hifi:setVolume', value, currentData)
			ESX.UI.Menu.CloseAll()
			OpenHifiMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenDistanceDialog()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setdistance', {
		title = 'Entrez la distance max (entre 10 et 50)',
	}, function(data, menu)
		local value = tonumber(data.value)
		if value < 10 or value > 50 then
			ESX.ShowNotification('Le volume doit être entre 10 et 50')
		else
			TriggerServerEvent('fl_hifi:setDistance', value, currentData)
			ESX.UI.Menu.CloseAll()
			OpenHifiMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPlaySongDialog()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'play', {
		title = "https://www.youtube.com/watch?v=",
	}, function(data, menu)
		TriggerServerEvent('fl_hifi:playMusic', data.value, currentData)
		ESX.UI.Menu.CloseAll()
		OpenHifiMenu()
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		local object = GetClosestObjectOfType(coords, 3.0, `prop_boombox_01`, false, false, false)

		if DoesEntityExist(object) then
			local objCoords = GetEntityCoords(object)
			local distance  = #(coords - objCoords)

			if closestDistance == -1 or closestDistance > distance then
				closestDistance = distance
				closestEntity   = object
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if IsEntityAMissionEntity(closestEntity) then
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accèder à la chaîne hifi", false, false)
				if lastEntity ~= closestEntity and not ESX.UI.Menu.IsOpenNamespace(GetCurrentResourceName()) then
					lastEntity = closestEntity
					currentAction = "music"
					currentData = NetworkGetNetworkIdFromEntity(closestEntity)
				end
			end
		else
			if lastEntity then
				lastEntity = nil
				currentAction = nil
				currentData = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if currentlyPlayingNetId then
			if NetworkDoesEntityExistWithNetworkId(currentlyPlayingNetId) then
				local object = NetworkGetEntityFromNetworkId(currentlyPlayingNetId)

				SendNUIMessage({
					transactionType = 'volume',
					transactionData = baseVolume - (#(GetEntityCoords(object) - GetEntityCoords(PlayerPedId())) / baseDistance) * baseVolume
				})
			else
				currentlyPlayingNetId = nil
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if currentAction then
			if IsControlJustReleased(0, 38) and currentAction == 'music' then
				OpenHifiMenu()
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

function PlayAnimation(lib,anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	end)
end