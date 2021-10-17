local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local isBarman = false
local isInMarker = false

function IsGradeBoss()
	return ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'viceboss'
end

function cleanPlayer(playerPed)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setClipset(playerPed, clip)
	RequestAnimSet(clip)
	while not HasAnimSetLoaded(clip) do
	Citizen.Wait(0)
	end
	SetPedMovementClipset(playerPed, clip, true)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
			if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
				setClipset(playerPed, "MOVE_M@POSH@")
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
			if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
				setClipset(playerPed, "MOVE_F@POSH@")
			end
		end
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()

	local elements = {
		{label = 'Garde robe perso', value = 'clotheshop'},
		{label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = _U('barman_outfit'), value = 'barman_outfit'},
		{label = _U('dancer_outfit_1'), value = 'dancer_outfit_1'},
		{label = _U('dancer_outfit_2'), value = 'dancer_outfit_2'},
		{label = _U('dancer_outfit_3'), value = 'dancer_outfit_3'},
		{label = _U('dancer_outfit_4'), value = 'dancer_outfit_4'},
		{label = _U('dancer_outfit_5'), value = 'dancer_outfit_5'},
		{label = _U('dancer_outfit_6'), value = 'dancer_outfit_6'},
		{label = _U('dancer_outfit_7'), value = 'dancer_outfit_7'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		elements = elements,
	}, function(data, menu)
		isBarman = false
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'barman_outfit' then
			setUniform(data.current.value, playerPed)
			isBarman = true
		elseif data.current.value == 'clotheshop' then
			TriggerEvent('fl_clotheshop:openNonEditableDessing')
		elseif data.current.value == 'dancer_outfit_1' or
			data.current.value == 'dancer_outfit_2' or
			data.current.value == 'dancer_outfit_3' or
			data.current.value == 'dancer_outfit_4' or
			data.current.value == 'dancer_outfit_5' or
			data.current.value == 'dancer_outfit_6' or
			data.current.value == 'dancer_outfit_7' then
			setUniform(data.current.value, playerPed)
		end

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
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vault', {
		title = _U('vault'),
		elements = {
			{label = _U('get_object'), value = 'get_stock'},
			{label = _U('put_object'), value = 'put_stock'}
		},
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'unicorn')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'unicorn')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_vault'
		CurrentActionMsg = _U('open_vault')
		CurrentActionData = {}
	end)
end

function OpenFridgeMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'fridge', {
		title = _U('fridge'),
		elements = {
			{label = _U('get_object'), value = 'get_stock'},
			{label = _U('put_object'), value = 'put_stock'}
		},
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			TriggerEvent('fl_society:openPutStocksMenu', 'unicorn_fridge')
		elseif data.current.value == 'get_stock' then
			TriggerEvent('fl_society:openGetStocksMenu', 'unicorn_fridge')
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
		{label = _U('billing'), value = 'billing'}
	}

	if isBarman or IsGradeBoss() then
		table.insert(elements, {label = _U('crafting'), value = 'menu_crafting'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'unicorn_actions', {
		title = _U('unicorn'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'billing' then
			OpenBillingMenu()
		elseif data.current.value == 'menu_crafting' then

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'menu_crafting', {
				title = _U('crafting'),
				elements = {
					{label = _U('jagerbomb'), value = 'jagerbomb'},
					{label = _U('golem'), value = 'golem'},
					{label = _U('whiskycoca'), value = 'whiskycoca'},
					{label = _U('vodkaenergy'), value = 'vodkaenergy'},
					{label = _U('vodkafruit'), value = 'vodkafruit'},
					{label = _U('rhumfruit'), value = 'rhumfruit'},
					{label = _U('teqpaf'), value = 'teqpaf'},
					{label = _U('rhumcoca'), value = 'rhumcoca'},
					{label = _U('mojito'), value = 'mojito'},
					{label = _U('mixapero'), value = 'mixapero'},
					{label = _U('metreshooter'), value = 'metreshooter'},
					{label = _U('jagercerbere'), value = 'jagercerbere'},
				}
			}, function(data2, menu2)
				TriggerServerEvent('fl_unicornjob:craftingCoktails', data2.current.value)
				animsAction({ lib = "mini@drinking", anim = "shots_barman_b" })
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function OpenBillingMenu()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title = _U('billing_amount')
	}, function(data, menu)
		local amount = tonumber(data.value)
		local player, distance = ESX.Game.GetClosestPlayer()

		if player ~= -1 and distance <= 3.0 then
			menu.close()
			if amount == nil then
				ESX.ShowNotification(_U('amount_invalid'))
			else
				TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(player), 'society_unicorn', _U('billing'), amount)
			end
		else
			ESX.ShowNotification(_U('no_players_nearby'))
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenShopMenu(zone)
	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		table.insert(elements, {
			label = item.label,
			realLabel = item.label,
			value = item.name,
			price = item.price,
			rightLabel = '$' .. item.price,
			rightLabelColor = 'red',
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'unicorn_shop', {
		title = _U('shop'),
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('fl_unicornjob:buyItem', data.current.value, data.current.price, data.current.realLabel)
	end, function(data, menu)
		menu.close()
	end)
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


AddEventHandler('fl_unicornjob:hasEnteredMarker', function(zone)
	if zone == 'BossActions' and IsGradeBoss() then
		CurrentAction = 'menu_boss_actions'
		CurrentActionMsg = _U('open_bossmenu')
		CurrentActionData = {}
	elseif zone == 'Cloakrooms' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionData = {}
	elseif zone == 'Vaults' then
		CurrentAction = 'menu_vault'
		CurrentActionMsg = _U('open_vault')
		CurrentActionData = {}
	elseif zone == 'Fridge' then
		CurrentAction = 'menu_fridge'
		CurrentActionMsg = _U('open_fridge')
		CurrentActionData = {}
	elseif zone == 'Flacons' or zone == 'NoAlcool' or zone == 'Apero' or zone == 'Ice' then
		CurrentAction = 'menu_shop'
		CurrentActionMsg = _U('shop_menu')
		CurrentActionData = {zone = zone}
	elseif zone == 'SellFarm' and IsGradeBoss() then
		CurrentAction = 'farm_resell'
		CurrentActionMsg = _U('press_sell')
		CurrentActionData = {zone = zone}
	end
end)

AddEventHandler('fl_unicornjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	if zone == 'SellFarm' then
		TriggerServerEvent('fl_unicornjob:stopSell')
	end
	CurrentAction = nil
end)

-- Display markers
CreateJobLoop('unicorn', function()
	local sleep = true
	local coords = GetEntityCoords(PlayerPedId())
	for k,v in pairs(Config.Zones) do
		if #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 200, 100, true, true, 2, false, false, false, false)
			sleep = false
		end
	end

	if sleep then
		Citizen.Wait(300)
	end
end)

-- Enter / Exit marker events
CreateJobLoop('unicorn', function()
	Wait(300)
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
		TriggerEvent('fl_unicornjob:hasEnteredMarker', currentZone)
	end

	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_unicornjob:hasExitedMarker', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(500)
	end
end)

-- Key Controls
CreateJobLoop('unicorn', function()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		if IsControlJustReleased(0,  38) then

			if CurrentAction == 'menu_cloakroom' then
				OpenCloakroomMenu()
			elseif CurrentAction == 'farm_resell' then
				TriggerServerEvent('fl_unicornjob:startSell', CurrentActionData.zone)
			elseif CurrentAction == 'menu_vault' then
				OpenVaultMenu()
			elseif CurrentAction == 'menu_fridge' then
				OpenFridgeMenu()
			elseif CurrentAction == 'menu_shop' then
				OpenShopMenu(CurrentActionData.zone)
			elseif CurrentAction == 'menu_boss_actions' and IsGradeBoss() then
				ESX.UI.Menu.CloseAll()

				TriggerEvent('fl_society:openBossMenu', 'unicorn', function(data, menu)
					menu.close()
					CurrentAction = 'menu_boss_actions'
					CurrentActionMsg = _U('open_bossmenu')
					CurrentActionData = {}
				end, {})
			end

			CurrentAction = nil
		end

	else
		Citizen.Wait(3000)
	end
end)

AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'unicorn' then
		OpenSocietyActionsMenu()
	end
end)
