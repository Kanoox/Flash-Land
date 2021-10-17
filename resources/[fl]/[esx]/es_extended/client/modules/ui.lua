ESX.UI = {}
ESX.UI.Menu = {}
ESX.UI.Menu.RegisteredTypes = {}
ESX.UI.Menu.Opened = {}

ESX.UI.Menu.RegisterType = function(menuType, open, close)
	ESX.UI.Menu.RegisteredTypes[menuType] = {
		open   = open,
		close  = close,
	}
end

ESX.UI.Menu.Open = function(menuType, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = menuType
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()
		ESX.UI.Menu.RegisteredTypes[menuType].close(namespace, name)

		for i=1, #ESX.UI.Menu.Opened, 1 do
			if ESX.UI.Menu.Opened[i] then
				if ESX.UI.Menu.Opened[i].type == menuType and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
					ESX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end
	end

	menu.update = function(query, newData)
		local anyMatch = false
		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				anyMatch = true
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

		if not anyMatch then
			print('No matching element with data : ' .. ESX.Dump(query))
		end

	end

	menu.refresh = function()
		ESX.UI.Menu.RegisteredTypes[menuType].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, newElement)
		menu.data.elements[i] = newElement
	end

	menu.setElementValue = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setElements = function(newElements)
		menu.data.elements = newElements
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(ESX.UI.Menu.Opened, menu)
	ESX.UI.Menu.RegisteredTypes[menuType].open(namespace, name, data)

	return menu
end

ESX.UI.Menu.Close = function(menuType, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == menuType and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				ESX.UI.Menu.Opened[i].close()
				ESX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

ESX.UI.Menu.CloseAll = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			ESX.UI.Menu.Opened[i].close()
		end
	end

	ESX.UI.Menu.Opened = {}
	SetNuiFocus(false)
end

ESX.UI.Menu.GetOpened = function(menuType, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == menuType and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.GetOpenedNamespace = function(namespace)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			if ESX.UI.Menu.Opened[i].namespace == namespace then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.IsOpenNamespace = function(namespace)
	return ESX.UI.Menu.GetOpenedNamespace(namespace) ~= nil
end

ESX.UI.Menu.CloseNamespace = function(namespace)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i].namespace == namespace then
			ESX.UI.Menu.Opened[i].close()
			ESX.UI.Menu.Opened[i] = nil
		end
	end
end

ESX.UI.Menu.HasAnyMenuOpen = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			return true
		end
	end

	return false
end

ESX.UI.Menu.GetOpenedMenus = function()
	return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(menuType, namespace, name)
	return ESX.UI.Menu.GetOpened(menuType, namespace, name) ~= nil
end

ESX.UI.ShowInventoryItemNotification = function(add, item, count)
	local prepText = tostring(count) .. ' ' .. tostring(item.label)
	if add then prepText = '+' .. prepText else prepText = '-' .. prepText end

	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(prepText)
	DrawSubtitleTimed(2000, 1)
end

AddEventHandler('onResourceStop', function(resourceName)
	ESX.UI.Menu.CloseNamespace(resourceName)
end)