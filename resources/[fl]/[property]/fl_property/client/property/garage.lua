

local openedGarageMenu = false

RMenu.Add("fl_garageprop", "fl_garageprop_main", RageUI.CreateMenu("Menu Garage","Actions garage"))
RMenu:Get("fl_garageprop", "fl_garageprop_main"):SetStyleSize(0)
RMenu:Get("fl_garageprop", "fl_garageprop_main").Closed = function()
	openedGarageMenu = false
    FreezeEntityPosition(PlayerPedId(), false)
end


RMenu.Add('fl_garagesortir', 'fl_garagesortir_main', RageUI.CreateSubMenu(RMenu:Get("fl_garageprop", "fl_garageprop_main"), "Sortir un véhicule","Sortez un véhicule."))
RMenu:Get("fl_garagesortir", "fl_garagesortir_main"):SetStyleSize(0)
RMenu:Get('fl_garagesortir', 'fl_garagesortir_main').Closed = function()
    RageUI.CloseAll()
    openedGarageMenu = false

    camGarage = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
    SetCamActive(camGarage,  false)	
    FreezeEntityPosition(PlayerPedId(), false)
    RenderScriptCams(false,  false,  0,  false,  false)
    SetFocusEntity(PlayerPedId())
    camGarage = nil
    
    Citizen.SetTimeout(1000, function()
        for k, v in pairs(vehiclesSpawned) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end
    end)
end



