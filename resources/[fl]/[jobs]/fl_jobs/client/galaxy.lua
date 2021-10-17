local HasAlreadyEnteredMarker = false
local LastZone, CurrentAction = nil, nil
local CurrentActionMsg = ''
local CurrentActionData = {}

function OpenGalaxyActionsMenu()
	local elements = {
		{label = 'Tenue de travail', value = 'cloakroom'},
		{label = 'Tenue civile', value = 'cloakroom2'},
		{label = 'Déposer Stock', value = 'put_stock'},
		{label = 'Prendre Stock', value = 'get_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'galaxy_actions',
		{
			title = 'galaxy',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'cloakroom' then
				menu.close()
				ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
    				if skin.sex == 0 then
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
    				else
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
    				end
				end)
			elseif data.current.value == 'cloakroom2' then
				menu.close()
				ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
    				TriggerEvent('skinchanger:loadSkin', skin)
				end)
			elseif data.current.value == 'put_stock' then
    			TriggerEvent('fl_society:openPutStocksMenu', 'galaxy')
			elseif data.current.value == 'get_stock' then
				TriggerEvent('fl_society:openGetStocksMenu', 'galaxy')
			end
		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'galaxy_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end

AddEventHandler('fl_jobs:galaxy:hasEnteredMarker', function(zone)
	if zone == 'GalaxyActions' then
		CurrentAction = 'galaxy_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'BossActionsGalaxy' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_actions_galaxy_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu patron.'
		CurrentActionData = {}
	end
end)

AddEventHandler('fl_jobs:galaxy:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

CreateJobLoop('galaxy', function()
	local coords = GetEntityCoords(PlayerPedId())
	local sleep = true

	for k,v in pairs(Config.ZonesGalaxy) do
		if(v.Type ~= -1 and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance) then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			sleep = false
		end
	end

	if sleep then
		Citizen.Wait(500)
	end
end)

-- Enter / Exit marker events
CreateJobLoop('galaxy', function()
	Citizen.Wait(400)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil
	for k,v in pairs(Config.ZonesGalaxy) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
			isInMarker = true
			currentZone = k
		end
	end
	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('fl_jobs:galaxy:hasEnteredMarker', currentZone)
	end
	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_jobs:galaxy:hasExitedMarker', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(300)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'galaxy' then
		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mobile_galaxy_actions', {
			title = 'galaxy',
			elements = {
				{label = 'Facturation',    value = 'billing'},
			}
		}, function(data, menu)
			if data.current.value == 'billing' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Montant de la facture',
				}, function(data, menu)
					local amount = tonumber(data.value)
					if amount == nil then
						ESX.ShowNotification('Montant invalide')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification('Aucun joueur à proximité')
						else
							TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_galaxy', 'galaxy', amount)
						end
					end
				end, function(data, menu)
					menu.close()
				end)
			end

		end, function(data, menu)
			menu.close()
		end)
	end
end)

-- Key Controls
CreateJobLoop('galaxy', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'galaxy_actions_menu' then
				OpenGalaxyActionsMenu()
			elseif CurrentAction == 'boss_actions_galaxy_menu' then
				OpenBossActionsGalaxyMenu()
			end
			CurrentAction = nil
		end
	else
		Citizen.Wait(500)
	end
end)

function OpenBossActionsGalaxyMenu()
	ESX.UI.Menu.CloseAll()

	TriggerEvent('fl_society:openBossMenu', 'galaxy', function(data, menu)
		CurrentAction = 'boss_actions_galaxy_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
		menu.close()
	end)
end
