local open = false
RegisterCommand('debug_bob_safe', function()
	open = not open
	if open then
		InteriorIplObject.Safe.Close('right')
		InteriorIplObject.Safe.Close('left')
	else
		InteriorIplObject.Safe.Open('right')
		InteriorIplObject.Safe.Open('left')
	end
end)

local swags = {}
RegisterCommand('debug_bob_swag', function(argN, args)
	if not CurrentOwnedProperty then return end
	swags[args[1]] = not swags[args[1]]
	TriggerServerEvent('fl_property:swag', CurrentOwnedProperty.id, args[1], swags[args[1]])
end)

RegisterNetEvent('fl_property:swag')
AddEventHandler('fl_property:swag', function(OwnedId, Swag, Toggle)
	if not CurrentOwnedProperty then return end
	if OwnedId ~= CurrentOwnedProperty.id then return end
	InteriorIplObject.Swag.Enable(InteriorIplObject.Swag[Swag], Toggle, true)
end)

local toggle = {}
RegisterCommand('debug_bob_toggle', function(argN, args)
	toggle[args[1]] = not toggle[args[1]]
	print(':' .. tostring(toggle[args[1]]))
	InteriorIplObject[args[1]].Set(toggle[args[1]], true)
end)

RegisterCommand('debug_interiorid', function()
	local pos = GetEntityCoords(PlayerPedId())
	print(tostring(GetInteriorAtCoords(pos.x, pos.y, pos.z)))
end)

RegisterCommand('debug_isintanced', function()
	print('trigger')
	ESX.TriggerServerCallback('instance:isInstanced', function(isInstanced)
		print('isInstanced:' .. tostring(isInstanced))
	end)
end)

RegisterCommand('debug_property', function()
	print('-')
	print('CurrentAction:'..tostring(CurrentAction))
	print('CurrentProperty:'..tostring(CurrentProperty))
	print('isInMarker:'..tostring(isInMarker))
	print('LastMarkerProperty:'..tostring(LastMarkerProperty))
	print('LastMarkerPart:'..tostring(LastMarkerPart))
end)

RegisterCommand('debug_openhouseradius', function()
	DebugOpenHouseRadius = not DebugOpenHouseRadius
	print('DebugOpenHouseRadius:'..tostring(DebugOpenHouseRadius))
end)

RegisterCommand('debug_societydisplay', function(argN, args)
	if args[2] then
		local v = nil
		if args[1] == 'name' then
			v = args[2]
		elseif args[1] == 'style' then
			v = FinanceOrganization.Name.Style[args[2]]
		elseif args[1] == 'color' then
			v = FinanceOrganization.Name.Colors[args[2]]
		elseif args[1] == 'font' then
			v = FinanceOrganization.Name.Fonts[args[2]]
		else
			print('Unknown')
			return
		end
		FinanceOrganization.Name[args[1]] = v
	end
    FinanceOrganization.Name.Set(FinanceOrganization.Name.name, FinanceOrganization.Name.style, FinanceOrganization.Name.color, FinanceOrganization.Name.font)
end)