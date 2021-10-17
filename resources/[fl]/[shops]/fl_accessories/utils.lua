function split(inputstr, sep)
	if sep == nil then sep = "%s" end
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function extractIdFromItem(item)
	local separatedName = split(item, Config.ItemSep)
	return separatedName[1], tonumber(separatedName[2]), tonumber(separatedName[3])
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function startAnimAction(lib, anim)
	Citizen.CreateThread(function()
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 8.0, -1, 49, 0, false, false, false)
			Citizen.Wait(GetAnimDuration(lib, anim) * 1000)
			ClearPedTasks(PlayerPedId())
			RemoveAnimDict(lib)
		end)
	end)
end

function SetPedAccessory(separatedName, el1, el2)
	local playerPed = PlayerPedId()
	if separatedName == 'imask' then
		print(el1, el2)
		SetPedComponentVariation(playerPed, 1, el1, el2, 2)
	elseif separatedName == 'iears' then
		if el1 <= 0 then
			ClearPedProp(playerPed, 2)
		else
			SetPedPropIndex(playerPed, 2, el1, el2, 2)
		end
	elseif separatedName == 'ihelmet' then
		if el1 <= 0 then
			ClearPedProp(playerPed, 0)
		else
			SetPedPropIndex(playerPed, 0, el1, el2, 2)
		end
	elseif separatedName == 'iglass' then
		if el1 <= 0 then
			ClearPedProp(playerPed, 1)
		else
			SetPedPropIndex(playerPed, 1, el1, el2, 2)
		end
	elseif separatedName == 'ibag' then
		SetPedComponentVariation(playerPed, 5, el1, el2, 2)
	else
		error('Unknown separatedName : ' .. tostring(separatedName))
	end
end

function GetZoneTypeFromItem(separatedItem)
	for ZoneType,ItemPrefix in pairs(Config.Item) do
		if ItemPrefix == separatedItem then return ZoneType end
	end
	return '???'
end