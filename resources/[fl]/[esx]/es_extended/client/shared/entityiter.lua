function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

function EnumerateObjects()
	return ipairs(GetGamePool('CObject'))
end

function EnumeratePeds()
	return ipairs(GetGamePool('CPed'))
end

function EnumerateVehicles()
	return ipairs(GetGamePool('CVehicle'))
end

function EnumeratePickups()
	return ipairs(GetGamePool('CPickup'))
end