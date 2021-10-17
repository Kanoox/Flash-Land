local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg  = ''
local Blips = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()


	RMenu.Add('rubenammu', 'menu', RageUI.CreateMenu("", "Intéraction", 0, 0, 'casinoui_slots_diamond', 'casinoui_slots_diamond', 110, 0, 50, 0))
	RMenu.Add('rubenammuachat', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammustockobjet', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammustockarme', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammuprendrearme', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammudeposerarme', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammuprendrestockobjet', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammudeposerstockobjet', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammuboss', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
    RMenu.Add('rubenammulspd', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
	RMenu.Add('rubenammubcso', 'menu', RageUI.CreateSubMenu(RMenu.Get('rubenammu', 'menu'), ""))
end)

local ammunation_item = {
	vector3(21.694, -1106.739, 28.79)
}

Citizen.CreateThread(function()
	RMenu.Add('armurerie', 'achat_item', RageUI.CreateMenu("Armurerie", "Ammunation", 0, 0, 'commonmenu', 'interaction_bgd', 110, 0, 50, 0))
    while true do
        Citizen.Wait(0)
        for k in pairs(ammunation_item) do
            local ply = GetPlayerPed(-1)
            local plyCoords = GetEntityCoords(ply, false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ammunation_item[k].x, ammunation_item[k].y, ammunation_item[k].z)
    
            if dist <= 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ pour intéragir avec l'armurerie")
                if IsControlJustReleased(1,51) then
                    RageUI.Visible(RMenu.Get('armurerie', 'achat_item'), true)
                end
            end
            if dist <= 25 then
                DrawMarker(1, ammunation_item[k].x, ammunation_item[k].y, ammunation_item[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
            end
        end
        if RageUI.Visible(RMenu.Get('armurerie', 'achat_item')) then
			AchatAmmu()
		end
    end
end)

function AchatAmmu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Separator("~y~Equipement disponible")
		RageUI.Button("Kevlar", nil, {RightLabel = "~g~7500$"}, true, function(Hovered, Active, Selected)
			if (Selected) then
				TriggerServerEvent("ruben:achat", "bullet4", 1, 7500)
			end
		end)
		RageUI.Button("Boite de 45 ACP", nil, {RightLabel = "~g~100$"}, true, function(Hovered, Active, Selected)
			if (Selected) then
				TriggerServerEvent("ruben:achat", "pistol_ammo_box", 1, 100)
			end
		end)
	end)
end

function OpenAmmuActionsMenu()
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'}
	}

	 if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'second' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss'  then
	table.insert(elements, {label = 'Prendre Stock', value = 'get_stock'})
	end

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'Ammu_actions',
		{
			title = _U('ammunation'),
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
				TriggerEvent('fl_society:openPutStocksMenu', 'ammunation')
			elseif data.current.value == 'get_stock' then
				TriggerEvent('fl_society:openGetStocksMenu', 'ammunation')
			elseif data.current.value == 'boss_actions' then
				TriggerEvent('fl_society:openBossMenu', 'ammunation', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'ammu_actions_menu'
			CurrentActionMsg  = _U('open_actions')
			end
	)
end

function OpenAmmuHarvestMenu()

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name ~= 'stagiaire' and ESX.PlayerData.job.name == 'ammunation' then
		local elements = {
			{label = 'Carbone', value = 'carbone_recolt'},
		{label = 'Acier', value = 'acier_recolt'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'native', GetCurrentResourceName(), 'ammu_harvest',
			{
				title = _U('harvest'),
				elements = elements
			},
			function(data, menu)
				if data.current.value == 'carbone_recolt' then
					menu.close()
					TriggerServerEvent('fl_ammunation:startHarvest')
				end

		if data.current.value == 'acier_recolt' then
					menu.close()
					TriggerServerEvent('fl_ammunation:startHarvest2')
				end

			end,
			function(data, menu)
				menu.close()
				CurrentAction = 'ammu_harvest_menu'
				CurrentActionMsg  = _U('harvest_menu')
			end
		)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMobileAmmuActionsMenu()
	ESX.UI.Menu.CloseAll()

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'second' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'mobile_ammu_actions',
		{
			title = _U('ammunation'),
			elements = {
			{label = _U('billing'),    value = 'billing'},
			{label = 'Permis de port d\'arme',    value = 'license'},
			}
		},
		function(data, menu)
			if data.current.value == 'billing' then
			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'billing',
				{
				title = _U('invoice_amount')
				},
				function(data, menu)
				local amount = tonumber(data.value)
				if amount == nil then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification(_U('no_players_nearby'))
					else
					TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ammunation', _U('ammunation'), amount)
					end
				end
				end,
			function(data, menu)
				menu.close()
			end
			)
			end

			if data.current.value == 'license' then

			ESX.UI.Menu.Open(
				'native', GetCurrentResourceName(), 'citizen_interaction',
				{
				title = 'Licences',
				elements = {
					{label = 'Permis de port d\'arme', value = 'tier1'}
				},
				},
				function(data2, menu2)

				local player, distance = ESX.Game.GetClosestPlayer()

				if player ~= -1 and distance <= 3.0 then

					if data2.current.value == 'tier1' then
						TriggerServerEvent('fl_ammunation:givelicence', GetPlayerServerId(player), 'weapon')
					end

				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end

				end,
				function(data2, menu2)
				menu2.close()
				end
			)

			end
		end,
		function(data, menu)
		menu.close()
		end
		)
	else
		ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'mobile_ammu_actions',
		{
			title = _U('ammunation'),
			elements = {
				{label = _U('billing'),    value = 'billing'},
			}
		},
		function(data, menu)
			if data.current.value == 'billing' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = _U('invoice_amount')
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification(_U('amount_invalid'))
						else
							menu.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification(_U('no_players_nearby'))
							else
								TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ammunation', _U('ammunation'), amount)
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
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	refreshBlips()
end)

