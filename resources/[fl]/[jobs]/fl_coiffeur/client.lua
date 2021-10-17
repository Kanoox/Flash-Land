local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local skinBefore = {}

function OpenShopMenu(targetServerId, skin)
	OpenMenu(targetServerId, skin,function(data, menu)
		menu.close()

		ESX.UI.Menu.Open(
			'native', GetCurrentResourceName(), 'shop_confirm',
			{
				title = 'Valider cette coiffure ?',
				elements = {
					{label = 'Non', value = 'no'},
					{label = 'Oui', value = 'yes'}
				}
			},
			function(data, menu)
				menu.close()

				if data.current.value == 'yes' then
					TriggerServerEvent("fl_coiffeur:save", targetServerId)
				elseif data.current.value == 'no' then
					ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				end

				CurrentAction = 'shop_menu'
				CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
				CurrentActionData = {}
			end, function(data, menu)
				menu.close()

				CurrentAction = 'shop_menu'
				CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
				CurrentActionData = {}
			end)

	end, function(data, menu)
			menu.close()

			CurrentAction = 'shop_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
	end, getLimitationByGrade())
end

AddEventHandler('fl_coiffeur:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
	CurrentActionData = {}
end)

AddEventHandler('fl_coiffeur:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips
Citizen.CreateThread(function()
	for i=1, #Config.Shops, 1 do
		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite(blip, 71)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 51)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Barbier')
		EndTextCommandSetBlipName(blip)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone = nil

		for i,Pos in pairs(Config.Shops) do
			if #(coords - Pos) < 1.5 then
				isInMarker = true
				currentZone = 'Shop_' .. (i + 1)
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('fl_coiffeur:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('fl_coiffeur:hasExitedMarker', LastZone)
		end
	end
end)

-- Key controls
CreateJobLoop('barber', function()
	local coords = GetEntityCoords(PlayerPedId())

	for _,Pos in pairs(Config.Shops) do
		if #(coords - Pos) < Config.DrawDistance then
			DrawMarker(1, Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
		end
	end

	for k,v in pairs(Config.Chests) do
		local distance = #(coords - vector3(v.x, v.y, v.z))
		if distance < Config.DrawDistance then
			DrawMarker(29, v.x, v.y, v.z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.8, 1.8, 1.8, 0, 120, 0, 100, false, true, 2, false, false, false, false)


			if distance < 2.0 then
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre.")

				if IsControlJustPressed(1, 38) then
					OpenBarberActionsMenu()
				end
			end

		end
	end

	if CurrentAction ~= nil then
		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then
			if CurrentAction == 'shop_menu' then
				local player, distance = ESX.Game.GetClosestPlayer()

				if player ~= -1 and distance < 3.0 then
					TriggerServerEvent("fl_coiffeur:getSkin", GetPlayerServerId(player))
					CurrentAction = nil
				else
					ESX.ShowNotification("~r~Il n'y a personne autour...")
					CurrentAction = 'shop_menu'
				end
			else
				print('Unknown currentAction')
				CurrentAction = nil
			end

		end
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'barber' then
		OpenMobileActionsMenu()
	end
end)

function getLimitationByGrade()
	local limitations = {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4'
	}

	if ESX.PlayerData.job.grade_name ~= "barbier" then
		table.insert(limitations, 'hair_1')
		table.insert(limitations, 'hair_2')
		table.insert(limitations, 'hair_color_1')
		table.insert(limitations, 'hair_color_2')
		table.insert(limitations, 'eyebrows_1')
		table.insert(limitations, 'eyebrows_2')
		table.insert(limitations, 'eyebrows_3')
		table.insert(limitations, 'eyebrows_4')
	end

	if ESX.PlayerData.job.grade_name == "boss" then
		table.insert(limitations, 'makeup_1')
		table.insert(limitations, 'makeup_2')
		table.insert(limitations, 'makeup_3')
		table.insert(limitations, 'makeup_4')
		table.insert(limitations, 'lipstick_1')
		table.insert(limitations, 'lipstick_2')
		table.insert(limitations, 'lipstick_3')
		table.insert(limitations, 'lipstick_4')
		table.insert(limitations, 'ears_1')
		table.insert(limitations, 'ears_2')
	end

	return limitations
end

function OpenMenu(targetPlayerId, skin, submitCb, cancelCb, restrict)
    local playerPed = PlayerPedId()

    TriggerEvent('skinchanger:getData', function(components, maxVals)
        local elements    = {}
        local _components = {}

        if restrict == nil then
            for i=1, #components, 1 do
                _components[i] = components[i]
            end
        else
            for i=1, #components, 1 do
                local found = false

                for j=1, #restrict, 1 do
                    if components[i].name == restrict[j] then
                        found = true
                    end
                end

                if found then
                    table.insert(_components, components[i])
                end
            end
        end

        for i=1, #_components, 1 do
            local value = _components[i].value
            local componentId = _components[i].componentId

            if componentId == 0 then
                value = GetPedPropIndex(playerPed, _components[i].componentId)
            end

            local items = {}

            for k, v in pairs(maxVals) do
                if k == _components[i].name then
                    _components[i].max = v
                    break
                end
            end

            for any = _components[i].min, _components[i].max do
                table.insert(items, any)
            end

            if _components[i].max < _components[i].min then
                table.insert(items, _components[i].min)
            end

            local data = {
                label = _components[i].label,
                name = _components[i].name,
                index = value + 1,
                textureof = _components[i].textureof,
                zoomOffset = _components[i].zoomOffset,
                camOffset = _components[i].camOffset,
                min = _components[i].min,
                type = 'list',
                items = items,
            }

            table.insert(elements, data)
        end

        ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'skin', {
            title    = 'Menu Coiffeur',
            elements = elements
        }, function(data, menu)
            submitCb(data, menu)
        end, function(data, menu)
            menu.close()
			TriggerServerEvent("fl_coiffeur:resetSkin", targetPlayerId)
            if cancelCb ~= nil then
                cancelCb(data, menu)
            end
        end, function(data, menu)
            local components, maxVals

			if skin[data.current.name] ~= data.current.items[data.current.index] then
				TriggerServerEvent("fl_coiffeur:change", targetPlayerId, data.current.name, data.current.items[data.current.index])

				-- Update max values
				TriggerEvent('skinchanger:getData', function(components, maxVals)
					for i = 1, #data.elements do
						local newData = {}

						local items = {}

						for any = data.elements[i].min, maxVals[data.elements[i].name] do
							table.insert(items, any)
						end

						if maxVals[data.elements[i].name] < data.elements[i].min then
							table.insert(items, data.elements[i].min)
						end

						newData.items = items

						if data.elements[i].textureof ~= nil and data.current.name == data.elements[i].textureof then
							newData.index = 1
						end

						menu.update({ name = data.elements[i].name }, newData)
					end
				end)
            end
        end, function(data, menu)
        end)
    end)
end

RegisterNetEvent("fl_coiffeur:setSkin")
AddEventHandler("fl_coiffeur:setSkin", function(skin, target)
	print('[fl_coiffeur:setSkin] ' .. tostring(target))
	OpenShopMenu(target, skin)
end)

RegisterNetEvent("fl_coiffeur:resetSkin")
AddEventHandler("fl_coiffeur:resetSkin", function()
	TriggerEvent('skinchanger:loadSkin', skinBefore)
end)

RegisterNetEvent("fl_coiffeur:getSkin")
AddEventHandler("fl_coiffeur:getSkin", function(target)
	print('[fl_coiffeur:getSkin] ' .. tostring(target))
	TriggerEvent('skinchanger:getSkin', function(skin)
		skinBefore = skin
		TriggerServerEvent('fl_coiffeur:setSkin', skin, target)
	end)
end)

RegisterNetEvent("fl_coiffeur:change")
AddEventHandler("fl_coiffeur:change", function(name, value)
	print('fl_coiffeur:change : ' .. tostring(name) .. ' | ' .. tostring(value))
	TriggerEvent('skinchanger:change', name, value)
end)

RegisterNetEvent("fl_coiffeur:save")
AddEventHandler("fl_coiffeur:save", function()
	print('[fl_coiffeur:save]')
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('fl_skin:save', skin)
	end)
end)

