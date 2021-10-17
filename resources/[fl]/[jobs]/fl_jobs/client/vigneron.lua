local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local OnJob = false
local BlipsVigneron = {}
local JobBlipsVigneron = {}
local JobBlipsVigneron2 = {}
local Blips2Vigneron = {}
local JobBlips2Vigneron = {}


Citizen.CreateThread(function()
	CreateJobBlipsVigneron()
	CreateJobBlipsVigneron2()
	CreateJobBlips2Vigneron()
end)

function OpenVigneronActionsMenu()

	local elements = {
		{label = 'Tenue de travail', value = 'cloakroom_vigneron'},
		{label = 'Tenue civile', value = 'cloakroom2_vigneron'},
		{label = 'Déposer Stock', value = 'put_stock_vigneron'},
		{label = 'Prendre Stock', value = 'get_stock_vigneron'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vigneron_actions', {
		title = 'Vigneron',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom_vigneron' then
			menu.close()
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'cloakroom2_vigneron' then
			menu.close()
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'put_stock_vigneron' then
			TriggerEvent('fl_society:openPutStocksMenu', 'vigneron')
		elseif data.current.value == 'get_stock_vigneron' then
			TriggerEvent('fl_society:openGetStocksMenu', 'vigneron')
		end

	end, function(data, menu)
		menu.close()
		CurrentAction = 'vigneron_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	end)
end

function OpenVigneronVehiclesMenu()

	local elements = {
		{label = 'Sortir Véhicule', value = 'vehicle_vigneron_list'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vigneron_vehicles', {
			title = 'Vigneron',
			elements = elements
	}, function(data, menu)
		local grade = ESX.PlayerData.job.grade_name
		if data.current.value == 'vehicle_vigneron_list' then
			local elements = {
				{label = 'Bison', value = 'bison3'}
			}

			ESX.UI.Menu.CloseAll()

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'spawn_vigneron_vehicle',
				{
					title = 'Véhicule de service',
					elements = elements
				},
				function(data, menu)
					for i=1, #elements, 1 do
						local playerPed = PlayerPedId()
						local coords = Config.Zones5.VehicleSpawnVigneronPoint.Pos
						local platenum = math.random(100, 900)
						ESX.Game.SpawnVehicle(data.current.value, coords, 257.03, function(vehicle)
							SetVehicleNumberPlateText(vehicle, "VIGN" .. platenum)
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
					OpenVigneronVehiclesMenu()
				end
			)
		end

	end, function(data, menu)
		menu.close()
		CurrentAction = 'vigneron_vehicles_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
		CurrentActionData = {}
	end)
end

function OpenVigneronHarvestMenu()

	local elements = {
		{label = 'Raisin', value = 'harvest_vigneron'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vigneron_harvest', {
		title = 'Ramasser du Raisin',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'harvest_vigneron' then
			menu.close()
			TriggerServerEvent('fl_jobs:vigneron:startHarvestVigneron')
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'vigneron_harvest_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	end)
end

function OpenVigneronCraftMenu()

	local elements = {
		{label = 'Jus de raisin', value = 'craft_jusraisin'},
		{label = 'Vin', value = 'craft_vin'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vigneron_craft', {
		title = 'Distillation',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'craft_jusraisin' then
			menu.close()
			TriggerServerEvent('fl_jobs:vigneron:startCraftVigneron')
		elseif data.current.value == 'craft_vin' then
			menu.close()
			TriggerServerEvent('fl_jobs:vigneron:startCraftVigneron2')
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'vigneron_craft_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	end)
end

function OpenMobileVigneronActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mobile_vigneron_actions', {
			title = 'Vigneron',
			elements = {
				{label = 'Facturation',    value = 'billing_vigneron'},
			}
		}, function(data, menu)
			if data.current.value == 'billing_vigneron' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vigneron_billing', {
					title = 'Montant de la facture'
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
							TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_vigneron', 'vigneron', amount)
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
	end
	)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	CreateJobBlipsVigneron()
	CreateJobBlipsVigneron2()
	CreateJobBlips2Vigneron()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	CreateJobBlipsVigneron()
	CreateJobBlipsVigneron2()
    CreateJobBlips2Vigneron()
end)

function IsJobTrueVigneron()
	if ESX.PlayerData ~= nil then
	  local IsJobTrueVigneron = false
	  if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'vigneron' then
		IsJobTrueVigneron = true
	  end
	  return IsJobTrueVigneron
	end
end

function CreateJobBlipsVigneron()
	if IsJobTrueVigneron() then
	local blip = AddBlipForCoord(Config.Zones5.VigneronSellFarm.Pos.x, Config.Zones5.VigneronSellFarm.Pos.y, Config.Zones5.VigneronSellFarm.Pos.z)
		SetBlipSprite(blip, 605)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vente de jus raisin")
		EndTextCommandSetBlipName(blip)
		table.insert(JobBlipsVigneron, blip)
	end
end

function CreateJobBlipsVigneron2()
	if IsJobTrueVigneron() then
	local blip = AddBlipForCoord(Config.Zones5.VigneronSellFarm2.Pos.x, Config.Zones5.VigneronSellFarm2.Pos.y, Config.Zones5.VigneronSellFarm2.Pos.z)
		SetBlipSprite(blip, 605)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vente de vin")
		EndTextCommandSetBlipName(blip)
		table.insert(JobBlipsVigneron2, blip)
	end
end

function DeleteJobBlipsVigneron()
	if JobBlipsVigneron[1] ~= nil then
		for i=1, #JobBlipsVigneron, 1 do
			RemoveBlip(JobBlipsVigneron[i])
			JobBlipsVigneron[i] = nil
		end
	end
end

function DeleteJobBlipsVigneron2()
	if JobBlipsVigneron2[1] ~= nil then
		for i=1, #JobBlipsVigneron2, 1 do
			RemoveBlip(JobBlipsVigneron2[i])
			JobBlipsVigneron2[i] = nil
		end
	end
end

function CreateJobBlips2Vigneron()
	if IsJobTrueVigneron() then
	local blip2 = AddBlipForCoord(Config.Zones5.VigneronCraft.Pos.x, Config.Zones5.VigneronCraft.Pos.y, Config.Zones5.VigneronCraft.Pos.z)
		SetBlipSprite(blip2, 478)
		SetBlipDisplay(blip2, 4)
		SetBlipScale(blip2, 0.7)
		SetBlipColour(blip2, 0)
		SetBlipAsShortRange(blip2, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Distillerie")
		EndTextCommandSetBlipName(blip2)
		table.insert(JobBlips2Vigneron, blip2)
	end
end

function DeleteJobBlips2Vigneron()
	if JobBlips2Vigneron[1] ~= nil then
		for i=1, #JobBlips2Vigneron, 1 do
			RemoveBlip(JobBlips2Vigneron[i])
			JobBlips2Vigneron[i] = nil
		end
	end
end

AddEventHandler('fl_jobs:vigneron:hasEnteredMarkerVigneron', function(zone)

	if zone == 'VigneronActions' then
		CurrentAction = 'vigneron_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'HarvestVigneron' then
		CurrentAction = 'vigneron_harvest_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la récolte.'
		CurrentActionData = {}
	elseif zone == 'HarvestVigneron2' then
		CurrentAction = 'vigneron_harvest_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la récolte.'
		CurrentActionData = {}
	elseif zone == 'VigneronCraft' then
		CurrentAction = 'vigneron_craft_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'VigneronSellFarm' then
		CurrentAction = 'vigneron_sell_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la vente.'
		CurrentActionData = {zone = zone}
	elseif zone == 'VigneronSellFarm2' then
		CurrentAction = 'vigneron_sell_menu2'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la vente.'
		CurrentActionData = {zone = zone}
	elseif zone == 'VehicleSpawnVigneronMenu' then
		CurrentAction = 'vigneron_vehicles_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
		CurrentActionData = {}
	elseif zone == 'VehicleVigneronDeleter' then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed,  false) then
			CurrentAction = 'delete_vigneron_vehicle'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule.'
			CurrentActionData = {}
		end
	elseif zone == 'BossActionsVigneron' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_vigneron_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu patron.'
		CurrentActionData = {}
	end

end)

AddEventHandler('fl_jobs:vigneron:hasExitedMarkerVigneron', function(zone)

	if zone == 'VigneronCraft' then
		TriggerServerEvent('fl_jobs:vigneron:stopCraftVigneron')
		TriggerServerEvent('fl_jobs:vigneron:stopCraftVigneron2')
	elseif zone == 'HarvestVigneron' then
		TriggerServerEvent('fl_jobs:vigneron:stopHarvestVigneron')
	elseif zone == 'HarvestVigneron2' then
		TriggerServerEvent('fl_jobs:vigneron:stopHarvestVigneron')
	elseif zone == 'VigneronSellFarm' then
		TriggerServerEvent('fl_jobs:vigneron:stopSellVigneron')
	elseif zone == 'VigneronSellFarm2' then
		TriggerServerEvent('fl_jobs:vigneron:stopSellVigneron2')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Display markers
CreateJobLoop('vigneron', function()
	local coords = GetEntityCoords(PlayerPedId())
	local sleep = true

	for k,v in pairs(Config.Zones5) do
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
CreateJobLoop('vigneron', function()
	Citizen.Wait(400)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil
	for k,v in pairs(Config.Zones5) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < 2.5) then
			isInMarker = true
			currentZone = k
		end
	end
	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('fl_jobs:vigneron:hasEnteredMarkerVigneron', currentZone)
	end
	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_jobs:vigneron:hasExitedMarkerVigneron', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(300)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'vigneron' then
		OpenMobileVigneronActionsMenu()
	end
end)

-- Key Controls
CreateJobLoop('vigneron', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'vigneron_actions_menu' then
				OpenVigneronActionsMenu()
			elseif CurrentAction == 'vigneron_harvest_menu' then
				OpenVigneronHarvestMenu()
			elseif CurrentAction == 'boss_vigneron_actions_menu' then
				OpenBossVigneronActionsMenu()
			elseif CurrentAction == 'vigneron_craft_menu' then
				OpenVigneronCraftMenu()
			elseif CurrentAction == 'vigneron_sell_menu' then
				TriggerServerEvent('fl_jobs:vigneron:startSellVigneron', CurrentActionData.zone)
			elseif CurrentAction == 'vigneron_sell_menu2' then
				TriggerServerEvent('fl_jobs:vigneron:startSellVigneron2', CurrentActionData.zone)
			elseif CurrentAction == 'vigneron_vehicles_menu' then
				OpenVigneronVehiclesMenu()
			elseif CurrentAction == 'delete_vigneron_vehicle' then
				local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
				local plate = GetVehicleNumberPlateText(vehicle)
				TriggerServerEvent('fl_controlvehicle:deleteKeyJobs', plate, NetworkGetNetworkIdFromEntity(vehicle))
			end
			CurrentAction = nil
		end
	else
		Citizen.Wait(300)
	end
end)

function OpenBossVigneronActionsMenu()

	local elements = {
		{label = 'Déposer Stock', value = 'put_stock_vigneron'},
		{label = 'Prendre Stock', value = 'get_stock_vigneron'},
		{label = '---------------', value = nil},
		{label = 'Action Patron', value = 'boss_vigneron_actions'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'boss_actions_vigneron',
		{
			title = 'Boss',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'put_stock_vigneron' then
				TriggerEvent('fl_society:openPutStocksMenu', 'vigneron')
			elseif data.current.value == 'get_stock_vigneron' then
				TriggerEvent('fl_society:openGetStocksMenu', 'vigneron')
			elseif data.current.value == 'boss_vigneron_actions' then
				TriggerEvent('fl_society:openBossMenu', 'vigneron', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'boss_vigneron_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end