AddEventHandler('fl_ammunation:hasEnteredMarker', function(zone)
	if zone == 'AmmunationActions' then
		CurrentAction     = 'ammu_actions_menu'
		CurrentActionMsg  = _U('open_actions')
	elseif zone == 'Matos' then
		CurrentAction     = 'ammu_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
	elseif zone == 'Poudre' then
		CurrentAction     = 'poudre_harvest'
		CurrentActionMsg  = _U('poudre_menu')
	elseif zone == 'Douille' then
		CurrentAction     = 'douille_harvest'
		CurrentActionMsg  = _U('douille_menu')
	elseif zone == 'Revente' then
		CurrentAction     = 'resell'
		CurrentActionMsg  = _U('resell_menu')
	elseif zone == 'Craft' then
	  CurrentAction = 'ammu_craft_menu'
	  CurrentActionMsg = _U('craft_menu')
	end

end)

AddEventHandler('fl_ammunation:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	elseif zone == 'Matos' then
		TriggerServerEvent('fl_ammunation:stopHarvest')
		TriggerServerEvent('fl_ammunation:stopHarvest2')
		TriggerServerEvent('fl_ammunation:stopHarvest3')
	elseif zone == 'Poudre' then
		TriggerServerEvent('fl_ammunation:stopHarvestMunition')
	elseif zone == 'Douille' then
		TriggerServerEvent('fl_ammunation:stopHarvestMunition2')
	elseif zone == 'Revente' then
		TriggerServerEvent('fl_ammunation:stopVenteMunition')
	end

  if zone == 'Craft' then
	TriggerServerEvent('fl_ammunation:stopTransformMunition')
	TriggerServerEvent('fl_ammunation:stopCraft')
  end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

function refreshBlips()
	if ESX.PlayerData.job.name ~= 'ammunation' then return end
	local zones = {}
	local blipInfo = {}

	local blip = AddBlipForCoord(121.23, -3212.40, 6.0)
	SetBlipSprite (blip, 566)
	SetBlipDisplay(blip, 4)
	SetBlipScale (blip, 0.75)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Ammunation - Fabrication d'armes")
	EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(1736.26, 3327.5, 40.22)
	SetBlipSprite (blip, 478)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.75)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Ammunation - Matériels")
	EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(2572.25, 292.76, 107.7349)
	SetBlipSprite (blip, 549)
	SetBlipDisplay(blip, 4)
	SetBlipScale (blip, 0.75)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Ammunation - Poudre")
	EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(1689.71, 3757.49, 33.70)
	SetBlipSprite (blip, 549)
	SetBlipDisplay(blip, 4)
	SetBlipScale (blip, 0.75)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Ammunation - Douille")
	EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(612.09, -3075.18, 5.06)
	SetBlipSprite (blip, 549)
	SetBlipDisplay(blip, 4)
	SetBlipScale (blip, 0.75)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Ammunation - Revente")
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(refreshBlips)

