-- Pole Emploi
local menuIsShowed, isInJoblistingMarker = false, false

function ShowJobListingMenu(data)
	ESX.TriggerServerCallback('fl_joblisting:getJobsList', function(data)
		local elements = {}
		for _, el in pairs(data) do
			table.insert(elements, {
					label = el.label,
					value = el.value,
				})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'joblisting', {
				title = 'Pôle-Emploi',
				elements = elements,
			},
			function(data, menu)
				TriggerServerEvent('fl_joblisting:setJob', data.current.value)
				ESX.ShowNotification('Félicitation ! Vous avez un nouveau job !')
				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)

	end)
end

AddEventHandler('fl_joblisting:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for i=1, #Config.ZonesPE, 1 do
			if #(coords - Config.ZonesPE[i]) < Config.DrawDistance then
				DrawMarker(23, Config.ZonesPE[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())
		isInJoblistingMarker  = false
		local currentZone = nil
		for i=1, #Config.ZonesPE, 1 do
			if(#(coords - Config.ZonesPE[i]) < 1.5) then
				isInJoblistingMarker  = true
				SetTextComponentFormat('STRING')
            	AddTextComponentString('Appuyez sur ~INPUT_PICKUP~ pour \naccéder au ~b~Pôle Emploi~s~.')
            	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInJoblistingMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInJoblistingMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('fl_joblisting:hasExitedMarker')
		end

		if not isInJoblistingMarker then
			Citizen.Wait(500)
		end
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isInJoblistingMarker and not menuIsShowed then
			if IsControlJustReleased(0, 38) then
				ShowJobListingMenu()
			end

		else
			Citizen.Wait(500)
		end
	end
end)