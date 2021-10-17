-- Markers --

hasAlreadyEnteredMarker = false
lastZone                = nil
CurrentAction           = nil
CurrentActionMsg        = ''
CurrentActionData        = nil

AddEventHandler('fl_simcard:hasEnteredMarker', function (zone, data)
	if zone == 'ShopActions' and IsPedOnFoot(PlayerPedId()) then
		CurrentAction     = 'shop_actions_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_PICKUP~ pour faire des achats'
		CurrentActionData = data
	end
end)

AddEventHandler('fl_simcard:hasExitedMarker', function (zone, data)
	CurrentAction = nil
	CurrentActionMsg = nil
	CurrentActionData = nil
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		local sleep = true
		local playerCoords = GetEntityCoords(PlayerPedId())

		for _,Shop in pairs(Config.Shops) do
			if #(Shop.shop - playerCoords) < 20 then
				sleep = false
				DrawMarker(29, Shop.shop, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 0, 200, 10, false, true, 2, false, false, false, false)
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
		local currentData = nil

		for _,Shop in pairs(Config.Shops) do
			if #(Shop.shop - playerCoords) < 1.0 then
				isInMarker  = true
				currentZone = 'ShopActions'
				currentData = Shop
				break
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone                = currentZone
			TriggerEvent('fl_simcard:hasEnteredMarker', currentZone, currentData)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('fl_simcard:hasExitedMarker', lastZone, currentData)
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
				if CurrentAction == 'shop_actions_menu' then
					OpenShopMenu(CurrentActionData)
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