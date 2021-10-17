local SpeedZone = {}
local Objects = {}

local NearestObject = nil
local NearestCoords = nil
local NearestDistance = nil
local Scale = nil
Citizen.CreateThread(function()
	while true do
		if NearestObject and deleteMode then
			ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour enlever l'objet")                         -- SCALE 2.0    --RGB
			DrawMarker(28, NearestCoords.x, NearestCoords.y, NearestCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, NearestSize, NearestSize, NearestSize, 255, 0, 0, 30, false, true, 2, nil, nil, true)
			if IsControlJustReleased(1, 38) then
				RemoveSpeedZone(SpeedZone[NearestObject])
				TriggerServerEvent("esx:deleteEntity", NetworkGetNetworkIdFromEntity(NearestObject))
				DeleteEntity(NearestObject)
				for i,Ob in pairs(Objects) do
					if Ob == NearestObject then
						Objects[i] = nil
					end
				end
				ShowHelpNotification("Objet supprimé !")
			end
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if deleteMode then
			Objects = {}
			local pCoords = GetEntityCoords(PlayerPedId())
	        for _, Ob in EnumerateObjects() do
				local oCoords = GetEntityCoords(Ob)
				if #(pCoords - oCoords) <= 50 then
					local ObHash = GetEntityModel(Ob)
					for _,hash in pairs(hashList) do
						if hash == ObHash then
							table.insert(Objects, Ob)
						end
					end
				end
	    	end
			Citizen.Wait(5000)
		else
			Citizen.Wait(500)
		end

	end
end)

Citizen.CreateThread(function()
	local minimumDistance = 3
	while true do
		if deleteMode then
			NearestObject = nil
			NearestCoords = nil
			NearestDistance = minimumDistance
			local pCoords = GetEntityCoords(PlayerPedId())
			for _,Ob in pairs(Objects) do
				local oCoords = GetEntityCoords(Ob)
				local distance = #(pCoords - oCoords)
				if distance < minimumDistance and distance < NearestDistance then
					NearestObject = Ob
					NearestCoords = oCoords
					NearestDistance = distance
					local min, max = GetModelDimensions(GetEntityModel(Ob))
					NearestSize = (max - min).y
				end
			end
		end
		Citizen.Wait(500)
	end
end)

local heightShift = 0.0
local distanceShift = 2.0
local rotationShift = 0.0
local heightShiftMax = 5.0
function SpawnObj(PropInfo)
	local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)

	if IsControlPressed(0, 21) then -- Disable sprint props flying
		DisableControlAction(0, 21, true)
		DisableControlAction(0, 22, true)
		ForcePedMotionState(PlayerPedId(), `motionstate_walk`, 0, 0, 0)
		Citizen.Wait(0)
	end
	DrawInstructions()

	local objectCoords = (coords + forward * distanceShift)
	local Ent = nil

	SpawnObject(PropInfo.prop, objectCoords, function(obj)
		SetEntityCollision(obj, 0, 0)
		SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
		Ent = obj
		Wait(1)
	end)
	Wait(1)
	while Ent == nil do Wait(1) end
	SetEntityHeading(Ent, GetEntityHeading(playerPed))
	PlaceObjectOnGroundProperly(Ent)
	local placed = false
	while not placed do
		Citizen.Wait(1)
		NearestObject = nil
		local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
		local objectCoords = (coords + forward * distanceShift)
		SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
		SetEntityHeading(Ent, GetEntityHeading(playerPed) + rotationShift)
		PlaceObjectOnGroundProperly(Ent)
		if not PropInfo.fix then
			PropInfo.fix = 0
		end
		SetEntityCoords(Ent, GetEntityCoords(Ent) + vector3(0.0, 0.0, heightShift + PropInfo.fix), 0.0, 0.0, 0.0, 0)
		SetEntityAlpha(Ent, 170, 170)
		SetEntityCollision(Ent, 0, 0)
		DisableControlAction(0, 21, true)
		DisableControlAction(0, 22, true)

		DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0);

		if IsControlPressed(0, 174) then -- LEFT
			rotationShift = rotationShift - 1
		elseif IsControlPressed(0, 175) then -- RIGHT
			rotationShift = rotationShift + 1
		elseif IsControlPressed(0, 172) then -- UP
			if heightShift <= heightShiftMax then
				heightShift = heightShift + 0.05
			end
		elseif IsControlPressed(0, 173) then -- DOWN
			if heightShift >= -heightShiftMax then
				heightShift = heightShift - 0.05
			end
		elseif IsControlPressed(0, 178) then -- RESET
			heightShift = 0.0
			rotationShift = 0.0
		end

		if IsControlJustReleased(1, 348) or IsControlJustPressed(1, 201) then
			placed = true
		end

		if IsControlJustReleased(1, 194) or IsPedInAnyVehicle(PlayerPedId(), true) then -- Cancel
			DeleteEntity(Ent)
			return
		end
	end

	local objCoord = GetEntityCoords(Ent)
	local min, max = GetModelDimensions(GetEntityModel(Ent))
	local size = (max - min).y * 1.5 + 2
	SpeedZone[Ent] = AddSpeedZoneForCoord(objCoord.x, objCoord.y, objCoord.z, size, 0.0, false)
	SetEntityCoords(Ent, objCoord, 0.0, 0.0, 0.0, 0)
	SetEntityCollision(Ent, 1, 1)
	FreezeEntityPosition(Ent, not PropInfo.canMove)
	SetEntityInvincible(Ent, not PropInfo.canBeDestroyed)
	ResetEntityAlpha(Ent)
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Ent), true)
end

