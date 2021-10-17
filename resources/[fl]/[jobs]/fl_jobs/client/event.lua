local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

function OpenEventActionsMenu()
	local elements = {
		{label = 'Déposer Stock', value = 'put_stock'},
		{label = 'Prendre Stock', value = 'get_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'actions',
		{
			title = 'Evenementiel',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'put_stock' then
				TriggerEvent('fl_society:openPutStocksMenu', 'event')
			end

			if data.current.value == 'get_stock' then
				TriggerEvent('fl_society:openGetStocksMenu', 'event')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
		)
end

function OpenMobileEventActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'mobile_actions',
		{
			title = 'Evenementiel',
			elements = {
				{label = 'Facturation',    value = 'billing'},
			}
		},
		function(data, menu)

			if data.current.value == 'billing' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing_menu',
					{
						title = 'Montant de la facture'
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification('Montant invalide')
							return
						end
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification('Aucun joueur à proximité')
							return
						end

						TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_event', 'Evenementiel', amount)
					end,
					function(data, menu)
						menu.close()
					end
					)
			end

		end,
		function(data, menu)
			menu.close()
		end
		)
end

AddEventHandler('fl_jobs:hasEnteredMarkerEvent', function(zone)
	if zone == 'Actions' then
		CurrentAction = 'actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'BossActions' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu patron.'
		CurrentActionData = {}
	end
end)

AddEventHandler('fl_jobs:hasExitedMarkerEvent', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Display markers
CreateJobLoop('event', function()
	local sleep = true
	local coords = GetEntityCoords(PlayerPedId())

	for k,v in pairs(Config.ZonesEvent) do
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
CreateJobLoop('event', function()
	Citizen.Wait(400)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil
	for k,v in pairs(Config.ZonesEvent) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
			isInMarker = true
			currentZone = k
		end
	end
	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('fl_jobs:hasEnteredMarkerEvent', currentZone)
	end
	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_jobs:hasExitedMarkerEvent', LastZone)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'event' then
		OpenMobileEventActionsMenu()
	end
end)

-- Key Controls

CreateJobLoop('event', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if IsControlJustReleased(0, 38) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'event' then
			if CurrentAction == 'actions_menu' then
				OpenEventActionsMenu()
			elseif CurrentAction == 'boss_actions_menu' then
				OpenBossEventActionsMenu()
			end
			CurrentAction = nil
		end
	else
		Citizen.Wait(500)
	end
end)

function OpenBossEventActionsMenu()
	local elements = {
		{label = 'Déposer Stock', value = 'put_stock'},
		{label = 'Prendre Stock', value = 'get_stock'},
		{label = '---------------', value = nil},
		{label = 'Action Patron', value = 'boss_actions'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'boss_actions',
		{
			title = 'Boss',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'put_stock' then
				TriggerEvent('fl_society:openPutStocksMenu', 'event')
			elseif data.current.value == 'get_stock' then
				TriggerEvent('fl_society:openGetStocksMenu', 'event')
			elseif data.current.value == 'boss_actions' then
				TriggerEvent('fl_society:openBossMenu', 'event', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'boss_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
		)
end