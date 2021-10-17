local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local OnJob = false
local BlipsDaymson = {}
local JobBlipsDaymson = {}
local Blips2Daymson = {}
local JobBlips2Daymson = {}

Citizen.CreateThread(function()
	CreateJobBlipsDaymson()
	CreateJobBlips2Daymson()
end)

function OpenDaymsonActionsMenu()

	local elements = {
		{label = 'Tenue de travail', value = 'cloakroom_daymson'},
		{label = 'Tenue civile', value = 'cloakroom2_daymson'},
		{label = 'Déposer Stock', value = 'put_stock_daymson'},
		{label = 'Prendre Stock', value = 'get_stock_daymson'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'daymson_actions',
		{
			title = 'Daymson',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'cloakroom_daymson' then
				menu.close()
				ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
    				if skin.sex == 0 then
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
    				else
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
    				end
				end)
			end

			if data.current.value == 'cloakroom2_daymson' then
				menu.close()
				ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
    				TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if data.current.value == 'put_stock_daymson' then
    			TriggerEvent('fl_society:openPutStocksMenu', 'daymson')
			end

			if data.current.value == 'get_stock_daymson' then
				TriggerEvent('fl_society:openGetStocksMenu', 'daymson')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'daymson_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end

function OpenDaymsonVehiclesMenu()

	local elements = {
		{label = 'Sortir Véhicule', value = 'vehicle_daymson_list'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'daymson_vehicles',
		{
			title = 'Daymson',
			elements = elements
		},
		function(data, menu)
			local grade = ESX.PlayerData.job.grade_name
			if data.current.value == 'vehicle_daymson_list' then
				local elements = {
					{label = 'Rumpo', value = 'rumpo'}
				}

				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'manager' then
					table.insert(elements, {label = 'Toros', value = 'toros'})
				end

				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'gerant'then
					table.insert(elements, {label = 'Toros', value = 'toros'})
					table.insert(elements, {label = 'Limousine Patriot', value = 'patriot2'})
				end

				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
					table.insert(elements, {label = 'Toros', value = 'toros'})
					table.insert(elements, {label = 'Limousine Patriot', value = 'patriot2'})
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open(
					'native', GetCurrentResourceName(), 'spawn_daymson_vehicle',
					{
						title = 'Véhicule de service',
						elements = elements
					},
					function(data, menu)
						for i=1, #elements, 1 do
							local playerPed = PlayerPedId()
							local coords = Config.Zones3.VehicleSpawnDaymsonPoint.Pos
							local platenum = math.random(100, 900)
							ESX.Game.SpawnVehicle(data.current.value, coords, 172.734, function(vehicle)
								SetVehicleColours(vehicle, 149, 149)
								SetVehicleNumberPlateText(vehicle, "BREC" .. platenum)
								TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
								local plate = GetVehicleNumberPlateText(vehicle)
								TriggerServerEvent('fl_controlvehicle:giveKey', plate) -- vehicle lock
							end)
							break
						end
						menu.close()
					end,
					function(data, menu)
						menu.close()
						OpenDaymsonVehiclesMenu()
					end
				)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'daymson_vehicles_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
			CurrentActionData = {}
		end
	)
end

function OpenDaymsonHarvestMenu()

	local elements = {
		{label = 'CD vierge', value = 'cdvierge'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'daymson_harvest',
		{
			title = 'Récupérer CD vierge',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'cdvierge' then
				menu.close()
				TriggerServerEvent('fl_jobs:daymson:startHarvestDaymson')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'daymson_harvest_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end

function OpenDaymsonCraftMenu()

	local elements = {
		{label = 'CD scellé', value = 'cdscelle'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'daymson_craft',
		{
			title = 'Assemblement',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'cdscelle' then
				menu.close()
				TriggerServerEvent('fl_jobs:daymson:startCraftDaymson')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'daymson_craft_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la gravure des cd.'
			CurrentActionData = {}
		end
	)
end

function OpenMobileDaymsonActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'mobile_daymson_actions',
		{
			title = 'Daymson',
			elements = {
				{label = 'Facturation',    value = 'billing_daymson'},
			}
		},
		function(data, menu)

			if data.current.value == 'billing_daymson' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'daymson_billing',
					{
						title = 'Montant de la facture'
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification('Montant invalide')
						else
							menu.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_daymson', 'Ballas Record', amount)
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
	end
	)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	CreateJobBlipsDaymson()
	CreateJobBlips2Daymson()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    CreateJobBlipsDaymson()
    CreateJobBlips2Daymson()
end)

function IsJobTrueDaymson()
	if ESX.PlayerData ~= nil then
	  local IsJobTrueDaymson = false
	  if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'daymson' then
		IsJobTrueDaymson = true
	  end
	  return IsJobTrueDaymson
	end
end

function CreateJobBlipsDaymson()
	if IsJobTrueDaymson() then
	local blip = AddBlipForCoord(Config.Zones3.DaymsonSellFarm.Pos.x, Config.Zones3.DaymsonSellFarm.Pos.y, Config.Zones3.DaymsonSellFarm.Pos.z)
		SetBlipSprite(blip, 605)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 0)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vente de CD")
		EndTextCommandSetBlipName(blip)
		table.insert(JobBlipsDaymson, blip)
	end
end

function DeleteJobBlipsDaymson()
	if JobBlipsDaymson[1] ~= nil then
		for i=1, #JobBlipsDaymson, 1 do
			RemoveBlip(JobBlipsDaymson[i])
			JobBlipsDaymson[i] = nil
		end
	end
end

function IsJobTrue2Daymson()
  if ESX.PlayerData ~= nil then
    local IsJobTrue2Daymson = false
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'daymson' then
      IsJobTrue2Daymson = true
    end
    return IsJobTrue2Daymson
  end
end

function CreateJobBlips2Daymson()
	if IsJobTrue2Daymson() then
	local blip2 = AddBlipForCoord(Config.Zones3.HarvestDaymson.Pos.x, Config.Zones3.HarvestDaymson.Pos.y, Config.Zones3.HarvestDaymson.Pos.z)
		SetBlipSprite(blip2, 614)
		SetBlipDisplay(blip2, 4)
		SetBlipScale(blip2, 0.7)
		SetBlipColour(blip2, 0)
		SetBlipAsShortRange(blip2, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Récolte de CD")
		EndTextCommandSetBlipName(blip2)
		table.insert(JobBlips2Daymson, blip2)
	end
end

function DeleteJobBlips2Daymson()
	if JobBlips2Daymson[1] ~= nil then
		for i=1, #JobBlips2Daymson, 1 do
			RemoveBlip(JobBlips2Daymson[i])
			JobBlips2Daymson[i] = nil
		end
	end
end

AddEventHandler('fl_jobs:daymson:hasEnteredMarkerDaymson', function(zone)

	if zone == 'DaymsonActions' then
		CurrentAction = 'daymson_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'HarvestDaymson' then
		CurrentAction = 'daymson_harvest_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la récolte.'
		CurrentActionData = {}
	elseif zone == 'DaymsonCraft' then
		CurrentAction = 'daymson_craft_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au traitement.'
		CurrentActionData = {}
	elseif zone == 'DaymsonSellFarm' then
		CurrentAction = 'daymson_sell_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la vente.'
		CurrentActionData = {zone = zone}
	elseif zone == 'VehicleSpawnDaymsonMenu' then
		CurrentAction = 'daymson_vehicles_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
		CurrentActionData = {}
	elseif zone == 'VehicleDaymsonDeleter' then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed,  false) then
			CurrentAction = 'delete_daymson_vehicle'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule.'
			CurrentActionData = {}
		end
	elseif zone == 'BossActionsDaymson' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_daymson_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu patron.'
		CurrentActionData = {}
	end

end)

AddEventHandler('fl_jobs:daymson:hasExitedMarkerDaymson', function(zone)

	if zone == 'DaymsonCraft' then
		TriggerServerEvent('fl_jobs:daymson:stopCraftDaymson')
	elseif zone == 'HarvestDaymson' then
		TriggerServerEvent('fl_jobs:daymson:stopHarvestDaymson')
	elseif zone == 'DaymsonSellFarm' then
		TriggerServerEvent('fl_jobs:daymson:stopSellDaymson')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Display markers
CreateJobLoop('daymson', function()
	local sleep = true
	local coords = GetEntityCoords(PlayerPedId())

	for k,v in pairs(Config.Zones3) do
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
CreateJobLoop('daymson', function()
	Citizen.Wait(400)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil
	for k,v in pairs(Config.Zones3) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
			isInMarker = true
			currentZone = k
		end
	end
	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('fl_jobs:daymson:hasEnteredMarkerDaymson', currentZone)
	end
	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_jobs:daymson:hasExitedMarkerDaymson', LastZone)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'daymson' then
		OpenMobileDaymsonActionsMenu()
	end
end)

-- Key Controls
CreateJobLoop('daymson', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if IsControlJustReleased(0, 38) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'daymson' then

			if CurrentAction == 'daymson_actions_menu' then
				OpenDaymsonActionsMenu()
			elseif CurrentAction == 'daymson_harvest_menu' then
				OpenDaymsonHarvestMenu()
							elseif CurrentAction == 'boss_daymson_actions_menu' then
				OpenBossDaymsonActionsMenu()
			elseif CurrentAction == 'daymson_craft_menu' then
				  OpenDaymsonCraftMenu()
							elseif CurrentAction == 'daymson_sell_menu' then
				TriggerServerEvent('fl_jobs:daymson:startSellDaymson', CurrentActionData.zone)
			elseif CurrentAction == 'daymson_vehicles_menu' then
				OpenDaymsonVehiclesMenu()
			elseif CurrentAction == 'delete_daymson_vehicle' then
				local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
				local plate = GetVehicleNumberPlateText(vehicle)
				TriggerServerEvent('fl_controlvehicle:deleteKeyJobs', plate, NetworkGetNetworkIdFromEntity(vehicle))
			end
			CurrentAction = nil
		end
	else
		Citizen.Wait(500)
	end
end)

function OpenBossDaymsonActionsMenu()

	local elements = {
		{label = 'Déposer Stock', value = 'put_stock_daymson'},
		{label = 'Prendre Stock', value = 'get_stock_daymson'},
		{label = '---------------', value = nil},
		{label = 'Action Patron', value = 'boss_daymson_actions'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'boss_actions_daymson',
		{
			title = 'Boss',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'put_stock_daymson' then
				TriggerEvent('fl_society:openPutStocksMenu', 'daymson')
			elseif data.current.value == 'get_stock_daymson' then
				TriggerEvent('fl_society:openGetStocksMenu', 'daymson')
			elseif data.current.value == 'boss_daymson_actions' then
				TriggerEvent('fl_society:openBossMenu', 'daymson', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'boss_daymson_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end