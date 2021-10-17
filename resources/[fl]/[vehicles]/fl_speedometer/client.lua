local ind = {l = false, r = false}
local hide = false

AddEventHandler('ui:toggle', function(doShow)
	hide = not doShow
	SendNUIMessage({
		showhud = false,
	})
end)

Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and not hide then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then

				-- Speed
				SendNUIMessage({
					showhud = true,
					speed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				})

				-- Lights
				_,feuPosition,feuRoute = GetVehicleLightsState(PedCar)
				if(feuPosition == 1 and feuRoute == 0) then
					SendNUIMessage({
						feuPosition = true
					})
				else
					SendNUIMessage({
						feuPosition = false
					})
				end
				if(feuPosition == 1 and feuRoute == 1) then
					SendNUIMessage({
						feuRoute = true
					})
				else
					SendNUIMessage({
						feuRoute = false
					})
				end

			else
				SendNUIMessage({
					showhud = false,
				})
				Citizen.Wait(1000)
			end
		else
			SendNUIMessage({
				showhud = false,
			})
			Citizen.Wait(1000)
		end

		Citizen.Wait(100)
	end
end)

-- Consume fuel factor
Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then

				SendNUIMessage({
					showfuel = true,
					fuel = GetVehicleFuelLevel(PedCar)
				})
			end
			Citizen.Wait(4000)
		end

		Citizen.Wait(2000)
	end
end)