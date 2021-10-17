local MenuType = 'native'

local NativesMenu = {}
local FocusMenu = {}

Citizen.CreateThread(function()
	ESX.UI.Menu.RegisterType(MenuType, function(namespace, name, data)
		if NativesMenu[namespace] == nil then NativesMenu[namespace] = {} end
		table.insert(FocusMenu, {namespace = namespace, name = name})
		local thisMenu = RageUI.CreateMenu(data.title, data.description or ' ')
		NativesMenu[namespace][name] = thisMenu

		thisMenu.onIndexChange = function(Index)
			local esxMenu = ESX.UI.Menu.GetOpened(MenuType, namespace, name)
			for i, element in pairs(esxMenu.data.elements) do
				esxMenu.setElementValue(i, 'selected', false)
				element.selected = false
			end
			esxMenu.setElementValue(Index, 'selected', true)
			local elementData = esxMenu.data.elements[Index]
			elementData.selected = true

			if esxMenu.change then
				esxMenu.change({
					current = elementData,
					elements = esxMenu.data.elements
				}, esxMenu)
			end
		end

		thisMenu.Closed = function()
			local esxMenu = ESX.UI.Menu.GetOpened(MenuType, namespace, name)
			if esxMenu.cancel then
				esxMenu.cancel({}, esxMenu)
			end
		end

	end, function(namespace, name)
		for i, Focus in pairs(FocusMenu) do
			if Focus.namespace == namespace and Focus.name == name then
				table.remove(FocusMenu, i)
			end
		end
		NativesMenu[namespace][name] = nil
	end, true)
end)

