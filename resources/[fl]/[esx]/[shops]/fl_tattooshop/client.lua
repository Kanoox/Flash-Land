local currentTattoos, cam, CurrentActionData = {}, -1, {}
local HasAlreadyEnteredMarker, CurrentAction, CurrentActionMsg

AddEventHandler('skinchanger:modelLoaded', function()
	ESX.TriggerServerCallback('fl_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k, v in pairs(tattooList) do
				ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
			end

			currentTattoos = tattooList
		end
	end)
end)

RegisterCommand('reload', function()
	ESX.TriggerServerCallback('fl_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k, v in pairs(tattooList) do
				ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
			end
			currentTattoos = tattooList
		end
	end)
end)

function OpenShopMenu(targetId, skin, playerCurrentTattoos)
	local elements = {}

	for k, v in pairs(Config.TattooCategories) do
		table.insert(elements, {label = v.name, value = v.value})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'tattoo_shop',
		{
			title = _U('tattoos'),
			elements = elements
		},
		function(data, menu)
			local currentLabel, currentValue = data.current.label, data.current.value

			if data.current.value then
				elements = {{label = _U('go_back_to_menu'), value = nil}}

				for k, v in pairs(Config.TattooList[data.current.value]) do
					table.insert(
						elements,
						{
							label = _U('tattoo_item', k),
							rightLabel = '$' .. ESX.Math.GroupDigits(v.price),
							rightLabelColor = 'green',
							value = k,
							price = v.price
						}
					)
				end

				ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'tattoo_shop_categories', {
					title = _U('tattoos') .. ' | ' .. currentLabel,
					elements = elements
				}, function(data2, menu2)
					local price = data2.current.price
					if data2.current.value ~= nil then
						TriggerServerEvent('fl_tattooshop:purchaseTattoo', playerCurrentTattoos, targetId, {collection = currentValue, texture = data2.current.value})
					else
						OpenShopMenu(targetId, skin, playerCurrentTattoos)
						TriggerServerEvent('fl_tattooshop:resetSkin', targetId)
					end
				end, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('fl_tattooshop:setPedSkin', targetId)
				end, function(data2, menu2)
					if data2.current.value ~= nil then
						TriggerServerEvent('fl_tattooshop:change', targetId, currentValue, data2.current.value)
					end
				end)
			end
		end,
		function(data, menu)
			menu.close()
			TriggerServerEvent('fl_tattooshop:setPedSkin', targetId)
		end)
end

Citizen.CreateThread(function()
	for k, v in pairs(Config.Zones) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 75)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('tattoo_shop'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local sleep = true
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(Config.Zones) do
			if Config.Type ~= -1 and #(coords - v) < Config.DrawDistance then
				sleep = false
				DrawMarker(Config.Type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'tattoo' then
			for k, v in pairs(Config.Chests) do
				local distance = #(coords - vector3(v.x, v.y, v.z))
				if distance < Config.DrawDistance then
					sleep = false
					DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)

					if distance < 2.0 then
						ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre.')

						if IsControlJustPressed(1, 38) then
							OpentattooActionsMenu()
						end
					end
				end
			end
		end

		if sleep then
			Citizen.Wait(1000)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone, LastZone

		for k, v in pairs(Config.Zones) do
			if #(coords - v) < Config.Size.x then
				isInMarker = true
				currentZone = 'TattooShop'
				LastZone = 'TattooShop'
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('fl_tattooshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('fl_tattooshop:hasExitedMarker', LastZone)
		end
	end
end)

AddEventHandler('fl_tattooshop:hasEnteredMarker', function(zone)
	if zone == 'TattooShop' then
		CurrentAction = 'tattoo_shop'
		CurrentActionMsg = _U('tattoo_shop_prompt')
		CurrentActionData = {zone = zone}
	end
end)

AddEventHandler('fl_tattooshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'tattoo' then
		OpenMobileActionsMenu()
	end
end)

-- Key Controls
CreateJobLoop('tattoo', function()
	if CurrentAction then
		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then
			local player, distance = ESX.Game.GetClosestPlayer()
			player = GetPlayerServerId(player)

			if player ~= -1 and distance < 3.0 then
				TriggerServerEvent('fl_tattooshop:getSkin', player)
				CurrentAction = nil
			else
				ESX.ShowNotification("~r~Il n'y a personne autour")
			end
		end

		if IsControlJustReleased(0, 10) then
			TriggerServerEvent('fl_tattooshop:getSkin', GetPlayerServerId(PlayerId()))
			CurrentAction = nil
		end
	end
end)

function setPedSkin()
	ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
			local model = nil

			if skin.sex == 0 then
				model = `mp_m_freemode_01`
			else
				model = `mp_f_freemode_01`
			end

			ESX.Streaming.RequestModel(model)

			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)

			TriggerEvent('skinchanger:loadSkin', skin)
			TriggerEvent('esx:restoreLoadout')
		end)

	Citizen.Wait(1000)

	for k, v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end

