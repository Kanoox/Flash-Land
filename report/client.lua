ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('setreportadmin')
AddEventHandler('setreportadmin', function()
    reportadmingroup = true
end)    

Citizen.CreateThread(function()
    while true do
        Citizen.Wait( 2000 )

        if NetworkIsSessionStarted() then
            TriggerServerEvent("checkreportadmin")
        end
    end
end )

reportlistesql = {}

RMenu.Add('report', 'main', RageUI.CreateMenu("Report", "Pour effectuer un report"))
RMenu.Add('report', 'lister', RageUI.CreateSubMenu(RMenu:Get('report', 'main'), "Liste report", "Pour voir la liste des reports"))
RMenu.Add('report', 'gestr', RageUI.CreateSubMenu(RMenu:Get('report', 'lister'), "Gestion reports", "Pour gérer les reports"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('report', 'main'), true, true, true, function()
            RageUI.Button(" Report un joueur", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local nameResults = KeyboardInput("Nom du Joueur:", "", 20)
                local reasonResults = KeyboardInput("Raison du Report: ", "", 200)

                    local playerName = GetPlayerName(PlayerId())
                    local typereport = "Report"
                    

                if nameResults == nil or nameResults == "" then
                    TriggerEvent('chatMessage', "Report", {255, 0, 0}, "Vous n'avez pas saisi de nom")
                else
                    TriggerEvent('chatMessage', "Report", {0, 255, 0}, "Votre report a été envoyé contre ".. nameResults .. " pour " .. reasonResults.."")
                    TriggerServerEvent('h4ci_report:ajoutreport', typereport, playerName, nameResults, reasonResults)
                    end

                end
            end)
            RageUI.Button(" Appeller un admin", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    
                local reasonResults = KeyboardInput("Raison du Report: ", "", 200)

                    local playerName = GetPlayerName(PlayerId())
                    local typereport = "Appel admin"
                    local nameResults = "Appel Admin"

                    TriggerEvent('chatMessage', "Appel admin", {0, 255, 0}, "Votre appel admin a été envoyé pour " .. reasonResults..".")
                    TriggerServerEvent('h4ci_report:ajoutreport', typereport, playerName, nameResults, reasonResults)

                end
            end)
            
            if reportadmingroup == true then 
                RageUI.Button(" Liste report", "Pour voir la liste des reports", {RightLabel = "→→→"},true, function()
            end, RMenu:Get('report', 'lister'))
            end

            end, function()
        end)
        RageUI.IsVisible(RMenu:Get('report', 'lister'), true, true, true, function()
              for numreport = 1, #reportlistesql, 1 do
                RageUI.Button("[Joueur : "..reportlistesql[numreport].reporteur.."~s~] - "..reportlistesql[numreport].type, "Numéro : "..reportlistesql[numreport].id, {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        typereport = reportlistesql[numreport].type
                        reportjoueur = reportlistesql[numreport].reporteur
                        raisonreport = reportlistesql[numreport].raison
                        joueurreporter = reportlistesql[numreport].nomreporter
                        supprimer = reportlistesql[numreport].id
                    end
                end, RMenu:Get('report', 'gestr'))
            end
        
       end, function()
        end)
    RageUI.IsVisible(RMenu:Get('report', 'gestr'), true, true, true, function()
        RageUI.Button("~r~Type de report~s~ : ".. typereport, nil, {}, true, function(Hovered, Active, Selected)
        end)   
        RageUI.Button("~r~Joueur qui report~s~ : ".. reportjoueur, nil, {}, true, function(Hovered, Active, Selected)
        end)    
        RageUI.Button("~r~Joueur qui est reporté~s~ : ".. joueurreporter, nil, {}, true, function(Hovered, Active, Selected)
        end) 
        RageUI.Button("~r~Raison du report~s~ : ".. raisonreport, nil, {}, true, function(Hovered, Active, Selected)
        end) 
        RageUI.Button("~r~Supprimer le report~s~ : ".. supprimer, nil, {}, true, function(Hovered, Active, Selected)
            if (Selected) then
                TriggerServerEvent('h4ci_report:supprimereport', supprimer)
                ESX.ShowNotification("Le report numéro : ".. supprimer .. " a bien été supprimé, pensez à relancer le menu")
            end
        end)
       end, function()
        end)
            Citizen.Wait(0)
        end
    end)

RegisterCommand("report", function() 
    ESX.TriggerServerCallback('h4ci_report:affichereport', function(keys)
    reportlistesql = keys
    end)
  RageUI.Visible(RMenu:Get('report', 'main'), not RageUI.Visible(RMenu:Get('report', 'main')))
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
    blockinput = true --Blocks new input while typing if **blockinput** is used

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() --Gets the result of the typing
        Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
        blockinput = false --This unblocks new Input when typing is done
        return result --Returns the result
    else
        Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
        blockinput = false --This unblocks new Input when typing is done
        return nil --Returns nil if the typing got aborted
    end
end
