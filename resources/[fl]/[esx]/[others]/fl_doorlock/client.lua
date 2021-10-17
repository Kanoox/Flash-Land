playerGroup = nil

Citizen.CreateThread(function()
	while playerGroup == nil do
		ESX.TriggerServerCallback('fl_doorlock:getUsergroup', function(group) playerGroup = group end)
		Citizen.Wait(10)
	end

	-- Update the door list
	ESX.TriggerServerCallback('fl_doorlock:getDoorInfo', function(doorInfo)
		for doorID,state in pairs(doorInfo) do
			Config.DoorList[doorID].locked = state
		end
	end)
end)

-- Get objects every X seconds, instead of every frame
Citizen.CreateThread(function()
	while true do
		for _,doorID in ipairs(Config.DoorList) do
			if doorID.actualDistance and doorID.actualDistance < 200 then
				if doorID.doors then
					for k,v in ipairs(doorID.doors) do
						if not v.object or not DoesEntityExist(v.object) then
							v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
						end
					end
				else
					if not doorID.object or not DoesEntityExist(doorID.object) then
						doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash, false, false, false)
					end
				end

				doorID.isAuthorized = IsAuthorized(doorID)
			end
		end

		Citizen.Wait(4000)
	end
end)

-- Get distance every x, instead of every frame
Citizen.CreateThread(function()
	while true do
		local playerCoords = GetEntityCoords(PlayerPedId())

		for _,doorID in ipairs(Config.DoorList) do
			if doorID.doors then
				if doorID.textCoords == nil then
					doorID.actualDistance = #(playerCoords - doorID.doors[1].objCoords)
					doorID.textCoords = doorID.doors[1].objCoords
				else
					doorID.actualDistance = #(playerCoords - doorID.textCoords)
				end
			else
				if doorID.textCoords == nil then
					doorID.actualDistance = #(playerCoords - doorID.objCoords)
					doorID.textCoords = doorID.objCoords
				else
					doorID.actualDistance = #(playerCoords - doorID.textCoords)
				end
			end
		end

		Citizen.Wait(300)
	end
end)

Citizen.CreateThread(function()
	while true do
		for k,doorID in ipairs(Config.DoorList) do
			if doorID.actualDistance and doorID.actualDistance < 50 then
				updateDoor(doorID)
			end
		end
		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = true
		Citizen.Wait(0)
		for k,doorID in ipairs(Config.DoorList) do
			local maxDistance, size = 2.5, 0.8

			if doorID.distance then
				maxDistance = doorID.distance
			end

			if doorID.size then
				size = doorID.size
			end

			local displayText = '🔓'

			if doorID.actualDistance < maxDistance then
				if doorID.locked then
					displayText = '🔒'
				end

				if doorID.isAuthorized then
					displayText = '🔑 ' .. displayText

					if IsControlJustReleased(0, 38) then
						doorID.locked = not doorID.locked
						TriggerServerEvent('fl_doorlock:updateState', k, doorID.locked)
					end
				end

				ESX.Game.Utils.DrawText3D(doorID.textCoords, displayText, size)
				sleep = false
			end
		end

		if sleep then
			Citizen.Wait(1000)
		end
	end
end)

function updateDoor(doorID)
	if doorID.doors then
		for _,v in ipairs(doorID.doors) do
			Citizen.CreateThread(function()
				FreezeEntityPosition(v.object, doorID.locked)

				if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
					SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
				end
			end)
		end
	else
		Citizen.CreateThread(function()
			FreezeEntityPosition(doorID.object, doorID.locked)

			if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
				SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
			end
		end)
	end
end

function IsAuthorized(doorID)
	if --[[playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner' or--]] playerGroup == '_dev' then
		return true
	end

	for _,job in pairs(doorID.authorizedJobs) do
		if ESX.PlayerData.job and job == ESX.PlayerData.job.name then
			if doorID.authorizedGrades ~= nil then
				for _,grade in pairs(doorID.authorizedGrades) do
					if ESX.PlayerData.job.grade_name == grade then
						return true
					end
				end
			else
				return true
			end
		end

		if ESX.PlayerData.faction and job == ESX.PlayerData.faction.name then
			return true
		end
	end

	return false
end

-- Set state for a door
RegisterNetEvent('fl_doorlock:setState')
AddEventHandler('fl_doorlock:setState', function(doorID, state)
	Config.DoorList[doorID].locked = state
	updateDoor(Config.DoorList[doorID])
end)

RegisterNetEvent('fl_doorlock:debug')
AddEventHandler('fl_doorlock:debug', function()
	local object = ESX.Game.GetClosestObject()
	local model = GetEntityModel(object)
	local coords = GetEntityCoords(object)
	print(model)
	print('x:' .. ESX.Math.Round(coords.x, 1))
	print('y:' .. ESX.Math.Round(coords.y, 1))
	print('z:' .. ESX.Math.Round(coords.z, 1))
	print('yaw:' .. ESX.Math.Round(GetEntityHeading(object), 1))
	print('')

	for _, anyObject in pairs(ESX.Game.GetObjects()) do
		if object ~= anyObject and model == GetEntityModel(anyObject) then
			local anyCoords = GetEntityCoords(anyObject)
			if #(coords - anyCoords) < 3 then
				print('similar object <3 : (' .. ESX.Math.Round(anyCoords.x, 1) .. ', ' .. ESX.Math.Round(anyCoords.y, 1) .. ', ' .. ESX.Math.Round(anyCoords.z, 1) .. ', ' .. ESX.Math.Round(GetEntityHeading(anyObject), 1) .. ')')
				print('med: (' .. ESX.Math.Round(((anyCoords + coords)/2).x, 1) .. ', ' .. ESX.Math.Round(((anyCoords + coords)/2).y, 1) .. ', ' .. ESX.Math.Round(((anyCoords + coords)/2).z, 1) .. ')')
				print('')
			end
		end
	end
end)

RegisterNetEvent('fl_doorlock:getDoorsState')
AddEventHandler('fl_doorlock:getDoorsState', function(cb)
	cb(Config.DoorList)
end)
