Notif = Notif or {}

function Notif:DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end 

function Notif:ShowForcedMessage(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTickerForced(true, true)
end

function Notif:ShowMessage(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(true, true)
end

function Notif:ShowAdvancedNotification(msg, isMugshot, textureDict, textureName, flash, iconType, title, subtitle)
    if isMugshot then
        local handle = RegisterPedheadshot(PlayerPedId())
        while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
            Citizen.Wait(0)
        end

        local txd = GetPedheadshotTxdString(handle)
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostMessagetext(txd, txd, flash, iconType, title, subtitle)
        UnregisterPedheadshot(handle)
    else
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostMessagetext(textureDict, textureName, flash, iconType, title, subtitle)
    end

    EndTextCommandThefeedPostTicker(false, true)
    if handle then  UnregisterPedheadshot(handle) end
end

function TeleportTopCoords(pos, ent, trustPos)
	if not pos or not pos.x or not pos.y or not pos.z or (ent and not DoesEntityExist(ent)) then return true end
	local x, y, z = pos.x, pos.y, pos.z + 1.0
	ent = ent or GetPlayerPed(-1)

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local tempTimer = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(ent, x, y, z)

	tempTimer = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(ent) do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	local foundNewZ, newZ
	if not trustPos then
		foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
		tempTimer = GetGameTimer()
		while not foundNewZ do
			z = z + 10.0
			foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
			Wait(0)

			if GetGameTimer() - tempTimer > 2000 then
				break
			end
		end
	end

	LastCoords = vector3(x, y, foundNewZ and newZ or z)
	SetEntityCoordsNoOffset(ent, x, y, foundNewZ and newZ or z)
	NewLoadSceneStop()

	if type(pos) ~= "vector3" and pos.a then SetEntityHeading(ent, pos.a) end
	return true
end

function IsPedMale(ped)
    return IsPedModel(ped or PlayerPedId(), GetHashKey("mp_m_freemode_01"))
end

local done
function MoovePlayerToPos(p, ent)
	done = true
	DoScreenFadeOut(100)
	Citizen.Wait(100)
	done = TeleportTopCoords(p, ent)
	while not done do
		Citizen.Wait(0)
	end
	DoScreenFadeIn(100)
end

local fullScreens = {
	["1920.1080"] = true,
	["2560.1080"] = true,
	["3840.2160"] = true,
}
function IsFullScreen()
	return fullScreens[string.format("%0d.%0d", GetActiveScreenResolution())]
end

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(false)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local minimap = {}
    minimap.width = xscale * (res_x / (4 * aspect_ratio))
    minimap.bar_scale = yscale * 0.595 * res_y / 35.470306
    minimap.height = yscale * (res_y / 5.674) - minimap.bar_scale
	minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10) + (IsFullScreen() and 0 or 26 / res_x)) )	
    minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10))) - minimap.bar_scale
    minimap.right_x = minimap.left_x + minimap.width
    minimap.top_y = minimap.bottom_y - minimap.height
    minimap.x = minimap.left_x 
    minimap.y = minimap.top_y
    minimap.xunit = xscale
    minimap.yunit = yscale
	return minimap
end

RegisterNUICallback("recalculateMinimap", function(data, cb)
    local minimap = GetMinimapAnchor()
    cb({type = "bars", action = "resize", width = minimap.width, height = minimap.height,left_x = minimap.left_x,top_y = minimap.top_y,bar_scale = minimap.bar_scale})
end)

function TransportToPos(pos, ped)
    DoScreenFadeOut(650)
	Citizen.Wait(650)
	SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z + 200.0)
	LastCoords = vector3(pos.x, pos.y, pos.z)
    SetPedParachuteTintIndex(ped, 3)
    TaskParachute(ped, 1)
    DoScreenFadeIn(650)
end

function RegisterControlKey(strKeyName, strDescription, strKey, cbPress, cbRelease)
    RegisterKeyMapping("+" .. strKeyName, strDescription, "keyboard", strKey)

	RegisterCommand("+" .. strKeyName, function()
		if not cbPress or UpdateOnscreenKeyboard() == 0 then 
			return 
		end
        cbPress()
    end, false)

    RegisterCommand("-" .. strKeyName, function()
		if not cbRelease or UpdateOnscreenKeyboard() == 0 then 
			return 
		end
        cbRelease()
    end, false)
end


function DrawText3D(B6zKxgVs, O3_X, DVs8kf2w, vms5, M7, v3)
    local ihKb = M7 or 7
    local JGSK, rA5U, Uc06 = table.unpack(GetGameplayCamCoords())
    M7 = GetDistanceBetweenCoords(JGSK, rA5U, Uc06, B6zKxgVs, O3_X, DVs8kf2w, 1)
    local lcBL = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), B6zKxgVs, O3_X, DVs8kf2w, 1) - 1.65
    local DHPxI, dx = ((1 / M7) * (ihKb * .7)) * (1 / GetGameplayCamFov()) * 100, 255;
    if lcBL < ihKb then
        dx = math.floor(255 * ((ihKb - lcBL) / ihKb))
    elseif lcBL >= ihKb then
        dx = 0
    end
    dx = v3 or dx
    SetTextFont(0)
    SetTextScale(.0 * DHPxI, .1 * DHPxI)
    SetTextColour(255, 255, 255, math.max(0, math.min(255, dx)))
    SetTextCentre(1)
    SetDrawOrigin(B6zKxgVs, O3_X, DVs8kf2w, 0)
    SetTextEntry("STRING")
    AddTextComponentString(vms5)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
