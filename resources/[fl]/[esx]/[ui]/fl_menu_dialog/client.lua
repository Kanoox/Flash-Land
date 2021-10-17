Citizen.CreateThread(function()
	local GUI = {}
	GUI.Time = 0

	local MenuType = 'dialog'
	local OpenedMenus = {}

	local openMenu = function(namespace, name, data)
		OpenedMenus[namespace .. '_' .. name] = true

		SendNUIMessage({
			action = 'openMenu',
			namespace = namespace,
			name = name,
			data = data,
		})

		ESX.SetTimeout(200, function()
			SetNuiFocus(true, true)
		end)
	end

	local closeMenu = function(namespace, name)
		OpenedMenus[namespace .. '_' .. name] = nil
		local OpenedMenuCount                 = 0

		SendNUIMessage({
			action = 'closeMenu',
			namespace = namespace,
			name = name,
			data = data,
		})

		for k,v in pairs(OpenedMenus) do
			if v then
				OpenedMenuCount = OpenedMenuCount + 1
			end
		end

		if OpenedMenuCount == 0 then
			SetNuiFocus(false)
		end
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu == nil then
			print('No menu opened...')
		end

		if menu and menu.submit then
			menu.submit(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu == nil then
			print('No menu opened...')
		end

		if menu and menu.cancel then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu == nil then
			print('No menu opened...')
		end

		if menu and menu.change then
			menu.change(data, menu)
		end

		cb('OK')
	end)

	Citizen.CreateThread(function()
		while true do
			Wait(0)

			local OpenedMenuCount = 0

			for k,v in pairs(OpenedMenus) do
				if v then
					OpenedMenuCount = OpenedMenuCount + 1
				end
			end

			if OpenedMenuCount > 0 then
				DisableControlAction(0, 1, true) -- LookLeftRight
				DisableControlAction(0, 2, true) -- LookUpDown
				DisableControlAction(0, 142, true) -- MeleeAttackAlternate
				DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
				DisableControlAction(0, 12, true) -- WeaponWheelUpDown
				DisableControlAction(0, 14, true) -- WeaponWheelNext
				DisableControlAction(0, 15, true) -- WeaponWheelPrev
				DisableControlAction(0, 16, true) -- SelectNextWeapon
				DisableControlAction(0, 17, true) -- SelectPrevWeapon
			end
		end
	end)

end)