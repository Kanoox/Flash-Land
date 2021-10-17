GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    TriggerServerEvent("fl_burglary:globalEvent", options)
end

FetchHouseData = function()
    ESX.TriggerServerCallback("fl_burglary:fetchData", function(data)
        cachedData.houseData = data
    end)
end

BeginLockpick = function(id, data)
    RequestAnimDict('missheistfbisetup1')
    while not HasAnimDictLoaded('missheistfbisetup1') do
        Wait(0)
    end
    local timer = 0
    TaskPlayAnim(PlayerPedId(), 'missheistfbisetup1', 'hassle_intro_loop_f', 8.0, -8, -1, 11, 0, 0, 0, 0)
    Wait(50)
    while true do
        if IsEntityPlayingAnim(PlayerPedId(), 'missheistfbisetup1', 'hassle_intro_loop_f', 3) then
            timer = timer+10
            if math.floor((timer / 1000) / Config.LockPickTime * 100) >= 100 then
                ClearPedTasksImmediately(PlayerPedId())
                GlobalFunction("lockpick_house", {
                    houseId = id,
                    saveData = true
                })
                break
            end
        else
            ESX.ShowNotification('Vous avez annulé le crochetage...')
            break
        end
        drawTxt(0.97, 0.6, 1.0, 1.0, 0.5, "Crochetage... ~b~" .. math.floor((timer / 1000) / Config.LockPickTime * 100) .. "~s~%", 255, 255, 255, 255)
        Wait(0)
    end
end

LockHouse = function(id, data)
    while not HasAnimDictLoaded('missheistfbisetup1') do
        RequestAnimDict('missheistfbisetup1')
        Wait(0)
    end
    local timer = 0
    TaskPlayAnim(PlayerPedId(), 'missheistfbisetup1', 'hassle_intro_loop_f', 8.0, -8, -1, 11, 0, 0, 0, 0)
    Wait(50)
    while true do
        if IsEntityPlayingAnim(PlayerPedId(), 'missheistfbisetup1', 'hassle_intro_loop_f', 3) then
            timer = timer+10
            if math.floor((timer / 1000) / Config.LockTime * 100) >= 100 then
                ESX.ShowNotification("Vous avez verrouillé la porte et arrêté l'alarme.")
                ClearPedTasksImmediately(PlayerPedId())
                GlobalFunction("lock_house", {
                    houseId = id,
                    saveData = true
                })
                break
            end
        else
            ESX.ShowNotification('Tu as arrêté de verrouiller la porte...')
            break
        end
        drawTxt(0.97, 0.6, 1.0, 1.0, 0.5, "Locking... ~b~" .. math.floor((timer / 1000) / Config.LockTime * 100) .. "~s~%", 255, 255, 255, 255)
        Wait(0)
    end
end