function DeleteVehi()
    Citizen.CreateThread(function()
        local entity = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        NetworkRequestControlOfEntity(entity)
        local test = 0
        while test > 100 and not NetworkHasControlOfEntity(entity) do
            NetworkRequestControlOfEntity(entity)
            Wait(1)
            test = test + 1
        end

        SetEntityAsNoLongerNeeded(entity)
        SetEntityAsMissionEntity(entity, true, true)

        Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
     
        while DoesEntityExist(entity) do 
            SetEntityAsNoLongerNeeded(entity)
            DeleteEntity(entity)
            Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
            SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
            Wait(300)
        end 
    end)
end

function RequestControl(entity)
	local start = GetGameTimer()
	local entityId = tonumber(entity)
	if not DoesEntityExist(entityId) then return end
	if not NetworkHasControlOfEntity(entityId) then		
		NetworkRequestControlOfEntity(entityId)
		while not NetworkHasControlOfEntity(entityId) do
			Citizen.Wait(10)
			if GetGameTimer() - start > 5000 then return end
		end
	end
	return entityId
end

function DeleteVehicle(vehicle)
	RequestControl(vehicle)
	if not DoesEntityExist(vehicle) then return end
	SetEntityAsMissionEntity(vehicle, true, true)
	SetEntityAsNoLongerNeeded(vehicle)
	TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
	DeleteEntity(vehicle)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end
RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ClearPedSecondaryTask(PlayerPedId())
end)
local e,B6zKxgVs=18000,6000
function requestVehControl(veh)
	if not veh then return end
	local id = VehToNet(veh)

	if id > 0 and not NetworkHasControlOfEntity(veh) then
		NetworkRequestControlOfEntity(veh)
		while not NetworkHasControlOfEntity(veh) do
			Citizen.Wait(0)
		end

		return true
	end
end


local GetActivePlayers = GetActivePlayers
local GetPlayerPed = GetPlayerPed
local GetEntityCoords = GetEntityCoords
local GetEntityForwardVector = GetEntityForwardVector
local IsEntityVisible = IsEntityVisible
local HasAnimDictLoaded = HasAnimDictLoaded

-- PLAYER_LOOP
function GetPlayers()
	return GetActivePlayers()
end

local max = 1.5
function getClosePly(bl, d, addVector)
	local ped, closestPlayer = GetPlayerPed(-1)
	local playerPos, playerForward = GetEntityCoords(ped), GetEntityForwardVector(ped)
	playerPos = playerPos + (addVector or playerForward * 0.5)

	for _,v in pairs(GetPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (d or max) and (not closestPlayer or GetDistanceBetweenCoords(otherPedPos, playerPos)) then
			closestPlayer = v
		end
	end

	return closestPlayer
end

function IsBehindPed(cJoBcud)
    return not
    HasEntityClearLosToEntityInFront(cJoBcud,GetPlayer().Ped)
end

function GetClosestVehicle2(vector, radius, modelHash, testFunction)
	if not vector or not radius then return end
	local handle, veh = FindFirstVehicle()
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z, true)
		if firstDist < radius and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh), true)) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextVehicle(handle)
	until not success
		EndFindVehicle(handle)

	return theVeh
end

function GetClosestObject(vector, radius, modelHash, testFunction)
	if not vector or not radius then return end
	local handle, veh = FindFirstObject()
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z, true)
		if firstDist < radius and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh), true)) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextObject(handle)
	until not success
		EndFindObject(handle)

	return theVeh
end

function GetClosestPed2(vector, radius, modelHash, testFunction)
	if not vector or not radius then return end
	local handle, myped, veh = FindFirstPed(), GetPlayerPed(-1)
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z)
		if firstDist < radius and veh ~= myped and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh))) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextPed(handle)
	until not success
		EndFindPed(handle)

	return theVeh
end