function drawTattoo(current, collection)
	ClearPedDecorations(PlayerPedId())

	for k, v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end

	TriggerEvent(
		'skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent(
					'skinchanger:loadSkin',
					{
						sex = 0,
						tshirt_1 = 15,
						tshirt_2 = 0,
						arms = 15,
						torso_1 = 91,
						torso_2 = 0,
						pants_1 = 14,
						pants_2 = 0
					}
				)
			else
				TriggerEvent(
					'skinchanger:loadSkin',
					{
						sex = 1,
						tshirt_1 = 34,
						tshirt_2 = 0,
						arms = 15,
						torso_1 = 101,
						torso_2 = 1,
						pants_1 = 16,
						pants_2 = 0
					}
				)
			end
		end)

	ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(Config.TattooList[collection][current].nameHash))
end

function cleanPlayer()
	ClearPedDecorations(PlayerPedId())

	for k, v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end

RegisterNetEvent('fl_tattooshop:getSkin')
AddEventHandler('fl_tattooshop:getSkin', function(target)
	TriggerEvent('skinchanger:getSkin', function(skin)
		skinBefore = skin
		TriggerServerEvent('fl_tattooshop:setSkin', skin, target, currentTattoos)
	end)
end)

RegisterNetEvent('fl_tattooshop:setSkin')
AddEventHandler('fl_tattooshop:setSkin', function(target)
	TriggerEvent('skinchanger:setSkin', function(skin)
		skinBefore = skin
		TriggerServerEvent('fl_tattooshop:setSkin', skin, target, currentTattoos)
	end)
end)

RegisterNetEvent('fl_tattooshop:change')
AddEventHandler('fl_tattooshop:change', function(collection, name)
	drawTattoo(name, collection)
end)

RegisterNetEvent('fl_tattooshop:resetSkin')
AddEventHandler('fl_tattooshop:resetSkin', function()
	cleanPlayer()
	ESX.TriggerServerCallback('fl_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k, v in pairs(tattooList) do
				ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
			end

			currentTattoos = tattooList
		end
	end)
end)

RegisterNetEvent('fl_tattooshop:setPedSkin')
AddEventHandler('fl_tattooshop:setPedSkin', function()
	setPedSkin()
	ESX.TriggerServerCallback('fl_tattooshop:requestPlayerTattoos', function(tattooList)
			if tattooList then
				for k, v in pairs(tattooList) do
					ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
				end

				currentTattoos = tattooList
			end
		end)
end)

RegisterNetEvent('fl_tattooshop:setSkin')
AddEventHandler('fl_tattooshop:setSkin', function(skin, targetId, playerCurrentTattoos)
	OpenShopMenu(targetId, skin, playerCurrentTattoos)
end)

function OpentattooActionsMenu()
	local elements = {
		{label = 'Déposer Stock', value = 'put_stock'}
	}

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = 'Prendre Stock', value = 'get_stock'})
		table.insert(elements, {label = 'Actions boss', value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native',
		GetCurrentResourceName(),
		'tattoo_actions',
		{
			title = 'Tatoueur',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'put_stock' then
				TriggerEvent('fl_society:openPutStocksMenu', 'tattoo')
			elseif data.current.value == 'get_stock' then
				TriggerEvent('fl_society:openGetStocksMenu', 'tattoo')
			elseif data.current.value == 'boss_actions' then
				TriggerEvent('fl_society:openBossMenu', 'tattoo', function(data, menu)
					menu.close()
				end)
			end
		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'tattoo_actions_menu'
			CurrentActionMsg = _U('open_actions')
			CurrentActionData = {}
		end)
end

function OpenMobileActionsMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'native',
		GetCurrentResourceName(),
		'mobile_tattoo_actions',
		{
			title = 'Tatoueur',
			elements = {
				{label = 'Facture', value = 'billing'}
			}
		},
		function(data, menu)
			if data.current.value == 'billing' then
				ESX.UI.Menu.Open(
					'dialog',
					GetCurrentResourceName(),
					'billing',
					{
						title = _U('invoice_amount')
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification('Montant invalide')
						else
							menu.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Pas de joueur autours')
							else
								TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_tattoo', 'Tatoueur', amount)
							end
						end
					end,
					function(data, menu)
						menu.close()
					end)
			end
		end,
		function(data, menu)
			menu.close()
		end)
end