EnterHouse = function(id, data)
    local type = Config.Interiors[data.HouseType]

    TriggerEvent('instance:create', 'burglary', {burglary = 'burglary_'..id})
    ESX.Game.Teleport(PlayerPedId(), type.Exit)
    cachedData.InsideHouse = true

    Citizen.CreateThread(function()

        while cachedData.InsideHouse do

            local sleep = 500
            local pedCoords = GetEntityCoords(PlayerPedId())
            local dstcheck = #(pedCoords - type.Exit)
            local text = "Exit"

            if dstcheck <= 5.5 then
                sleep = 5
                if dstcheck <= 1.3 then
                    text = "[~b~E~s~] Exit"
                    if IsControlJustReleased(0, 38) then
                        ExitHouse(id, data)
                    end
                end
                ESX.Game.Utils.DrawText3D(type.Exit, text, 0.6)
                DrawMarker(6, type.Exit-vector3(0.0,0.0,0.975), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 55, 100, 200, 155, 0, false, false, 0, false, false, false, false)
            end


            for LootablesId, LootablesData in pairs(type.Lootables) do

                local dstcheck = #(pedCoords - LootablesData.Pos)
                local text = LootablesId

                if dstcheck <= 2.5 then
                    sleep = 5
                    if dstcheck <= 1.3 then
                        text = "[~b~E~s~] Loot " .. LootablesId
                        if IsControlJustReleased(0, 38) then
                            if not cachedData.houseData[id].Lootables[LootablesId] then
                                LootPlace(data, id, LootablesId, LootablesData)
                            else
                                ESX.ShowNotification("Quelqu'un a déjà pillé cela.")
                            end
                        end
                    end
                    ESX.Game.Utils.DrawText3D(LootablesData.Pos, text, 0.6)
                    DrawMarker(6, LootablesData.Pos-vector3(0.0,0.0,0.975), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 55, 100, 200, 155, 0, false, false, 0, false, false, false, false)
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

CreateBlip = function(eventData)
    if cachedData[eventData.houseId] == nil then cachedData[eventData.houseId] = {} end
    cachedData[eventData.houseId].Blip = AddBlipForCoord(Config.Coords[eventData.houseId].Pos)
    SetBlipSprite(cachedData[eventData.houseId].Blip, 418)
    SetBlipScale(cachedData[eventData.houseId].Blip, 1.0)
	SetBlipColour(cachedData[eventData.houseId].Blip, 1)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Coords[eventData.houseId].Info)
    EndTextCommandSetBlipName(cachedData[eventData.houseId].Blip)
    PulseBlip(cachedData[eventData.houseId].Blip)
end

LootPlace = function(data, id, LootablesId, LootablesData)
    TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_BUM_BIN", LootablesData.Pos, LootablesData.Heading, 0, false, false)

    cachedData.startedSearching = GetGameTimer()

    while GetGameTimer() - cachedData.startedSearching < Config.SearchTime do
        Citizen.Wait(5)

        if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_BUM_BIN") then
            ESX.ShowNotification("Vous avez arrêté de chercher.")

            return
        end

        drawTxt(0.97, 0.6, 1.0, 1.0, 0.5, "Recherche... " ..LootablesId, 255, 255, 255, 255)
    end

    GlobalFunction("loot_place", {
        saveData = true,
        houseId = id,
        lootSpot = LootablesId
    })

    ESX.TriggerServerCallback("fl_burglary:lootItem", function(loot)
        if loot then
            ESX.ShowNotification("Vous avez un " ..loot)
        end
    end)

    ClearPedTasks(PlayerPedId())
end

CameraMenu = function()
    local menuElements = {}
    for houseId, houseData in pairs(cachedData.houseData) do
        if not houseData.locked then
            table.insert(menuElements, {
                label = Config.Coords[houseId].Info,
                action = houseId,
            })
        end
    end

    if #menuElements == 0 then
        ESX.ShowNotification('~r~Aucune maison en cours de cambriolage..')
        return
    end

    ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'vehicle_warehouse',
        {
            title = 'Camera maison',
            elements = menuElements,
        },
        function(menuData, menuHandle)
            if menuData.current.action then
                EnterCameraMode(menuData.current.action)
                menuHandle.close()
            end
        end,
    function(menuData, menuHandle)
        menuHandle.close()
    end)
end

