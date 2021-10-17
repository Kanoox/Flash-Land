local codesCooldown = false
local returnedPlayerData = nil
local closestPlayer, closestDistance
local currentTask = {}
local appelsList = {}
local policeDog = false

local function getListeAppels()
    local info = {}
    ESX.TriggerServerCallback('fl_appels:infoReport', function(info)
        appelsList = info
    end)
end

local function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
  
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
      Citizen.Wait(0)
    end
  
    if UpdateOnscreenKeyboard() ~= 2 then
      local result = GetOnscreenKeyboardResult()
      Citizen.Wait(500)
      return result
    else
      Citizen.Wait(500)
      return nil
    end
end


RegisterCommand('DebugMenuLSPD', function() 
	local job = ESX.PlayerData.job.name
	if job == 'police' then
		MenuClothesLSPD = false
        MenuLSPDOpen = false
        ArmurerieMenuLSPDOpen = false
        PerquiseStockMenu = false
        ESX.ShowNotification('Menu ~g~debug !\n~s~Si ce n\'est pas le cas, veuillez ~r~déco/reco.' )
	else
		ESX.ShowNotification('Vous n\'êtes pas policier.')
	end
end)

RegisterCommand('openMenuPolice', function()
	if ESX.IsPlayerLoaded() then
		if GetEntityHealth(PlayerPedId()) > 0 and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			openLSPDMENU()
		end
	end
end, false)
  
RegisterKeyMapping('openMenuPolice', 'Menu police', 'keyboard', 'F6')

