local HasAlreadyEnteredMarker = false
local LastStation, LastPart, LastPartNum, CurrentAction, CurrentActionMsg

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function OpenStockMenu(station)
	local elements = {
		{label = _U('remove_object'), value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'armory', {
		title = 'Stock',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'gouv')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'gouv')
		end

	end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_stock'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accèder au stock'
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{label = 'Garde robe perso', value = 'clotheshop'},
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'stagiaire' then
		table.insert(elements, {label = _U('gouv_wear'), value = 'stagiaire_wear'})
	elseif grade == 'gardedc' then
		table.insert(elements, {label = _U('gouv_wear'), value = 'gardedc_wear'})
	elseif grade == 'secretaire' then
		table.insert(elements, {label = _U('gouv_wear'), value = 'secretaire_wear'})
	elseif grade == 'coboss' then
		table.insert(elements, {label = _U('gouv_wear'), value = 'coboss_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('gouv_wear'), value = 'boss_wear'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		if
			data.current.value == 'stagiaire_wear' or
			data.current.value == 'gardedc_wear' or
			data.current.value == 'secretaire_wear' or
			data.current.value == 'coboss_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear'
		then
			setUniform(data.current.value, playerPed)
		elseif data.current.value == 'clotheshop' then
			TriggerEvent('fl_clotheshop:openNonEditableDessing')
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
	end)
end

function OpenDatabaseMenu()
	if ESX.PlayerData.job.grade_name == 'stagiaire' or ESX.PlayerData.job.grade_name == 'gardedc' then
		ESX.ShowNotification('~r~Vous n\'avez pas accès à la base de donnée...')
		return
	end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'gouv_actions', {
		title = 'Consultation base de donnée',
		elements = {
			{label = 'Liste des licenses (Toutes)', value = 'menu_license'},
			{label = 'Liste des licenses d\'armes', value = 'menu_licenseweapon'},
	}}, function(data, menu)
		if data.current.value == 'menu_license' then
			OpenLicenseList()
		elseif data.current.value == 'menu_licenseweapon' then
			OpenLicenseWeaponList()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenLicenseList()
	ESX.TriggerServerCallback('fl_gouv:getLicenseList', function(licenseList)
		local elements = {
			head = {'Nom', 'Prénom', 'Identité', 'Type'},
			rows = {}
		}

		for i=1, #licenseList, 1 do
			table.insert(elements.rows, {
				data = licenseList[i],
				cols = {
					licenseList[i].lastname,
					licenseList[i].firstname,
					licenseList[i].name,
					licenseList[i].label,
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'license_list', elements, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenLicenseWeaponList()
	ESX.TriggerServerCallback('fl_gouv:getLicenseList', function(licenseList)
		local elements = {
			head = {'Nom', 'Prénom', 'Identité', 'Type'},
			rows = {}
		}

		for i=1, #licenseList, 1 do
			if licenseList[i].type == 'weapon' then
				table.insert(elements.rows, {
					data = licenseList[i],
					cols = {
						licenseList[i].lastname,
						licenseList[i].firstname,
						licenseList[i].name,
						licenseList[i].label,
					}
				})
			end
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'license_list', elements, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenMobileActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'gouv_actions', {
		title = 'Gouvernement',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
			{label = 'Menu Menottes', value = 'menu_menottes'},
			{label = _U('object_spawner'), value = 'object_spawner'},
			{label = 'Equiper un bouclier', value = 'shield'},
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('search'), value = 'body_search'},
				{label = _U('fine'), value = 'fine'},
				{label = _U('unpaid_bills'), value = 'unpaid_bills'}
			}

			table.insert(elements, { label = _U('license_check'), value = 'license' })
			if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'coboss' then
				table.insert(elements, {label = 'Attribuer licence armes', value = 'addlicenseweapon'})
			end

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'citizen_interaction', {
				title = _U('citizen_interaction'),
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'unpaid_bills' then
						TriggerEvent('fl_bank:openUnpaidBills', closestPlayer)
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'menu_menottes' then
			TriggerEvent('fl_policejob:openHandcuffMenu')
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
			end

			table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_interaction', {
				title = _U('vehicle_interaction'),
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			TriggerEvent("fl_civilprops:OpenMenu")
			menu.close()
		elseif data.current.value == 'shield' then
			TriggerEvent("fl_shield:shield")
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'fine', {
		title = _U('fine'),
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'), value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'), value = 3}
	}}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('fl_policejob:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label = fine.label,
				value = fine.id,
				amount = fine.amount,
				fineLabel = fine.label,
				rightLabel = _U('armory_item', ESX.Math.GroupDigits(fine.amount)),
				rightLabelColor = 'green',
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'fine_category', {
			title = _U('fine'),
			elements = elements
		}, function(data, menu)
			menu.close()

			TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(player), 'society_gouv', _U('fine_total', data.current.fineLabel), data.current.amount)

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('fl_policejob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('fl_policejob:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_infos', {
			title = _U('vehicle_info'),
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

AddEventHandler('fl_gouv:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
	elseif part == 'BossActions' then
		CurrentAction = 'menu_boss_actions'
		CurrentActionMsg = _U('open_bossmenu')
	elseif part == 'Stock' then
		CurrentAction = 'menu_stock'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accèder au stock'
	elseif part == 'ConsultDatabase' then
		CurrentAction = 'consult_database'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accèder à la base de donnée'
	end
end)

AddEventHandler('fl_gouv:hasExitedMarker', function(station, part, partNum)
	CurrentAction = nil
end)

CreateJobLoop('gouv', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local isInMarker, hasExited, letSleep = false, false, true
	local currentStation, currentPart, currentPartNum

	for k,v in pairs(Config.GouvStations) do
		for i=1, #v.Cloakrooms, 1 do
			local distance = #(coords - v.Cloakrooms[i])

			if distance < Config.DrawDistance then
				DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
				letSleep = false
			end

			if distance < Config.MarkerSize.x then
				isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
			end
		end

		if ESX.PlayerData.job.grade_name == 'boss' then
			for i=1, #v.BossActions, 1 do
				local distance = #(coords - v.BossActions[i])

				if distance < Config.DrawDistance then
					DrawMarker(22, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
				end
			end
		end

		for i=1, #v.ConsultDatabase, 1 do
			local distance = #(coords - v.ConsultDatabase[i])

			if distance < Config.DrawDistance then
				DrawMarker(21, v.ConsultDatabase[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
				letSleep = false
			end

			if distance < Config.MarkerSize.x then
				isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ConsultDatabase', i
			end
		end

		for i=1, #v.Stock, 1 do
			local distance = #(coords - v.Stock[i])

			if distance < Config.DrawDistance then
				DrawMarker(21, v.Stock[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
				letSleep = false
			end

			if distance < Config.MarkerSize.x then
				isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Stock', i
			end
		end
	end

	if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
		if
			(LastStation and LastPart and LastPartNum) and
			(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
		then
			TriggerEvent('fl_gouv:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		end

		HasAlreadyEnteredMarker = true
		LastStation = currentStation
		LastPart = currentPart
		LastPartNum = currentPartNum

		TriggerEvent('fl_gouv:hasEnteredMarker', currentStation, currentPart, currentPartNum)
	end

	if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_gouv:hasExitedMarker', LastStation, LastPart, LastPartNum)
	end

	if letSleep then
		Citizen.Wait(500)
	end
end)

CreateJobLoop('gouv', function()
	if CurrentAction then
		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'menu_cloakroom' then
				OpenCloakroomMenu()
			elseif CurrentAction == 'menu_stock' then
				OpenStockMenu()
			elseif CurrentAction == 'consult_database' then
				OpenDatabaseMenu()
			elseif CurrentAction == 'menu_boss_actions' then
				ESX.UI.Menu.CloseAll()
				TriggerEvent('fl_society:openBossMenu', 'gouv', function(data, menu)
					menu.close()

					CurrentAction = 'menu_boss_actions'
					CurrentActionMsg = _U('open_bossmenu')
				end, {})
			end

			CurrentAction = nil
		end
	end -- CurrentAction end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'gouv' then
		OpenMobileActionsMenu()
	end
end)