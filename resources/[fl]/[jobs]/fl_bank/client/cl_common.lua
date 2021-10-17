RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if job.name == 'banker' or job.name == 'police' then
		HideHoldUpBlips()
	else
		DisplayHoldUpBlips()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function (xPlayer)
	if xPlayer.job.name == 'banker' or xPlayer.job.name == 'police' then
		HideHoldUpBlips()
	else
		DisplayHoldUpBlips()
	end
end)

-- Markers --

hasAlreadyEnteredMarker = false
lastZone                = nil
CurrentAction           = nil
CurrentActionMsg        = ''

AddEventHandler('fl_bank:hasEnteredMarker', function (zone)
	if zone == 'BankActions' and ESX.PlayerData.job.name == 'banker' then
		CurrentAction     = 'bank_actions_menu'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu'
	end

	if zone == 'ATM' and IsPedOnFoot(PlayerPedId()) then
		CurrentAction     = 'atm_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_PICKUP~ pour interagir avec l\'~b~ATM'
	end

	if zone == 'Guichet' and IsPedOnFoot(PlayerPedId()) then
		CurrentAction     = 'guichet_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_PICKUP~ pour interagir avec le ~b~Guichet'
	end
end)

AddEventHandler('fl_bank:hasExitedMarker', function (zone)
	CurrentAction = nil
	CurrentActionMsg = nil
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		local sleep = true
		local playerCoords = GetEntityCoords(PlayerPedId())

		for _,Bank in pairs(Config.Banks) do
			if ESX.PlayerData.job.name == 'banker' then
				for _,ActionPosition in pairs(Bank.actionPositions) do
					if #(ActionPosition - playerCoords) < 20 then
						sleep = false
						DrawMarker(27, ActionPosition - vector3(0, 0, 0.95), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 0, 204, 100, false, true, 2, false, false, false, false)
					end
				end
			end

			for _,GuichetPosition in pairs(Bank.guichetPositions) do
				if #(GuichetPosition - playerCoords) < 20 then
					sleep = false
					DrawMarker(29, GuichetPosition, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 0, 10, false, true, 2, false, false, false, false)
				end
			end
		end

		if sleep then
			Citizen.Wait(500)
		end

		Citizen.Wait(0)
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		local playerCoords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for _,Bank in pairs(Config.Banks) do
			if ESX.PlayerData.job.name == 'banker' then
				for _,ActionPosition in pairs(Bank.actionPositions) do
					if #(ActionPosition - playerCoords) < 0.75 then
						isInMarker  = true
						currentZone = 'BankActions'
						break
					end
				end
			end

			for _,GuichetPosition in pairs(Bank.guichetPositions) do
				if #(GuichetPosition - playerCoords) < 1.0 then
					isInMarker  = true
					currentZone = 'Guichet'
					break
				end
			end
		end

		CurrentATM = nil
		for ATMCoord,ATM in pairs(Config.ATMLocations) do
			if #(ATMCoord - playerCoords) < 1.4 then
				isInMarker  = true
				currentZone = 'ATM'
				CurrentATM = ATM
				break
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone = currentZone
			TriggerEvent('fl_bank:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('fl_bank:hasExitedMarker', lastZone)
		end

		Citizen.Wait(300)
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg, true)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'bank_actions_menu' then
					OpenBankActionsMenu()
				end

				if CurrentAction == 'atm_actions_menu' then
					OpenGuichet()
				end

				if CurrentAction == 'guichet_actions_menu' then
					OpenGuichet()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)


-- Utils

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if outline then
		SetTextOutline()
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end