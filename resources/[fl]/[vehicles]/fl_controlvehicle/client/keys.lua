function OpenCloseVehicle()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true)

	if IsPedDeadOrDying(playerPed, true) then return end

	local vehicle = nil
	local currentlyInVehicle = false

	if IsPedInAnyVehicle(playerPed,  false) then
		currentlyInVehicle = true
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
	end

	ESX.TriggerServerCallback('fl_controlvehicle:myKey', function(gotkey)
		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 or locked == 0 then -- if unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
			elseif locked == 2 then -- if locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
			end

			if not currentlyInVehicle then
				ESX.Streaming.RequestModel(`p_car_keys_01`, function()
					local KeyFobObject = CreateObject(`p_car_keys_01`, 0, 0, 0, true, true, true)
					SetEntityCollision(KeyFobObject, false, false)

					AttachEntityToEntity(KeyFobObject, playerPed, GetPedBoneIndex(playerPed, 57005), 0.09, 0.03, -0.02, -76.0, 13.0, 28.0, false, true, true, true, 0, true);
					SetModelAsNoLongerNeeded(`p_car_keys_01`);

					SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true);
					ClearPedTasks(playerPed);
					TaskTurnPedToFaceEntity(playerPed, vehicle, 500);

					for i = 1,2 do
						local timer = GetGameTimer()
						while GetGameTimer() - timer < 50 do
							SoundVehicleHornThisFrame(vehicle);
							Citizen.Wait(0)
						end
						Citizen.Wait(50)
					end

					local animDict = "anim@mp_player_intmenu@key_fob@"
					ESX.Streaming.RequestAnimDict(animDict, function()
						TaskPlayAnim(playerPed, animDict, 'fob_click', 8.0, 8.0, -1, 50, 0, false, false, false)
						--player.Character.Task.PlayAnimation(animDict, "fob_click", 3f, 1000, AnimationFlags.UpperBodyOnly);
						PlaySoundFromEntity(-1, "Remote_Control_Fob", playerPed, "PI_Menu_Sounds", true, 0);
						Citizen.Wait(1250)
						ClearPedTasks(playerPed)
						DetachEntity(KeyFobObject, false, false);
						DeleteObject(KeyFobObject);
						RemoveAnimDict(animDict);
					end)
				end)
			end
		else
			ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end

RegisterCommand('+lockvehicle', function()
	OpenCloseVehicle()
end, false)
RegisterCommand('-lockvehicle', function() end, false)

RegisterNetEvent('fl_controlvehicle:openKeysMenu')
AddEventHandler('fl_controlvehicle:openKeysMenu', function()
    ESX.TriggerServerCallback('fl_controlvehicle:getAllKeys', function(mykey)
	 	local elements = {}
		for i=1, #mykey, 1 do
			local txt = 'Véhicule : '
			if mykey[i].NB == 2 then
				txt = '[DOUBLE] ' .. txt
			end

			table.insert(elements, {label = txt.. ' [' .. tostring(mykey[i].plate) .. ']', plate = mykey[i].plate, NB = mykey[i].NB})
		end


	    ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mykey1', {
			title = 'Mes clés',
			elements = elements
		}, function(data2, menu2) --Submit Cb
		        if data2.current.NB == 1 then
		        	ESX.UI.Menu.CloseAll()
		  			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'mykey2', {
						title = 'Voulez vous ?',
						elements = {
								{label = 'Vendre Voiture', value = 'donnerkey'}, -- Donner les clés
								{label = 'Prêter Clé', value = 'preterkey'}, -- Donner les clés
					  		},
			  		}, function(data3, menu3) --Submit Cb
                        local player, distance = ESX.Game.GetClosestPlayer()

                        if distance ~= -1 and distance <= 3.0 then
                           if data3.current.value == 'donnerkey' then
                               ESX.UI.Menu.CloseAll()
                                TriggerServerEvent('fl_controlvehicle:changeOwner', GetPlayerServerId(player), data2.current.plate)
                          elseif data3.current.value == 'preterkey' then
                               ESX.UI.Menu.CloseAll()
                                TriggerServerEvent('fl_controlvehicle:lendKey', GetPlayerServerId(player), data2.current.plate)
                          end
                         else
                           ESX.ShowNotification('~r~Vous devez être près de quelqu\'un pour lui donner les clés')
                        end
		       	    end, function(data3, menu3) --Cancel Cb
                        menu3.close()
		       		end)
		        end
	    end, function(data2, men2) --Cancel Cb
	        men2.close()
	    end)
    end)
end)

RegisterNetEvent('lock')
AddEventHandler('lock', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true)

	if GetVehiclePedIsEntering(playerPed) ~= 0 then
		ESX.ShowNotification('~r~Vous êtes en train d\'entrer dans un véhicule')
		return
	end

	local vehicle = nil

	if IsPedInAnyVehicle(playerPed,  false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		local nearVehicle, distance = ESX.Game.GetClosestVehicle(coords)
		if distance < 7 then
			vehicle = nearVehicle
		else
			ESX.ShowNotification('~r~Aucun véhicule autour de vous...')
			return
		end
	end

	ESX.TriggerServerCallback('fl_controlvehicle:myKey', function(gotkey)
		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 or locked == 0 then
				Citizen.CreateThread(function()
					repeat
						NetworkRequestControlOfEntity(vehicle)
						SetVehicleDoorsLocked(vehicle, 2)
						Citizen.Wait(0)
					until GetVehicleDoorLockStatus(vehicle) == 2
					PlayVehicleDoorCloseSound(vehicle, 1)
					ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
				end)
			elseif locked == 2 then -- if locked
				Citizen.CreateThread(function()
					repeat
						NetworkRequestControlOfEntity(vehicle)
						SetVehicleDoorsLocked(vehicle, 1)
						Citizen.Wait(0)
					until GetVehicleDoorLockStatus(vehicle) == 1
					PlayVehicleDoorOpenSound(vehicle, 0)
					ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
				end)
			end
		else
			ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end)

RegisterNetEvent('lockLights')
AddEventHandler('lockLights', function()
local vehicle = saveVehicle
	StartVehicleHorn(vehicle, 100, 1, false)
	SetVehicleLights(vehicle, 2)
	Wait (200)
	SetVehicleLights(vehicle, 0)
	StartVehicleHorn(vehicle, 100, 1, false)
	Wait (200)
	SetVehicleLights(vehicle, 2)
	Wait (400)
	SetVehicleLights(vehicle, 0)
end)