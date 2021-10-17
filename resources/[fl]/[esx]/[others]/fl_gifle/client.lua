RegisterCommand('-giffler', function() end, false)
RegisterCommand('+giffler', function()
    if IsControlPressed(1, 19) then
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
        if DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId()) then
            ESX.Streaming.RequestAnimDict("melee@unarmed@streamed_variations")
            TaskPlayAnim(PlayerPedId(), "melee@unarmed@streamed_variations", "plyr_takedown_front_slap", 8.0, 1.0, 1500, 1, 0, 0, 0, 0)
            Wait(500)
            SendNUIMessage({
                DemarrerLaMusique = 'DemarrerLaMusique',
                VolumeDeLaMusique = 0.2
            })
        end
    end
end, false)