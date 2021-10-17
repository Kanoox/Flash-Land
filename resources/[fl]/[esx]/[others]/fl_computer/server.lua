ESX.RegisterCommand('blipcamera', 'user', function(xPlayer, args, showError)
    if xPlayer.job.name == 'police' then
        xPlayer.triggerEvent('fl_computer:blipCamera')
    else
        xPlayer.showNotification('~r~Vous n\'êtes pas policier...')
    end
end, false, {help = 'Activer/Désactiver les blips de caméra'})