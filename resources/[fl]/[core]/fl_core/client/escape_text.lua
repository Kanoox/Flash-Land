nbPlayerTotal = 0
RegisterNetEvent('fl_core:updatePlayerCount')
AddEventHandler('fl_core:updatePlayerCount', function(nbPlayer)
    nbPlayerTotal = nbPlayer
end)

Citizen.CreateThread(function()
    while true do
        AddTextEntry('PM_SCR_MAP', '~b~Carte de Los Santos')
        AddTextEntry('PM_SCR_GAM', '~r~Prendre l\'avion')
        AddTextEntry('PM_SCR_INF', '~g~Logs')
        AddTextEntry('PM_SCR_SET', '~p~Configuration')
        AddTextEntry('PM_SCR_STA', '~b~Statistiques')
        AddTextEntry('PM_SCR_GAL', '~y~Galerie')
        AddTextEntry('PM_SCR_RPL', '~y~Éditeur ∑')
        AddTextEntry('PM_PANE_CFX', '~y~FreeLife')
        AddTextEntry('FE_THDR_GTAO', "~b~FreeLife - Officiel ~m~| ~b~discord.gg/~w~7bmgk6GDc8 ~m~| ~b~ID : ~w~".. GetPlayerServerId(PlayerId()) .." ~m~| ~b~".. nbPlayerTotal .. "~w~/~b~999 ~w~joueurs ~b~en ligne")
        AddTextEntry('PM_PANE_LEAVE', '~p~Se déconnecter de FreeLife');
        AddTextEntry('PM_PANE_QUIT', '~r~Quitter FiveM');
        Citizen.Wait(5000)
    end
end)