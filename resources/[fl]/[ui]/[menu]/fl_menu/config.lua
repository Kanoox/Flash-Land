Config = {}

-- LANGUAGE --
Config.Locale = 'fr'

-- GENERAL --
Config.MenuTitle = 'FreeLife' -- change it to you're server name
Config.NoclipSpeed = 1.5 -- change it to change the speed in noclip
Config.JSFourIDCard = true -- enable if you're using jsfour-idcard

-- CONTROLS --
Config.Controls = {
	Pointing = {keyboard = 29}, -- B
	Crouch = {keyboard = 36}, -- CTRL
	StopTasks = {keyboard = 73}, -- X
	TPMarker = {keyboard1 = 36, keyboard2 = 45} -- CTRL F6
}

-- GPS --
Config.GPS = {
	{label = 'Aucun', coords = nil},
	{label = 'Poste de Police', coords = vector2(425.13, -979.55)},
	{label = 'Garage Central', coords = vector2(-449.67, -340.83)},
	{label = 'Hôpital', coords = vector2(-33.88, -1102.37)},
	{label = 'Concessionnaire', coords = vector2(215.06, -791.56)},
	{label = 'Benny\'s Custom', coords = vector2(-212.13, -1325.27)},
	{label = 'Pôle Emploi', coords = vector2(-264.83, -964.54)},
	{label = 'Auto école', coords = vector2(-829.22, -696.99)},
	{label = 'Téquila-la', coords = vector2(-565.09, 273.45)},
	{label = 'Bahama Mamas', coords = vector2(-1391.06, -590.34)}
}

-- ADMIN --
Config.Admin = {

	{
		name = 'goto',
		label = _U('admin_goto_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)

				if type(plyId) == 'number' then
					TriggerServerEvent('fl_menu:Admin_Move', plyId, GetPlayerServerId(PlayerId()))
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'goto',
		label = _U('admin_goto_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)

				if type(plyId) == 'number' then
					TriggerServerEvent('fl_menu:Admin_Move', plyId, GetPlayerServerId(PlayerId()))
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'bring',
		label = _U('admin_bring_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)

				if type(plyId) == 'number' then
					TriggerServerEvent('fl_menu:Admin_Move', plyId)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'tpxyz',
		label = _U('admin_tpxyz_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local pos = KeyboardInput('KORIOZ_BOX_XYZ', _U('dialogbox_xyz'), '', 50)

			if pos ~= nil and pos ~= '' then
				local _, _, x, y, z = string.find(pos, '([%d%.]+) ([%d%.]+) ([%d%.]+)')

				if x ~= nil and y ~= nil and z ~= nil then
					ESX.Game.Teleport(plyPed, vector3(x + .0, y + .0, z + .0))
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'godmode',
		label = _U('admin_godmode_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			Player.godmode = not Player.godmode

			if Player.godmode then
				SetEntityInvincible(plyPed, true)
				ESX.ShowNotification(_U('admin_godmodeon'))
			else
				SetEntityInvincible(plyPed, false)
				ESX.ShowNotification(_U('admin_godmodeoff'))
			end
		end
	},
	{
		name = 'ghostmode',
		label = _U('admin_ghostmode_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			Player.ghostmode = not Player.ghostmode

			if Player.ghostmode then
				SetEntityVisible(plyPed, false, false)
				ESX.ShowNotification(_U('admin_ghoston'))
			else
				SetEntityVisible(plyPed, true, false)
				ESX.ShowNotification(_U('admin_ghostoff'))
			end
		end
	},
	{
		name = 'spawnveh',
		label = _U('admin_spawnveh_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local modelName = KeyboardInput('KORIOZ_BOX_VEHICLE_NAME', _U('dialogbox_vehiclespawner'), '', 50)

			if modelName ~= nil then
				modelName = tostring(modelName)

				if type(modelName) == 'string' then
					ESX.Game.SpawnVehicle(modelName, GetEntityCoords(plyPed), GetEntityHeading(plyPed), function(vehicle)
						TaskWarpPedIntoVehicle(plyPed, vehicle, -1)
					end)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'repairveh',
		label = _U('admin_repairveh_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local plyVeh = GetVehiclePedIsIn(plyPed, false)
			SetVehicleFixed(plyVeh)
			SetVehicleDirtLevel(plyVeh, 0.0)
		end
	},
	{
		name = 'flipveh',
		label = _U('admin_flipveh_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local plyCoords = GetEntityCoords(plyPed)
			local newCoords = plyCoords + vector3(0.0, 2.0, 0.0)
			local closestVeh = GetClosestVehicle(plyCoords, 10.0, 0, 70)

			SetEntityCoords(closestVeh, newCoords)
			ESX.ShowNotification(_U('admin_vehicleflip'))
		end
	},
	{
		name = 'givemoney',
		label = _U('admin_givemoney_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

			if amount ~= nil then
				amount = tonumber(amount)

				if type(amount) == 'number' then
					TriggerServerEvent('fl_menu:Admin_give', 'money', amount)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'givebank',
		label = _U('admin_givebank_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

			if amount ~= nil then
				amount = tonumber(amount)

				if type(amount) == 'number' then
					TriggerServerEvent('fl_menu:Admin_give', 'bank', amount)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'givedirtymoney',
		label = _U('admin_givedirtymoney_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

			if amount ~= nil then
				amount = tonumber(amount)

				if type(amount) == 'number' then
					TriggerServerEvent('fl_menu:Admin_give', 'black_money', amount)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'showxyz',
		label = _U('admin_showxyz_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			Player.showCoords = not Player.showCoords
		end
	},
	{
		name = 'showname',
		label = _U('admin_showname_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			Player.showName = not Player.showName

			local playerPed = PlayerPedId()
			if Player.showName then
				Citizen.CreateThread(function()
					while Player.showName do
						for k, v in ipairs(ESX.Game.GetPlayers()) do
							local otherPed = GetPlayerPed(v)
			
							if otherPed ~= playerPed then
								if #(GetEntityCoords(playerPed, false) - GetEntityCoords(otherPed, false)) < 5000.0 then
									playersName[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
								else
									RemoveMpGamerTag(playersName[v])
									playersName[v] = nil
								end
							end
						end
						Wait(1)
					end
				end)
			else
				for k, v in ipairs(ESX.Game.GetPlayers()) do
					local otherPed = GetPlayerPed(v)
					if otherPed ~= playerPed then
						RemoveMpGamerTag(playersName[v])
						playersName[v] = nil
					end
				end
			end
		end
	},
	{
		name = 'tpmarker',
		label = _U('admin_tpmarker_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local waypointHandle = GetFirstBlipInfoId(8)

			if DoesBlipExist(waypointHandle) then
				Citizen.CreateThread(function()
					local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
					local foundGround, zCoords, zPos = false, -500.0, 0.0

					while not foundGround do
						zCoords = zCoords + 10.0
						RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
						Citizen.Wait(0)
						foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

						if not foundGround and zCoords >= 2000.0 then
							foundGround = true
						end
					end

					SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
					ESX.ShowNotification(_U('admin_tpmarker'))
				end)
			else
				ESX.ShowNotification(_U('admin_nomarker'))
			end
		end
	},
	{
		name = 'revive',
		label = _U('admin_revive_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)

				if type(plyId) == 'number' then
					TriggerServerEvent('fl_ambulancejob:revive', plyId)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'changeskin',
		label = _U('admin_changeskin_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			RageUI.CloseAll()
			Citizen.Wait(100)
			TriggerEvent('fl_skin:openSaveableMenu')
		end
	}
}