MenuLSPDOpen = false
function openLSPDMENU()	  
    if not MenuLSPDOpen then 
        MenuLSPDOpen = true
		RageUI.Visible(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), true)

		Citizen.CreateThread(function()
			while MenuLSPDOpen do
				RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_main'),true,true,true,function()
                    
                    RageUI.Separator("↓ ~b~Statut de service ~s~↓")
                    RageUI.Checkbox("Statut de service", nil, inServicePolice, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        inServicePolice = Checked;
                    end, function()
                        inServicePolice = true
                    end, function()
                        inServicePolice = false
                    end)

                    if inServicePolice then

                    RageUI.Separator("↓ ~y~Interactions ~s~↓")
                        RageUI.ButtonWithStyle("Interactions personnelles", "Accédez aux interactions personnelles", { RightLabel = "→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_personal'))
                        RageUI.ButtonWithStyle("Interactions citoyens", "Accédez aux interactions citoyens", { RightLabel = "→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_citizen'))
                        RageUI.ButtonWithStyle("Interactions véhicules", "Accédez aux interactions véhicules", { RightLabel = "→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_veh'))
                        RageUI.ButtonWithStyle("Interactions appels", "Accédez aux interactions d\'appels", { RightLabel = "→" }, true, function(_, _, s)
                            if s then 
                                getListeAppels()
                            end
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_appelsmain'))
                        
                        
                        RageUI.Separator("↓ ~g~Communication ~s~↓")

                        RageUI.ButtonWithStyle("Effectuer un code radio", "Effectuez un code radio", { RightLabel = "→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_codes'))

                        RageUI.Separator("↓ ~o~Unités ~s~↓")
                        RageUI.ButtonWithStyle("Unité K9", "Accédez au chien du LSPD", { RightLabel = "→" }, true, function()
                        end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_K9'))
                        
                    end

                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_personal'),true,true,true,function()
                    
                    RageUI.ButtonWithStyle("Equiper un bouclier", 'Prenez un bouclier !', { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            TriggerEvent("fl_shield:shield")
                            RageUI.CloseAll()
                            MenuLSPDOpen = false
                        end
                    end)

                    RageUI.ButtonWithStyle("Props LSPD", 'Accédez aux props LSPD', { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            TriggerEvent('fl_police:OuvPropsM')
                            MenuLSPDOpen = false
                        end
                    end)

                    RageUI.ButtonWithStyle("Gestion de bracelets", 'Accédez aux bracelets', { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            TriggerEvent('fl_policejob:manageBracelet')
                            MenuLSPDOpen = false
                        end
                    end)

                    RageUI.ButtonWithStyle("Zone d'arrêt NPC", "Accédez a la gestion NPC", { RightLabel = "→" }, true, function()
                    end, RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_arretNPC'))


                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_K9'),true,true,true,function()
                    
                    RageUI.Separator("↓ ~b~Intéractions principales~s~ ↓")
                    RageUI.ButtonWithStyle("Appeler / Rentrer votre chien", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            if not DoesEntityExist(policeDog) then
                                RequestModel(1126154828)
                                while not HasModelLoaded(1126154828) do Wait(0) end
                                policeDog = CreatePed(4, 1126154828, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.98), 0.0, true, false)
                                SetEntityAsMissionEntity(policeDog, true, true)
                                ESX.ShowNotification('Votre chien est ~g~arrivé !')
                                followingDogs = false
                            else
                                ESX.ShowNotification('Votre chien est ~r~rentré !')
                                DeleteEntity(policeDog)
                            end
                            
                        end
                    end)

                    RageUI.ButtonWithStyle("Monter / Descendre du véhicule", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if not IsPedInAnyVehicle(policeDog, false) then
                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog)) <= 10.0 then
                                    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 7.5, 0, 70)
                                    if DoesEntityExist(vehicle) then
                                        for i = 0, GetVehicleMaxNumberOfPassengers(vehicle) do
                                            if IsVehicleSeatFree(vehicle, i) then
                                                TaskEnterVehicle(policeDog, vehicle, 15.0, i, 1.0, 1, 0)
                                                break
                                            end
                                        end
                                    end
                                else
                                    ESX.ShowNotification('Votre chien est trop ~r~loin !')
                                end
                            else
                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog)) <= 5.0 then
                                    TaskLeaveVehicle(policeDog, GetVehiclePedIsIn(policeDog, false), 0)
                                else
                                    ESX.ShowNotification('Votre chien est trop ~r~loin !')
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Attaque !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if DoesEntityExist(policeDog) then
                                if not IsPedDeadOrDying(policeDog) then
                                    if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 15.0 then
                                        local player, distance = ESX.Game.GetClosestPlayer()
                                        if distance ~= -1 then
                                            if distance <= 3.0 then
                                                local playerPed = GetPlayerPed(player)
                                                if not IsPedInCombat(policeDog, playerPed) then
                                                    if not IsPedInAnyVehicle(playerPed, true) then
                                                        TaskCombatPed(policeDog, playerPed, 0, 16)
                                                        followingDogs = false
                                                    end
                                                else
                                                    ClearPedTasksImmediately(policeDog)
                                                end
                                            end
                                        end
                                    end
                                else
                                    ESX.ShowNotification('Ton chien est ~r~décédé..')
                                end
                            else
                                ESX.ShowNotification('Tu ~r~n\'as pas~s~ de chiens.')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Cherche !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if DoesEntityExist(policeDog) then
                                if not IsPedDeadOrDying(policeDog) then
                                    if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 3.0 then
                                        local player, distance = ESX.Game.GetClosestPlayer()
                                        if distance ~= -1 then
                                            if distance <= 3.0 then
                                                local playerPed = GetPlayerPed(player)
                                                if not IsPedInAnyVehicle(playerPed, true) then
                                                    TriggerServerEvent('esx_policedog:hasClosestDrugs', GetPlayerServerId(player))
                                                end
                                            end
                                        end
                                    end
                                else
                                    ESX.ShowNotification('Ton chien est ~r~décédé..')
                                end
                            else
                                ESX.ShowNotification('Tu ~r~n\'as pas~s~ de chiens.')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Suis moi !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            TriggerEvent("K9:ToggleFollow")
                        end
                    end)

                    RageUI.Separator("↓ ~o~Animations~s~ ↓")
                    RageUI.ButtonWithStyle("Assis / Debout !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if DoesEntityExist(policeDog) then
                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
                                    if IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 3) then
                                        ClearPedTasks(policeDog)
                                    else
                                        loadDict('creatures@rottweiler@amb@world_dog_sitting@base')
                                        TaskPlayAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8, -1, 1, 0, false, false, false)
                                    end
                                else
                                    ESX.ShowNotification('Votre chien est trop ~r~loin !')
                                end
                            else
                                ESX.ShowNotification('Tu ~r~n\'as pas~s~ de chiens.')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Coucher / Debout !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if DoesEntityExist(policeDog) then
                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
                                    if IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel', 3) then
                                        ClearPedTasks(policeDog)
                                    else
                                        loadDict('creatures@rottweiler@amb@sleep_in_kennel@')
                                        TaskPlayAnim(policeDog, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel', 8.0, -8, -1, 1, 0, false, false, false)
                                    end
                                else
                                    ESX.ShowNotification('Votre chien est trop ~r~loin !')
                                end
                            else
                                ESX.ShowNotification('Tu ~r~n\'as pas~s~ de chien.')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Aboie / Chut !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if DoesEntityExist(policeDog) then
                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
                                    if IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@world_dog_barking@idle_a', 'idle_a', 3) then
                                        ClearPedTasks(policeDog)
                                    else
                                        loadDict('creatures@rottweiler@amb@world_dog_barking@idle_a')
                                        TaskPlayAnim(policeDog, 'creatures@rottweiler@amb@world_dog_barking@idle_a', 'idle_a', 8.0, -8, -1, 1, 0, false, false, false)
                                    end
                                else
                                    ESX.ShowNotification('Votre chien est trop ~r~loin !')
                                end
                            else
                                ESX.ShowNotification('Tu ~r~n\'as pas~s~ de chien.')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Gratte toi / Arrête !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if DoesEntityExist(policeDog) then
                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
                                    if IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@idle_a', 'idle_a', 3) then
                                        ClearPedTasks(policeDog)
                                    else
                                        loadDict('creatures@rottweiler@amb@world_dog_sitting@idle_a')
                                        TaskPlayAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@idle_a', 'idle_a', 8.0, -8, -1, 1, 0, false, false, false)
                                    end
                                else
                                    ESX.ShowNotification('Votre chien est trop ~r~loin !')
                                end
                            else
                                ESX.ShowNotification('Tu ~r~n\'as pas~s~ de chien.')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("La patte !", nil, { RightLabel = "→" }, DoesEntityExist(policeDog), function(_,_,s)
                        if s then
                            if DoesEntityExist(policeDog) then
                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
                                    if IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@tricks@', 'paw_right_loop', 3) then
                                        ClearPedTasks(policeDog)
                                    else
                                        loadDict('creatures@rottweiler@tricks@')
                                        TaskPlayAnim(policeDog, 'creatures@rottweiler@tricks@', 'paw_right_loop', 8.0, -8, -1, 1, 0, false, false, false)
                                    end
                                else
                                    ESX.ShowNotification('Votre chien est trop ~r~loin !')
                                end
                            else
                                ESX.ShowNotification('Tu ~r~n\'as pas~s~ de chien.')
                            end
                        end
                    end)


                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_arretNPC'),true,true,true,function()
                    

                    RageUI.Separator("↓ ~b~Gestion de la circulation~s~ ↓")

                    RageUI.ButtonWithStyle("Ajouter une zone d\'arrêt", nil, {RightLabel = "→"}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            TriggerEvent('fl_policejob:promptSpeedzone')
                            MenuLSPDOpen = false
                        end
                    end)

                    RageUI.ButtonWithStyle("Afficher les zones", nil, {RightLabel = "→"}, true, function(_,_,s)
                        if s then
                            TriggerEvent('fl_policejob:toggleSpeedzoneDraw')
                        end
                    end)
            
            
                end, function()    
                end, 1)
                

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_appelsmain'),true,true,true,function()
                    

                    if #appelsList >= 1 then
                        RageUI.Separator("~y~↓ Gestion d\'appels ↓")

                        for k,v in pairs(appelsList) do
                            RageUI.ButtonWithStyle("Appel numéro ~o~"..v.cpt.."~s~ du ~b~"..v.nom.."", nil, {RightLabel = "→"},true , function(_,_,s)
                                if s then
                                    nom = v.nom
                                    raison = v.raison
                                    id = v.id
                                    idA = k
                                    posit = v.pos
                                end
                            end, RMenu:Get("police_dynamicmenu", "police_dynamicmenu_actappel"))
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~o~Aucun Appel~s~")
                        RageUI.Separator("")
                    end   

                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_actappel'),true,true,true,function()
                    
                    RageUI.Separator("Numéro : ~b~"..nom.."")
                    RageUI.Separator("Raison de l\'appel : ~b~\n"..raison)
                    RageUI.Separator('')
                    RageUI.ButtonWithStyle("Point sur le GPS", nil, {RightLabel = "→"}, true, function(_,_,s)
                        if s then
                            SetNewWaypoint(posit.x, posit.y, posit.z)
                        end
                    end)
                    


                    RageUI.ButtonWithStyle("Clear l\'appel", '~r~Attention ! Cet appel sera supprimé pour toutes les unités.', {RightLabel = "→"}, true, function(_,_,s)
                        if s then
                            TriggerServerEvent('fl_appels:ClearApp', idA, nom, raison)
                            RageUI.CloseAll()
                            MenuLSPDOpen = false
                        end
                    end)
                end, function()    
                end, 1)


                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_citizen'),true,true,true,function()
                    
                    closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    RageUI.Separator('↓ ~y~Citoyens~s~ ↓')
                    RageUI.ButtonWithStyle("Fouiller l'individu", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            Wait(2)
                            TriggerServerEvent('fl_policejob:message', GetPlayerServerId(closestPlayer), 'Vous êtes fouillés par le ~b~LSPD.')
                            TriggerEvent('fl_factions:bodySearch', closestPlayer)
                            MenuLSPDOpen = false
                        end
                    end)
                    RageUI.ButtonWithStyle("Menotter / Démenotter", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('fl_policejob:handcuff', GetPlayerServerId(closestPlayer))
                        end
                    end)


                    RageUI.ButtonWithStyle("Escorter", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('fl_policejob:drag', GetPlayerServerId(closestPlayer))
                        end
                    end)

                   
                    RageUI.ButtonWithStyle("Mettre dans le véhicule", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('fl_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Sortir du véhicule", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            TriggerServerEvent('fl_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
                        end
                    end)
                    RageUI.Separator('↓ ~o~Amendes~s~ ↓')
                    RageUI.ButtonWithStyle("Amendes", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            local montant = tonumber(KeyboardInput('Amende', 'Montant :', '', 20))
                            if montant == nil or montant <= 0 then
                                ESX.ShowNotification('Montant invalide')
                            else
                                RageUI.CloseAll()
                                MenuLSPDOpen = false
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('Pas de joueurs proche')
                                else
                                    local playerPed = PlayerPedId()
        
                                    Citizen.CreateThread(function()
                                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                                        Citizen.Wait(5000)
                                        ClearPedTasks(playerPed)
                                        TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_police', 'Police', montant)
                                    end)
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Gérer les amendes impayées", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            flCore.jobs["police"].OpenUnpaidBillsMenu(closestPlayer)
                            RageUI.CloseAll()
                            MenuLSPDOpen = false
                        end
                    end)
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'l1' or ESX.PlayerData.job.grade_name == 'l2' or ESX.PlayerData.job.grade_name == 'l3' or ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.Separator('↓ ~r~Licenses~s~ ↓')
                        RageUI.ButtonWithStyle("Donner le PPA", nil, { RightLabel = "→" }, closestPlayer ~= -1 and closestDistance <= 3.0, function(_,_,s)
                            if s then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                TriggerServerEvent('fl_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
                                ESX.ShowNotification('~g~License d\'armes attribuée !')
                            end
                        end)
                    end
                    
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_carinfos'),true,true,true,function()
                    
                    if vehicleStats == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~o~En attente des données...")
                        RageUI.Separator("")
                    else
                        local owner = ""
                        if not vehicleStats.owner then owner = "John Doe ~r~(CIVIL)" else owner = vehicleStats.owner end
                        RageUI.Separator("~o~Plaque: ~s~"..vehicleStats.plate)
                        RageUI.Separator("~o~Propriétaire: ~s~"..owner)
                    end
                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_veh'),true,true,true,function()
                    
                    local coords  = GetEntityCoords(PlayerPedId())
                    local vehicle = ESX.Game.GetVehicleInDirection()

                    RageUI.ButtonWithStyle("Infos véhicule", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            vehicleStats = nil
                            local vehicle = ESX.Game.GetVehicleInDirection()
                            local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                            flCore.jobs["police"].getVehicleInfos(vehicleData)
                        end
                    end,RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_carinfos')) 

                    RageUI.ButtonWithStyle("Crocheter véhicule", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
                                TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING', 0, true)
                                Citizen.Wait(20000)
                                ClearPedTasksImmediately(PlayerPedId())
    
                                SetVehicleDoorsLocked(vehicle, 1)
                                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                ESX.ShowNotification("~o~Véhicule dévérouillé!")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Vehicule en fourrière", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            local playerPed = GetPlayerPed(-1)
                            if currentTask.busy then
                                return
                            end

                            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    
                            currentTask.busy = true
                            currentTask.task = ESX.SetTimeout(10000, function()
                                ClearPedTasks(playerPed)
                                ESX.Game.DeleteVehicle(vehicle)
                                ESX.ShowNotification("~o~Mise en fourrière effectuée")
                                currentTask.busy = false
                                Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
                            end)
    
                            -- keep track of that vehicle!
                            Citizen.CreateThread(function()
                                while currentTask.busy do
                                    Citizen.Wait(1000)
    
                                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                    if not DoesEntityExist(vehicle) and currentTask.busy then
                                        ESX.ShowNotification("~r~Le véhicule a bougé!")
                                        ESX.ClearTimeout(currentTask.task)
                                        ClearPedTasks(playerPed)
                                        currentTask.busy = false
                                        break
                                    end
                                end
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Consulter la base de donnée", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            local input = KeyboardInput('Recherche', 'Plaque d\'immatriculation :', '', 20)
                            flCore.jobs["police"].LookupVehicle(input)
                        end
                    end)

                    RageUI.ButtonWithStyle("Recherche N° permis", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            TriggerEvent('fl_dmvschool:dialogFindLicenseById')
                            MenuLSPDOpen = false
                        end
                    end)

                end, function()    
                end, 1)

                RageUI.IsVisible(RMenu:Get("police_dynamicmenu",'police_dynamicmenu_codes'),true,true,true,function()
                    
                    RageUI.Separator("↓ ~r~Demandes de renfort ~s~↓")

                    RageUI.ButtonWithStyle("~g~Urgence légère", nil, { RightLabel = "→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local coords  = GetEntityCoords(PlayerPedId())
                            local district = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
                            local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("fl_core:police:code", 11, 3,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~" .. GetPlayerName(PlayerId()) .. "\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos :~g~ CODE 2 \n", coords)
                            TriggerServerEvent("fl_appels:Zebi", "~g~Code 2", GetEntityCoords(PlayerPedId()), GetPlayerName(PlayerId()))
                            codesCooldown = true
                            Citizen.SetTimeout(12500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~o~Urgence moyenne", nil, { RightLabel = "→" }, not codesCooldown, function(_,_,s)
                        if s then
                            local coords  = GetEntityCoords(PlayerPedId())
                            local district = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
                            local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            TriggerServerEvent("fl_core:police:code", 12, 3,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~" .. GetPlayerName(PlayerId()) .. "\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos :~o~ CODE 3 \n", coords)
                            TriggerServerEvent("fl_appels:Zebi", "~o~Code 3", GetEntityCoords(PlayerPedId()), GetPlayerName(PlayerId()))
                            codesCooldown = true
                            Citizen.SetTimeout(12500, function()
                                codesCooldown = false
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~Urgence maximale", nil, { RightLabel = "→" }, not codesCooldown, function(_,_,s)
                        if s then
                            
                            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                            local coords  = GetEntityCoords(PlayerPedId())
                            local district = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
                            local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))
                            TriggerServerEvent("fl_core:police:code", 13, 3,mugshot, mugshotStr, GetEntityCoords(PlayerPedId()), PlayerId())
                            TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~" .. GetPlayerName(PlayerId()) .. "\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos :~r~ CODE 99 \n", coords)
                            TriggerServerEvent("fl_appels:Zebi", "~r~Code 99", GetEntityCoords(PlayerPedId()), GetPlayerName(PlayerId()))
                            codesCooldown = true
                            Citizen.SetTimeout(12500, function()
                                codesCooldown = false
                            end)
                        end
                    end)       

                   

                end, function()    
                end, 1)

				Wait(1)
			end

		Wait(0)
		MenuLSPDOpen = false
		end)
	end
end


MenuClothesLSPD = false
function openClothesLSPDMenu()
    RMenu.Add("police_clothes", "police_clothes_main", RageUI.CreateMenu("Vestiaires", "Changez votre tenue"))
    RMenu:Get("police_clothes", "police_clothes_main"):SetStyleSize(0)
    RMenu:Get("police_clothes", "police_clothes_main").Closed = function()
        MenuClothesLSPD = false
    end
	  
    if not MenuClothesLSPD then 
        MenuClothesLSPD = true
		RageUI.Visible(RMenu:Get('police_clothes', 'police_clothes_main'), true)

		Citizen.CreateThread(function()
			while MenuClothesLSPD do
                RageUI.IsVisible(RMenu:Get("police_clothes",'police_clothes_main'),true,true,true,function()

                    RageUI.Separator("↓ ~b~Tenues de civil~s~ ↓")
                    RageUI.ButtonWithStyle("Prenez votre tenue civil","Prenez votre tenue avec laquelle vous êtes venus !", {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                        if s then
                            ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
                                local isMale = skin.sex == 0
                                TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                    ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
                                        TriggerEvent('skinchanger:loadSkin', skin)
                                        TriggerEvent('esx:restoreLoadout')
                                    end)
                                end)
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Garde Robe Perso","Prenez les tenues dans votre casier !", {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            Wait(5)
                            TriggerEvent('fl_clotheshop:openNonEditableDessing')
                            MenuClothesLSPD = false
                        end
                    end)
                

                    RageUI.Separator("↓ ~o~Tenues de service~s~ ↓")

                    for i = 1,9 do
                        RageUI.ButtonWithStyle("Tenue de "..flCore.jobs["police"].config[i].label,"Equipez la tenue de "..flCore.jobs["police"].config[i].label, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                            if s then
                                flCore.jobs["police"].setUniform(i,PlayerPedId())
                            end
                        end)
                    end
                    RageUI.Separator("↓ ~y~Tenues spéciales~s~ ↓")
                    for i = 10,16 do
                        RageUI.ButtonWithStyle("Tenue de "..flCore.jobs["police"].config[i].label,"Equipez la tenue de "..flCore.jobs["police"].config[i].label, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                            if s then
                                flCore.jobs["police"].setUniform(i,PlayerPedId())
                            end
                        end)
                    end
                    RageUI.Separator("↓ ~g~Gilets~s~ ↓")
                    for i = 17, 20 do
                        RageUI.ButtonWithStyle(flCore.jobs["police"].config[i].label,"Equipez un "..flCore.jobs["police"].config[i].label, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                            if s then
                                flCore.jobs["police"].setUniform(i,PlayerPedId())
                            end
                        end)
                    end

                    
                end, function()    
                end, 1)
				Wait(1)
			end

		Wait(0)
		MenuClothesLSPD = false
		end)
	end
end

ArmurerieMenuLSPDOpen = false
function openArmoryLSPDMenu()
    RMenu.Add("police_armory", "police_armory_main", RageUI.CreateMenu("Armurerie", "Obtenez vos armes de service"))
    RMenu:Get("police_armory", "police_armory_main"):SetStyleSize(0)
    RMenu:Get("police_armory", "police_armory_main").Closed = function()
        ArmurerieMenuLSPDOpen = false
    end
	  

    if not ArmurerieMenuLSPDOpen then 
        ArmurerieMenuLSPDOpen = true
		RageUI.Visible(RMenu:Get('police_armory', 'police_armory_main'), true)

		Citizen.CreateThread(function()
			while ArmurerieMenuLSPDOpen do
                RageUI.IsVisible(RMenu:Get("police_armory",'police_armory_main'),true,true,true,function()
                    RageUI.Separator("↓ ~b~Stock d'armes~s~ ↓")
                    RageUI.ButtonWithStyle("Prendre des armes", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            Wait(5)
                            TriggerEvent('fl_society:openGetStocksMenu', 'police_weapons')
                            ArmurerieMenuLSPDOpen = false
                        end
                    end)
                    RageUI.ButtonWithStyle("Ranger des armes", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            Wait(5)
                            TriggerEvent('fl_society:openPutStocksMenu', 'police_weapons')
                            ArmurerieMenuLSPDOpen = false
                        end
                    end)
                end, function()    
                end, 1)
				Wait(1)
			end

		Wait(0)
		ArmurerieMenuLSPDOpen = false
		end)
	end
end

PerquiseStockMenu = false
function openPerquiseStockMenu()
    RMenu.Add("police_perquise", "police_perquise_main", RageUI.CreateMenu("Stock", "Gestion du stock"))
    RMenu:Get("police_perquise", "police_perquise_main"):SetStyleSize(0)
    RMenu:Get("police_perquise", "police_perquise_main").Closed = function()
        PerquiseStockMenu = false
    end
	  

    if not PerquiseStockMenu then 
        PerquiseStockMenu = true
		RageUI.Visible(RMenu:Get('police_perquise', 'police_perquise_main'), true)

		Citizen.CreateThread(function()
			while PerquiseStockMenu do
                RageUI.IsVisible(RMenu:Get("police_perquise",'police_perquise_main'),true,true,true,function()

                    RageUI.Separator("↓ ~b~Gestion du stock~s~ ↓")


                    RageUI.ButtonWithStyle("Déposer un objet","Prenez un objet du stock !", {RightLabel = "→"}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            Wait(5)
                            TriggerEvent('fl_society:openPutStocksMenu', 'police')
                            PerquiseStockMenu = false
                        end
                    end)
                
                    RageUI.ButtonWithStyle("Prendre un objet","Déposez un objet du stock !", {RightLabel = "→"}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            Wait(5)
                            TriggerEvent('fl_society:openGetStocksMenu', 'police')
                            PerquiseStockMenu = false
                        end
                    end)
            
                end, function()    
                end, 1)
				Wait(1)
			end

		Wait(0)
		PerquiseStockMenu = false
		end)
	end
end




RegisterNetEvent("K9:ToggleFollow")
AddEventHandler("K9:ToggleFollow", function()
	if DoesEntityExist(policeDog) then
		if not followingDogs then
			TaskFollowToOffsetOfEntity(policeDog, GetPlayerPed(PlayerId()), 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
			SetPedKeepTask(policeDog, true)
			followingDogs = true
		else
			SetPedKeepTask(policeDog, false)
			ClearPedTasks(policeDog)
			followingDogs = false
		end
	end
end)

