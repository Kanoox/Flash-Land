local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentDrug = nil
local CurrentType = nil

AddEventHandler('fl_drugs:hasEnteredMarker', function()
	ESX.UI.Menu.CloseAll()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == "police" then return end

	CurrentAction = CurrentDrug .. '_' .. CurrentType
	CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ' .. _(CurrentType) .. ' la ' .. CurrentDrug
end)

AddEventHandler('fl_drugs:hasExitedMarker', function()
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('fl_drugs:stop')
end)

Citizen.CreateThread(function()
	while true do
		Wait(200)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false

		for _,DrugData in pairs(Config.Zones) do
			for typeDrug, data in pairs(DrugData) do
				if type(data) == 'vector3' then
					local size = 3
					if CurrentType == 'harvest' then
						size = DrugData.size
					end

					if #(coords - DrugData[typeDrug]) < size then
						isInMarker = true
						CurrentDrug = DrugData.drug
						CurrentType = typeDrug
					end
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone = currentZone
			TriggerEvent('fl_drugs:hasEnteredMarker')
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('fl_drugs:hasExitedMarker')
		end

		if not isInMarker then
			Citizen.Wait(400)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg, true)
			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('fl_drugs:start' .. CurrentType:gsub("^%l", string.upper), CurrentDrug)
				CurrentAction = nil
			end
		else
			Citizen.Wait(400)
		end
	end
end)