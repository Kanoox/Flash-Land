Citizen.CreateThread(function()
    while true do
        local letSleep = true
        local playerCoords = GetEntityCoords(PlayerPedId())
        for ChouffId, Chouff in pairs(Config.Chouff) do
            local distance = #(Chouff.coords - playerCoords)
            if distance < 1.5 and ESX.PlayerData.faction then
                letSleep = false
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec " .. Chouff.name)

                if IsControlJustPressed(1, 38) then
                    OpenMenu(ChouffId)
                end
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end

        Citizen.Wait(0)
    end
end)

function OpenMenu(ChouffId)
    if ESX.PlayerData.faction.name == "resid" then
        ESX.ShowNotification('~r~Vous ne faites pas partie d\'une faction...')
        return
    end

	ESX.TriggerServerCallback('fl_drugsPNJ:getChouffData', function(ChouffData)
        if ChouffData.faction then
            ESX.ShowNotification('~r~Je bosse déjà là ...')
            return
        end

        local Chouff = Config.Chouff[ChouffId]

        ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'chouf_manage', {
            title = Chouff.name,
            elements = {
                {
                    label = 'Engager ' .. Chouff.name,
                    rightLabel = '$' .. ESX.Math.Round(ChouffData.canAttack and Chouff.price or Chouff.price/2) ,
                    action = 'pay',
                },
                {
                    label = 'Attaque ?',
                    rightLabel = (ChouffData.canAttack and 'OUI' or 'NON'),
                    action = 'config_attack',
                },
            },
        }, function(data, menu)
            if data.current.action == 'pay' then
                TriggerServerEvent('fl_drugsPNJ:payChouff', ChouffId)
            elseif data.current.action == 'config_attack' then
                TriggerServerEvent('fl_drugsPNJ:toggleAttack', ChouffId)
                Citizen.Wait(100)
                OpenMenu(ChouffId)
            else
                error('?')
            end
            ESX.UI.Menu.CloseAll()
        end, function(data, menu)
            menu.close()
        end)
    end, ChouffId)
end