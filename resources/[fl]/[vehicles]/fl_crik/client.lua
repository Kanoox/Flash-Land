local raisedCar
local isRaised = false
local vehpos

local flWheelStand
local frWheelStand
local rlWheelStand
local rrWheelStand

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Function to check if vehicle is a car
-----------------------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- raise the closest car --
-----------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('crik+')
AddEventHandler('crik+', function () 
	
	local veh = getNearestVeh()
	local ped = GetPlayerPed(-1)
	
    if IsEntityAVehicle(veh) and IsCar(veh) and not(IsPedInAnyVehicle(ped, false)) and not(isRaised) and IsVehicleSeatFree(veh, -1) and IsVehicleStopped(veh) then
		
		isRaised = true	
		
		raisedCar = veh
		
		local model = 'xs_prop_x18_axel_stand_01a'
		
		FreezeEntityPosition(veh, true)
		vehpos = GetEntityCoords(veh)
		RequestModel(model)
		
		flWheelStand = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
		frWheelStand = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
		rlWheelStand = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
		rrWheelStand = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
		
		AttachEntityToEntity(flWheelStand, veh, 0, 0.5, 1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		AttachEntityToEntity(frWheelStand, veh, 0, -0.5, 1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		AttachEntityToEntity(rlWheelStand, veh, 0, 0.5, -1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		AttachEntityToEntity(rrWheelStand, veh, 0, -0.5, -1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

		Citizen.Wait(1250)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
		
		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.075, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.125, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.175, true, true, true)

		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)


    end
end)



-----------------------------------------------------------------------------------------------------------------------------------------------------
-- lower the previously raised car --
-----------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('crik-')
AddEventHandler('crik-', function () 
	
	local veh = raisedCar

    if isRaised then

		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.175, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.125, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.075, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)

		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
		Citizen.Wait(1000)
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)

		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z, true, true, true)
		FreezeEntityPosition(veh, false)
				
		DeleteObject(flWheelStand)
		DeleteObject(frWheelStand)		
		DeleteObject(rlWheelStand)		
		DeleteObject(rrWheelStand)		
		
		isRaised = false
		
		raisedCar = nil
		vehpos = nil
		flWheelStand = nil
		frWheelStand = nil
		rlWheelStand = nil
		rrWheelStand = nil
		
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- get nearest vehicle function
-----------------------------------------------------------------------------------------------------------------------------------------------------
function getNearestVeh()
local pos = GetEntityCoords(GetPlayerPed(-1))
		local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
return vehicleHandle
end
