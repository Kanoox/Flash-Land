-- Objects
Citizen.CreateThread(function()
	while true do
		for _,Object in pairs(ESX.Game.GetObjects()) do
			local modelHash = GetEntityModel(Object)

			for _,FreezedHash in pairs(Config.FreezedHashes) do
				if modelHash == FreezedHash then
					FreezeEntityPosition(Object, true)
				end
			end

			for _,DoorsHash in pairs(Config.FleecaDoors) do
				if modelHash == DoorsHash then
					SetEntityCoords(Object, 0, 0, 0, 0, 0, 0, 0)
				end
			end

			for _,ATMHash in pairs(Config.ATMProps) do
				if modelHash == ATMHash then
					local ObjectCoord = GetEntityCoords(Object)
					if not Config.ATMLocations[ObjectCoord] then
						Config.ATMLocations[ObjectCoord] = {ObjectCoord = ObjectCoord, Money = Config.MoneyInAtm + math.random(0, Config.MoneyVariation)}
						--print('Detected new atm at ' .. tostring(ObjectCoord) .. ' with ' .. Config.ATMLocations[ObjectCoord].Money .. ' $')

						local atmBlip = AddBlipForCoord(ObjectCoord)
						SetBlipSprite(atmBlip, 431)
						SetBlipDisplay(atmBlip, 5)
						SetBlipScale(atmBlip, 0.5)
						SetBlipColour(atmBlip, 2)
						SetBlipAsShortRange(atmBlip, true)

						Config.ATMLocations[ObjectCoord].Blip = atmBlip
					end
				end
			end
		end

		Citizen.Wait(6000)
	end
end)

RegisterNetEvent('fl_bank:updateMoneyAtm')
AddEventHandler('fl_bank:updateMoneyAtm', function(ATMCoords, Amount)
	if not Config.ATMLocations[ATMCoords] then
		Config.ATMLocations[ATMCoords] = {ObjectCoord = ATMCoords, Money = Config.MoneyInAtm + math.random(0, Config.MoneyVariation)}
	end

	Config.ATMLocations[ATMCoords].Money = Config.ATMLocations[ATMCoords].Money + Amount
end)