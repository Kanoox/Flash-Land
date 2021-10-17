local VehicleTrails = true

RegisterNetEvent('fl_xmas:toggleSnowChain')
AddEventHandler('fl_xmas:toggleSnowChain', function()
    SetVehicleTrailsXmas(not VehicleTrails)
end)

RegisterNetEvent('fl_xmas:forceSnowChain')
AddEventHandler('fl_xmas:forceSnowChain', function(NewVehicleTrail)
    SetVehicleTrailsXmas(NewVehicleTrail)
end)

function SetVehicleTrailsXmas(NewVehicleTrail)
    VehicleTrails = NewVehicleTrail
    if VehicleTrails then
        ESX.ShowNotification('~r~Vous enlevez les chaînes de neige de votre voiture')
    else
        ESX.ShowNotification('~g~Vous mettez les chaînes de neige sur votre voiture')
        ESX.ShowNotification('~c~Vous serez seul à ne pas glisser sur la neige avec cette voiture (pour des raisons techniques)')
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		SetWeatherTypePersist("XMAS")
		SetWeatherTypeNowPersist("XMAS")
		SetWeatherTypeNow("XMAS")
		SetOverrideWeather("XMAS")
		SetForceVehicleTrails(VehicleTrails)
		SetForcePedFootstepsTracks(true)

		--SetWind(1.0)
		--SetWindSpeed(11.99)
		--SetWindDirection(180.00)
	end
end)

Citizen.CreateThread(function()
    local showHelp = true
    local loaded = false

    while true do
        Citizen.Wait(0)
        --WaterOverrideSetStrength(2.0)

        if not loaded then
            RequestScriptAudioBank("ICE_FOOTSTEPS", false)
            RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
            RequestNamedPtfxAsset("core_snow")
            while not HasNamedPtfxAssetLoaded("core_snow") do
                Citizen.Wait(0)
            end
            RequestAnimDict('anim@mp_snowball')
            UseParticleFxAssetNextCall("core_snow")
            loaded = true
        end

        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            if IsControlJustReleased(0, 57) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInCover(PlayerPedId(), 0) then
                TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
                Citizen.Wait(1500)
                TriggerServerEvent('fl_xmas:giveSnowball')
            end

            if showHelp then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_DROP_AMMO~ pour ramasser une boule de neige")
            end
            showHelp = false
        else
            showHelp = true
        end
    end
end)