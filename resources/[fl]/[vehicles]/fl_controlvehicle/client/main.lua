-- Regulateur
local cruise = 0

RegisterCommand('-cruisespeed', function()end, false)
RegisterCommand('+cruisespeed', function()
	if cruise == 0 then
		TriggerEvent('pv:setCruiseSpeed')
	else
		cruise = 0
		ESX.ShowNotification('Limitateur: ~r~ INACTIF~s~')
	end
end, false)

AddEventHandler('pv:setCruiseSpeed', function()
	print('setCruiseSpeed')
	local playerPed = PlayerPedId()

	if not IsPedInAnyVehicle(playerPed, false) then
		return
	end

	if IsPedInAnyBoat(playerPed) then
		ESX.ShowNotification('~r~Ce bateau ne possède pas de limitateur !')
		return
	end

	local cruiseVeh = GetVehiclePedIsIn(playerPed, false)

	if GetEntitySpeedVector(cruiseVeh, true)['y'] <= 0 then
		cruise = 0
		ESX.ShowNotification('~r~Vous êtes à l\'arrêt...')
		return
	end

	cruise = GetEntitySpeed(cruiseVeh)
	local cruiseKm  = math.floor(cruise * 3.6 + 0.5)

	ESX.ShowNotification('Limitateur: ~g~ ACTIF~w~ - ~b~ ' .. cruiseKm ..' km/h')

	Citizen.CreateThread(function()
		while cruise > 0 and GetPedInVehicleSeat(cruiseVeh, -1) == playerPed do
			if IsVehicleOnAllWheels(cruiseVeh) and GetEntitySpeed(cruiseVeh) > cruise then
				SetVehicleForwardSpeed(cruiseVeh, cruise)
			end
			Citizen.Wait(50)
		end
		cruise = 0
	end)
end)

--[[
local ControlLoop = false
function ControlVehicle(currentVehicle)
	SetPedCanBeDraggedOut(GetPedInVehicleSeat(currentVehicle, -1), false)

	local lock = GetVehicleDoorLockStatus(currentVehicle)
	if lock == 7 then
		SetVehicleDoorsLocked(currentVehicle, 2)
	end

	if ControlLoop then return end

	local ped = PlayerPedId()
	while GetVehiclePedIsIn(ped) == currentVehicle do
		Citizen.Wait(0)
		DisableVehicleRoll(ped, currentVehicle)
		ControlLoop = true
	end
	ControlLoop = false
end

AddEventHandler('baseevents:enteringVehicle', ControlVehicle)
AddEventHandler('baseevents:enteredVehicle', ControlVehicle)

function DisableVehicleRoll(ped, currentVehicle)
	local inAir = IsEntityInAir(currentVehicle)
	local model = GetEntityModel(currentVehicle)
	if inAir then
		-- If it's not a boat, plane or helicopter, and the vehilce is off the ground with ALL wheels, then block steering/leaning left/right/up/down.
		if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABike(model) and not IsThisModelABicycle(model) then
			DisableControlAction(0, 59) -- leaning left/right
			DisableControlAction(0, 60) -- leaning up/down
		end
	end

	if GetPedInVehicleSeat(currentVehicle, -1) == ped and not IsThisModelABike(model) and not IsThisModelABicycle(model) then
		local roll = GetEntityRoll(currentVehicle)

		if roll > 75.0 or roll < -75.0 then
			DisableControlAction(2, 59, true)
			DisableControlAction(2, 60, true)
			if not inAir and GetEntitySpeed(currentVehicle) < 0.15 then
				SetVehicleEngineOn(currentVehicle, false)
			end
		end
	end
end
-]]

-- C O N F I G --
local interactionDistance = 3.5 --The radius you have to be in to interact with the vehicle.

-- E N G I N E --
IsEngineOn = true
RegisterNetEvent('engine')
AddEventHandler('engine',function()
	local player = PlayerPedId()

	if (IsPedSittingInAnyVehicle(player)) then
		local vehicle = GetVehiclePedIsIn(player,false)

		if IsEngineOn then
			IsEngineOn = false
			SetVehicleEngineOn(vehicle,false,false,false)
		else
			IsEngineOn = true
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
		end

		while not IsEngineOn do
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
		end
	end
end)

-- T R U N K --
RegisterNetEvent('trunk')
AddEventHandler('trunk',function()
	local player = PlayerPedId()
	vehicle = GetVehiclePedIsIn(player,true)

	local isopen = GetVehicleDoorAngleRatio(vehicle,5)
	local distanceToVeh = #(GetEntityCoords(player) - GetEntityCoords(vehicle))

	if distanceToVeh <= interactionDistance then
		if (isopen == 0) then
			SetVehicleDoorOpen(vehicle,5,0,0)
		else
			SetVehicleDoorShut(vehicle,5,0)
		end
	else
		ESX.ShowNotification("~r~Vous devez être près de votre véhicule !")
	end
end)
-- R E A R  D O O R S --
RegisterNetEvent('rdoors')
AddEventHandler('rdoors',function()
	local player = PlayerPedId()
	vehicle = GetVehiclePedIsIn(player,true)
	local isopen = GetVehicleDoorAngleRatio(vehicle, 0) and GetVehicleDoorAngleRatio(vehicle, 1) or GetVehicleDoorAngleRatio(vehicle, 2) and GetVehicleDoorAngleRatio(vehicle, 3)
	local distanceToVeh = #(GetEntityCoords(player) - GetEntityCoords(vehicle))

	if distanceToVeh <= interactionDistance then
		if (isopen == 0) then
			SetVehicleDoorOpen(vehicle, 0, 0)
			SetVehicleDoorOpen(vehicle, 1, 0)
			SetVehicleDoorOpen(vehicle, 2, 0)
			SetVehicleDoorOpen(vehicle, 3, 0)
		else
			SetVehicleDoorShut(vehicle, 0, 0)
			SetVehicleDoorShut(vehicle, 1, 0)
			SetVehicleDoorShut(vehicle, 2, 0)
			SetVehicleDoorShut(vehicle, 3, 0)
		end
	else
		ESX.ShowNotification("~r~You must be near your vehicle to do that.")
	end
end)

-- H O O D --
RegisterNetEvent('hood')
AddEventHandler('hood',function()
	local player = PlayerPedId()
	vehicle = GetVehiclePedIsIn(player,true)

	local isopen = GetVehicleDoorAngleRatio(vehicle,4)
	local distanceToVeh = #(GetEntityCoords(player) - GetEntityCoords(vehicle))

	if distanceToVeh <= interactionDistance then
		if (isopen == 0) then
		SetVehicleDoorOpen(vehicle,4,0,0)
		else
		SetVehicleDoorShut(vehicle,4,0)
		end
	else
		ESX.ShowNotification("~r~You must be near your vehicle to do that.")
	end
end)