function OpenBarberActionsMenu()
	local elements = {
	  {label = "Déposer Stock", value = 'put_stock'},
	  {label = 'Prendre Stock', value = 'get_stock'},
	}

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss'  then
		table.insert(elements, {label = "Actions boss", value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'native', GetCurrentResourceName(), 'barber_actions',
	  {
		title    = "Coiffeur",
		elements = elements
	  },
	  function(data, menu)

		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'barber')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'barber')
		elseif data.current.value == 'boss_actions' then
		  TriggerEvent('fl_society:openBossMenu', 'barber', function(data, menu)
			menu.close()
		  end)
		end

	  end,
	  function(data, menu)
		menu.close()
	  end
	)
end

function OpenMobileActionsMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'native', GetCurrentResourceName(), 'mobile_tattoo_actions',
	{
		title    = "Coiffeur",
		elements = {
			{label = "Facture",    value = 'billing'},
		}
	},
	function(data, menu)
		if data.current.value == 'billing' then
			ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'billing',
			{
				title = "Quantité"
			},
			function(data, menu)
				local amount = tonumber(data.value)
				if amount == nil then
					ESX.ShowNotification("Montant invalide")
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification("Pas de joueur autours")
					else
						TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_barber', "Coiffeur", amount)
					end
				end
			end,
			function(data, menu)
				menu.close()
			end
			)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end
