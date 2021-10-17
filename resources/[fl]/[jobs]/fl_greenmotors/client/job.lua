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
		if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'chief' or ESX.PlayerData.job.grade_name == 'coboss' then
			return true
		end
		return false
	end
end

function OpenVaultMenu()
	local elements = {
		{label = _U('get_object'), value = 'get_stock'},
		{label = _U('put_object'), value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'native', GetCurrentResourceName(), 'vault',
		{
		title = _U('vault'),
		elements = elements,
		},
		function(data, menu)
			if data.current.value == 'put_stock' then
				TriggerEvent('fl_society:openPutStocksMenu', 'greenmotors')
			end

			if data.current.value == 'get_stock' then
				TriggerEvent('fl_society:openGetStocksMenu', 'greenmotors')
			end
		end,
		function(data, menu)
			menu.close()

			CurrentAction = 'menu_vault'
			CurrentActionMsg = _U('open_vault')
			CurrentActionData = {}
		end
	)
end

function OpenSocietyActionsMenu()
	local elements = {
		{label = _U('billing'), value = 'billing'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'native', GetCurrentResourceName(), 'greenmotors_actions',
	{
		title = _U('greenmotors'),
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'billing' then
			OpenBillingMenu()
		end
	end,
	function(data, menu)
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
				TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(player), 'society_greenmotors', _U('billing'), amount)
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


AddEventHandler('fl_greenmotors:hasEnteredMarker', function(zone)
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
end)

AddEventHandler('fl_greenmotors:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Display markers
CreateJobLoop('greenmotors', function()
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
CreateJobLoop('greenmotors', function()
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
		TriggerEvent('fl_greenmotors:hasEnteredMarker', currentZone)
	end

	if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('fl_greenmotors:hasExitedMarker', LastZone)
	end

	if not isInMarker then
		Citizen.Wait(300)
	end
end)

-- Key Controls
CreateJobLoop('greenmotors', function()
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

			if CurrentAction == 'menu_boss_actions' and IsChiefOrBoss() then
				ESX.UI.Menu.CloseAll()

				TriggerEvent('fl_society:openBossMenu', 'greenmotors', function(data, menu)
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
	if society == 'greenmotors' then
		OpenSocietyActionsMenu()
	end
end)