local shisha = {`prop_bong_01`}
local shishaHasStarted = false
local distX, distY, distZ = 0, 0, 0
local buyad = false
local sessionStarted = false
local endCallback = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)

		for i = 1, #shisha do
			local closestShisha = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, shisha[i], false, false, false)
			local shishaPos = GetEntityCoords(closestShisha)
			local dist = #(pos - shishaPos)

			if dist < 3.5 then
				local loc = vector3(shishaPos.x, shishaPos.y, shishaPos.z)

				if not buyad then
					ESX.Game.Utils.DrawText3D(vector3(shishaPos.x, shishaPos.y, shishaPos.z+1), "Appuyez sur [~y~E~w~] pour commencer une session. (100$)", 0.5)
				end

				-- Start Session
				if not sessionStarted then
				if IsControlJustReleased(0, 38) then
					buyad = true
					sessionStarted = true
					endCallback = true
					ESX.ShowNotification("~g~Vous avez commencé une session et payé ~r~100$.", false, false)
					ShishaFunctions()
					TriggerEvent("fl_hookah:anim")

					local playerPed = PlayerPedId()
					local coords = GetEntityCoords(playerPed)
					local boneIndex = GetPedBoneIndex(playerPed, 12844)
					local boneIndex2 = GetPedBoneIndex(playerPed, 24818)

					ESX.Game.SpawnObject('v_corp_lngestoolfd', {
						x = coords.x+0.5,
						y = coords.y+0.1,
						z = coords.z+0.4
					}, function(schlauch)
						AttachEntityToEntity(schlauch, playerPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)
						hookaschlauch = schlauch
						helmet = true
					end)

					TriggerServerEvent("fl_hookah:pay")
					Citizen.CreateThread(function()
						while true do
							if sessionStarted then
								ESX.Game.Utils.DrawText3D(vector3(shishaPos.x, shishaPos.y, shishaPos.z+0.4), "~c~Appuyez sur ~b~\"H\"~c~ pour tirer sur le tuyau.", 0.5)
								ESX.Game.Utils.DrawText3D(loc, "~c~Appuyez sur ~b~\"F\"~c~ pour terminer la session.", 0.5)
							end
							Citizen.Wait(0)
						end
					end)
				end
				end
			else
				Citizen.Wait(1000)
			end
		end
    end
end)

function ShishaFunctions()
	Citizen.CreateThread(function()
		while sessionStarted do
			Citizen.Wait(0)
			if IsControlJustPressed(0, 74) then -- Normal: H
				TriggerServerEvent('fl_particles:sync', math.random(100000, 999999), GetEntityCoords(PlayerPedId()), 'core', 'exp_grd_bzgas_smoke', true, 5)
			end

			if IsControlJustReleased(0, 23) then -- Normal: F
				if endCallback == true then
					sessionStarted = false
					buyad = false
					ClearPedTasks(PlayerPedId())
					ESX.Game.DeleteObject(hookaschlauch)
					ESX.ShowNotification("~r~Vous avez fini votre session", false, false)
					endCallback = false
				end
			end
		end
	end)
end

AddEventHandler("fl_hookah:anim", function(source)
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while not HasAnimDictLoaded(ad) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end)

RegisterNetEvent("fl_hookah:spawn")
AddEventHandler("fl_hookah:spawn", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	ESX.Game.SpawnObject('prop_bong_01', {
		x = coords.x+0.5,
		y = coords.y+0.1,
		z = coords.z-0.7
	}, function(mobilehooka)
	end)
end)