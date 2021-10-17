local lastSkin, cam, isCameraActive
local firstSpawn, zoomOffset, camOffset, heading = true, 0.0, 0.0, 90.0
local zoom = 0
local angle = 90

function OpenMenu(submitCb, cancelCb, restrict)
    local playerPed = PlayerPedId()

    TriggerEvent('skinchanger:getSkin', function(skin)
        LastSkin = skin
    end)

    TriggerEvent('skinchanger:getData', function(components, maxVals)
        local elements = {}
        local _components = {}

        -- Restrict menu
        if restrict == nil then
            for i = 1, #components, 1 do
                _components[i] = components[i]
            end
        else
            for i = 1, #components, 1 do
                local found = false

                for j = 1, #restrict, 1 do
                    if components[i].name == restrict[j] then
                        found = true
                    end
                end

                if found then
                    table.insert(_components, components[i])
                end
            end
        end

        -- Insert elements
        for i = 1, #_components, 1 do
            local value = _components[i].value
            local componentId = _components[i].componentId

            if componentId == 0 then
                value = GetPedPropIndex(playerPed, _components[i].componentId)
            end

            local items = {}

            for k, v in pairs(maxVals) do
                if k == _components[i].name then
                    _components[i].max = v
                    break
                end
            end

            for any = _components[i].min, _components[i].max do
                table.insert(items, any)
            end

            if _components[i].max < _components[i].min then
                table.insert(items, _components[i].min)
            end

            local data = {
                label = _components[i].label,
                name = _components[i].name,
                index = value + 1,
                textureof = _components[i].textureof,
                zoomOffset = _components[i].zoomOffset,
                camOffset = _components[i].camOffset,
                min = _components[i].min,
                type = 'list',
                items = items,
            }

            table.insert(elements, data)
        end

        CreateSkinCam()
        zoomOffset = _components[1].zoomOffset
        camOffset = _components[1].camOffset

        ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'skin', {
            title = 'Personnalisation',
            elements = elements
        }, function(data, menu) --submit
            data.current.value = data.current.items[data.current.index] -- shitty code because too much evasive everywhere
            TriggerEvent('skinchanger:getSkin', function(skin)
                LastSkin = skin
            end)

            submitCb(data, menu)
            DeleteSkinCam()
        end, function(data, menu) -- cancel
            ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
                if skin == nil then
                    ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'confirm_escape', {
                        title = ('Voulez-vous vraiment quitter ? (Tous les changements seront perdus)'),
                        elements = {
                            { label = 'Non', value = 'no' },
                            { label = 'Oui', value = 'yes' }
                        }
                    }, function(data2, menu2) -- submit
                        if data2.current.value == 'yes' then
                            menu.close()
                            DeleteSkinCam()
                            TriggerEvent('skinchanger:loadSkin', LastSkin)
                            Citizen.Wait(1000)
                            TriggerEvent('skinchanger:getSkin', function(skin)

                                if skin.hair_1 == 0 and skin.tshirt_1 == 0 and skin.shoes_1 == 0 and skin.torso_1 == 0 then
                                    Citizen.Wait(1000)
                                    ESX.ShowNotification("Vous devez personnaliser votre personnage..")
                                    Citizen.Wait(1000)
                                    TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu)
                                end
                            end)
                        end

                        menu2.close()
                    end)
                else
                    DeleteSkinCam()
                    menu.close()
                end
            end)

            if cancelCb ~= nil then
                cancelCb(data, menu)
            end
        end, function(data, menu) -- change
            TriggerEvent('skinchanger:getSkin', function(skin)
                zoomOffset = data.current.zoomOffset
                camOffset = data.current.camOffset

                if skin[data.current.name] ~= data.current.items[data.current.index] then
                    -- Change skin element
                    TriggerEvent('skinchanger:change', data.current.name, data.current.items[data.current.index])

                    -- Update max values
                    TriggerEvent('skinchanger:getData', function(components, maxVals)
                        for i = 1, #data.elements do
                            local newData = {}

                            local items = {}

                            for any = data.elements[i].min, maxVals[data.elements[i].name] do
                                table.insert(items, any)
                            end

                            if maxVals[data.elements[i].name] < data.elements[i].min then
                                table.insert(items, data.elements[i].min)
                            end

                            newData.items = items

                            if data.elements[i].textureof ~= nil and data.current.name == data.elements[i].textureof then
                                newData.index = 1
                            end

                            menu.update({ name = data.elements[i].name }, newData)
                        end
                    end)
                end
            end)
        end, function(data, menu) -- close
            ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
                if skin == nil then
                    ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'confirm_escape', {
                        title = ('Valider ce skin ?'),
                        elements = {
                            { label = 'Non', value = 'no' },
                            { label = 'Oui', value = 'yes' }
                        }
                    }, function(data3, menu3)
                        if data3.current.value == 'yes' then
                            menu3.close()
                            DeleteSkinCam()
                            TriggerEvent('skinchanger:loadSkin', LastSkin)
                            Citizen.Wait(1000)
                            TriggerEvent('skinchanger:getSkin', function(skin)

                                if skin.hair_1 == 0 and skin.tshirt_1 == 0 and skin.shoes_1 == 0 and skin.torso_1 == 0 then
                                    Citizen.Wait(1000)
                                    ESX.ShowNotification("Vous devez personnaliser votre personnage..")
                                    Citizen.Wait(1000)
                                    TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu)
                                end
                            end)
                        else
                            TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu)
                        end

                        menu3.close()
                        menu.close()
                    end)
                else
                    TriggerEvent('skinchanger:loadSkin', LastSkin)
                    DeleteSkinCam()
                end
            end)
        end)
    end)
