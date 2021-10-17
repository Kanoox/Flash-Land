local LocationsCarWash = {
	vector3(26.5906, -1392.0261, 27.3634),
	vector3(167.1034, -1719.4704, 27.2916),
	vector3(-74.5693, 6427.8715, 29.4400),
	vector3(-699.6325, -932.7043, 17.0139)
}

Citizen.CreateThread(function()
	for _, carWashLocation in pairs(LocationsCarWash) do
		local blip = AddBlipForCoord(carWashLocation)
		SetBlipSprite(blip, 100)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Lavage Auto')
		EndTextCommandSetBlipName(blip)
	end

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for _, carWashLocation in pairs(LocationsCarWash) do
					local distance = #(coords - carWashLocation)

					if distance < 50 then
						DrawMarker(1, carWashLocation, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, false, false, 2, false, false, false, false)
						canSleep = false
					end

					if distance < 5 then
						ESX.ShowHelpNotification('Appuyer sur ~INPUT_CONTEXT~ pour laver votre véhicule pour ~g~$' .. ESX.Math.GroupDigits(Config.WasherPrice) .. '~s~')

						if IsControlJustReleased(0, 38) then
							local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

							if GetVehicleDirtLevel(vehicle) > 2 then
								ESX.TriggerServerCallback('fl_controlvehicle:carWashCanAfford', function(canAfford)
									if canAfford then
										local vehicle = GetVehiclePedIsIn(PlayerPedId())
										SetVehicleDirtLevel(vehicle, 0.0)
									end
									Citizen.Wait(5000)
								end)
							else
								ESX.ShowNotification('Votre véhicule n\'a pas besoin de se faire laver')
							end
						end
					end
				end
			end
		end

		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)