-- Enter / Exit marker events
CreateJobLoop('ammunation', function()
	Wait(100)
	local coords = GetEntityCoords(PlayerPedId())
	local isInMarker = false
	local currentZone = nil
	for k,v in pairs(Config.Zones) do
		if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
			isInMarker = true
			currentZone = k
		end
	end
	if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('fl_ammunation:hasEnteredMarker', currentZone)
	end
	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_ammunation:hasExitedMarker', LastZone)
	end
end)

CreateJobLoop('ammunation', function()
	local coords = GetEntityCoords(PlayerPedId())

	for k,v in pairs(Config.Zones) do
		if v.Type and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < 30 then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
		end
	end

	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'ammu_actions_menu' then
				OpenAmmuActionsMenu()
			elseif CurrentAction == 'ammu_harvest_menu' then
				OpenAmmuHarvestMenu()
			elseif CurrentAction == 'poudre_harvest' then
				TriggerServerEvent('fl_ammunation:startHarvestMunition')
			elseif CurrentAction == 'douille_harvest' then
				TriggerServerEvent('fl_ammunation:startHarvestMunition2')
			elseif CurrentAction == 'resell' then
				TriggerServerEvent('fl_ammunation:startVenteMunition')
			elseif CurrentAction == 'ammu_craft_menu' then
				if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'second' then
					OpenAmmuCraftMenu()
				end
			end

			CurrentAction = nil
		end
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'ammunation' then
		OpenMobileAmmuActionsMenu()
	end
end)

function OpenAmmuCraftMenu()
	if ESX.PlayerData.job.grade_name == 'recrue' or ESX.PlayerData.job.grade_name == 'employé' or ESX.PlayerData.job.name ~= 'ammunation' then
		ESX.ShowNotification(_U('not_experienced_enough'))
		return
	end

	local elements = {
		{label = 'Munition de pistolet', value = 'pistol_ammo'},
	}

	for weapon,price in pairs(Config.Price) do
		table.insert(elements, {label = _U('weapon_' .. weapon) .. ' $' .. price, value = weapon})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'ammu_craft',
		{
			title = _U('craft'),
			elements = elements
		},
		function(data, menu)
			local playerPed = PlayerPedId()
			menu.close()
			SetEntityHeading(playerPed, 96.47)
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 15000, true)

			if data.current.value == 'pistol_ammo' then
				TriggerServerEvent('fl_ammunation:startCraft', data.current.value)
			else
				TriggerServerEvent('fl_ammunation:startCraft', data.current.value)
			end
		end,
		function(data, menu)
			menu.close()
			CurrentAction = 'ammu_craft_menu'
			CurrentActionMsg = _U('craft_menu')
			end
	)
end

RegisterNetEvent('fl_ammunation:stopAnim')
AddEventHandler('fl_ammunation:stopAnim', function()
	ClearPedTasksImmediately(PlayerPedId())
end)