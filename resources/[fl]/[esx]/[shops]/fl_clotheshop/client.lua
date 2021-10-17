local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local HasPayed = false
local HasLoadCloth = false

-- Create Blips
Citizen.CreateThread(function()
	for i = 1, #Config.Shops, 1 do
		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite(blip, 73)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, 47)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('clothes'))
		EndTextCommandSetBlipName(blip)
	end
end)

function SaveThisSkin()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('fl_skin:save', skin)
	end)
end

function RollbackSkin()
	ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

function SaveThisOutfit(name)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('fl_eden_clotheshop:saveOutfit', name, skin)
	end)
end

function OpenShopMenu()
	local elements = {}

	table.insert(elements, {label = 'Changer de tenue ', value = 'player_dressing'})
	table.insert(elements, {label = 'Magasin de vêtements', rightLabel = '$100', rightLabelColor = 'green', value = 'shop_clothes'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'shop_main', {
			title = 'Magasin vêtement',
			description = 'Que souhaitez vous faire ?',
			elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'shop_clothes' then
			OpenShopClothes()
		elseif data.current.value == 'player_dressing' then
			OpenPlayerDressing()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'room_menu'
		CurrentActionMsg = _U('press_menu')
		CurrentActionData = {}
	end)
end

function OpenPlayerDressing()
	print('OpenPlayerDressing()')
	ESX.TriggerServerCallback('fl_eden_clotheshop:getPlayerDressing', function(dressing)
		local elements = {}

		for i, AnyTenue in pairs(dressing) do
			table.insert(elements, {label = AnyTenue, value = i})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'player_dressing',
		{
			title = 'Garde robe',
			elements = elements
		},
		function(data, menu)
			ManageOutfit(data.current.value, data.current.label)
		end,
		function(data, menu)
			menu.close()

			CurrentAction = 'shop_menu'
			CurrentActionMsg = _U('press_menu')
			CurrentActionData = {}
		end)
	end)
end

function ManageOutfit(outfitIndex, outfitName)
	print('ManageOutfit(' .. tostring(outfitIndex) .. ')')
	if outfitName == nil then outfitName = 'N°' .. outfitIndex end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'manage_outfit',
	{
		title = 'Tenue : ' .. tostring(outfitName),
		elements = {
			{label = 'Mettre la tenue', value = 'grab'},
			{label = 'Renommer', value = 'rename'},
			{label = 'Editer', value = 'edit'},
			{label = 'Supprimer', value = 'remove'},
		}
	},
	function(data, menu)
		if data.current.value == 'grab' then
			GrabOutfit(outfitIndex)
			menu.close()
		elseif data.current.value == 'rename' then
			OpenRenameMenuOutfit(outfitIndex, function()
				menu.close()
				ESX.UI.Menu.Close('native', GetCurrentResourceName(), 'player_dressing')
				OpenPlayerDressing()
			end)
		elseif data.current.value == 'remove' then
			menu.close()
			ConfirmDeletion(outfitIndex)
		elseif data.current.value == 'edit' then
			GrabOutfit(outfitIndex, function()
				OpenShopClothes({ outfitIndex = outfitIndex, outfitName = outfitName })
			end)
		else
			print('Unknown action : ' .. tostring(data.current.value))
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function ConfirmDeletion(outfitIndex)
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'confirm',
	{
		title = 'Êtes-vous sûr de supprimer ?',
		elements = {
			{label = 'Non', value = 'no'},
			{label = 'Oui', value = 'yes'},
		}
	},
	function(dataConfirm, menuConfirm)
		menuConfirm.close()
		if dataConfirm.current.value == 'yes' then
			DeleteOutfit(outfitIndex)
			ESX.UI.Menu.Close('native', GetCurrentResourceName(), 'player_dressing')
			OpenPlayerDressing()
			ESX.ShowNotification('~r~Vous avez supprimé votre tenue ! (' .. tostring(outfitIndex) .. ')')
		else
			ESX.ShowNotification('~g~Suppression annulée')
		end
	end,
	function(dataConfirm, menuConfirm)
		menuConfirm.close()
	end)
end

function OpenRenameMenuOutfit(outfitIndex, cb)
	print('OpenRenameMenuOutfit(' .. tostring(outfitIndex) .. ')')
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', { title = 'Renommer votre tenue' },
	function(data, menu)
		menu.close()
		ESX.ShowNotification('Vous avez renommé votre tenue en ' .. tostring(data.value))
		TriggerServerEvent('fl_eden_clotheshop:renameOutfit', outfitIndex, data.value)
		Citizen.Wait(100)
		if cb ~= nil then cb() end
	end,
	function(data, menu)
		menu.close()
	end)
end

