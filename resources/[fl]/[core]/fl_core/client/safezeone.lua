--------------------------------------------------------------------------------------------------------------
------------First off, many thanks to @anders for help with the majority of this script. ---------------------
------------Also shout out to @setro for helping understand pNotify better.              ---------------------
--------------------------------------------------------------------------------------------------------------
------------To configure: Add/replace your own coords in the sectiong directly below.    ---------------------
------------        Goto LINE 90 and change "50" to your desired SafeZone Radius.        ---------------------
------------        Goto LINE 130 to edit the Marker( Holographic circle.)               ---------------------
--------------------------------------------------------------------------------------------------------------
-- Place your own coords here!
local zones = {
	vector3(437.03552246094, -982.3388671875, 29.689813613892), ----- Comico
	vector3(314.44583129883, -592.25970458984, 42.284629821777), ----- Hopital
	vector3(236.77288818359, -789.02093505859, 29.565050125122), ----- Garage
	vector3(-192.5597076416, -1280.7900390625, 30.279026031494), ----- Garage
	vector3(-977.21600341797, -2710.37890625, 12.853494644165), ----- Garage
	vector3(-2026.9670410156, -469.88668823242, 10.402121543884), ----- Garage
	vector3(-3047.6899414062, 590.29809570312, 6.7618598937988), ----- Garage
	vector3(-340.7131652832, 266.72476196289, 84.679481506348), ----- Garage
	vector3(1212.3199462891, 339.94033813477, 80.990905761719),
	vector3(1846.5600585938, 2585.8601074219, 44.672019958496),
	vector3(1737.5899658203, 3710.1999511719, 33.139423370361),
	vector3(105.35625457764, 6613.5859375, 31.397464752197),
	vector3(4987.466796875, -5146.2841796875, 1.4775037765503),
	vector3(-204.79539489746, -801.29235839844, 29.454027175903), ----- Spawn
}

local notifIn = false
local notifOut = false
local closestZone = 1


--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------                              Creating Blips at the locations. 							--------------
-------You can comment out this section if you dont want any blips showing the zones on the map.--------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #zones, 1 do
		local zoneblip = AddBlipForRadius(zones[i].x, zones[i].y, zones[i].z, 450.0)

        SetBlipSprite(zoneblip,1)
        SetBlipColour(zoneblip,28)
        SetBlipAlpha(zoneblip,50)   
	end
end)

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
----------------   Getting your distance from any one of the locations  --------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
---------   Setting of friendly fire on and off, disabling your weapons, and sending pNoty   -----------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	
		if dist <= 45.0 then  ------------------------------------------------------------------------------ Here you can change the RADIUS of the Safe Zone. Remember, whatever you put here will DOUBLE because 
			if not notifIn then																			  -- it is a sphere. So 50 will actually result in a diameter of 100. I assume it is meters. No clue to be honest.
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
                ESX.ShowNotification("Vous êtes en zone safe")
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
                ESX.ShowNotification("Vous n'êtes plus en zone safe")
				notifOut = true
				notifIn = false
			end
		end
		if notifIn then
		DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
		DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
      	DisableControlAction(0, 106, true) -- Disable in-game mouse controls
			if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
                ESX.ShowNotification("Vous ne pouvez par utiliser d'armes en zone safe")
			end
			if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
                ESX.ShowNotification("Vous ne pouvez par faire ça en zone safe")
			end
		end
		-- Comment out lines 142 - 145 if you dont want a marker.
	end
end)