local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
	for k,v in pairs(Config.ShopsBlips) do
		if v.Pos ~= nil then
			for i=1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i])

				SetBlipSprite(blip, v.Blip.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, 0.7)
				SetBlipColour(blip, v.Blip.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.Name)
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

for k,v in pairs(Config.Zones) do
	for _, Pos in pairs(v) do
		Citizen.CreateThread(function()
			local coords = nil
			local distance = 0

			while true do
				coords = GetEntityCoords(PlayerPedId())
				distance = #(coords - Pos)

				if distance < 15 then
					DrawMarker(Config.Type, Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color[k].r, Config.Color[k].g, Config.Color[k].b, 100, false, true, 2, false, false, false, false)
					Citizen.Wait(0)
				else
					Citizen.Wait(distance * 10)
				end
			end
		end)
	end
end

Citizen.CreateThread(function()
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil

	while true do
		Citizen.Wait(500)

		coords = GetEntityCoords(PlayerPedId())
		isInMarker = false
		currentZone = nil
		for k,v in pairs(Config.Zones) do
			for _, Pos in pairs(v) do
				if #(coords - Pos) < 1.5 then
					isInMarker  = true
					currentZone = k
				end
			end
		end
		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('fl_accessories:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('fl_accessories:hasExitedMarker')
		end

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and CurrentActionData.accessory then
				OpenAccessoryMenu(CurrentActionData.accessory)
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end

	end
end)

AddEventHandler('fl_accessories:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à la boutique'
	CurrentActionData = { accessory = zone }
end)

AddEventHandler('fl_accessories:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('esx:loadingScreenOff', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		for Name,Prefix in pairs(Config.Item) do
			if skin[string.lower(Name) .. '_1'] > 0 then
				local finded = false
				for k,v in ipairs(ESX.PlayerData.inventory) do
					if v.name == Prefix .. Config.ItemSep .. skin[string.lower(Name) .. '_1'] .. Config.ItemSep .. skin[string.lower(Name) .. '_2'] then
						finded = v.count > 0
					end
				end

				if finded then
					if Name == 'Bags' then
						TriggerServerEvent('esx:updateWeight', 'bag', true)
					end
				else
					TriggerEvent('fl_accessories:setAcc', Prefix, -1, 0)
				end
			end
		end
	end)
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if item.count > 0 then return end

	for Name,Prefix in pairs(Config.Item) do
		if string.starts(item.name, Prefix) then
			TriggerEvent('fl_accessories:setAcc', Prefix, -1, 0)
		end
	end
end)

AddEventHandler('fl_accessories:setAcc', function(accType, el1, el2)
	local zoneType = GetZoneTypeFromItem(accType)
	TriggerEvent('skinchanger:getSkin', function(skin)
		ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(playerSkin, jailSkin)
			local clothes = {}
			clothes[string.lower(zoneType) .. '_1'] = el1
			clothes[string.lower(zoneType) .. '_2'] = el2
			
			if accType == 'imask' then
				if el1 == -1 then
					skin['face'] = playerSkin['face']
				else
					skin['face'] = 0
				end
			end
			
			TriggerEvent('skinchanger:loadClothes', skin, clothes)
		end)
	end)

	if accType == 'ibag' then
		TriggerServerEvent('esx:updateWeight', 'bag', el1 > 0)
	end
end)

