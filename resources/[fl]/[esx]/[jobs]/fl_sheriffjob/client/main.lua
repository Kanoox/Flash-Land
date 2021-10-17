local CurrentActionData, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
blip = nil

local attente = 0

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

			if job == 'tenu_doag' then
				SetPedArmour(playerPed, 100)
			end

			if job == 'tenu_sahpg' then
				SetPedArmour(playerPed, 100)
			end

			if job == 'tenu_swatgr' then
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

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{label = 'Garde robe perso', value = 'clotheshop'},
		{label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = 'Tenue Policier', value = 'tenu_lspd'},
		{label = 'Tenue Cérémonie', value = 'tenu_ma'},
		{label = 'Tenue SWAT', value = 'tenu_swatgr'},
		{label = _U('bullet_wear'), value = 'bullet_wear'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				local isMale = skin.sex == 0


				TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
					ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('esx:restoreLoadout')
					end)
				end)

			end)
		end

		if
			data.current.value == 'recruit_wear' or
			data.current.value == 'officer_wear' or
			data.current.value == 'sergeant_wear' or
			data.current.value == 'intendent_wear' or
			data.current.value == 'lieutenant_wear' or
			data.current.value == 'chef_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'tenu_ma' or
			data.current.value == 'tenu_hiv' or
			data.current.value == 'tenu_swat' or
			data.current.value == 'tenu_swatgr' or
			data.current.value == 'tenu_doag' or
			data.current.value == 'tenu_lspd' or
			data.current.value == 'tenu_sahp' or
			data.current.value == 'tenu_sahpg'
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
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{label = _U('get_weapon'), value = 'get_weapon'},
		{label = ('Ranger ses armes'), value = 'put_weapon'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'armory', {
		title = _U('armory'),
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			TriggerEvent('fl_society:openGetStocksMenu', 'sheriff_weapons')
		elseif data.current.value == 'put_weapon' then
			TriggerEvent('fl_society:openPutStocksMenu', 'sheriff_weapons')
		end

	end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_armory'
		CurrentActionMsg = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

CreateJobLoop('sheriff', function()
	if isInShopMenu then
		DisableControlAction(0, 75, true)  -- Disable exit vehicle
		DisableControlAction(27, 75, true) -- Disable exit vehicle
	else
		Citizen.Wait(500)
	end
end)

function OpensheriffActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'sheriff_actions', {
		title = 'sheriff',
		elements = {
			{label = 'Status de l\'agent', value = 'status'},
			{label = 'Interaction Citoyen', value = 'citizen_interaction'},
			{label = 'Menu Menottes', value = 'menu_menottes'},
			{label = 'Gérer les bracelets', value = 'bracelet'},
			{label = 'Recherche par N° de permis', value = 'licensepoint'},
			{label = 'Interaction véhicule', value = 'vehicle_interaction'},
			{label = 'Menu objets', value = 'object_spawner'},
			{label = 'Equiper un bouclier', value = 'shield'},
			{label = 'Mettre une amende', value = 'amende'},
			{label = 'Demande renfort', value = 'renfort'},
			{label = "Liste des appels", value = 'appels'},
			{label = 'Zone d\'arrêt NPC', value = 'speedZone'},
	}}, function(data, menu)
		if data.current.value == 'speedZone' then
			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'speedzone_menu', {
				title = 'Zone d\'arrêt NPC',
				elements = {
					{label = 'Ajouter une zone d\'arrêt', value = 'add_zone'},
					{label = 'Afficher les zones', value = 'display_zone'},
				}
			}, function(dataSZ, menuSZ)
				if dataSZ.current.value == 'add_zone' then
					menu.close()
					menuSZ.close()
					TriggerEvent('fl_sheriffjob:promptSpeedzone')
				elseif dataSZ.current.value == 'display_zone' then
					TriggerEvent('fl_sheriffjob:toggleSpeedzoneDraw')
				else
					menu.close()
					menuSZ.close()
					error('Unknown value in speedzone_menu')
				end
			end, function(dataSZ, menuSZ)
				menuSZ.close()
			end)
		elseif data.current.value == 'licensepoint' then
			TriggerEvent('fl_dmvschool:dialogFindLicenseById')
		elseif data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('search'), value = 'body_search'},
				{label = _U('fine'), value = 'fine'},
				{label = _U('unpaid_bills'), value = 'unpaid_bills'}
			}

			table.insert(elements, {label = _U('license_check'), value = 'license'})

			if ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'boss' then
				table.insert(elements, {label = 'Attribuer licence armes', value = 'addlicenseweapon'})
			end

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'citizen_interaction', {
				title = _U('citizen_interaction'),
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 2.0 then
					local action = data2.current.value

					if action == 'body_search' then
						TriggerServerEvent('fl_sheriffjob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						TriggerEvent('fl_factions:bodySearch', closestPlayer)
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'addlicenseweapon' then
						TriggerServerEvent('fl_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
						ESX.ShowNotification('License d\'armes attribué')
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'bracelet' then
			TriggerEvent('fl_sheriffjob:manageBracelet')
		elseif data.current.value == 'amende' then

			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'amende',
				{
					title = 'Donner une contravention'
				},
				function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil or amount <= 0 then
						ESX.ShowNotification('Montant invalide')
					else
						menu.close()

						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification('Pas de joueurs proche')
						else
							local playerPed = PlayerPedId()

							Citizen.CreateThread(function()
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
								Citizen.Wait(5000)
								ClearPedTasks(playerPed)
								TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sheriff', 'sheriff', amount)
							end)
						end
					end
				end,
				function(data, menu)
					menu.close()
			end)
		elseif data.current.value == 'menu_menottes' then
			TriggerEvent('fl_sheriffjob:openHandcuffMenu')
		elseif data.current.value == 'status' then
			local elements = {}

			local elements = {
				{label = 'Prise de service', value = 'prise'},
				{label = 'Fin de service', value = 'fin'},
				{label = 'Pause de service', value = 'pause'},
				{label = 'Standby en attente de dispatch', value = 'standby'},
				{label = 'Contrôle routier en cours', value = 'control'},
				{label = 'Refus d\'obtempérer / Délit de fuite', value = 'refus'},
				{label = 'Crime en cours / poursuite en cours', value = 'crime'}
			}

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'status_service', {
				title = 'Status Service',
				elements = elements
			}, function(data2, menu2)
				local action = data2.current.value

				if action == 'prise' then
					TriggerServerEvent('sheriff:PriseEtFinservice', action)
				elseif action == 'fin' then
					TriggerServerEvent('sheriff:PriseEtFinservice', action)
				elseif action == 'pause' then
					TriggerServerEvent('sheriff:PriseEtFinservice', action)
				elseif action == 'standby' then
					TriggerServerEvent('sheriff:PriseEtFinservice', action)
				elseif action == 'control' then
					TriggerServerEvent('sheriff:PriseEtFinservice', action)
				elseif action == 'refus' then
					TriggerServerEvent('sheriff:PriseEtFinservice', action)
				elseif action == 'crime' then
					TriggerServerEvent('sheriff:PriseEtFinservice', action)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'), value = 'impound'})
			end

			table.insert(elements, {label = _U('search_database'), value = 'search_database'})
			--table.insert(elements, {label = 'Fourrière (à coté du véhicule)', value = 'impound2'})

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_interaction', {
				title = _U('vehicle_interaction'),
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif action == 'impound2' then
					-- is the script busy?
					if currentTask.busy then
						return
					end

					local playerPed = PlayerPedId()
					local vehicle = ESX.Game.GetVehicleInDirection()
					if IsPedInAnyVehicle(playerPed, true) then
					    vehicle = GetVehiclePedIsIn(playerPed, false)
					end
					carModel = GetEntityModel(vehicle)
					carName = GetDisplayNameFromVehicleModel(carModel)
					NetworkRequestControlOfEntity(vehicle)

					local timeout = 2000
					while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
					    Wait(100)
					    timeout = timeout - 100
					end

					SetEntityAsMissionEntity(vehicle, true, true)

					local timeout = 2000
					while timeout > 0 and not IsEntityAMissionEntity(vehicle) do
					    Wait(100)
					    timeout = timeout - 100
					end

					DeleteVehicle(vehicle)

					if DoesEntityExist(vehicle) then
					    DeleteEntity(vehicle)
					end
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
					elseif action == 'impound' then
						-- is the script busy?
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)

						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while currentTask.busy do
								Citizen.Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(currentTask.task)
									ClearPedTasks(playerPed)
									currentTask.busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'renfort' then
			local elements = {}
			local playerPed = PlayerPedId()

			table.insert(elements, {label = ('Petite demande'), value = 'petite_demande'})
			table.insert(elements, {label = ('Demande importante'), value = 'demande_importante'})
			table.insert(elements, {label = ('Toutes les unitées demandées !'), value = 'omgad'})


			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'renfort', {
				title = 'Menu renfort',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action = data2.current.value
				local name = GetPlayerName(PlayerId())
				TriggerServerEvent('3dme:shareDisplay', '*La personne demande des renforts*')

				if action == 'petite_demande' then
					local raison = 'petit'
					TriggerServerEvent('sheriff:renfort', coords, raison)
					TriggerServerEvent("iCore:sendCallMsg", "~g~Renfort demandé\n~s~de : ~b~" .. GetPlayerName(PlayerId()) .. "\n~s~Code : ~b~CODE 2\n~s~Importance : ~b~légère", coords)
				elseif action == 'demande_importante' then
					local raison = 'importante'
					TriggerServerEvent('sheriff:renfort', coords, raison)
					TriggerServerEvent("iCore:sendCallMsg", "~g~Renfort demandé\n~s~de : ~b~" .. GetPlayerName(PlayerId()) .. "\n~s~Code : ~b~CODE 3\n~s~Importance : ~b~haute", coords)
				elseif action == 'omgad' then
					local raison = 'omgad'
					TriggerServerEvent('sheriff:renfort', coords, raison)
					print(json.encode(ESX.PlayerData))
					TriggerServerEvent("iCore:sendCallMsg", "~g~Renfort demandé\n~s~de : ~b~" .. GetPlayerName(PlayerId()) .. "\n~s~Code : ~b~CODE 99\n~s~Importance : ~b~MAXIMALE", coords)
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

AddEventHandler('fl_sheriffjob:finishedPlacingSpeedzone', function()
	Citizen.Wait(200)
	OpensheriffActionsMenu()
end)

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
	ESX.TriggerServerCallback('fl_sheriffjob:getFineList', function(fines)
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

			ESX.ShowNotification(_U('fine_total', data.current.fineLabel))

			TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(player), 'society_sheriff', _U('fine_total', data.current.fineLabel), data.current.amount)

			ESX.SetTimeout(300, function()
				OpenFineMenu(player, category)
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
			ESX.TriggerServerCallback('fl_sheriffjob:getVehicleFromPlate', function(owner, found)
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

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('fl_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = bill.label,
				rightLabel = _U('armory_item', ESX.Math.GroupDigits(bill.amount)),
				rightLabelColor = 'red',
				billId = bill.id,
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'billing', {
			title = _U('unpaid_bills'),
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('fl_sheriffjob:getVehicleInfos', function(retrivedInfo)
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


AddEventHandler('fl_sheriffjob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction = 'menu_armory'
		CurrentActionMsg = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Stock' then
		CurrentAction = 'menu_stock'
		CurrentActionMsg = _U('open_stock')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction = 'menu_vehicle_spawner'
		CurrentActionMsg = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction = 'menu_boss_actions'
		CurrentActionMsg = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('fl_sheriffjob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(Config.sheriffStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end

end)

-- Display markers
CreateJobLoop('sheriff', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local isInMarker, hasExited, letSleep = false, false, true
	local currentStation, currentPart, currentPartNum

	for k,v in pairs(Config.sheriffStations) do

		for i=1, #v.Cloakrooms, 1 do
			local distance = #(coords - v.Cloakrooms[i])

			if distance < Config.DrawDistance then
				DrawMarker(27, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				letSleep = false
			end

			if distance < Config.MarkerSize.x then
				isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
			end
		end

		for i=1, #v.Armories, 1 do
			local distance = #(coords - v.Armories[i])

			if distance < Config.DrawDistance then
				DrawMarker(27, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
				letSleep = false
			end

			if distance < Config.MarkerSize.x then
				isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
			end
		end

		for i=1, #v.Stock, 1 do
			local distance = #(coords - v.Stock[i])

			if distance < Config.DrawDistance then
				DrawMarker(27, v.Stock[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
				letSleep = false
			end

			if distance < Config.MarkerSize.x then
				isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Stock', i
			end
		end

		if ESX.PlayerData.job.grade_name == 'boss' then
			for i=1, #v.BossActions, 1 do
				local distance = #(coords - v.BossActions[i])

				if distance < Config.DrawDistance then
					DrawMarker(27, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
				end
			end
		end
	end

	if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
		if
			(LastStation and LastPart and LastPartNum) and
			(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
		then
			TriggerEvent('fl_sheriffjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		end

		HasAlreadyEnteredMarker = true
		LastStation = currentStation
		LastPart = currentPart
		LastPartNum = currentPartNum

		TriggerEvent('fl_sheriffjob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
	end

	if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_sheriffjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
	end

	if letSleep then
		Citizen.Wait(500)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'sheriff' then
		OpensheriffActionsMenu()
	end
end)

CreateJobLoop('sheriff', function()
	if IsControlJustReleased(0, 38) and currentTask.busy then
		ESX.ShowNotification(_U('impound_canceled'))
		ESX.ClearTimeout(currentTask.task)
		ClearPedTasks(PlayerPedId())

		currentTask.busy = false
	end
end)
-- Key Controls
CreateJobLoop('sheriff', function()
	if CurrentAction then
		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'menu_cloakroom' then
				OpenCloakroomMenu()
			elseif CurrentAction == 'menu_armory' then
				OpenArmoryMenu(CurrentActionData.station)
			elseif CurrentAction == 'menu_stock' then
				OpenStockMenu(CurrentActionData.station)
			elseif CurrentAction == 'menu_vehicle_spawner' then
				OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
			elseif CurrentAction == 'delete_vehicle' then
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			elseif CurrentAction == 'menu_boss_actions' then
				ESX.UI.Menu.CloseAll()
				TriggerEvent('fl_society:openBossMenu', 'sheriff', function(data, menu)
					menu.close()

					CurrentAction = 'menu_boss_actions'
					CurrentActionMsg = _U('open_bossmenu')
					CurrentActionData = {}
				end, {})
			elseif CurrentAction == 'remove_entity' then
				DeleteEntity(CurrentActionData.entity)
			end

			CurrentAction = nil
		end
	end
end)

function OpenStockMenu(station)
	local elements = {
		{label = _U('remove_object'), value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'stock', {
		title = 'Stock & Saisies',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'sheriff')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'sheriff')
		end

	end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_stock'
		CurrentActionMsg = _U('open_stock')
		CurrentActionData = {station = station}
	end)
end

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end

	if not ESX.PlayerData.job then
		return false
	end

	for k,v in ipairs(Config.WhitelistedCops) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

RegisterNetEvent('sheriff:setBlip')
AddEventHandler('sheriff:setBlip', function(coords, raison)
	if raison == 'petit' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		-- ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-2\n~w~Importance: ~g~Légère.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 2
	elseif raison == 'importante' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		-- ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-3\n~w~Importance: ~o~Importante.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 47
	elseif raison == 'omgad' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
		-- ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-99\n~w~Importance: ~r~URGENTE !\nDANGER IMPORTANT', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
		color = 1
	end
	local blipId = AddBlipForCoord(coords)
	SetBlipSprite(blipId, 161)
	SetBlipScale(blipId, 1.2)
	SetBlipColour(blipId, color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Demande renfort')
	EndTextCommandSetBlipName(blipId)
	Wait(80 * 1000)
	RemoveBlip(blipId)
end)

RegisterNetEvent('sheriff:InfoService')
AddEventHandler('sheriff:InfoService', function(service, nom)
	if service == 'prise' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('SHERIFF INFORMATIONS', '~b~Prise de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-8\n~w~Information: ~g~Prise de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'fin' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('SHERIFF INFORMATIONS', '~b~Fin de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-10\n~w~Information: ~g~Fin de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'pause' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('SHERIFF INFORMATIONS', '~b~Pause de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-6\n~w~Information: ~g~Pause de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'standby' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('SHERIFF INFORMATIONS', '~b~Mise en standby', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-12\n~w~Information: ~g~Standby, en attente de dispatch.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'control' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('SHERIFF INFORMATIONS', '~b~Contrôle routier', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-48\n~w~Information: ~g~Contrôle routier en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'refus' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('SHERIFF INFORMATIONS', '~b~Refus d\'obtempérer', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-30\n~w~Information: ~g~Refus d\'obtempérer / Délit de fuite en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'crime' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('SHERIFF INFORMATIONS', '~b~Crime en cours', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-31\n~w~Information: ~g~Crime en cours / poursuite en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	end
end)

--function createBlipRenfort(coords)
--	if isPlayerWhitelisted then
--		print(coords)
--		--local ped = GetPlayerPed(id)
--		local alpha = 2500
--		--local blip = GetBlipFromEntity(ped)
--		local blipsRenfort = AddBlipForCoord(coords.x, coords.y, coords.z)
--
--
--		SetBlipSprite(blipsRenfort, 161)
--		SetBlipScale(blipsRenfort, 2.0) -- set scale
--		--SetBlipName(blipsRenfort, 'Demande de renfort')
--		SetBlipColour(blipsRenfort, 2)
--		SetBlipAlpha(blipsRenfort, alpha)
--
--		while alpha ~= 0 do
--			Citizen.Wait(10)
--			alpha = alpha - 1
--			SetBlipAlpha(blipsRenfort, alpha)
--
--			if alpha == 0 then
--				RemoveBlip(blipsRenfort)
--				return
--			end
--		end
--	end
--
--end

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	TriggerEvent('fl_sheriffjob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('fl_sheriffjob:spawned')
	end
	hasAlreadyJoined = true
end)

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	local playerPed = PlayerPedId()
	local vehicle = ESX.Game.GetVehicleInDirection()
	if IsPedInAnyVehicle(playerPed, true) then
	    vehicle = GetVehiclePedIsIn(playerPed, false)
	end
	local entity = vehicle
	carModel = GetEntityModel(entity)
	carName = GetDisplayNameFromVehicleModel(carModel)
	NetworkRequestControlOfEntity(entity)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(entity) do
	    Wait(100)
	    timeout = timeout - 100
	end

	SetEntityAsMissionEntity(entity, true, true)

	local timeout = 2000
	while timeout > 0 and not IsEntityAMissionEntity(entity) do
	    Wait(100)
	    timeout = timeout - 100
	end

	DeleteVehicle(entity)

	ESX.ShowNotification(_U('impound_successful'))
	currentTask.busy = false
end
