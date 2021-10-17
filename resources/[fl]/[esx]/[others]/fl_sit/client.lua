local sitting, lastPos, currentSitCoords, currentScenario = false
local playerPed = nil
local showHelp = false
local currentModelName = ''

local currentAnim = 1
local anims = {
	{ a = "sitchair", offset = vector3(-0.44, 0.0, 0.0) },
	{ a = "sitchair2", offset = vector3(-0.6, 0.0, 0.0) },
	{ a = "sitchair3", offset = vector3(-0.75, 0.2, -0.3) },
	{ a = "sitchair4", offset = vector3(-0.4, 0.0, 0.0) },
	{ a = "sitchair5", offset = vector3(-0.83, 0.0, 0.0) },
	{ a = "sitchair6", offset = vector3(-0.8, 0.1, 0.0) },
	{ a = "sitchairside", offset = vector3(-0.4, 0.0, 0.0) },
}

Citizen.CreateThread(function()
	Config.Interactables = {}
	for PropName,_ in pairs(Config.Sitable) do
		if type(PropName) == 'number' then
			Config.Interactables[PropName] = true
		else
			Config.Interactables[GetHashKey(PropName)] = true
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		playerPed = PlayerPedId()

		local object, distance = ESX.Game.GetClosestObject(GetEntityCoords(playerPed), Config.Interactables)

		local somethingIsAlreadyDisplayed = false
		if not showHelp and IsHelpMessageBeingDisplayed() then
			somethingIsAlreadyDisplayed = true
		end

		if not somethingIsAlreadyDisplayed then
			showHelp = false
			if distance < 1.5 then
				local hash = GetEntityModel(object)

				for k,v in pairs(Config.Sitable) do
					if k == hash or GetHashKey(k) == hash then
						showHelp = true
						break
					end
				end
			end
		end

		Citizen.Wait(3000)
	end
end)

AddEventHandler('dpemotes:onEmoteCancel', function()
	if sitting then
		wakeup()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if showHelp then
			if sitting then
				ESX.ShowHelpNotification('~INPUT_SPRINT~ ~INPUT_PICKUP~ ou ~INPUT_VEH_DUCK~ pour se lever\n~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ pour changer de position', false, false, 0)
			else
				ESX.ShowHelpNotification('~INPUT_SPRINT~ ~INPUT_PICKUP~ pour s\'asseoir', false, false, 0)
			end
		end

		if sitting then
			if IsControlJustPressed(0, 174) then
				currentAnim = currentAnim - 1

				if currentAnim <= 0 then
					currentAnim = #anims
				end
				TriggerEvent('fl_sit:updateSit')
			elseif IsControlJustPressed(0, 175) then
				currentAnim = currentAnim + 1

				if currentAnim > #anims then
					currentAnim = 1
				end
				TriggerEvent('fl_sit:updateSit')
			end
		end

		if IsControlJustPressed(0, 38) and IsControlPressed(0, 21) and IsInputDisabled(0) then
			if IsPedOnFoot(playerPed) then
				if sitting then
					wakeup()
				else
					local object, distance = ESX.Game.GetClosestObject(GetEntityCoords(playerPed), Config.Interactables)

					if distance < 1.5 then
						local hash = GetEntityModel(object)

						for k,v in pairs(Config.Sitable) do
							if k == hash or GetHashKey(k) == hash then
								sit(object, k, v, GetEntityCoords(object))
								break
							end
						end
					end
				end
			end
		end
	end
end)

function wakeup()
	ClearPedTasks(playerPed)

	sitting = false

	SetEntityCoords(playerPed, lastPos)
	FreezeEntityPosition(playerPed, false)

	TriggerServerEvent('fl_sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
end

function sit(object, modelName, data, pos)
	local realPos = GetEntityCoords(object)
	local newPos = realPos
	local objectCoords = math.floor(pos.x + 0.5) .. math.floor(pos.y + 0.5) .. math.floor(pos.z + 0.5)

	ESX.TriggerServerCallback('fl_sit:getPlace', function(occupied)
		if occupied and Config.Sitable[modelName].bench then
			if realPos.y - pos.y == 0 then
				newPos = newPos + vector3(0, 1.0, 0)
				sit(object, modelName, data, newPos)
			elseif realPos.y - pos.y > 0 then
				newPos = newPos + vector3(0, 1.0, 0)
				sit(object, modelName, data, newPos)
			else
				ESX.ShowNotification('~r~Cette place est prise...')
			end
			return
		end

		if occupied then
			ESX.ShowNotification('~r~Cette place est prise...')
		else
			lastPos, currentSitCoords, currentModelName = GetEntityCoords(playerPed), objectCoords, modelName

			TriggerServerEvent('fl_sit:takePlace', objectCoords)
			FreezeEntityPosition(object, true)

			TriggerEvent('fl_sit:updateSit')

			Citizen.Wait(1000)
			sitting = true
		end
	end, objectCoords)
end

AddEventHandler('fl_sit:updateSit', function()
	local object, distance = ESX.Game.GetClosestObject(GetEntityCoords(playerPed), Config.Interactables)

	if distance < 1.5 then
		local offset = anims[currentAnim].offset + Config.Sitable[currentModelName].offset
		local forward = GetEntityForwardVector(object)
		SetEntityCoords(playerPed, GetEntityCoords(object) + forward * offset.x + vector3(-forward.y, forward.x, 0.0) * offset.y + vector3(0, 0, offset.z))
		SetEntityHeading(playerPed, GetEntityHeading(object) + 180.0)

		TriggerEvent('dpemotes:emoteStart', anims[currentAnim].a)
	end
end)