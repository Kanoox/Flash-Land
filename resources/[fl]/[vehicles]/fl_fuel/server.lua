math.randomseed(os.time())

RegisterNetEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price)

	if price > 0 then
		xPlayer.removeMoney(amount)
		xPlayer.showNotification('Vous avez payé ~g~$' .. ESX.Math.GroupDigits(amount))
	end
end)

RegisterNetEvent('fuel:giveJerrycan')
AddEventHandler('fuel:giveJerrycan', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('petrolcan', 1)
end)

Citizen.CreateThread(function()
	while true do
		for _,vehicleId in pairs(GetAllVehicles()) do
			if DoesEntityExist(vehicleId) then
				local vehicleState = Entity(vehicleId).state
				if vehicleState.fuel == nil then
					vehicleState:set('fuel', {fuelLevel = math.random(20, 80)}, true)
				end
			end
		end
		Citizen.Wait(3000)
	end
end)