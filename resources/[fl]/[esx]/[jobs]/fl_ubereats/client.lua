local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local isInMarker = false
local hintIsShowed = false
local hintToDisplay = "no hint to display"

function IsChiefOrBoss()
	if ESX.PlayerData ~= nil then
		if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'chief' then
			return true
		end
		return false
	end
end

function CleanPlayer(playerPed)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function SetClipset(playerPed, clip)
	RequestAnimSet(clip)
	while not HasAnimSetLoaded(clip) do
	Citizen.Wait(0)
	end
	SetPedMovementClipset(playerPed, clip, true)
end

function SetUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)

	if skin.sex == 0 then
		if Config.Uniforms[job].male ~= nil then
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
		else
			ESX.ShowNotification(_U('no_outfit'))
		end
	else
		if Config.Uniforms[job].female ~= nil then
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
		else
			ESX.ShowNotification(_U('no_outfit'))
		end
	end

	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()

	local elements = {
		{label = 'Garde robe perso', value = 'clotheshop'},
		{label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = _U('ubereats_outfit'), value = 'ubereats_outfit'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		elements = elements,
	}, function(data, menu)
		CleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'clotheshop' then
			TriggerEvent('fl_clotheshop:openNonEditableDessing')
		end

		SetUniform(data.current.value, playerPed)

		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionData = {}

	end, function(data, menu)
		menu.close()
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenVaultMenu()
	local elements = {
		{label = _U('get_object'), value = 'get_stock'},
		{label = _U('put_object'), value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vault', {
		title = _U('vault'),
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'ubereats')
		end

		if data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'ubereats')
		end
	end,
	function(data, menu)
		menu.close()

		CurrentAction = 'menu_vault'
		CurrentActionMsg = _U('open_vault')
		CurrentActionData = {}
	end)
end

function OpenFridgeMenu()
	local elements = {
		{label = _U('get_object'), value = 'get_stock'},
		{label = _U('put_object'), value = 'put_stock'}
	}
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'fridge', {
		title = _U('fridge'),
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'ubereats_fridge')
		end

		if data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'ubereats_fridge')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_fridge'
		CurrentActionMsg = _U('open_fridge')
		CurrentActionData = {}
	end)
end

function OpenSocietyActionsMenu()
	local elements = {
		{label = _U('billing'), value = 'billing'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'ubereats_actions', {
		title = _U('ubereats'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'billing' then
			OpenBillingMenu()
		end
	end, function(data, menu)
		menu.close()
	end)

end

function OpenBillingMenu()
	ESX.UI.Menu.Open(
	'dialog', GetCurrentResourceName(), 'billing',
	{
		title = _U('billing_amount')
	},
	function(data, menu)
		local amount = tonumber(data.value)
		local player, distance = ESX.Game.GetClosestPlayer()

		if player ~= -1 and distance <= 3.0 then
			menu.close()
			if amount == nil then
				ESX.ShowNotification(_U('amount_invalid'))
			else
				TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(player), 'society_ubereats', _U('billing'), amount)
			end
		else
			ESX.ShowNotification(_U('no_players_nearby'))
		end
	end,
	function(data, menu)
		menu.close()
	end
	)
end

function animsAction(animObj)
	Citizen.CreateThread(function()
		if not playAnim then
			local playerPed = PlayerPedId();
			if DoesEntityExist(playerPed) then -- Check if ped exist
				dataAnim = animObj

				-- Play Animation
				RequestAnimDict(dataAnim.lib)
				while not HasAnimDictLoaded(dataAnim.lib) do
					Citizen.Wait(0)
				end
				if HasAnimDictLoaded(dataAnim.lib) then
					local flag = 0
					if dataAnim.loop ~= nil and dataAnim.loop then
						flag = 1
					elseif dataAnim.move ~= nil and dataAnim.move then
						flag = 49
					end

					TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
					playAnimation = true
				end

				-- Wait end animation
				repeat
					Citizen.Wait(0)
				until IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3)

				playAnim = false
				TriggerEvent('ft_animation:ClFinish')
			end -- end ped exist
		end
	end)
end


AddEventHandler('fl_ubereats:hasEnteredMarker', function(zone)
	if zone == 'BossActions' and IsChiefOrBoss() then
		CurrentAction = 'menu_boss_actions'
		CurrentActionMsg = _U('open_bossmenu')
		CurrentActionData = {}
	end

	if zone == 'Cloakrooms' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionData = {}
	end

	if zone == 'Vaults' then
		CurrentAction = 'menu_vault'
		CurrentActionMsg = _U('open_vault')
		CurrentActionData = {}
	end

	if zone == 'Fridge' then
		CurrentAction = 'menu_fridge'
		CurrentActionMsg = _U('open_fridge')
		CurrentActionData = {}
	end
end)

AddEventHandler('fl_ubereats:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Display markers
CreateJobLoop('ubereats', function()
	local sleep = true
	local coords = GetEntityCoords(PlayerPedId())
	for k,v in pairs(Config.Zones) do
		if v.Type ~= -1 and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, true, true, 2, false, false, false, false)
			sleep = false
		end
	end

	if sleep then
		Citizen.Wait(300)
	end
end)

-- Enter / Exit marker events
CreateJobLoop('ubereats', function()
	Citizen.Wait(100)
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
		TriggerEvent('fl_ubereats:hasEnteredMarker', currentZone)
	end

	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_ubereats:hasExitedMarker', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(300)
	end
end)

-- Key Controls
CreateJobLoop('ubereats', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		if IsControlJustReleased(0,  38) then
			if CurrentAction == 'menu_cloakroom' then
				OpenCloakroomMenu()
			end

			if CurrentAction == 'menu_vault' then
				OpenVaultMenu()
			end

			if CurrentAction == 'menu_fridge' then
				OpenFridgeMenu()
			end

			if CurrentAction == 'menu_boss_actions' and IsChiefOrBoss() then
				ESX.UI.Menu.CloseAll()

				TriggerEvent('fl_society:openBossMenu', 'ubereats', function(data, menu)
					menu.close()
					CurrentAction = 'menu_boss_actions'
					CurrentActionMsg = _U('open_bossmenu')
					CurrentActionData = {}
				end, {})
			end

			CurrentAction = nil
		end
	else
		Citizen.Wait(500)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'ubereats' then
		OpenSocietyActionsMenu()
	end
end)