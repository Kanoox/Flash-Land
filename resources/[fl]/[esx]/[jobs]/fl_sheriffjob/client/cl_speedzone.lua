local Speedzones = {}
local DrawSpeedzones = false
local InstructionScaleform = nil

AddEventHandler('fl_sheriffjob:toggleSpeedzoneDraw', function()
	DrawSpeedzones = not DrawSpeedzones
	if DrawSpeedzones then
		ESX.ShowNotification('~g~Affichage des zones d\'arrêt NPC')
	else
		ESX.ShowNotification('~r~Zones d\'arrêt NPC masquées')
	end
end)

local sizeMax = 50.0
AddEventHandler('fl_sheriffjob:promptSpeedzone', function()
	local BeforeDrawSpeedzones = DrawSpeedzones
	DrawSpeedzones = true
	InDrawSpeedzones()
	local placed = false
	local size = 1.0

	InitInstructionScaleform()

	repeat
		DrawMarker(25, GetEntityCoords(PlayerPedId()) + vector3(0,0,-0.95), 0, 0, 0, GetEntityRotation(PlayerPedId()), size * 2.0, size * 2.0, 1.0, 10, 10, 10, 255, false, false, 2, false, nil, nil, false)
		DrawScaleformMovieFullscreen(InstructionScaleform, 255, 255, 255, 255, 0);


		if IsControlPressed(0, 172) then -- UP
			if size <= sizeMax then
				size = size + 0.1
			end
		elseif IsControlPressed(0, 173) then -- DOWN
			if size >= 1.0 then
				size = size - 0.08
			end
		end

		if IsControlJustReleased(1, 348) or IsControlJustPressed(1, 201) then
			placed = true
		end

		if IsControlJustReleased(1, 194) or IsPedInAnyVehicle(PlayerPedId(), true) then -- Cancel
			ESX.ShowNotification('~r~Zone d\'arrêt annulée')
			DrawSpeedzones = BeforeDrawSpeedzones
			InDrawSpeedzones()
			TriggerEvent('fl_sheriffjob:finishedPlacingSpeedzone')
			return
		end

		Citizen.Wait(0)
	until placed

	TriggerServerEvent('fl_sheriffjob:addSpeedzone', GetEntityCoords(PlayerPedId()), size)
	DrawSpeedzones = BeforeDrawSpeedzones
	InDrawSpeedzones()
end)

RegisterNetEvent('fl_sheriffjob:addSpeedzone')
AddEventHandler('fl_sheriffjob:addSpeedzone', function(whoCreated, pos, size)
	local zoneIndex = AddSpeedZoneForCoord(pos.x, pos.y, pos.z, size, 0.0, false)
	table.insert(Speedzones, {
		whoCreated = whoCreated,
		pos = pos,
		size = size,
		zoneIndex = zoneIndex,
	})
	if whoCreated == GetPlayerServerId(PlayerId()) then
		ESX.ShowNotification('~g~Zone d\'arrêt placée')
		TriggerEvent('fl_sheriffjob:finishedPlacingSpeedzone')
	end
end)

RegisterNetEvent('fl_sheriffjob:removeSpeedzone')
AddEventHandler('fl_sheriffjob:removeSpeedzone', function(whoDeleted, deletedSpeedZone)
	for i,speedZone in pairs(Speedzones) do
		if speedZone.pos == deletedSpeedZone.pos then
			Speedzones[i] = nil
		end
	end
	RemoveSpeedZone(deletedSpeedZone.zoneIndex)
	if deletedSpeedZone.whoCreated ~= whoDeleted and deletedSpeedZone.whoCreated == GetPlayerServerId(PlayerId()) then
		ESX.ShowNotification('~r~Votre zone d\'arrêt a été supprimée')
	end
	if whoDeleted == GetPlayerServerId(PlayerId()) then
		ESX.ShowNotification('~r~Zone d\'arrêt supprimée')
	end
end)

function InitInstructionScaleform()
	InstructionScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
	repeat
		Citizen.Wait(0)
	until HasScaleformMovieLoaded(InstructionScaleform)

	BeginScaleformMovieMethod(InstructionScaleform, "CLEAR_ALL");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(6);
	PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_ACCEPT~");
	PushScaleformMovieMethodParameterString("~INPUT_MAP_POI~");
	PushScaleformMovieMethodParameterString("Poser la zone d'arrêt");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(5);
	PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_RRIGHT~");
	PushScaleformMovieMethodParameterString("Annuler");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(4);
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_UP~");
	PushScaleformMovieMethodParameterString("Agrandir la zone");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(3);
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_DOWN~");
	PushScaleformMovieMethodParameterString("Réduire la zone");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS");
	ScaleformMovieMethodAddParamInt(0);
	EndScaleformMovieMethod();
end

function DrawSpeedzone(Speedzone, Selected)
	if Selected then
		DrawMarker(25, Speedzone.pos + vector3(0,0,-0.95), 0, 0, 0, 0, 0, 0, Speedzone.size * 2.0, Speedzone.size * 2.0, 1.0, 127, 0, 0, 200, false, false, 2, false, nil, nil, false)
	else
		DrawMarker(25, Speedzone.pos + vector3(0,0,-0.95), 0, 0, 0, 0, 0, 0, Speedzone.size * 2.0, Speedzone.size * 2.0, 1.0, 0, 0, 127, 127, false, false, 2, false, nil, nil, false)
	end
end

function InDrawSpeedzones()
	if not DrawSpeedzones then return end

	Citizen.CreateThread(function()
		while DrawSpeedzones do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(PlayerPedId())
			local closest, closestDistance = nil, 1000

			for _,Speedzone in pairs(Speedzones) do
				local distance = #(Speedzone.pos - playerPos)
				if distance < 30 then
					DrawSpeedzone(Speedzone, false)
					if distance < closestDistance then
						closestDistance = distance
						closest = Speedzone
					end
				end
			end

			if closest and closestDistance < closest.size then
				DrawSpeedzone(closest, true)
				ESX.ShowHelpNotification('~INPUT_CELLPHONE_OPTION~ pour supprimer la zone d\'arrêt NPC')
				if IsControlJustReleased(1, 178) then
					TriggerServerEvent('fl_sheriffjob:removeSpeedzone', closest)
				end
			end
		end
	end)
end