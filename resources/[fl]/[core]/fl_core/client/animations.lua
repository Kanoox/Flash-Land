local recoils = {
	-- pistols
	[416676503] = 0.34,
	--smg
	[-957766203] = 0.22,
	-- rifles
	[970310034] = 0.14,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	       DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)

Citizen.CreateThread( function()
	
	while true do 

		 if IsPedArmed(PlayerPedId(), 6) then
		 	Citizen.Wait(1)
		 else
		 	Citizen.Wait(1500)
		 end  

	    if IsPedShooting(PlayerPedId()) then
	    	local ply = PlayerPedId()
	    	local GamePlayCam = GetFollowPedCamViewMode()
	    	local Vehicled = IsPedInAnyVehicle(ply, false)
	    	local MovementSpeed = math.ceil(GetEntitySpeed(ply))

	    	if MovementSpeed > 69 then
	    		MovementSpeed = 69
	    	end

	        local _,wep = GetCurrentPedWeapon(ply)

	        local group = GetWeapontypeGroup(wep)

	        local p = GetGameplayCamRelativePitch()

	        local cameraDistance = #(GetGameplayCamCoord() - GetEntityCoords(ply))

	        local recoil = math.random(130,140+(math.ceil(MovementSpeed*1.5)))/100
	        local rifle = false

          	if group == 970310034 or group == 1159398588 then
          		rifle = true
          	end

          	if cameraDistance < 5.3 then
          		cameraDistance = 1.5
          	else
          		if cameraDistance < 8.0 then
          			cameraDistance = 4.0
          		else
          			cameraDistance = 7.0
          		end
          	end

	        if Vehicled then
	        	recoil = recoil + (recoil * cameraDistance)
	        else
	        	recoil = recoil * 0.3
	        end

	        if GamePlayCam == 4 then

	        	recoil = recoil * 0.7
		        if rifle then
		        	recoil = recoil * 0.1
		        end
	        end

	        if rifle then
	        	recoil = recoil * 0.1
	        end

	        local rightleft = math.random(4)
	        local h = GetGameplayCamRelativeHeading()
	        local hf = math.random(10,40+MovementSpeed)/100

	        if Vehicled then
	        	hf = hf * 2.0
	        end

	        if rightleft == 1 then
	        	SetGameplayCamRelativeHeading(h+hf)
	        elseif rightleft == 2 then
	        	SetGameplayCamRelativeHeading(h-hf)
	        end 
        
	        local set = p+recoil

	       	SetGameplayCamRelativePitch(set,0.8)    	       		       	
	      -- 	print(GetGameplayCamRelativePitch())
	    end
	end
end)


Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 20) and not IsControlPressed(0, 61) and not IsControlPressed(0, 19) then
            local player = PlayerPedId()

            if DoesEntityExist(player) and not IsEntityDead(player) then
                local dict = "move_m@intimidation@cop@unarmed"
                ESX.Streaming.RequestAnimDict(dict)

                if IsEntityPlayingAnim(player, dict, "idle", 3) then
                    ClearPedSecondaryTask(player)
                else
                    TaskPlayAnim(player, dict, "idle", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                    RemoveAnimDict(dict)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterCommand('-siffler', function() end, false)
RegisterCommand('+siffler', function()
    if IsControlPressed(1, 19) then
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
        if DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId()) then
            ESX.Streaming.RequestAnimDict("rcmnigel1c")
            TaskPlayAnim(PlayerPedId(), "rcmnigel1c", "hailing_whistle_waive_a", 2.0, 2.0, 2000, 51, 0, false, false, false)
        end
    end
end, false)

-- Besoins
RegisterCommand('pipi', function()
    ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
        if skin.sex == 0 then
        	Pee(PlayerPedId(), 'male')
            TriggerServerEvent('esx-qalle-needs:sync', 'pee', 'male')
        else
        	Pee(PlayerPedId(), 'female')
            TriggerServerEvent('esx-qalle-needs:sync', 'pee', 'female')
        end
    end)
end, false)

RegisterCommand('caca', function()
	Poop(PlayerPedId())
    TriggerServerEvent('esx-qalle-needs:sync', 'poop')
 end)

RegisterNetEvent('esx-qalle-needs:syncCL')
AddEventHandler('esx-qalle-needs:syncCL', function(serverId, need, sex)
	if GetPlayerFromServerId(serverId) == -1 then
		return -- Out of scope
	end

    if need == 'pee' then
        Pee(GetPlayerPed(GetPlayerFromServerId(serverId)), sex)
    else
        Poop(GetPlayerPed(GetPlayerFromServerId(serverId)))
    end
end)

function Pee(PlayerPed, sex)
    local particleDictionary = "core"
    local particleName = "ent_amb_peeing"
    local animDictionaryMale = 'missbigscore1switch_trevor_piss'
    local animDictionaryFemale = 'missfbi3ig_0'

    ESX.Streaming.RequestNamedPtfxAsset(particleDictionary)
    ESX.Streaming.RequestAnimDict(animDictionaryMale)
    ESX.Streaming.RequestAnimDict(animDictionaryFemale)

    if sex == 'male' then
        SetPtfxAssetNextCall(particleDictionary)
        TaskPlayAnim(PlayerPed, animDictionaryMale, 'piss_loop', 8.0, -8.0, -1, 0, 0, false, false, false)
        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.1, -90.0, 0.0, 20.0, GetPedBoneIndex(PlayerPed, 11816), 2.0, false, false, false)
        Citizen.Wait(3500)
        StopParticleFxLooped(effect, 0)
    else
        SetPtfxAssetNextCall(particleDictionary)
        TaskPlayAnim(PlayerPed, animDictionaryFemale, 'shit_loop_trev', 8.0, -8.0, -1, 0, 0, false, false, false)
        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.55, 0.0, 0.0, 20.0, GetPedBoneIndex(PlayerPed, 11816), 2.0, false, false, false)
        Citizen.Wait(3500)
        StopParticleFxLooped(effect, 0)
    end
end

function Poop(PlayerPed)
    local particleDictionary = "scr_amb_chop"
    local particleName = "ent_anim_dog_poo"
    local animDictionary = 'missfbi3ig_0'
    local animName = 'shit_loop_trev'

    ESX.Streaming.RequestNamedPtfxAsset(particleDictionary)
    ESX.Streaming.RequestAnimDict(animDictionary)

    SetPtfxAssetNextCall(particleDictionary)
    TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

    local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, GetPedBoneIndex(PlayerPed, 11816), 2.0, false, false, false)
    Citizen.Wait(3500)
    StopParticleFxLooped(effect, 0)
end