end

function CreateSkinCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    InCameraActive()
    SetCamRot(cam, 0.0, 0.0, 270.0, true)
    SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end

function InCameraActive()
    isCameraActive = true
    Citizen.CreateThread(function()
        while isCameraActive do
            Citizen.Wait(0)
            HideHudAndRadarThisFrame()

            DisableControlAction(2, 30, true)
            DisableControlAction(2, 31, true)
            DisableControlAction(2, 33, true)
            DisableControlAction(2, 34, true)
            DisableControlAction(2, 35, true)
            DisableControlAction(0, 25, true) -- Input Aim
            DisableControlAction(0, 24, true) -- Input Attack

            angle = GetGameplayCamRot(0).z
            if IsControlJustPressed(0, 32) then -- Scrollup
                zoom = zoom - 0.05
                if zoom < -0.3 then zoom = -0.3 end
            end
            if IsControlJustPressed(0, 8) then
                zoom = zoom + 0.05 -- ScrollDown
                if zoom > 2.2 then zoom = 2.2 end
            end
            if IsControlJustPressed(0, 241) then -- Scrollup
                zoom = zoom - 0.05
                if zoom < -0.3 then zoom = -0.3 end
            end
            if IsControlJustPressed(0, 242) then
                zoom = zoom + 0.05 -- ScrollDown
                if zoom > 2.2 then zoom = 2.2 end
            end
            heading = angle + 0.0

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)

            local angle = heading * math.pi / 180.0
            local theta = {
                x = math.cos(angle),
                y = math.sin(angle)
            }

            local pos = {
                x = coords.x + ((zoomOffset + zoom) * theta.x),
                y = coords.y + ((zoomOffset + zoom) * theta.y)
            }

            local angleToLook = heading - 140.0
            if angleToLook > 360 then
                angleToLook = angleToLook - 360
            elseif angleToLook < 0 then
                angleToLook = angleToLook + 360
            end

            angleToLook = angleToLook * math.pi / 180.0
            local thetaToLook = {
                x = math.cos(angleToLook),
                y = math.sin(angleToLook)
            }

            local posToLook = {
                x = coords.x + ((zoomOffset + zoom) * thetaToLook.x),
                y = coords.y + ((zoomOffset + zoom) * thetaToLook.y)
            }

            SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
        end
    end)
end

