local SearchingPlayer = nil
local DistanceSearching = 2.0

RegisterCommand('+menufactions', function()
	OpenBanditsMenu()
end, false)
RegisterCommand('-menufactions', function() end, false)

Citizen.CreateThread(function()
	while true do
		if SearchingPlayer then
			local playerPed = PlayerPedId()
			local SearchingPed = GetPlayerPed(SearchingPlayer)
			if not DoesEntityExist(SearchingPed) then
				ESX.ShowNotification('~r~Il n\'y a personne...')
				SearchingPlayer = nil
				ESX.UI.Menu.CloseAll()
			elseif #(GetEntityCoords(playerPed) - GetEntityCoords(SearchingPed)) > DistanceSearching then
				ESX.ShowNotification('~r~La personne est trop loin...')
				SearchingPlayer = nil
				ESX.UI.Menu.CloseAll()
			end
		end
		Citizen.Wait(1000)
	end
end)

function OpenBanditsMenu()
	if ESX.IsPlayerDead() then return end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'actions', {
		title = 'Interaction',
		elements = {
			
			{label = 'Interaction Animal', value = 'animal'},
		},
	}, function(data, menu)
		if data.current.value == 'animal' then
			TriggerEvent('fl_animals:openPetMenu')
		elseif data.current.value == 'citizen_interaction' then
			local elementsCitizen = {
				{label = 'Faire les poches', value = 'body_search'},
				{label = 'Vérifier la carte sim', value = 'verify_simcard'},
				{label = 'Enlever le masque', value = 'remove_mask'},
			}

			for _,item in pairs(ESX.GetPlayerData().inventory) do
				if item.name == 'mower' and item.count > 0 then
					table.insert(elementsCitizen, {label = 'Raser la tête', value = 'mow_head'})
				end
			end

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'citizen_interaction', {
					title = 'Interaction',
					description = 'Victime',
					elements = elementsCitizen,
				},
				function(data2, menu2)
					local player, distance = ESX.Game.GetClosestPlayer()

					if distance ~= -1 and distance <= DistanceSearching then
						if data2.current.value == 'body_search' then
							TriggerEvent('fl_factions:bodySearch', player)
						elseif data2.current.value == 'verify_simcard' then
							TriggerEvent('fl_factions:verifySimcard', player)
						elseif data2.current.value == 'remove_mask' then
							TriggerServerEvent('3dme:shareDisplay', '*La personne lui enlève le masque*')
							TriggerServerEvent('fl_accessories:removeMaskOf', GetPlayerServerId(player))
						elseif data2.current.value == 'mow_head' then
							TriggerServerEvent('fl_factions:mowHead', GetPlayerServerId(player))
						else
							print('Unknown action menu')
						end
					else
						ESX.ShowNotification('~r~Aucun joueur à proximité')
					end
				end,
				function(data2, menu2)
					menu2.close()
				end)
		end
	end,
	function(data, menu)
		menu.close()
	end
	)
end

RegisterNetEvent('fl_factions:mowMyHead')
AddEventHandler('fl_factions:mowMyHead', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		skin.hair_1 = 0
		skin.hair_2 = 0
		TriggerEvent('skinchanger:loadSkin', skin)
		TriggerServerEvent('fl_skin:save', skin)
	end)
end)

AddEventHandler('fl_factions:verifySimcard', function(player)
	TriggerServerEvent('3dme:shareDisplay', '*La personne vérifie la présence d\'une sim*')
	ESX.TriggerServerCallback('fl_simcard:hasSimcard', function(hasSimcard)
		if hasSimcard then
			ESX.ShowNotification('~g~L\'individu a bien une carte sim dans son téléphone')
		else
			ESX.ShowNotification('~g~L\'individu n\'a pas de carte sim dans son téléphone')
		end
	end, GetPlayerServerId(player))
end)

AddEventHandler('fl_factions:bodySearch', function(player)
	SearchingPlayer = player
	OpenBodySearchMenu(SearchingPlayer)
end)

function OpenBodySearchMenu(player)
	if IsEntityVisible(PlayerPedId()) then
		TriggerServerEvent('3dme:shareDisplay', '*La personne fouille*')
	end

	ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'money' then
				table.insert(elements, {
					label = 'Confisquer argent : $' .. data.accounts[i].money,
					name = '$' .. data.accounts[i].money,
					value = data.accounts[i].name,
					itemType = 'item_account',
					amount = data.accounts[i].money
				})
			elseif data.accounts[i].name == 'black_money' then
				table.insert(elements, {
					label = 'Confisquer argent sale : $' .. data.accounts[i].money,
					name = '$' .. data.accounts[i].money,
					value = data.accounts[i].name,
					itemType = 'item_account',
					amount = data.accounts[i].money
				})
			end
		end

		table.insert(elements, {label = '___ Inventaire ___', value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label = 'Confisquer x' .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
					name =  data.inventory[i].label,
					rightLabel = 'x' .. data.inventory[i].count,
					value = data.inventory[i].name,
					itemType = 'item_standard',
					amount = data.inventory[i].count,
				})
			end
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'body_search', {
				title = 'Faire les poches',
				elements = elements,
			}, function(data, menu)
				if not data.current.value then return end

				local itemType = data.current.itemType
				local itemLabel = data.current.label
				local itemLabelName = data.current.name
				local itemName = data.current.value
				local amount = data.current.amount

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'consfiscate_dialog', {
					title = 'Nombre à confisquer'
				}, function(data, dialogMenu)
						local dialogAmount = tonumber(data.value)

						if dialogAmount == nil then
							ESX.ShowNotification('~r~Montant invalide...')
						elseif dialogAmount <= amount then
							TriggerServerEvent('fl_faction:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, dialogAmount)
							TriggerServerEvent('3dme:shareDisplay', '*La personne confisque  x' .. dialogAmount .. ' ' .. itemLabelName .. '*')
							Citizen.Wait(200)
							ESX.UI.Menu.CloseAll()
							Citizen.Wait(200)
							OpenBodySearchMenu(player)
						else
							ESX.ShowNotification('~r~La personne n\'a pas autant d\'objets...')
						end
					end, function(data, menu)
					menu.close()
				end)
			end, function(data, menu)
				SearchingPlayer = nil
				menu.close()
			end)
	end, GetPlayerServerId(player))

end