function DeleteOutfit(outfitIndex)
	print('DeleteOutfit(' .. tostring(outfitIndex) .. ')')
	TriggerServerEvent('fl_eden_clotheshop:deleteOutfit', outfitIndex)
end

function GrabOutfit(outfitIndex, cb)
	print('GrabOutfit(' .. tostring(outfitIndex) .. ')')
	TriggerEvent('skinchanger:getSkin', function(skin)
		ESX.TriggerServerCallback('fl_eden_clotheshop:getPlayerOutfit',
			function(clothes)
				TriggerEvent('skinchanger:loadClothes', skin, clothes)
				TriggerEvent('fl_skin:setLastSkin', skin)
				SaveThisSkin()

				ESX.ShowNotification(_U('loaded_outfit'))
				HasLoadCloth = true
				if cb ~= nil then cb() end
		end, outfitIndex)
	end)
end

function OpenShopClothes(editingData)
	HasPayed = false

	TriggerEvent('fl_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		BuyCurrentOutfit(editingData)
	end, function(data, menu)
		menu.close()

		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('press_menu')
		CurrentActionData = {}
	end, {
	 'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2',
	 'decals_1', 'decals_2', 'pants_1', 'pants_2',
	 'shoes_1', 'shoes_2', 'chain_1', 'chain_2',
	 'arms'
	})
end

function BuyCurrentOutfit(editingData)
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'shop_confirm', {
		title = _U('valid_this_purchase'),
		elements = {
			{label = 'Payer', value = 'yes'},
			{label = 'Annuler', value = 'no'},
		}
	}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('fl_eden_clotheshop:checkMoney', function(hasEnoughMoney)
				if not hasEnoughMoney then
					RollbackSkin()
					ESX.ShowNotification(_U('not_enough_money'))
					return
				end

				SaveThisSkin()
				Citizen.Wait(100)
				TriggerServerEvent('fl_eden_clotheshop:pay')
				HasPayed = true

				if editingData ~= nil then
					DeleteOutfit(editingData.outfitIndex)
					SaveThisOutfit(editingData.outfitName)
					ESX.ShowNotification('~g~Tenue sauvegardée !')
					return
				else
					ESX.ShowNotification('~g~Vous avez acheté une nouvelle tenue')
				end

				ESX.TriggerServerCallback('fl_eden_clotheshop:checkPropertyDataStore', function(foundStore)
					if not foundStore then return end
					ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'save_dressing',
						{
							title = _U('save_in_dressing'),
							elements = {
								{label = ('Sauvegarder dans la garde robe'), value = 'yes'},
								{label = ('Annuler'), value = 'no'}
							}
						},
						function(saveData, saveMenu)
							saveMenu.close()

							if saveData.current.value == 'yes' then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', { title = _U('name_outfit') },
								function(data3, menu3)
									menu3.close()
									SaveThisOutfit(data3.value)
									ESX.ShowNotification('Vous avez sauvegardé une nouvelle tenue')
								end,
								function(data3, menu3)
									menu3.close()
								end)
							end
						end)
				end)
			end)
		elseif data.current.value == 'no' then
			RollbackSkin()
		end

		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('press_menu')
		CurrentActionData = {}
	end, function(data, menu)
		menu.close()

		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('press_menu')
		CurrentActionData = {}
	end)
end

AddEventHandler('fl_eden_clotheshop:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = _U('press_menu')
	CurrentActionData = {}
end)

AddEventHandler('fl_eden_clotheshop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

	if not HasPayed and not HasLoadCloth then
		RollbackSkin()
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local sleep = true
		local isInMarker = false
		local currentZone = nil

		for _, ShopPos in pairs(Config.Shops) do
			local distance = #(coords - ShopPos)
			if distance < 15.0 then
				DrawMarker(Config.MarkerType,
					ShopPos.x, ShopPos.y, ShopPos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,
					Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z,
					Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				sleep = false

				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('fl_eden_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('fl_eden_clotheshop:hasExitedMarker', LastZone)
		end

		if sleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustPressed(0, 38) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(300)
		end
	end
end)

-- Property & other

AddEventHandler('fl_clotheshop:openNonEditableDessing', function()
	local elements = {}

	table.insert(elements, {label = _U('add_cloth'), value = 'player_dressing'})
	table.insert(elements, {label = _U('remove_cloth'), value = 'remove_cloth'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'room', {
		title = 'Garde robe',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('fl_eden_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'player_dressing', {
					title = 'Garde robe',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('fl_eden_clotheshop:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('fl_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('fl_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then
			ESX.TriggerServerCallback('fl_eden_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'remove_cloth', {
					title = 'Garde robe - ' .. _U('remove_cloth'),
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('fl_eden_clotheshop:removeOutfit', data2.current.value)
					ESX.ShowNotification(_U('removed_cloth'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end)