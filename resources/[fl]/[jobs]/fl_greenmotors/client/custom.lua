local Vehicles, myCar = {}, {}
local lsMenuIsShowed, isInLSMarker = false, false

Citizen.CreateThread(function()
	ESX.TriggerServerCallback('fl_greenmotors:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('fl_greenmotors:installMod')
AddEventHandler('fl_greenmotors:installMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('fl_greenmotors:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('fl_greenmotors:cancelInstallMod')
AddEventHandler('fl_greenmotors:cancelInstallMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

function OpenLSMenu(elems, menuName, menuTitle, parent)
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), menuName,
	{
		title = menuTitle,
		elements = elems
	}, function(data, menu)
		local isRimMod, found = false, false
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

		if data.current.modType == "modFrontWheels" then
			isRimMod = true
		end

		for k,v in pairs(Config.Menus) do
			if k == data.current.modType or isRimMod then
				if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
					ESX.ShowNotification(_U('already_own', data.current.label))
					TriggerEvent('fl_greenmotors:installMod')
				else
					local vehiclePrice = 50000

					for i=1, #Vehicles, 1 do
						if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
							vehiclePrice = Vehicles[i].price
							break
						end
					end

					if isRimMod then
						price = math.floor(vehiclePrice * data.current.price / 100)
						TriggerServerEvent("fl_greenmotors:buyMod", price)
					elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
						price = math.floor(vehiclePrice * v.price[data.current.modNum + 1] / 100)
						TriggerServerEvent("fl_greenmotors:buyMod", price)
					else
						price = math.floor(vehiclePrice * v.price / 100)
						TriggerServerEvent("fl_greenmotors:buyMod", price)
					end
				end

				menu.close()
				found = true
				break
			end
		end

		if not found then
			GetAction(data.current)
		end
	end, function(data, menu) -- on cancel
		menu.close()
		TriggerEvent('fl_greenmotors:cancelInstallMod')

		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDoorsShut(vehicle, false)

		if parent == nil then
			lsMenuIsShowed = false
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			FreezeEntityPosition(vehicle, false)
			myCar = {}
		end
	end, function(data, menu) -- on change
		UpdateMods(data.current)
	end)
end

function UpdateMods(data)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	if data.modType ~= nil then
		local props = {}

		if data.wheelType ~= nil then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end

		if data.modType == 'modFrontWheels' then
			props['modBackWheels'] = data.modNum
		end

		print('UpdateMods : ' .. tostring(data.modType) .. ' -> ' .. tostring(data.modNum))
		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data)
	local elements = {}
	local menuName = ''
	local menuTitle = ''
	local parent = nil

	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local vehiclePrice = 50000

	for i=1, #Vehicles, 1 do
		if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end

	for k,v in pairs(Config.Menus) do

		if data.value == k then

			menuName = k
			menuTitle = v.label
			parent = v.parent

			if v.modType ~= nil then

				if v.modType == 22 then
					table.insert(elements, {label = _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- disable neon
					table.insert(elements, {label = _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = _U('by_default'), modType = k, modNum = num})
				elseif v.modType == 17 then
					table.insert(elements, {label = _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 48 then
				   table.insert(elements, {label = _U('by_default'), modType = k, modNum = -1})
				elseif v.modType == 23 then
					table.insert(elements, {label = _U('by_default'), modType = 'modFrontWheels', modNum = -1})
				else
					table.insert(elements, {label = _U('by_default'), modType = k, modNum = 0})
				end

				local _label = ''
				local _rightLabel = ''
				local _rightLabelColor = ''

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						if j == currentMods.modHorns then
							_label = GetHornName(j)
							_rightLabel = _U('installed')
							_rightLabelColor = 'blue'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetHornName(j)
							_rightLabel = '$' .. price
							_rightLabelColor = 'green'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j)
							_rightLabel = _U('installed')
							_rightLabelColor = 'cornflowerblue'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetPlatesName(j)
							_rightLabel = '$' .. price
							_rightLabelColor = 'green'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
					end
				elseif v.modType == 22 then -- NEON
					if currentMods.modXenon then
						_label = 'Xenon'
						_rightLabel = _U('installed')
						_rightLabelColor = 'cornflowerblue'
					else
						price = math.floor(vehiclePrice * v.price / 100)
						_label = 'Xenon'
						_rightLabel = '$' .. price
						_rightLabelColor = 'green'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = math.floor(vehiclePrice * v.price / 100)
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = neons[i].label,
							rightLabel = '$' .. price,
							rightLabelColor = 'green',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						price = math.floor(vehiclePrice * v.price / 100)
						_label = colors[j].label
						_rightLabel = '$' .. price
						_rightLabelColor = 'green'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						if j == currentMods.modHorns then
							_label = GetWindowName(j)
							_rightLabel = _U('installed')
							_rightLabelColor = 'cornflowerblue'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetWindowName(j)
							_rightLabel = '$' .. price
							_rightLabelColor = 'green'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName)
								_rightLabel = _U('installed')
								_rightLabelColor = 'cornflowerblue'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName)
								_rightLabel = '$' .. price
								_rightLabelColor = 'green'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 1, modCount, 1 do
						if j == currentMods[k] then
							_label = _U('level', j+1)
							_rightLabel = _U('installed')
							_rightLabelColor = 'cornflowerblue'
						else
							price = math.floor(vehiclePrice * v.price[j+1] / 100)
							_label = _U('level', j+1)
							_rightLabel = '$' .. price
							_rightLabelColor = 'green'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
						if j == modCount-1 then
							break
						end
					end
				elseif v.modType == 17 then -- TURBO
					if currentMods[k] then
						_label = 'Turbo'
						_rightLabel = _U('installed')
						_rightLabelColor = 'cornflowerblue'
					else
						_label = 'Turbo'
						_rightLabel = '$' .. math.floor(vehiclePrice * v.price / 100)
						_rightLabelColor = 'green'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
				elseif v.modType == 48 then -- LIVERY
					local modCount = GetVehicleLiveryCount(vehicle)
					if modCount == -1 then modCount = 9 end
					for j = 0, modCount, 1 do
						if j == currentMods[k] then
							_label = 'Autocollant ' .. j .. ''
							_rightLabel = _U('installed')
							_rightLabelColor = 'cornflowerblue'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = 'Autocollant ' .. j
							_rightLabel = '$' .. price
							_rightLabelColor = 'green'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
					end
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							if j == currentMods[k] then
								_label = GetLabelText(modName)
								_rightLabel = _U('installed')
								_rightLabelColor = 'cornflowerblue'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName)
								_rightLabel = '$' .. price
								_rightLabelColor = 'green'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j, rightLabel = _rightLabel, rightLabelColor = _rightLabelColor})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then

							local addedLabel = ''

							if k == 'cosmetics' then
								local numModif = GetNumVehicleMods(vehicle, Config.Menus[l].modType)

								if Config.Menus[l].modType == 48 then
									numModif = GetVehicleLiveryCount(vehicle)
								end

								if Config.Menus[l].modType == 22 then numModif = 1 end

								if Config.Menus[l].modType == nil or
								   Config.Menus[l].modType == 'plateIndex' or
								   Config.Menus[l].modType == 'neonColor' or
								   Config.Menus[l].modType == 'windowTint' then
									numModif = '-'
								end

								addedLabel = '' .. tostring(numModif) .. ''
							end
							table.insert(elements, {label = w, rightLabel = addedLabel, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		if a.label == _U('by_default') then return true end
		if b.label == _U('by_default') then return false end
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local coords = GetEntityCoords(PlayerPedId())
			local currentZone = nil
			local zone = nil
			local lastZone = nil
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'greenmotors' then
				for k,v in pairs(Config.Zones) do
					if #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x and v.Name ~= nil then
						isInLSMarker  = true
						ESX.ShowHelpNotification(v.Hint)
						break
					else
						isInLSMarker  = false
					end
				end
			end

			if IsControlJustReleased(0, 38) and not lsMenuIsShowed and isInLSMarker then
				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'greenmotors' then
					lsMenuIsShowed = true

					local vehicle = GetVehiclePedIsIn(playerPed, false)
					FreezeEntityPosition(vehicle, true)

					myCar = ESX.Game.GetVehicleProperties(vehicle)

					ESX.UI.Menu.CloseAll()
					GetAction({value = 'main'})
				end
			end

			if isInLSMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
			end

			if not isInLSMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
			end

		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if lsMenuIsShowed then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 166, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)