function openGarageMenu()
	if not openedGarageMenu then 
        openedGarageMenu = true
        CanGoInGarage = false
		RageUI.Visible(RMenu:Get('fl_garageprop', 'fl_garageprop_main'), true)

        local fps = IsPedOnFoot(PlayerPedId())
        
        local Property = GetProperty(LastMarkerProperty)
        local OwnedProperties = GetOwnedPropertiesOfType(Property)

        for _,OwnedProperty in pairs(OwnedProperties) do
            if HasPermissionOnOwnedProperty(Property, OwnedProperty) then
                CanGoInGarage = true
            end
        end

		Citizen.CreateThread(function()
			while openedGarageMenu do
                FreezeEntityPosition(PlayerPedId(), true)
                
				RageUI.IsVisible(RMenu:Get("fl_garageprop",'fl_garageprop_main'),true,true,true,function()
					RageUI.Separator('↓ ~y~Garage ~s~↓')
					
                    if not fps then 
                        --print('Cuurent prop :', json.encode(CurrentProperty))
                        --print('Owned : ', json.encode(CurrentOwnedProperty))
                        if CanGoInGarage ~= nil and CanGoInGarage then
                            RageUI.ButtonWithStyle("Rentrer ce véhicule", 'Rentrez ce véhicule.', { RightLabel = "→" }, true, function(_,_,s)
                                if s then
                                    ESX.TriggerServerCallback('fl_property:getVehiclesInGarage', function(cb)
                                        if cb then
                                            if #cb < tonumber(GarageType[CurrentProperty.GarageType].Name) then
                                                local playerPed = PlayerPedId()
                                                local Coords, heading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)
                                                local zone, name = { x = Coords.x, y = Coords.y, z = Coords.z, h = heading}, CurrentProperty.name
                                                local vehicle = GetVehiclePedIsUsing(playerPed)
                                                local plate = GetVehicleNumberPlateText(vehicle)
                                                local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
                                                local maxHealth, health = GetEntityMaxHealth(vehicle), GetEntityHealth(vehicle)
                                                local healthPercent = (health / maxHealth) * 100

                                                if healthPercent < 15 then
                                                    ESX.ShowNotification('~r~ Faites réparer votre véhicules avant de le rentrer')
                                                else  
                                                    if DoesEntityExist(vehicle) then
                                                        TriggerServerEvent('fl_property:setParking', plate, name, zone, vehicleProps, CurrentProperty.name)
                                                        ESX.Game.DeleteVehicle(vehicle)
                                                        RageUI.CloseAll()
                                                        openedGarageMenu = false
                                                        FreezeEntityPosition(PlayerPedId(), false)
                                                    end
                                                end
                                            else
                                                FreezeEntityPosition(PlayerPedId(), false)
                                                ESX.ShowNotification("~r~Votre garage est plein !")
                                            end
                                        end
                                    end, CurrentProperty.name)
                                end
                            end) 
                        else
                            RageUI.Separator('')
                            RageUI.Separator('~r~Vous n\'êtes pas propriétaire ici.')
                            RageUI.Separator('')
                        end 
                    else
                        if CanGoInGarage ~= nil and CanGoInGarage then
                            RageUI.ButtonWithStyle("Sortir un véhicule", 'Sortez un véhicule.', { RightLabel = "→" }, true, function(_,_,s)
                                if s then

                                    ESX.TriggerServerCallback('fl_property:getVehiclesInGarage', function(cb)
                                        if cb then
                                            vehicleInGarage = cb 
                                        end
                                        camGarage = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

                                        SetFocusArea(GarageType[CurrentProperty.GarageType].Coords[1], GarageType[CurrentProperty.GarageType].Coords[2], GarageType[CurrentProperty.GarageType].Coords[3], 0.0, 0.0, 0.0)
                                        SetCamCoord(camGarage, GarageType[CurrentProperty.GarageType].Coords[1], GarageType[CurrentProperty.GarageType].Coords[2], GarageType[CurrentProperty.GarageType].Coords[3])
                                        SetCamActive(camGarage,  true)
                                        SetCamRot(camGarage, -10.0, 0.0, GarageType[CurrentProperty.GarageType].Coords[4])
                                        RenderScriptCams(true,  false,  0,  true,  true)
                                        FreezeEntityPosition(PlayerPedId(), true)
                                        vehiclesSpawned = {}
                                    end, CurrentProperty.name)
                                end
                            end, RMenu:Get('fl_garagesortir', 'fl_garagesortir_main'))
                        else
                            RageUI.Separator('')
                            RageUI.Separator('~r~Vous n\'êtes pas propriétaire ici.')
                            RageUI.Separator('')
                        end
                    end
				end, function()    
				end, 1)


                RageUI.IsVisible(RMenu:Get("fl_garagesortir",'fl_garagesortir_main'),true,true,true,function()					
                    if vehicleInGarage then 
                        RageUI.Separator('↓ ~y~Véhicules : '..#vehicleInGarage..'/'..GarageType[CurrentProperty.GarageType].Name..' ~s~↓')
                        if #vehicleInGarage > 0 then
    
                            for vehicleIndex = 1, #vehicleInGarage, 1 do 
                                local hashVeh = vehicleInGarage[vehicleIndex].vehicle.model
                                local vehName = GetDisplayNameFromVehicleModel(hashVeh)
                                local vehPropertie = vehicleInGarage[vehicleIndex].vehicle
                                if not vehiclesSpawned[vehicleIndex] then

                                    if not HasModelLoaded(hashVeh) then
                                        RequestModel(hashVeh)
                                        while not HasModelLoaded(hashVeh) do
                                            Wait(10)
                                        end
                                    end
                                    
                                    vehicleSpawned = CreateVehicle(hashVeh, GarageType[CurrentProperty.GarageType].Places[vehicleIndex][1], GarageType[CurrentProperty.GarageType].Places[vehicleIndex][2], GarageType[CurrentProperty.GarageType].Places[vehicleIndex][3], GarageType[CurrentProperty.GarageType].Places[vehicleIndex][4], false, false)

                                    ESX.Game.SetVehicleProperties(vehicleSpawned, vehPropertie)
                                    
                                    vehiclesSpawned[vehicleIndex] = vehicleSpawned
                                end

                                RageUI.ButtonWithStyle(vehName, nil, {RightLabel = vehicleInGarage[vehicleIndex].plate}, true, function(_,a,s)
                                    if s then
                                        if not IsAnyVehicleNearPoint(vehicleInGarage[vehicleIndex].zone.x, vehicleInGarage[vehicleIndex].zone.y, vehicleInGarage[vehicleIndex].zone.z, 5.0) then
                                            ESX.Game.SpawnVehicle(hashVeh,
                                            {
                                                x = vehicleInGarage[vehicleIndex].zone.x,
                                                y = vehicleInGarage[vehicleIndex].zone.y,
                                                z = vehicleInGarage[vehicleIndex].zone.z,
                                            }, vehicleInGarage[vehicleIndex].zone.h,
                                            function(hashVeh)                    
                                                ESX.Game.SetVehicleProperties(hashVeh, vehPropertie)
                                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), hashVeh, -1)
                                                TriggerServerEvent('fl_property:DelParking',vehicleInGarage[vehicleIndex].plate, CurrentProperty.name)
                                            end
                                            )               
                                        else 
                                            ESX.ShowNotification('~r~ Un véhicule est déja stationé')
                                        end
                                        camGarage = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
                                        SetCamActive(camGarage,  false)	
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        RenderScriptCams(false,  false,  0,  false,  false)
                                        SetFocusEntity(PlayerPedId())
                                        camGarage = nil
                                        RageUI.CloseAll()
                                        openedGarageMenu = false

                                        Citizen.SetTimeout(1000, function()
                                            for k, v in pairs(vehiclesSpawned) do
                                                if DoesEntityExist(v) then
                                                    DeleteEntity(v)
                                                end
                                            end
                                        end)

                                    end
                                end)
                            end
                        else
                            RageUI.Separator('')
                            RageUI.Separator('~r~Aucun véhicule n\'est garé ici.')
                            RageUI.Separator('')
                        end
                    end
                    
					

				end, function()    
				end, 1)
						
				Wait(1)
			end
			Wait(0)
			openedGarageMenu = false
		end)
	end
end