function DrawInstructions()
	Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
	repeat
		Citizen.Wait(0)
	until HasScaleformMovieLoaded(Scale)

	BeginScaleformMovieMethod(Scale, "CLEAR_ALL");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(6);
	PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_ACCEPT~");
	PushScaleformMovieMethodParameterString("~INPUT_MAP_POI~");
	PushScaleformMovieMethodParameterString("Poser l'objet");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(5);
	PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_RRIGHT~");
	PushScaleformMovieMethodParameterString("Annuler");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(4);
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_UP~");
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_DOWN~");
	PushScaleformMovieMethodParameterString("Hauteur d'objet");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(3);
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_LEFT~");
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_RIGHT~");
	PushScaleformMovieMethodParameterString("Tourner l'objet");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(2);
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_OPTION~");
	PushScaleformMovieMethodParameterString("Reset position");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS");
	ScaleformMovieMethodAddParamInt(0);
	EndScaleformMovieMethod();
end

function SpawnObject(model, coords, cb)
	local modelHash = model
	if not tonumber(model) then
		modelHash = GetHashKey(model)
	end

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(modelHash)
		Wait(1)
		local obj = CreateObject(modelHash, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end


function ClearProps()
	Citizen.CreateThread(function()
		local timer = true
		while timer do
			Objects = {} 
	        for _, Ob in EnumerateObjects() do
				local ObHash = GetEntityModel(Ob)
				for _,hash in pairs(hashList) do
					if hash == ObHash then
						table.insert(Objects, Ob)
					end
				end
	    	end
			ExecuteCommand('annonce Possible freeze de quelques secondes ! Clear des props en cours.')
			Wait(10000)

			if Objects ~= {} then
				for i,Ob in pairs(Objects) do
					if Ob ~= nil then
						DeleteEntity(Objects[i])
						Objects[i] = nil
					end
				end
				timer = false
				ESX.ShowNotification("Tous les props ont été delete !")
				break
			else
				ESX.ShowNotification("Aucun props a delete !")
				break
			end
		Wait(1000)
		end
	end)
end


local function getUserGroup()
    ESX.TriggerServerCallback("fl_props:getUserGroup", function(bool)
        if bool == true then
            ClearProps()
		else
			ESX.ShowNotification('~r~Vous n\'êtes pas autorisés à effectuer cette commande !')
        end
    end)
end


RegisterCommand('ClearProps', function()
	getUserGroup()
end)