function OpenSaveableMenu(submitCb, cancelCb, restrict)
    TriggerEvent('skinchanger:getSkin', function(skin)
        LastSkin = skin
    end)

    OpenMenu(function(data, menu)
        menu.close()
        DeleteSkinCam()

        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('fl_skin:save', skin)
            if submitCb ~= nil then
                submitCb(data, menu)
            end
        end)
    end, cancelCb, restrict)
end

AddEventHandler('esx:onPlayerSpawn', function()
	Citizen.CreateThread(function()
		if firstSpawn then
			ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
					TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)

			ESX.TriggerServerCallback('fl_skin:getPlayerSkinFaction', function(skin, factionSkin)
				if skin == nil then
					TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)

			firstSpawn = false
		end
	end)
end)

AddEventHandler('fl_skin:getLastSkin', function(cb)
	cb(lastSkin)
end)

AddEventHandler('fl_skin:setLastSkin', function(skin)
	lastSkin = skin
end)

RegisterNetEvent('fl_skin:openMenu')
AddEventHandler('fl_skin:openMenu', function(submitCb, cancelCb)
	OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('fl_skin:openRestrictedMenu')
AddEventHandler('fl_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('fl_skin:openSaveableMenu')
AddEventHandler('fl_skin:openSaveableMenu', function(submitCb, cancelCb)
    local restrict = {
        'sex',
        'face',
        'skin',
        'age_1',
        'age_2',
        'glasses_1',
        'glasses_2',
        'beard_1',
        'beard_2',
        'beard_3',
        'beard_4',
        'hair_1',
        'hair_2',
        'hair_color_1',
        'hair_color_2',
        'eye_color',
        'eyebrows_1',
        'eyebrows_2',
        'eyebrows_3',
        'eyebrows_4',
        'makeup_1',
        'makeup_2',
        'makeup_3',
        'makeup_4',
        'lipstick_1',
        'lipstick_2',
        'lipstick_3',
        'lipstick_4',
        'blemishes_1',
        'blemishes_2',
        'blush_1',
        'blush_2',
        'blush_3',
        'complexion_1',
        'complexion_2',
        'sun_1',
        'sun_2',
        'moles_1',
        'moles_2',
        'tshirt_1',
        'tshirt_2',
        'torso_1',
        'torso_2',
        'chain_1',
        'chain_2',
        'decals_1',
        'decals_2',
        'arms',
        'watches_1',
        'watches_2',
        'pants_1',
        'pants_2',
        'shoes_1',
        'shoes_2',
        'bproof_1',
        'bproof_2'
    }
    OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('fl_skin:openSaveableAdminMenu')
AddEventHandler('fl_skin:openSaveableAdminMenu', function(submitCb, cancelCb)
    OpenSaveableMenu(submitCb, cancelCb, {'sex', 'face', 'skin', 'hair_1', 'hair_2', 'hair_color_1', 'hair_color_2', 'beard_1', 'beard_2', 'beard_3', 'beard_4', 'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2', 'decals_1', 'decals_2', 'arms', 'arms_2', 'pants_1', 'pants_2', 'shoes_1', 'shoes_2', 'mask_1', 'mask_2', 'bproof_1', 'bproof_2', 'chain_1', 'chain_2', 'helmet_1', 'helmet_2', 'glasses_1', 'glasses_2', 'watches_1', 'watches_2', 'bracelets_1', 'bracelets_2', 'bags_1', 'bags_2', 'eye_color', 'eyebrows_2', 'eyebrows_1', 'eyebrows_3', 'eyebrows_4', 'makeup_1', 'makeup_2', 'makeup_3', 'makeup_4', 'lipstick_1', 'lipstick_2', 'lipstick_3', 'lipstick_4', 'ears_1', 'ears_2', 'chest_1', 'chest_2', 'chest_3', 'bodyb_1', 'bodyb_2', 'age_1', 'age_2', 'blemishes_1', 'blemishes_2', 'blush_1', 'blush_2', 'blush_3', 'complexion_1', 'complexion_2', 'sun_1', 'sun_2', 'moles_1', 'moles_2',})
end)

RegisterNetEvent('fl_skin:openSaveableRestrictedMenu')
AddEventHandler('fl_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenSaveableMenu(submitCb, cancelCb, restrict)
end)