EnterCameraMode = function(id, data)
    Citizen.CreateThread(function()
        local houseData = Config.Coords[id]
        cachedData.currentCam = 1
        cachedData.cameraAmount = #Config.Interiors[houseData.HouseType].Cameras
        TriggerEvent('instance:create', 'burglary', {burglary = 'burglary_'..id})
        CreateCameras(houseData)
        DrawBusySpinner("Connecting to security cameras...")
        RequestAnimDict('missheist_jewel@hacking')
        while not HasAnimDictLoaded('missheist_jewel@hacking') do
            Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), 'missheist_jewel@hacking', 'hack_loop', 8.0, -8, -1, 11, 0, 0, 0, 0)
        Wait(2500)
        DoScreenFadeOut(1500)
        Wait(3000)
        RemoveLoadingPrompt()
        cachedData.cameraMode = true
        SetCamActive(cachedData.Cameras[cachedData.currentCam], true)
        RenderScriptCams(true, false, 0, true, true)
        SetTimecycleModifier("scanline_cam")
        DoScreenFadeIn(1250)
        Wait(1200)

        while cachedData.cameraMode do
            Wait(0)
            DrawButtons({
                {
                    button = "~INPUT_FRONTEND_RRIGHT~",
                    label = "Sortir"
                },
                {
                    button = "~INPUT_CELLPHONE_RIGHT~",
                    label = "Cam suivante"
                },
                {
                    button = "~INPUT_CELLPHONE_LEFT~",
                    label = "Cam précédente"
                }
            })

            if IsControlJustReleased(0, 174) then
                if cachedData.currentCam > 1 then
                    SetCamActive(cachedData.Cameras[cachedData.currentCam], false)
                    cachedData.currentCam = cachedData.currentCam - 1
                else
                    cachedData.currentCam = cachedData.cameraAmount
                end
            elseif IsControlJustReleased(0, 175) then
                if cachedData.currentCam < cachedData.cameraAmount then
                    SetCamActive(cachedData.Cameras[cachedData.currentCam], false)
                    cachedData.currentCam = cachedData.currentCam + 1
                else
                    cachedData.currentCam = 1
                end
            elseif IsControlJustReleased(0, 177) then
                DrawBusySpinner("Déconnexion des caméras de sécurité...")
                DoScreenFadeOut(1500)
                Wait(2500)
                TriggerEvent('instance:leave')
                for cam=1, #cachedData.Cameras do
                    DestroyCam(cachedData.Cameras[cam], true)
                    RenderScriptCams(false, false, 0, true, true)
                end
                ClearPedTasksImmediately(PlayerPedId())
                ClearTimecycleModifier()
                Wait(1000)
                DoScreenFadeIn(1250)
                RemoveLoadingPrompt()
                cachedData.cameraMode = false
                break
            end
            if not IsCamActive(cachedData.Cameras[cachedData.currentCam]) then
                SetCamActive(cachedData.Cameras[cachedData.currentCam], true)
                RenderScriptCams(true, false, 0, true, true)
            end
        end
    end)
end

CreateCameras = function(houseData)
    local configData = Config.Interiors[houseData.HouseType].Cameras
    for id, data in ipairs(configData) do
        cachedData.Cameras[id] = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", data.Pos, data.Rotation, 80.0)
    end
end

ExitHouse = function(id, data)
    ESX.Game.Teleport(PlayerPedId(), Config.Coords[id].Pos)
    SetEntityHeading(PlayerPedId(), Config.Coords[id].Heading)
    cachedData.InsideHouse = false
    TriggerEvent('instance:leave')
end

drawTxt = function(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if outline then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

HasLockPick = function()
	local inventory = ESX.GetPlayerData().inventory
	local ItemAmount = nil
	for i=1, #inventory, 1 do
		if inventory[i].name == Config.LockPickItem then
			ItemAmount = inventory[i].count
		end
	end
	if ItemAmount > 0 then
		return true
	end
	return false
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end

DrawButtons = function(buttonsToDraw)
	Citizen.CreateThread(function()
		local instructionScaleform = RequestScaleformMovie("instructional_buttons")

		while not HasScaleformMovieLoaded(instructionScaleform) do
			Wait(0)
		end

		PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
		PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
		PushScaleformMovieFunctionParameterBool(0)
		PopScaleformMovieFunctionVoid()

		for buttonIndex, buttonValues in ipairs(buttonsToDraw) do
			PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

			PushScaleformMovieMethodParameterButtonName(buttonValues.button)
			PushScaleformMovieFunctionParameterString(buttonValues.label)
			PopScaleformMovieFunctionVoid()
		end

		PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		PushScaleformMovieFunctionParameterInt(-1)
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
	end)
end