local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000

function ManageFuelUsage(vehicle)
	local vehicleFuelLevel = GetFuel(vehicle)

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, vehicleFuelLevel - Config.FuelUsage[ESX.Math.Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if GetPedInVehicleSeat(vehicle, -1) == ped and NetworkGetEntityIsNetworked(vehicle) then
				ManageFuelUsage(vehicle)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)
		local pumpObject, pumpDistance = ESX.Game.GetClosestObject(GetEntityCoords(PlayerPedId()), Config.PumpModels)

		if pumpDistance < 3.5 then
			isNearPump = pumpObject

			for k,v in ipairs(ESX.PlayerData.accounts) do
				if v.name == 'money' then
					currentCash = v.money
				end
			end
		else
			isNearPump = false
			Citizen.Wait(3000)
		end
	end
end)

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetFuel(vehicle)

	while isFueling do
		Citizen.Wait(500)

		local oldFuel = GetFuel(vehicle)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end

		currentCost = currentCost + extraCost

		if currentCash >= currentCost then
			SetFuel(vehicle, currentFuel)
		else
			isFueling = false
		end
	end

	if pumpObject then
		TriggerServerEvent('fuel:pay', currentCost)
	end

	currentCost = 0.0
end)

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(1000)
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
	ESX.Streaming.RequestAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)

	while isFueling do
		Citizen.Wait(1)

		for k,v in pairs(Config.DisableKeys) do
			DisableControlAction(0, v)
		end

		local vehicleCoords = GetEntityCoords(vehicle)

		if pumpObject then
			local stringCoords = GetEntityCoords(pumpObject)
			local extraString = "\n" .. Config.Strings.TotalCost .. ": ~g~$" .. ESX.Math.Round(currentCost, 1)

			ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.CancelFuelingPump .. extraString, 0.35)
			ESX.Game.Utils.DrawText3D(vehicleCoords + vector3(0, 0, 0.5), ESX.Math.Round(currentFuel, 1) .. "%", 0.35)
		else
			ESX.Game.Utils.DrawText3D(vehicleCoords + vector3(0, 0, 0.5), Config.Strings.CancelFuelingJerryCan .. "\nGas can: ~g~" .. ESX.Math.Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) .. "% | Vehicle: " .. ESX.Math.Round(currentFuel, 1) .. "%", 0.35)
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local ped = PlayerPedId()

		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)

				ESX.Game.Utils.DrawText3D(pumpCoords + vector3(0, 0, 1.2), Config.Strings.ExitVehicle, 0.35)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)

				if DoesEntityExist(vehicle) and #(GetEntityCoords(ped) - vehicleCoords) < 2.5 then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords

							if GetAmmoInPedWeapon(ped, 883325847) < 100 then
								canFuel = false
							end
						end

						if GetFuel(vehicle) < 95 and canFuel then
							if currentCash > 0 then
								ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.EToRefuel, 0.35)

								if IsControlJustReleased(0, 38) then
									isFueling = true

									ESX.Streaming.RequestAnimDict("timetable@gardener@filling_can")
									TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
								end
							else
								ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.NotEnoughCash, 0.35)
							end
						elseif not canFuel then
							ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.JerryCanEmpty, 0.35)
						else
							ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.FullTank, 0.35)
						end
					end
				elseif isNearPump then
					local stringCoords = GetEntityCoords(isNearPump)

					if currentCash >= Config.JerryCanCost then
						if not HasPedGotWeapon(ped, 883325847) then
							ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.PurchaseJerryCan, 0.35)

							if IsControlJustReleased(0, 38) then
								TriggerServerEvent('fuel:pay', Config.JerryCanCost)
								TriggerServerEvent('fuel:giveJerrycan')

								for k,v in ipairs(ESX.PlayerData.accounts) do
									if v.name == 'money' then
										currentCash = v.money
									end
								end
							end
						else
							local refillCost = ESX.Math.Round(Config.RefillCost * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))

							if refillCost > 0 then
								if currentCash >= refillCost then
									ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.RefillJerryCan .. refillCost, 0.35)

									if IsControlJustReleased(0, 38) then
										TriggerServerEvent('fuel:pay', refillCost)

										SetPedAmmo(ped, 883325847, 4500)
									end
								else
									ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.NotEnoughCashJerryCan, 0.35)
								end
							else
								ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.JerryCanFull, 0.35)
							end
						end
					else
						ESX.Game.Utils.DrawText3D(stringCoords + vector3(0, 0, 1.2), Config.Strings.NotEnoughCash, 0.35)
					end
				else
					Citizen.Wait(250)
				end
			end
		else
			Citizen.Wait(250)
		end
	end
end)

Citizen.CreateThread(function()
	for _,v in pairs(Config.GasStations) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite(blip, 361)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 1)
		SetBlipDisplay(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Station-service")
		EndTextCommandSetBlipName(blip)
	end
end)

function GetFuel(vehicle)
	local vehicleStateBag = Entity(vehicle).state

	if vehicleStateBag.fuel == nil or vehicleStateBag.fuel.fuelLevel == nil then
		print('Creating new fuel state from random')

		if GetVehicleClass(vehicle) == 16 then -- Helico
			return SetFuel(vehicle, 100)
		end
		return SetFuel(vehicle, GetVehicleFuelLevel(vehicle))
	end

	return tonumber(vehicleStateBag.fuel.fuelLevel)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		Entity(vehicle).state:set('fuel', { fuelLevel = fuel }, true)
		return fuel
	end

	error('SetFuel() misusage : ' .. ESX.DumpTable(fuel))
end