function tableValueFind(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

function ShowNotificationWithButton(button, message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	return EndTextCommandThefeedPostReplayInput(1, button, message)
end

function DrawTopNotification(txt)
	SetTextComponentFormat("jamyfafi")
	AddLongString(txt)
	DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

function drawCenterText(msg, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(msg)
	DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function RequestAndWaitModel(modelName)
	if modelName and IsModelInCdimage(modelName) and not HasModelLoaded(modelName) then
		RequestModel(modelName)
		while not HasModelLoaded(modelName) do Citizen.Wait(100) end
	end
end

function RequestAndWaitDict(dictName)
	if dictName and DoesAnimDictExist(dictName) and not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
		while not HasAnimDictLoaded(dictName) do Citizen.Wait(100) end
	end
end

function RequestAndWaitSet(setName)
	if setName and not HasAnimSetLoaded(setName) then
		RequestAnimSet(setName)
		while not HasAnimSetLoaded(setName) do Citizen.Wait(100) end
	end
end

function tableCount(tbl, checkCount)
	if not tbl or type(tbl) ~= "table" then return not checkCount and 0 end
	local n = 0
	for k,v in pairs(tbl) do
		n = n + 1
		if checkCount and n >= checkCount then return true end
	end
	return not checkCount and n
end

function doAnim(animName, time, flag, ped, customPos)
	if type(animName) ~= "table" then animName = {animName} end
	ped, flag = ped or GetPlayerPed(-1), flag and tonumber(flag) or false

	if not animName or not animName[1] or string.len(animName[1]) < 1 then return end
    if IsEntityPlayingAnim(ped, animName[1], animName[2], 3) or IsPedActiveInScenario(ped) then ClearPedTasks(ped) 
        return end

	Citizen.CreateThread(function()
		forceAnim(animName, flag, { ped = ped, time = time, pos = customPos })
	end)
end

function GetDistanceBetween3DCoords(x1, y1, z1, x2, y2, z2)

    if x1 ~= nil and y1 ~= nil and z1 ~= nil and x2 ~= nil and y2 ~= nil and z2 ~= nil then
        return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
    end
    return -1

end

local animBug = {"WORLD_HUMAN_MUSICIAN", "WORLD_HUMAN_CLIPBOARD"}
local femaleFix = {
	["WORLD_HUMAN_BUM_WASH"] = {"amb@world_human_bum_wash@male@high@idle_a", "idle_a"},
	["WORLD_HUMAN_SIT_UPS"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a"},
	["WORLD_HUMAN_PUSH_UPS"] = {"amb@world_human_push_ups@male@base", "base"},
	["WORLD_HUMAN_BUM_FREEWAY"] = {"amb@world_human_bum_freeway@male@base", "base"},
	["WORLD_HUMAN_CLIPBOARD"] = {"amb@world_human_clipboard@male@base", "base"},
	["WORLD_HUMAN_VEHICLE_MECHANIC"] = {"amb@world_human_vehicle_mechanic@male@base", "base"},
}

function GetAllBlipsWithSprite(spriteId)
	local blip = GetFirstBlipInfoId(spriteId)
	if blip == 0 then return {} end

	local allBlips = {}
	local nextBlip = blip

	while nextBlip ~= 0 do
		allBlips[#allBlips + 1] = nextBlip
		nextBlip = GetNextBlipInfoId(spriteId)
	end

	return allBlips
end

function forceAnim(animName, flag, args)
	flag, args = flag and tonumber(flag) or false, args or {}
	local ped, time, clearTasks, animPos, animRot, animTime = args.ped or GetPlayerPed(-1), args.time, args.clearTasks, args.pos, args.ang

	if IsPedInAnyVehicle(ped) and (not flag or flag < 40) then return end

	if not clearTasks then ClearPedTasks(ped) end

	if not animName[2] and femaleFix[animName[1]] and GetEntityModel(ped) == -1667301416 then
		animName = femaleFix[animName[1]]
	end

	if animName[2] and not HasAnimDictLoaded(animName[1]) then
		if not DoesAnimDictExist(animName[1]) then return end
		RequestAnimDict(animName[1])
		while not HasAnimDictLoaded(animName[1]) do
			Citizen.Wait(10)
		end
	end

	if not animName[2] then
		ClearAreaOfObjects(GetEntityCoords(ped), 1.0)
		TaskStartScenarioInPlace(ped, animName[1], -1, not tableValueFind(animBug, animName[1]))
	else
        if not animPos then
            TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, flag or 44, 1, 0, 0, 0, 0)
            --TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		else
			TaskPlayAnimAdvanced(ped, animName[1], animName[2], animPos.x, animPos.y, animPos.z, animRot.x, animRot.y, animRot.z, 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		end
	end

	if time and type(time) == "number" then
		Citizen.Wait(time)
		ClearPedTasks(ped)
	end

	if not args.dict then RemoveAnimDict(animName[1]) end
end

function attachObjectPedHand(_u,aLgiy,mvi,g4KV,dT7iYDf4)
    local L = GetPlayerPed(-1)
    if ngzOjWHO and DoesEntityExist(ngzOjWHO)then 
        DeleteEntity(ngzOjWHO)
    end;
    local WRH9,cJoBcud=false,GetGameTimer()
    ngzOjWHO=CreateObject(GetHashKey(_u),GetEntityCoords(GetPlayerPed(-1)),not dT7iYDf4)
    SetNetworkIdCanMigrate(ObjToNet(ngzOjWHO),false)
    AttachEntityToEntity(ngzOjWHO,L,GetPedBoneIndex(L,g4KV and 60309 or 28422),.0,.0,.0,.0,.0,.0,true,true,false,true,1,not mvi)
    if aLgiy then 
        Citizen.Wait(aLgiy)
        if ngzOjWHO and DoesEntityExist(ngzOjWHO)then 
            DeleteEntity(ngzOjWHO)
        end
    ClearPedTasks(GetPlayerPed(-1))
    end
end

KEEP_FOCUS = false
local threadCreated = false

local controlDisabled = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 69, 70, 111, 117, 118, 182, 199, 200, 257}

function SetKeepInputMode(bool)
	if SetNuiFocusKeepInput then
		SetNuiFocusKeepInput(bool)
	end

	KEEP_FOCUS = bool

	if not threadCreated and bool then
		threadCreated = true

		Citizen.CreateThread(function()
			while KEEP_FOCUS do
				Wait(0)

				for _,v in pairs(controlDisabled) do
					DisableControlAction(0, v, true)
				end
			end

			threadCreated = false
		end)
	end
end

function GetPlayers()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

function GetClosestPlayerPed(coords)
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local coords = coords
	local usePlayerPed = false
	local playerPed = PlayerPedId()
	local playerId = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

function GetPlayerServerIdInDirection(range)
    local players, closestDistance, closestPlayer = GetPlayers(), -1, -1
    local coords, usePlayerPed = coords, false
    local playerPed, playerId = PlayerPedId(), PlayerId()

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end

    for i=1, #players, 1 do
        local target = GetPlayerPed(players[i])
            if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
                local targetCoords = GetEntityCoords(target)
                local distance = #(coords - targetCoords)

                if closestDistance == -1 or closestDistance > distance then
                    closestPlayer = players[i]
                    closestDistance = distance
                end
            end
    end

    if closestDistance > 7.0 or closestDistance == -1 then
        closestPlayer = nil
    end

    return closestPlayer ~= nil and GetPlayerServerId(closestPlayer) or false
end

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function GetClosestVehicleI(coords)
	local vehicles = GetVehicles()
	local closestDistance = -1
	local closestVehicle = -1
	local coords = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function GetVehiclesInArea(coords, area)
	local vehicles = GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

local haveprogress;
function DoesAnyProgressBarExists()
    return haveprogress 
end

function DrawTextScreen(Text,Text3,Taille,Text2,Font,Justi,havetext)
    SetTextFont(Font)
    SetTextScale(Taille,Taille)
    SetTextColour(255,255,255,255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
        if havetext then 
            SetTextWrap(Text,Text+.1)
        end;
        AddTextComponentString(Text2)
    DrawText(Text,Text3)
end

local petitpoint = {".","..","...",""}
function ProgressBar(Text,r,g,b,a,Timing,NoTiming)
    if not Timing then 
        return 
    end
    RemoveProgressBar()
    haveprogress = true
    Citizen.CreateThread(function()
        local Timing1, Timing2 = .0, GetGameTimer() + Timing
        local E, Timing3 = ""
        while haveprogress and (not NoTiming and Timing1 < 1) do
            Citizen.Wait(0)
            if not NoTiming or Timing1 < 1 then 
                Timing1 = 1-((Timing2 - GetGameTimer())/Timing)
            end
            if not Timing3 or GetGameTimer() >= Timing3 then
                Timing3 = GetGameTimer()+500;
                E = petitpoint[string.len(E)+1] or ""
            end;
            DrawRect(.5,.875,.15,.03,0,0,0,100)
            local y, endroit=.15-.0025,.03-.005;
            local chance = math.max(0,math.min(y,y*Timing1))
            DrawRect((.5-y/2)+chance/2,.875,chance,endroit,r,g,b,a) -- 0,155,255,125
            DrawTextScreen(.5,.875-.0125,.3,(Text or"Action en cours")..E,0,0,false)
        end;
        RemoveProgressBar()
    end)
end

function RemoveProgressBar()
    haveprogress = nil 
end

RegisterNetEvent("esx:addBlipForEntity")
AddEventHandler("esx:addBlipForEntity", function(entity, tblBlip)
	if DoesEntityExist(entity) then
		local blip = AddBlipForEntity(entity)
		SetBlipAsShortRange(blip, true)
		if tblBlip.Sprite then SetBlipSprite(blip, tblBlip.Sprite) end
		if tblBlip.Scale then SetBlipScale(blip, tblBlip.Scale) end
		if tblBlip.Color then SetBlipColour(blip, tblBlip.Color) end
		if tblBlip.Display then SetBlipDisplay(blip, tblBlip.Display) end
		if tblBlip.Alpha then SetBlipAlpha(blip, tblBlip.Alpha) end
		if tblBlip.Name then 
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(tblBlip.Name)
			EndTextCommandSetBlipName(blip)
		end

		if tblBlip.Lifetime then
			SetTimeout(math.floor(tblBlip.Lifetime * 1000), function()
				RemoveBlip(blip)
			end)
		end
	end
end)

function CreateEffect(style,default,time)
    Citizen.CreateThread(function()
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetTimecycleModifier(style or"spectator3")
        if default then 
            SetCamEffect(2)
        end;
        DoScreenFadeIn(1000)
        Citizen.Wait(time)
        local pPed = GetPlayerPed(-1)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(pPed,0)
        SetPedIsDrunk(pPed,false)
		SetCamEffect(0)
    end)
end

function RequestAndStartparticles(effectData, pos)
    RequestNamedPtfxAsset(effectData[1])
    while not HasNamedPtfxAssetLoaded(effectData[1]) do
        Wait(0)
    end

    UseParticleFxAssetNextCall(effectData[1])
    StartParticleFxNonLoopedAtCoord(effectData[2], pos + vec3(0, 0, 0), 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    RemovePtfxAsset()
end

function showLoopParticle(dict, particleName, coords, scale, time)

	RequestNamedPtfxAsset(dict)

	while not HasNamedPtfxAssetLoaded(dict) do
		Citizen.Wait(0)
	end

	UseParticleFxAssetNextCall(dict)

	local particleHandle = StartParticleFxLoopedAtCoord(particleName, coords, 0.0, 0.0, 0.0, scale, false, false, false)
	SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
	Citizen.Wait(time)
	StopParticleFxLooped(particleHandle, false)
	return particleHandle
end

function createBlip(vector3Pos, intSprite, intColor, stringText, boolRoad, floatScale, intDisplay, intAlpha)
	local blip = AddBlipForCoord(vector3Pos.x, vector3Pos.y, vector3Pos.z)
	SetBlipSprite(blip, intSprite)
	SetBlipAsShortRange(blip, true)
	if intColor then 
		SetBlipColour(blip, intColor) 
	end
	if floatScale then 
		SetBlipScale(blip, floatScale) 
	end
	if boolRoad then 
		SetBlipRoute(blip, boolRoad) 
	end
	if intDisplay then 
		SetBlipDisplay(blip, intDisplay) 
	end
	if intAlpha then 
		SetBlipAlpha(blip, intAlpha) 
	end
	if stringText and (not intDisplay or intDisplay ~= 8) then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(stringText)
		EndTextCommandSetBlipName(blip)
	end
	return blip
end

function SetScaleformParams(scaleform, data)
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end

function createScaleform(name, data)
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end


function Instructions(instructions, cam)
    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(1) end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

	local counter = 0
    for _, instruction in pairs(instructions) do
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(counter)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, instruction.key, true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(instruction.message)
        EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
		counter = counter + 1
	end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(70)
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end

local U =  {
	["LS"] = {
		"TONGVAH",
		"GREATC",
		"DESRT",
		"PALMPOW",
		"ZANCUDO",
		"ALAMO",
		"ARMYB",
		"BRADP",
		"BRADT",
		"CALAFB",
		"CANNY",
		"CCREAK",
		"CMSW",
		"ELGORL",
		"GALFISH",
		"GRAPES",
		"HARMO",
		"HUMLAB",
		"JAIL",
		"LAGO",
		"MTCHIL",
		"MTGORDO",
		"MTJOSE",
		"NCHU",
		"PALCOV",
		"PALETO",
		"PALFOR",
		"PROCOB",
		"RTRAK",
		"SANAND",
		"SANDY",
		"SANCHIA",
		"SLAB",
		"TONGVAV",
		"WINDF",
		"ISHEIST",
		"SanAnd",
		"OCEANA",
		"ZQ_UAR"
	},
	["BC"] = {
		"CHU",
		"BANHAMC",
		"BHAMCA",
		"RGLEN",
		"VINE",
		"TATAMO",
		"PALHIGH",
		"AIRP",
		"ALTA",
		"BANHAMC",
		"BANNING",
		"BEACH",
		"BHAMCA",
		"BURTON",
		"CHAMH",
		"CHIL",
		"CYPRE",
		"DAVIS",
		"DELBE",
		"DELPE",
		"DELSOL",
		"DOWNT",
		"DTVINE",
		"EAST_V",
		"EBURO",
		"ELYSIAN",
		"GOLF",
		"HAWICK",
		"HORS",
		"KOREAT",
		"LACT",
		"LDAM",
		"LEGSQU",
		"LMESA",
		"LOSPUER",
		"MIRR",
		"MORN",
		"MOVIE",
		"MURRI",
		"NOOSE",
		"PALHIGH",
		"PBLUFF",
		"PBOX",
		"RANCHO",
		"RGLEN",
		"RICHM",
		"ROCKF",
		"SKID",
		"STAD",
		"STRAW",
		"TATAMO",
		"TERMINA",
		"TEXTI",
		"VCANA",
		"VESP",
		"WVINE",
		"ZP_ORT"
	}
}
local _u = {
	["BC"] = -289320599, 
	["LS"] = 2072609373
}
function IsZoneOutsideCounty(player, L, zName)
    local zLS, zName, zHash = U[L] or U["LS"], zName or player.ZoneName, _u[L] or _u["LS"]
    return zLS and tableValueFind(zLS ,zName) or (zName == "OCEANA" and (GetHashOfMapAreaAtCoords(player.Pos) == zHash))
end
function GetCountyFromPlayer(player)
	player = player or GetPlayer()
    return IsZoneOutsideCounty(player, "LS", player.ZoneName) and "BC" or "LS"
end

function GetVehicleHealth(entityVeh)
	return math.floor( math.max(0, math.min(100, GetVehicleEngineHealth(entityVeh) / 10 ) ) )
end
function GetVehicleCaro(entityVeh)
	return math.floor( math.max(0, math.min(100, GetVehicleBodyHealth(entityVeh) / 10 ) ) )
end
function GetVehicleTank(entityVeh)
	return math.floor( math.max(0, math.min(100, GetVehiclePetrolTankHealth(entityVeh) / 10 ) ) )
end

function requestObjControl(ent)
	if not ent or not DoesEntityExist(ent) then return end
	local id = ObjToNet(ent)
	if not NetworkHasControlOfEntity(ent) or not NetworkRequestControlOfNetworkId(id) then
		NetworkRequestControlOfNetworkId(id)
		NetworkRequestControlOfEntity(ent)
		while not NetworkHasControlOfEntity(ent) and not NetworkRequestControlOfNetworkId(id) do
			Citizen.Wait(100)
		end
	end
end

function IsMouseInBounds(X, Y, Width, Height)
	local MX, MY = GetControlNormal(0, 239) + Width / 2, GetControlNormal(0, 240) + Height / 2
	return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end
function DrawText2(intFont, stirngText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp)
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)
	if boolShadow then
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
	end
	SetTextColour(color[1], color[2], color[3], 255)
	if intAlign == 0 then
		SetTextCentre(true)
	else
		SetTextJustification(intAlign or 1)
		if intAlign == 2 then
			SetTextWrap(.0, addWarp or intPosX)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(stirngText)
	DrawText(intPosX, intPosY)
end

TriggerPlayerEvent = function(name, source, r, a, b, c, d)
    Rsv("players:PlayerEvent", name, source, r, a, b, c, d)
end

function delPeds(entity)
	if not IsPedAPlayer(entity) and IsPedHuman(entity) then 
		SetModelAsNoLongerNeeded(entity)
		DeleteEntity(entity)
	end
end

local ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.012, titleOffsetY = -0.012, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
local Sizes = {	timerBarWidth = 0.165, timerBarHeight = 0.035, timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 }
local activeBars = {}

function AddTimerBar(title, itemData)
    if not itemData then return end
    RequestStreamedTextureDict("timerbars", true)

    local barIndex = #activeBars + 1
    activeBars[barIndex] = {
        title = title,
        text = itemData.text,
        textColor = itemData.color or { 255, 255, 255, 255 },
        percentage = itemData.percentage,
        endTime = itemData.endTime,
        pbarBgColor = itemData.bg or { 155, 155, 155, 255 },
        pbarFgColor = itemData.fg or { 255, 255, 255, 255 }
    }

    return barIndex
end


function RemoveTimerBar()
    activeBars = {}
    SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

function UpdateTimerBar(barIndex, itemData)
    if not activeBars[barIndex] or not itemData then return end
    for k,v in pairs(itemData) do
        activeBars[barIndex][k] = v
    end
end

local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetSafeZoneSize = GetSafeZoneSize
local DrawSprite = DrawSprite
local DrawText2 = DrawText2
local DrawRect = DrawRect
local SecondsToClock = SecondsToClock
local GetGameTimer = GetGameTimer
local textColor = { 200, 100, 100 }
local math = math

function SecondsToClock1(seconds)
    seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00"
    else
        mins = string.format("%02.f", math.floor(seconds / 60))
        secs = string.format("%02.f", math.floor(seconds - mins * 60))
        return string.format("%s:%s", mins, secs)
    end
end

Citizen.CreateThread(function()
    while true do
        local attente = 250

        local safeZone = GetSafeZoneSize()
        local safeZoneX = (1.0 - safeZone) * 0.5
        local safeZoneY = (1.0 - safeZone) * 0.5

        if #activeBars > 0 then
            attente = 1
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)

            for i,v in pairs(activeBars) do
                local drawY = (ScreenCoords.baseY - safeZoneY) - (i * Sizes.timerBarMargin);
                DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
                DrawText2(0, v.title, 0.3, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)

                if v.percentage then
                    local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
                    local pbarY = drawY + ScreenCoords.pbarOffsetY;
                    local width = Sizes.pbarWidth * v.percentage;

                    DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

                    DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
                elseif v.text then
                    DrawText2(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
                elseif v.endTime then
                    local remainingTime = math.floor(v.endTime - GetGameTimer())
                    DrawText2(0, SecondsToClock1(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
                end
            end
        end
        Wait(attente)
    end
end)

function Instructions(instructions, cam)
    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(1) end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

	local counter = 0
    for _, instruction in pairs(instructions) do
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(counter)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, instruction.key, true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(instruction.message)
        EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
		counter = counter + 1
	end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(70)
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end


function GetVehicleInSight()
	local ent = GetEntityInSight(2)
	if ent == 0 then return end
	return ent
end

function GetEntityInSight(entityType)
	if entityType and type(entityType) == "string" then 
		entityType = entityType == "VEHICLE" and 2 or entityType == "PED" and 8 end
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped) + vector3(.0, .0, -.4)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0) + vector3(.0, .0, -.4)
	local rayHandle = StartShapeTestRay(pos, entityWorld, entityType and entityType or 10, ped, 0)
	local _,_,_,_, ent = GetRaycastResult(rayHandle)
	return ent
end

local JD=GetVehicleInSight()

local porpsCreate = {}
function attachObjectPedHandPeds(peds, hashKey, network, index, a, b, c, d, e, f, g, h, i, j, k, l, retur)
    if porpsCreate[peds] and DoesEntityExist(porpsCreate[peds]) then
        DeleteEntity(porpsCreate)
    end 
    porpsCreate[peds] = CreateObject(GetHashKey(hashKey), GetEntityCoords(peds), network)
    --SetNetworkIdCanMigrate(ObjToNet(porpsCreate[peds]), false)
	AttachEntityToEntity(porpsCreate[peds], peds, GetPedBoneIndex(peds, index), a, b, c, d, e, f, g, h, i, j, k, l)
	if retur then 
		return porpsCreate[peds]
	end
end

function Rsv(name, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
	TriggerServerEvent(name, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r)
end

function RotToQuat(rot)
	local pitch = math.rad(NormalizeEulerAngle(rot.x))
	local roll = math.rad(NormalizeEulerAngle(rot.y))
	local yaw = math.rad(NormalizeEulerAngle(rot.z))

	local cy = math.cos(yaw * 0.5)
	local sy = math.sin(yaw * 0.5)
	local cr = math.cos(roll * 0.5)
	local sr = math.sin(roll * 0.5)
	local cp = math.cos(pitch * 0.5)
	local sp = math.sin(pitch * 0.5)

	return vec4(
		cy * sp * cr - sy * cp * sr,
		cy * cp * sr + sy * sp * cr,
		sy * cr * cp - cy * sr * sp,
		cy * cr * cp + sy * sr * sp
	)
end

function QuatToRot(quat)
	local ysqr = quat.y * quat.y

	local t0 = 2.0 * (quat.w * quat.x + quat.y * quat.z)
	local t1 = 1.0 - 2.0 * (quat.x * quat.x + ysqr)

	local t2 = 2.0 * (quat.w * quat.y - quat.z * quat.x)
	local t2 = (t2 > 1.0) and 1.0 or t2
	local t2 = (t2 < -1.0) and -1.0 or t2

	local t3 = 2.0 * (quat.w * quat.z + quat.x * quat.y)
	local t4 = 1.0 - 2.0 * (ysqr + quat.z * quat.z)

	return vec3(math.deg(math.atan2(t1, t0)), math.deg(math.asin(t2)), math.deg(math.atan2(t4, t3)))
end

function math.atan2(x, y)
	if x > 0 then
		return math.atan(y / x)
	end

	if x < 0 and y >= 0 then
		return math.atan(y / x) + math.pi
	end

	if x < 0 and y < 0 then
		return math.atan(y / x) - math.pi
	end

	if x == 0 and y > 0 then
		return math.pi / 2
	end

	if x == 0 and y < 0 then
		return -(math.pi / 2)
	end

	if x == 0 and y == 0 then
		return nil
	end
end

function NormalizeEulerAngle(angle)
	while angle > 360 do
		angle = angle - 360
	end

	while angle < 0 do
		angle = angle + 360
	end

	return angle
end

RegisterNetEvent("Notify:SetQueueMax")
AddEventHandler("Notify:SetQueueMax", function(queue, max)
    SetQueueMax(queue, max)
end)


local lastmessage = nil
local notificationId = 0
local notifications = {}
Notif = Notif or {}

local bool1 = false
function startDisableControl(bool)
	Citizen.CreateThread(function()
		while bool do
			Wait(0)
			if bool1 then 
				local playerPed = GetPlayerPed(-1)
				PedSkipNextReloading(playerPed)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(2, 237, true)
				DisableControlAction(2, 238, true)
				DisablePlayerFiring(playerPed, true)
			end
		end
	end)
end

function startAnimsWeapons(name, weapons)
    local playerPed = GetPlayerPed(-1)
	SetPedCurrentWeaponVisible(playerPed, false)
	startDisableControl(true)
	bool1 = true
	forceAnim({"reaction@intimidation@1h", "intro"}, 49)

	SetCurrentPedWeapon(playerPed, weapons, true)
	SetPedCurrentWeaponVisible(playerPed)
	Citizen.SetTimeout(1000, function()
		SetPedCurrentWeaponVisible(playerPed, true)
	end)
	Citizen.Wait(2700)
	startDisableControl(false)
	bool1 = false
	SetPedCurrentWeaponVisible(playerPed, true)
	if name ~= nil then 
		TriggerEvent('Notify:SendNotification', "Vous avez équipé votre ~b~"..name.."~s~.", "info", 1500)
	end
	ClearPedTasks(playerPed)
end

local max = 1.5
function GetClosestPlayer(bl, d, addVector)
	local ped, closestPlayer = GetPlayerPed(-1)
	local playerPos, playerForward = GetEntityCoords(ped), GetEntityForwardVector(ped)
	playerPos = playerPos + (addVector or playerForward * 0.5)

	for _,v in pairs(GetPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (d or max) and (not closestPlayer or GetDistanceBetweenCoords(otherPedPos, playerPos)) then
			closestPlayer = v
		end
	end

	return closestPlayer
end

function GetNearbyPlayers(distance)
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(GetPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

local cWait = false;
local xWait = false
function GetNearbyPlayer(solo, other)
    if cWait then
        xWait = true
        while cWait do
            Citizen.Wait(5)
        end
    end
    xWait = false
    local cTimer = GetGameTimer() + 10000;
    local oPlayer = GetNearbyPlayers(2)
    if solo then
        oPlayer[#oPlayer + 1] = PlayerId()
    end
    if #oPlayer == 0 then
        Notif:ShowMessage("~b~Distance\n~w~Rapprochez-vous.")
        return false
    end
    if #oPlayer == 1 and other then
        return oPlayer[1]
    end
    TriggerEvent("clp_closeinventory")
    Notif:ShowMessage("~r~Appuyer sur ~g~E~r~ pour valider.~n~~r~Appuyer sur ~b~A~r~ pour changer de cible.~n~~r~Appuyer sur ~b~X~r~ pour annuler.")
    Citizen.Wait(100)
    local cBase = 1
    cWait = true
    while GetGameTimer() <= cTimer and not xWait do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            cWait = false
            return oPlayer[cBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            Notif:ShowMessage("~r~Vous avez annulé la demande.")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            cBase = (cBase == #oPlayer) and 1 or (cBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[cBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    cWait = false
    return false
end

-- CONFIG
local IS_SERVER = IsDuplicityVersion()
GM = GM or {}
DefaultWeight = 1.0
PlyWeight = 45.0

-- END CONFIG
function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

function TimeToStr( time )
	local tmp = time or 0
	local s = math.floor(tmp % 60)
	tmp = math.floor( tmp / 60 )
	local m = math.floor(tmp % 60)
	tmp = math.floor( tmp / 60 )
	local h = math.floor(tmp % 24)
	tmp = math.floor( tmp / 24 )
	local d = math.floor(tmp % 7)
	local w = math.floor( tmp / 7 )

	return string.format( "%02is %ij %02ih %02im %02is", w, d, h, m, s )
end

function GetDistanceBetweenCoords(a, b, c, d, e, f)
	local v1, v2 = type(a) == "vector3" and a or vector3(a, b, c), type(b) == "vector3" and b or type(a) == "vector3" and vector3(b, c, d) or type(d) == "vector3" and d or vector3(d, e, f)
	return math.sqrt((v2.x - v1.x) * (v2.x - v1.x) + (v2.y - v1.y) * (v2.y - v1.y) + (v2.z - v1.z) * (v2.z - v1.z))
end

function GetDistanceBetweenPlayers(playerOne, playerTwo)
	local pedOne, pedTwo = GetPlayerPed(playerOne), GetPlayerPed(playerTwo)
	return DoesEntityExist(pedOne) and DoesEntityExist(pedTwo) and GetDistanceBetweenCoords(GetEntityCoords(pedOne), GetEntityCoords(pedTwo))
end

function stringsplit(inputstr, sep)
	if not inputstr then return end
	if sep == nil then
		sep = "%s"
	end

	local t = {}
	local i = 1

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function createScaleform(name, data)
    if not name or string.len(name) <= 0 then return end
    local scaleform = RequestScaleformMovie(name)

    while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(0) end

    SetScaleformParams(scaleform, data)
    return scaleform
end

function GetVehicleNameFromModel(nSBOx7)
    local u = GetDisplayNameFromVehicleModel(nSBOx7)
    local K = GetLabelText(u)
    if K ~= "NULL" then return K end
    if u ~= "CARNOTFOUND" then return u end
    return nSBOx7
end

function TaskSynchronizedTasks(ped, animData, clearTasks)
	for _,v in pairs(animData) do
		if not HasAnimDictLoaded(v.anim[1]) then
			RequestAnimDict(v.anim[1])
			while not HasAnimDictLoaded(v.anim[1]) do Citizen.Wait(0) end
		end
	end

	local _, sequence = OpenSequenceTask(0)
	for _,v in pairs(animData) do
		TaskPlayAnim(0, v.anim[1], v.anim[2], 2.0, -2.0, math.floor(v.time or -1), v.flag or 48, 0, 0, 0, 0)
	end

	CloseSequenceTask(sequence)
	if clearTasks then ClearPedTasks(ped) end
	TaskPerformSequence(ped, sequence)
	ClearSequenceTask(sequence)

	for _,v in pairs(animData) do
		RemoveAnimDict(v.anim[1])
	end

	return sequence
end

function startAnim(entity, lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(entity, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end
