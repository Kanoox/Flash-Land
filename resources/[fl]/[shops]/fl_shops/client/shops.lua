local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
	Citizen.Wait(5000)

	ESX.TriggerServerCallback('fl_shops:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			Config.Zones[k].Items = v
		end
	end)
end)

function OpenShopMenu(zone)
	ESX.TriggerServerCallback('fl_shops:IsFoodSellerOnline', function(isOnline)
		local elements = {}
		for i=1, #Config.Zones[zone].Items, 1 do
			local item = Config.Zones[zone].Items[i]

			if item.limit == -1 then
				item.limit = 100
			end

			local multi = 1
			if isOnline then
				multi = Config.MultiplierFoodSeller
			end

			local items = {}

			for i = 1, 10 do
				table.insert(items, i)
			end

			table.insert(elements, {
				label = item.label .. ' ~g~' .. '$' .. ESX.Math.GroupDigits(item.price * multi),
				label_real = item.label,
				item = item.item,
				price = item.price * multi,

				type = 'list',
				items = items,
			})
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'shop', {
			title = 'Magasin',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'shop_confirm', {
				title = 'Acheter ' .. data.current.index .. 'x ' .. data.current.label_real .. ' pour $' .. ESX.Math.GroupDigits(data.current.price * data.current.index) .. ' ?',
				elements = {
					{label = 'Payer en Espèces', value = 'yes'},
					{label = 'Payer par CB', value = 'yes2'}
				}
			}, function(data2, menu2)
				if data2.current.value == 'yes' then
					TriggerServerEvent('fl_shops:buyItem', 'money', data.current.item, data.current.index, zone)
				elseif data2.current.value == 'yes2' then
					ESX.TriggerServerCallback('fl_billing:hasTooManyBills', function(hasTooManyBills)
						if hasTooManyBills then
							ESX.ShowNotification('~r~La banque vous interdit les retraits avec autant d\'impayé !')
							return
						end
						TriggerServerEvent('fl_shops:buyItem', 'bank', data.current.item, data.current.index, zone)
					end)
				end

				menu2.close()
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()

			CurrentAction = 'shop_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin'
			CurrentActionData = {zone = zone}
		end)
	end)
end

AddEventHandler('fl_shops:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin'
	CurrentActionData = {zone = zone}
end)

AddEventHandler('fl_shops:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(#(coords - vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)) < Config.Size.x) then
					isInMarker = true
					ShopItems = v.Items
					currentZone = k
					LastZone = k
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('fl_shops:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('fl_shops:hasExitedMarker', LastZone)
		end

		if not isInMarker then
			Citizen.Wait(200)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = true
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if #(v.Pos[i]  - playerCoords) < 20 then
					sleep = false
					DrawMarker(29, v.Pos[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 0, 10, false, true, 2, false, false, false, false)
				end
			end
		end

		if sleep then
			Citizen.Wait(500)
		end

		Citizen.Wait(0)
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)