Citizen.CreateThread(function()
	while true do
		for _, NameSpace in pairs(NativesMenu) do
			for _, Menu in pairs(NameSpace) do
				RageUI.Visible(Menu, false)
			end
		end

		if #FocusMenu > 0 then
			local Focus = FocusMenu[#FocusMenu]
			local Menu = NativesMenu[Focus.namespace][Focus.name]

			local status, result = pcall(function()
				RageUI.Visible(Menu, true)

				RageUI.IsVisible(Menu, function()
					local esxMenu = ESX.UI.Menu.GetOpened(MenuType, Focus.namespace, Focus.name)

					for i,elementData in pairs(esxMenu.data.elements) do
						local Label = elementData.Label or elementData.label
						local Description = elementData.Description or elementData.description
						local ElementType = string.lower(elementData.Type or elementData.type or 'button')
						local RightBadge = GetBadgeFromName(elementData.RightBadge or elementData.rightBadge)
						local LeftBadge = GetBadgeFromName(elementData.LeftBadge or elementData.leftBadge)
						local RightLabel = elementData.RightLabel or elementData.rightLabel
						local RightLabelColor = elementData.RightLabelColor or elementData.rightLabelColor
						local Enabled = not (elementData.enabled == false or elementData.Enabled == false)
						local HightLightColor = elementData.HightLightColor or elementData.hightLightColor
						local BackgroundColor = elementData.BackgroundColor or elementData.backgroundColor

						if RightLabel == '>>>' or RightLabel == '>' or RightLabel == '->' then
							RightLabel = '→→→'
						end

						if type(RightLabelColor) == 'string' then
							RightLabelColor = GetColorFromName(RightLabelColor)
						end

						if type(RightLabelColor) == 'table' then
							if RightLabelColor.R == nil then
								RightLabelColor.R = RightLabelColor[1]
								RightLabelColor.G = RightLabelColor[2]
								RightLabelColor.B = RightLabelColor[3]
							end
						end

						if ElementType == nil or ElementType == 'button' then
							RageUI.Button(Label, Description, {
								LeftBadge = LeftBadge,
								RightBadge = RightBadge,
								RightLabel = RightLabel,
								RightLabelColor = RightLabelColor,
								Color = {
									HightLightColor = HightLightColor,
									BackgroundColor = BackgroundColor,
								},
							}, Enabled, {
								onSelected = function()
									if esxMenu.submit then
										esxMenu.submit({
											i = i,
											Current = elementData,
											current = elementData,
											Elements = esxMenu.data.elements,
											elements = esxMenu.data.elements,
										}, esxMenu)
									end
									Citizen.Wait(1)
								end,
							})
						elseif ElementType == 'checkbox' then
							local CheckboxStyle = elementData.CheckboxStyle or elementData.checkboxStyle
							local Checked = elementData.Checked or elementData.checked

							RageUI.Checkbox(Label, Description, Checked, {
								Style = CheckboxStyle,
								Enabled = Enabled,
								LeftBadge = LeftBadge,
								Color = {
									HightLightColor = HightLightColor,
									BackgroundColor = BackgroundColor,
								},
							}, {
								onChecked = function()
									esxMenu.setElementValue(i, 'Checked', true)
									esxMenu.setElementValue(i, 'checked', true)
									elementData.Checked = true
									elementData.checked = true
									if esxMenu.submit then
										esxMenu.submit({
											i = i,
											Checked = true,
											checked = true,
											Current = elementData,
											current = elementData,
											Elements = esxMenu.data.elements,
											elements = esxMenu.data.elements,
										}, esxMenu)
									end
								end,
								onUnChecked = function()
									esxMenu.setElementValue(i, 'Checked', false)
									esxMenu.setElementValue(i, 'checked', false)
									elementData.Checked = false
									elementData.checked = false
									if esxMenu.submit then
										esxMenu.submit({
											i = i,
											Checked = false,
											checked = false,
											Current = elementData,
											current = elementData,
											Elements = esxMenu.data.elements,
											elements = esxMenu.data.elements,
										}, esxMenu)
									end
								end,
							})
						elseif ElementType == 'list' then
							local Items = elementData.Items or elementData.items
							local Index = elementData.Index or elementData.index or 1
							if Items == nil then print('Trying to show list without any items') end
							if #Items == 0 then print('Trying to show empty list') end

							if not elementData.Index and not elementData.index then
								esxMenu.setElementValue(i, 'Index', Index)
								esxMenu.setElementValue(i, 'index', Index)
							end

							RageUI.List(Label, Items, Index, Description, {
								LeftBadge = LeftBadge,
								Enabled = Enabled,
								Color = {
									HightLightColor = HightLightColor,
									BackgroundColor = BackgroundColor,
								},
							}, Enabled, {
								onListChange = function(Index, Item)
									esxMenu.setElementValue(i, 'Index', Index)
									esxMenu.setElementValue(i, 'index', Index)
									elementData.Index = Index
									elementData.index = Index

									if esxMenu.change then
										esxMenu.change({
											i = i,
											Index = Index,
											index = Index,
											Current = elementData,
											current = elementData,
											Elements = esxMenu.data.elements,
											elements = esxMenu.data.elements,
										}, esxMenu)
									end
								end,
								onSelected = function(Index, Item)
									esxMenu.setElementValue(i, 'Index', Index)
									esxMenu.setElementValue(i, 'index', Index)
									elementData.Index = Index
									elementData.index = Index

									if esxMenu.submit then
										esxMenu.submit({
											i = i,
											Index = Index,
											index = Index,
											Current = elementData,
											current = elementData,
											Elements = esxMenu.data.elements,
											elements = esxMenu.data.elements,
										}, esxMenu)
									end
								end,
							})
						elseif ElementType == 'slider' then
							local Min = elementData.Min or elementData.min or 1
							local Max = elementData.Max or elementData.max or 100

							RageUI.Slider(Label, Min, Max, Description, true, {
								LeftBadge = LeftBadge,
								Enabled = Enabled,
							}, true, {
								onSliderChange = function(Index)
									esxMenu.setElementValue(i, 'Min', Index)
									esxMenu.setElementValue(i, 'min', Index)
									if esxMenu.change then
										esxMenu.change({
											i = i,
											Index = Index,
											index = Index,
											Current = elementData,
											current = elementData,
											Elements = esxMenu.data.elements,
											elements = esxMenu.data.elements,
										}, esxMenu)
									end
								end,
								onSelected = function(Index)
									esxMenu.setElementValue(i, 'Index', Index)
									esxMenu.setElementValue(i, 'index', Index)
									elementData.Index = Index
									elementData.index = Index

									if esxMenu.submit then
										esxMenu.submit({
											i = i,
											Index = Index,
											index = Index,
											Current = elementData,
											current = elementData,
											Elements = esxMenu.data.elements,
											elements = esxMenu.data.elements,
										}, esxMenu)
									end
								end
							})
						elseif ElementType == 'separator' then
							RageUI.Separator(Label)
						else
							RageUI.Button('Unknown ElementType : ' .. tostring(ElementType), '', {}, true, {})
						end
					end
				end)
			end)

			if not status then
				print('Error in menu ! (' .. tostring(status) .. ')')
				local esxMenu = ESX.UI.Menu.GetOpened(MenuType, Focus.namespace, Focus.name)
				if esxMenu and esxMenu.close then
					esxMenu.close()
				end
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(100)
		end
		Citizen.Wait(1.0)
	end
end)

function GetBadgeFromName(name)
	if name == '' or name == nil then
		return RageUI.BadgeStyle.None
	end

	for BadgeName, BadgeFunction in pairs(RageUI.BadgeStyle) do
		if string.lower(BadgeName) == string.lower(name) then
			return BadgeFunction
		end
	end

	print('Unknown badge name : ' .. name)
	return RageUI.BadgeStyle.None
end

function GetColorFromName(name)
	name = string.lower(name)
	if name == 'pink' then
		return {255, 192, 203}
	elseif name == 'cornflowerblue' then
		return {100, 149, 237}
	elseif name == 'red' then
		return {255, 0, 0}
	elseif name == 'lightblue' then
		return {173, 216, 230}
	elseif name == 'orange' then
		return {255, 165, 0}
	elseif name == 'gold' then
		return {255, 215, 0}
	elseif name == 'yellow' then
		return {255, 255, 0}
	elseif name == 'maroon' then
		return {128, 0, 0}
	elseif name == 'brown' then
		return {165, 42, 42}
	elseif name == 'darkgreen' then
		return {0, 100, 0}
	elseif name == 'green' then
		return {0, 128, 0}
	elseif name == 'lime' then
		return {0, 255, 0}
	elseif name == 'darkcyan' then
		return {0, 139, 139}
	elseif name == 'cyan' then
		return {0, 255, 255}
	elseif name == 'darkblue' then
		return {0, 0, 139}
	elseif name == 'blue' then
		return {0, 0, 255}
	elseif name == 'purple' then
		return {128, 0, 128}
	elseif name == 'violet' then
		return {139, 0, 139}
	elseif name == 'white' then
		return {255, 255, 255}
	elseif name == 'black' then
		return {0, 0, 0}
	elseif name == 'grey' then
	elseif name == 'gray' then
		return {128, 128, 128}
	elseif name == 'silver' then
		return {192, 192, 192}
	else
		print('Unknown color : ' .. tostring(name))
	end
end

AddEventHandler('onResourceStop', function(resourceName)
	for namespace, NameSpaceMenu in pairs(NativesMenu) do
		if namespace == resourceName then
			for _, Menu in pairs(NameSpaceMenu) do
				print('Killing menu because of restart...')
				RageUI.Visible(Menu, false)
			end
		end
	end

	NativesMenu[resourceName] = {}

	for i, Focus in pairs(FocusMenu) do
		if Focus.namespace == resourceName then
			table.remove(FocusMenu, i)
		end
	end
end)