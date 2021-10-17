local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local OnJob = false
local BlipsTabac = {}
local JobBlipsTabac = {}
local JobBlipsTabac2 = {}
local Blips2Tabac = {}
local JobBlips2Tabac = {}

Citizen.CreateThread(function()
	CreateJobBlipsTabac()
	CreateJobBlipsTabac2()
	CreateJobBlips2Tabac()
end)

function OpenTabacActionsMenu()

	local elements = {
		{label = 'Tenue de travail', value = 'cloakroom_tabac'},
		{label = 'Tenue civile', value = 'cloakroom2_tabac'},
		{label = 'Déposer Stock', value = 'put_stock_tabac'},
		{label = 'Prendre Stock', value = 'get_stock_tabac'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'tabac_actions',
		{
			title = 'Malborose',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'cloakroom_tabac' then
				menu.close()
				ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
    				if skin.sex == 0 then
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
    				else
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
    				end
				end)
			end

			if data.current.value == 'cloakroom2_tabac' then
				menu.close()
				ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
    				TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if data.current.value == 'put_stock_tabac' then
    			TriggerEvent('fl_society:openPutStocksMenu', 'tabac')
			end

			if data.current.value == 'get_stock_tabac' then
				TriggerEvent('fl_society:openGetStocksMenu', 'tabac')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'tabac_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end

function OpenTabacVehiclesMenu()

	local elements = {
		{label = 'Sortir Véhicule', value = 'vehicle_tabac_list'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'tabac_vehicles',
		{
			title = 'Malborose',
			elements = elements
		},
		function(data, menu)
			local grade = ESX.PlayerData.job.grade_name
			if data.current.value == 'vehicle_tabac_list' then
				local elements = {
					{label = 'Rumpo', value = 'rumpo2'}
				}

				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
					table.insert(elements, {label = 'Mesa', value = 'mesa'})
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open(
					'native', GetCurrentResourceName(), 'spawn_tabac_vehicle',
					{
						title = 'Véhicule de service',
						elements = elements
					},
					function(data, menu)
						for i=1, #elements, 1 do
							local playerPed = PlayerPedId()
							local coords = Config.Zones4.VehicleSpawnTabacPoint.Pos
							local platenum = math.random(100, 900)
							ESX.Game.SpawnVehicle(data.current.value, coords, 252.94, function(vehicle)
								SetVehicleNumberPlateText(vehicle, "MLBS" .. platenum)
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
						OpenTabacVehiclesMenu()
					end
				)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'tabac_vehicles_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
			CurrentActionData = {}
		end
	)
end

function OpenTabacHarvestMenu()

	local elements = {
		{label = 'Feuille de tabac', value = 'harvest_tabac'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'tabac_harvest',
		{
			title = 'Feuille de tabac',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'harvest_tabac' then
				menu.close()
				TriggerServerEvent('nwx_tabac:startHarvestTabac')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'tabac_harvest_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end

function OpenTabacCraftMenu()

	local elements = {
		{label = 'Séchage', value = 'craft_tabac'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'tabac_craft',
		{
			title = 'Séchage',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'craft_tabac' then
				menu.close()
				TriggerServerEvent('nwx_tabac:startCraftTabac')
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'tabac_craft_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au séchage.'
			CurrentActionData = {}
		end
	)
end

function OpenTabacCraft2Menu()

	local elements = {
		{label = 'Assembler cigarette', value = 'craft_malbora'},
		{label = 'Assembler Cigar', value = 'craft_cigar'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'tabac_craft2',
		{
			title = 'Assemblement',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'craft_malbora' then
				menu.close()
				TriggerServerEvent('nwx_tabac:startCraftTabac2')
			elseif data.current.value == 'craft_cigar' then
				menu.close()
				TriggerServerEvent('nwx_tabac:startCraftTabac3')
			end
		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'tabac_craft_menu2'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a l\'assemblement.'
			CurrentActionData = {}
		end
	)
end

function OpenMobileTabacActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'mobile_tabac_actions',
		{
			title = 'Malborose',
			elements = {
				{label = 'Facturation',    value = 'billing_tabac'},
			}
		},
		function(data, menu)

			if data.current.value == 'billing_tabac' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'tabac_billing',
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
								TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_tabac', 'tabac', amount)
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
	CreateJobBlipsTabac()
	CreateJobBlipsTabac2()
	CreateJobBlips2Tabac()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	CreateJobBlipsTabac()
	CreateJobBlipsTabac2()
    CreateJobBlips2Tabac()
end)

function IsJobTrueTabac()
	if ESX.PlayerData ~= nil then
	  local IsJobTrueTabac = false
	  if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'tabac' then
		IsJobTrueTabac = true
	  end
	  return IsJobTrueTabac
	end
end

function CreateJobBlipsTabac()
	if IsJobTrueTabac() then
	local blip = AddBlipForCoord(Config.Zones4.TabacSellFarm.Pos.x, Config.Zones4.TabacSellFarm.Pos.y, Config.Zones4.TabacSellFarm.Pos.z)
		SetBlipSprite(blip, 605)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vente de cigarette")
		EndTextCommandSetBlipName(blip)
		table.insert(JobBlipsTabac, blip)
	end
end

function CreateJobBlipsTabac2()
	if IsJobTrueTabac() then
	local blip = AddBlipForCoord(Config.Zones4.TabacSellFarm2.Pos.x, Config.Zones4.TabacSellFarm2.Pos.y, Config.Zones4.TabacSellFarm2.Pos.z)
		SetBlipSprite(blip, 605)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vente de cigar")
		EndTextCommandSetBlipName(blip)
		table.insert(JobBlipsTabac2, blip)
	end
end

function DeleteJobBlipsTabac()
	if JobBlipsTabac[1] ~= nil then
		for i=1, #JobBlipsTabac, 1 do
			RemoveBlip(JobBlipsTabac[i])
			JobBlipsTabac[i] = nil
		end
	end
end

function DeleteJobBlipsTabac2()
	if JobBlipsTabac2[1] ~= nil then
		for i=1, #JobBlipsTabac2, 1 do
			RemoveBlip(JobBlipsTabac2[i])
			JobBlipsTabac2[i] = nil
		end
	end
end

function IsJobTrue2Tabac()
  if ESX.PlayerData ~= nil then
    local IsJobTrue2Tabac = false
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'tabac' then
      IsJobTrue2Tabac = true
    end
    return IsJobTrue2Tabac
  end
end

function CreateJobBlips2Tabac()
	if IsJobTrue2Tabac() then
	local blip2 = AddBlipForCoord(Config.Zones4.HarvestTabac.Pos.x, Config.Zones4.HarvestTabac.Pos.y, Config.Zones4.HarvestTabac.Pos.z)
		SetBlipSprite(blip2, 478)
		SetBlipDisplay(blip2, 4)
		SetBlipScale(blip2, 0.7)
		SetBlipColour(blip2, 0)
		SetBlipAsShortRange(blip2, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Récolte de Tabac")
		EndTextCommandSetBlipName(blip2)
		table.insert(JobBlips2Tabac, blip2)
	end
end

function DeleteJobBlips2Tabac()
	if JobBlips2Tabac[1] ~= nil then
		for i=1, #JobBlips2Tabac, 1 do
			RemoveBlip(JobBlips2Tabac[i])
			JobBlips2Tabac[i] = nil
		end
	end
end

AddEventHandler('nwx_tabac:hasEnteredMarkerTabac', function(zone)

	if zone == 'TabacActions' then
		CurrentAction = 'tabac_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {}
	elseif zone == 'HarvestTabac' then
		CurrentAction = 'tabac_harvest_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la récolte.'
		CurrentActionData = {}
	elseif zone == 'TabacCraft' then
		CurrentAction = 'tabac_craft_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au séchage.'
		CurrentActionData = {}
	elseif zone == 'TabacCraft2' then
		CurrentAction = 'tabac_craft_menu2'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a l\'assemblage.'
		CurrentActionData = {}
	elseif zone == 'TabacSellFarm' then
		CurrentAction = 'tabac_sell_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la vente.'
		CurrentActionData = {zone = zone}
	elseif zone == 'TabacSellFarm2' then
		CurrentAction = 'tabac_sell_menu2'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder a la vente.'
		CurrentActionData = {zone = zone}
	elseif zone == 'VehicleSpawnTabacMenu' then
		CurrentAction = 'tabac_vehicles_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
		CurrentActionData = {}
	elseif zone == 'VehicleTabacDeleter' then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed,  false) then
			CurrentAction = 'delete_tabac_vehicle'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule.'
			CurrentActionData = {}
		end
	elseif zone == 'BossActionsTabac' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_tabac_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu patron.'
		CurrentActionData = {}
	end

end)

AddEventHandler('nwx_tabac:hasExitedMarkerTabac', function(zone)

	if zone == 'TabacCraft' then
		TriggerServerEvent('nwx_tabac:stopCraftTabac')
	elseif zone == 'TabacCraft2' then
		TriggerServerEvent('nwx_tabac:stopCraftTabac2')
		TriggerServerEvent('nwx_tabac:stopCraftTabac3')
	elseif zone == 'HarvestTabac' then
		TriggerServerEvent('nwx_tabac:stopHarvestTabac')
	elseif zone == 'TabacSellFarm' then
		TriggerServerEvent('nwx_tabac:stopSellTabac')
	elseif zone == 'TabacSellFarm2' then
		TriggerServerEvent('nwx_tabac:stopSellTabac2')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Display markers
CreateJobLoop('tabac', function()
	local coords = GetEntityCoords(PlayerPedId())
	local sleep = true

	for k,v in pairs(Config.Zones4) do
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
CreateJobLoop('tabac', function()
	Citizen.Wait(400)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil
	for k,v in pairs(Config.Zones4) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.z) then
			isInMarker = true
			currentZone = k
		end
	end
	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('nwx_tabac:hasEnteredMarkerTabac', currentZone)
	end
	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('nwx_tabac:hasExitedMarkerTabac', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(300)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'tabac' then
		OpenMobileTabacActionsMenu()
	end
end)

-- Key Controls
CreateJobLoop('tabac', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'tabac_actions_menu' then
				OpenTabacActionsMenu()
			elseif CurrentAction == 'tabac_harvest_menu' then
				OpenTabacHarvestMenu()
			elseif CurrentAction == 'boss_tabac_actions_menu' then
				OpenBossTabacActionsMenu()
			elseif CurrentAction == 'tabac_craft_menu' then
				OpenTabacCraftMenu()
			elseif CurrentAction == 'tabac_craft_menu2' then
				OpenTabacCraft2Menu()
			elseif CurrentAction == 'tabac_sell_menu' then
				TriggerServerEvent('nwx_tabac:startSellTabac', CurrentActionData.zone)
			elseif CurrentAction == 'tabac_sell_menu2' then
				TriggerServerEvent('nwx_tabac:startSellTabac2', CurrentActionData.zone)
			elseif CurrentAction == 'tabac_vehicles_menu' then
				OpenTabacVehiclesMenu()
			elseif CurrentAction == 'delete_tabac_vehicle' then
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

function OpenBossTabacActionsMenu()

	local elements = {
		{label = 'Déposer Stock', value = 'put_stock_tabac'},
		{label = 'Prendre Stock', value = 'get_stock_tabac'},
		{label = '---------------', value = nil},
		{label = 'Action Patron', value = 'boss_tabac_actions'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'boss_actions_tabac',
		{
			title = 'Boss',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'put_stock_tabac' then
				TriggerEvent('fl_society:openPutStocksMenu', 'tabac')
			elseif data.current.value == 'get_stock_tabac' then
				TriggerEvent('fl_society:openGetStocksMenu', 'tabac')
			elseif data.current.value == 'boss_tabac_actions' then
				TriggerEvent('fl_society:openBossMenu', 'tabac', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'boss_tabac_actions_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {}
		end
	)
end