RegisterNetEvent('fl_accessories:useAcc')
AddEventHandler('fl_accessories:useAcc', function(item)
	local separatedName, el1, el2 = extractIdFromItem(item)
	local zoneType = GetZoneTypeFromItem(separatedName)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin[string.lower(zoneType) .. '_1'] > 0 then
			if separatedName == Config.Item['Mask'] then
				startAnimAction('missfbi4', 'takeoff_mask')
			elseif separatedName == Config.Item['Ears'] then
				startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
			elseif separatedName == Config.Item['Helmet'] then
				startAnimAction('missfbi4', 'takeoff_mask')
			elseif separatedName == Config.Item['Glasses'] then
				startAnimAction('clothingspecs', 'try_glasses_positive_a')
			elseif separatedName == Config.Item['Bags'] then
				startAnimAction('missfbi4', 'takeoff_mask')
			else
				error('Unknown accessory type from item : ' .. tostring(item))
			end

			Citizen.Wait(850)
			TriggerEvent('fl_accessories:setAcc', separatedName, -1, 0)
		else
			if separatedName == Config.Item['Mask'] then
				startAnimAction('mp_masks@on_foot', 'put_on_mask')
			elseif separatedName == Config.Item['Ears'] then
				startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
			elseif separatedName == Config.Item['Helmet'] then
				startAnimAction('mp_masks@on_foot', 'put_on_mask')
			elseif separatedName == Config.Item['Glasses'] then
				startAnimAction('clothingspecs', 'try_glasses_positive_a')
			elseif separatedName == Config.Item['Bags'] then
				startAnimAction('mp_masks@on_foot', 'put_on_mask')
			else
				error('Unknown accessory type from item : ' .. tostring(item))
			end
			Citizen.Wait(500)
			TriggerEvent('fl_accessories:setAcc', separatedName, el1, el2)
		end
	end)
end)

local elements = nil
local itemCategory = {}
local itemsPerCategory = {}

Citizen.CreateThread(function()
	for item,itemName in pairs(Config.Items) do
		if not string.find(itemName, 'ibag_52') then
			local separatedName, el1, el2 = extractIdFromItem(item)
			if itemCategory[separatedName] == nil then itemCategory[separatedName] = {} end
			if itemsPerCategory[separatedName] == nil then itemsPerCategory[separatedName] = {} end

			local categoryLabel = split(itemName, '(')[1]
			local serializedName = categoryLabel:gsub("%s+", "")
			if not itemsPerCategory[separatedName][serializedName] then
				table.insert(itemCategory[separatedName], {
					label = categoryLabel,
					separatedName = separatedName,
					serializedName = serializedName,
				})
				itemsPerCategory[separatedName][serializedName] = {}
			end

			table.insert(itemsPerCategory[separatedName][serializedName],
			{
				label = itemName,
				item = item,
			})

		end
	end

	for _,a in pairs(itemCategory) do
		for _, b in pairs(a) do
			local i = 0
			for _,_ in pairs(itemsPerCategory[b.separatedName][b.serializedName]) do
				i = i + 1
			end
			b.rightLabel = i
		end
	end

end)


function OpenAccessoryMenu(ZoneType)
	local separatedName = Config.Item[ZoneType]
	local _, _el1, _el2 = extractIdFromItem(itemsPerCategory[separatedName][itemCategory[separatedName][1].serializedName][1].item)
	SetPedAccessory(separatedName, _el1, _el2)
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'acc_categories',
	{
		title = 'Catégories (' .. tostring(#itemCategory[separatedName]) .. ')',
		elements = itemCategory[separatedName],
	}, function(categoryData, menu) --submit
		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'acc_menu',
		{
			title = 'Liste des accessoires',
			elements = itemsPerCategory[separatedName][categoryData.current.serializedName]
		}, function(data, menu) --submit
			ESX.TriggerServerCallback('fl_accessories:checkMoney', function(hasEnoughMoney)
				TriggerEvent('fl_accessories:setAcc', separatedName, -1, 0)

				if hasEnoughMoney then
					TriggerServerEvent('fl_accessories:pay', data.current.item)
				else
					ESX.ShowNotification('Vous n\'avez pas assez d\'argent.')
				end
			end)

			menu.close()
		end, function(data, menu) --cancel
			menu.close()
		end, function(data, menu) --change
			local separatedName, el1, el2 = extractIdFromItem(data.current.item)
			SetPedAccessory(separatedName, el1, el2)
		end, function(data, menu) --close
			TriggerEvent('fl_accessories:setAcc', separatedName, -1, 0)
		end)

	end, function(data, menu) --cancel
		menu.close()
	end, function(categoryData, menu) --change
		local separatedName, el1, el2 = extractIdFromItem(itemsPerCategory[separatedName][categoryData.current.serializedName][1].item)
		SetPedAccessory(separatedName, el1, el2)
	end, function(data, menu) --close
		TriggerEvent('fl_accessories:setAcc', separatedName, -1, 0)
		HasAlreadyEnteredMarker = false
	end)
end
