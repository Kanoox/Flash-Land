local staffService = false
local NoClip = false
local ShowName = false
local invisible = false
local staffRank = nil
local colorVar = nil
local selected = nil
local isSubMenu = {[false] = { RightLabel = "~b~Éxecuter ~s~→→" },[true] = { RightLabel = "~s~→→" }}
local stringText = {[true] = "~g~ON~s~",[false] = "~r~OFF~s~"}
local Reports = { available = {}, taken = {} };
local SelectedReport = {}
local staffActions = {}
local possiblesQty = {}
local gamerTags = {}
local items = {}
local qty = 1
local NoClipSpeed =  2.0

local function init()
    TriggerServerEvent("pz_admin:canUse")
end

------- Fonction qui set les reports
function SetReports(reports)
	local PlayerServerId =  GetPlayerServerId(PlayerId())
	Reports.taken = {}
	Reports.available = {};

	for _, report in pairs(reports) do
		if not report.taken or report.taken == nil then
			table.insert(Reports.available, report);
		elseif PlayerServerId == report.taken then
			table.insert(Reports.taken, report)
		end
	end
end

RegisterCommand('report', function(source, args, rawCommand)
    local reportText = table.concat(args, " ")
	if reportText == nil then
		ESX.ShowNotification('~r~Le report n\'a pas ete envoye.');
		return;
	end

	ESX.ShowNotification('Votre report a bien été envoye.') 
	TriggerServerEvent('pz_admin:addReport', reportText);
end, 0)

RegisterNetEvent('pz_admin:setReports')
AddEventHandler('pz_admin:setReports', function(reports)
	SetReports(reports);
	ESX.ShowAdvancedNotification('FreeLife', 'Event', 'Les reports ont été mis à jours.', 'CHAR_BUGSTARS', 1);
end)


local function mug(title, subject, msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end

function playerMarker(player)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

local function getItems()
    TriggerServerEvent("pz_admin:getItems")
end

local function alterMenuVisibility()
    RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_main'), not RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_main')))
end

local function registerMenus()
    RMenu.Add("pz_admin", "pz_admin_main", RageUI.CreateMenu("Menu d'administration","Rang: "..Pz_admin.ranks[staffRank].color..Pz_admin.ranks[staffRank].label))
    RMenu:Get('pz_admin', 'pz_admin_main').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_self', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_main'), "Intéractions personnelle", "Intéractions avec votre joueur"))
    RMenu:Get('pz_admin', 'pz_admin_self').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_players', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_main'), "Intéractions citoyens", "Intéractions avec un citoyen"))
    RMenu:Get('pz_admin', 'pz_admin_players').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_veh', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_main'), "Intéractions véhicules", "Intéractions avec un véhicule proche"))
    RMenu:Get('pz_admin', 'pz_admin_veh').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_param', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_self'), "Intéractions personnelle", "Paramètres perso"))
    RMenu:Get('pz_admin', 'pz_admin_param').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_players_interact', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_players'), "Intéractions citoyens", "Intéragir avec ce joueur"))
    RMenu:Get('pz_admin', 'pz_admin_players_interact').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_players_remb', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_players_interact'), "Intéractions citoyens", "Intéragir avec ce joueur"))
    RMenu:Get('pz_admin', 'pz_admin_players_remb').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_report', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_main'), "Intéractions Report", "Intéragir avec ces reports"))
    RMenu:Get('pz_admin', 'pz_admin_report').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_report_info', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_report'), "Intéractions Report", "Intéragir avec ces reports"))
    RMenu:Get('pz_admin', 'pz_admin_report_info').Closed = function()end
end

local function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

local function generateStaffOutfit(model)
    clothesSkin = {}

    local couleur = Pz_admin.ranks[staffRank].outfit
    if model == GetHashKey("mp_m_freemode_01") then
        clothesSkin = {
            ['bproof_1'] = 0,
        }
    else
        clothesSkin = {
            ['bproof_1'] = 0,
        }
    end

    for k,v in pairs(clothesSkin) do
        TriggerEvent("skinchanger:change", k, v)
    end
end

local function initializeNoclip()
    Citizen.CreateThread(function()
        while NoClip and staffService do
            HideHudComponentThisFrame(19)
            local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local camCoords = getCamDirection()
            SetEntityVelocity(GetPlayerPed(-1), 0.01, 0.01, 0.01)
            SetEntityCollision(GetPlayerPed(-1), 0, 1)

            if IsControlPressed(0, 32) then
                pCoords = pCoords + (NoClipSpeed * camCoords)
            end

            if IsControlPressed(0, 269) then
                pCoords = pCoords - (NoClipSpeed * camCoords)
            end

            if IsControlPressed(1, 15) then
                NoClipSpeed = NoClipSpeed + 0.5
            end
            if IsControlPressed(1, 16) then
                NoClipSpeed = NoClipSpeed - 0.5
                if NoClipSpeed < 0 then
                    NoClipSpeed = 0
                end
            end
            SetEntityCoordsNoOffset(GetPlayerPed(-1), pCoords, true, true, true)
            Citizen.Wait(0)
        end
    end)
end

local function initializeInvis()
    Citizen.CreateThread(function()
        while invisible and staffService do
            SetEntityVisible(GetPlayerPed(-1), 0, 0)
            NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), 1)
            Citizen.Wait(1)
        end
    end)
end


local function initializeNames()
    Citizen.CreateThread(function()
        local pPed = PlayerPedId()
        while ShowName and staffService do
            local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
            for _, v in pairs(GetActivePlayers()) do
                local otherPed = GetPlayerPed(v)
                if otherPed ~= pPed then
                    if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                        gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
                        SetMpGamerTagVisibility(gamerTags[v], 4, 1)
                    else
                        RemoveMpGamerTag(gamerTags[v])
                        gamerTags[v] = nil
                    end
                end
                Citizen.Wait(1)
            end
        end
    end)
end

local function initializeText()
    Citizen.CreateThread(function()
        while staffService do 
            Citizen.Wait(1)
            RageUI.Text({message = colorVar.."Mode administration actif~n~~b~Reports: ~s~"..#Reports.available,time_display = 1})
        end
    end)
end


local openM = false
local function initializeThread(rank,license)
    mug("Administration","~b~Statut du mode staff","Votre mode staff est pour le moment désactivé, vous pouvez l'activer au travers du ~o~[F11]")

    staffRank = rank
    colorVar = "~r~"

    for i = 1,100 do 
        table.insert(possiblesQty, tostring(i))
    end

    getItems()
    registerMenus()

    local actualRankPermissions = {}

    for perm,_ in pairs(Pz_admin.functions) do
        actualRankPermissions[perm] = false
    end

    for _,perm in pairs(Pz_admin.ranks[staffRank].permissions) do 
        actualRankPermissions[perm] = true
    end
    if not openM then 
        openM = false
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if IsControlJustPressed(1, 344) then alterMenuVisibility() end
        end
    end)

    Citizen.CreateThread(function()
         while true do 
            Citizen.Wait(800)
            if colorVar == "~r~" then colorVar = "~o~" else colorVar = "~r~" end 
        end 
    end)


    

    Citizen.CreateThread(function()
        while true do
            local menu = false
            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_main'),true,true,true,function()
                menu = true
                RageUI.Checkbox("Mode administration", nil, staffService, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    staffService = Checked;
                end, function()
                    staffService = true
                    mug("Administration","~b~Statut du mode staff","Vous êtes désormais: ~g~en administration~s~.")
                    TriggerServerEvent("pz_admin:StaffOn", true)
                    initializeText()
                    generateStaffOutfit(GetEntityModel(PlayerPedId()))
                end, function()
                    staffService = false
                    NoClip = false
                    ShowName = false
                    invisible = false
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    SetEntityCollision(GetPlayerPed(-1), 1, 1)
                    SetEntityVisible(GetPlayerPed(-1), 1, 0)
                    NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), 0)
                    for _,v in pairs(GetActivePlayers()) do
                        RemoveMpGamerTag(gamerTags[v])
                    end
                    TriggerServerEvent("pz_admin:StaffOn", false)
                    mug("Administration","~b~Statut du mode staff","Vous êtes désormais ~r~hors administration~s~.")
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)
                end)

                if staffService then
                    RageUI.Separator(colorVar.."/!\\ Mode administration actif /!\\")
                    RageUI.ButtonWithStyle("Intéractions personnelle", "Intéragir avec votre ped", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_self'))
                    RageUI.ButtonWithStyle("Intéractions joueurs", "Intéragir avec les joueurs du serveur", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_players'))
                    RageUI.ButtonWithStyle("Intéractions véhicules", "Intéragir avec les véhicules du serveur", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_veh'))
                    RageUI.ButtonWithStyle("Intéractions report", "Intéragir avec les report des joueurs", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_report'))
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_players'),true,true,true,function()
                menu = true
                for k,v in pairs(GetActivePlayers()) do 

                    RageUI.ButtonWithStyle("["..GetPlayerServerId(v).."] "..GetPlayerName(v), "Intéragir avec ce joueur", { RightLabel = "~b~Intéragir ~s~→→" }, true, function(_,a,s)
                        if a then playerMarker(v) end
                        if s then
                            selected = {c = v, s = GetPlayerServerId(v)}
                        end
                    end, RMenu:Get('pz_admin', 'pz_admin_players_interact'))

                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_report'),true,true,true,function()
                menu = true
                RageUI.Separator("~b~↓↓~s~ Reports disponibles ~b~↓↓~s~")
                for i = 1, #Reports.available, 1 do
                    RageUI.ButtonWithStyle(Reports.available[i].label, Reports.available[i].text, {RightLabel = "~b~Intéragir ~s~→→" }, true, function(_,a,s)
                        if s then
                            SelectedReport = Reports.available[i]
                        end
                    end,RMenu:Get('pz_admin', 'pz_admin_report_info'))
                end
            end, function()    
            end, 1)
            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_report_info'),true,true,true,function()
                menu = true
                if not SelectedReport.taken or SelectedReport.taken == nil then
                    RageUI.ButtonWithStyle('~g~Prendre le report',nil,{}, true,function(_,a,s)
                        if s then
                            local PlayerServerId = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('pz_admin:takeReport', SelectedReport.serverId, SelectedReport.text);
                            SelectedReport.taken = PlayerServerId
                        end
                    end)
                else
                RageUI.ButtonWithStyle("Envoyez un message", "" , {} , true ,function(_,a,s)
                    if s then
                        local message = Pz_admin.utils.keyboard("Message","Entrez un message:")
                        TriggerServerEvent("pz_admin:message",SelectedReport.serverId, message)
                    end
                end)
                RageUI.ButtonWithStyle("Réanimer",nil , {RightBadge = RageUI.BadgeStyle.Heart}, true ,function(_,a,s)
                    if s then
                        TriggerServerEvent('ambulance:revive', SelectedReport.serverId);			
                    end
                end)
                RageUI.ButtonWithStyle("Se téléporter sur le joueur", nil , {} , true ,function(_,a,s)
                    if s then
                        ReportPlayer = GetPlayerPed(GetPlayerFromServerId(SelectedReport.serverId))
                        SetEntityCoords(PlayerPedId(), GetEntityCoords(ReportPlayer))

                        ESX.ShowNotification("Tu t'es téléporter à ~b~"..SelectedReport.label)
                    end
                end)
                
                RageUI.ButtonWithStyle("Téléporter le joueur sur moi", nil , {} , true ,function(_,a,s)
                    if s then
                        local plyPedCoords = GetEntityCoords(PlayerPedId())
                        TriggerServerEvent('pz_admin:bringplayer', SelectedReport.serverId, plyPedCoords)
                        ESX.ShowNotification(  "~s~ tu as apporté ~b~".. SelectedReport.label .."~s~ sur toi")
                    end
                end)
                RageUI.ButtonWithStyle("~r~Supprimer le Report", "Pas de retour en arrière prossible !!", {RightBadge = RageUI.BadgeStyle.Alert}, true ,function(_,a,s)
                    if s then
                        TriggerServerEvent('pz_admin:removeReport', SelectedReport.serverId, SelectedReport.text);
                    end
                end,RMenu:Get('pz_admin', 'pz_admin_report'))
            end
            end, function()    
            end, 1)
            
            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_players_interact'),true,true,true,function()
                menu = true 
                for i = 1,#Pz_admin.functions do
                    if Pz_admin.functions[i].cat == "player" then
                        if Pz_admin.functions[i].sep ~= nil then RageUI.Separator(Pz_admin.functions[i].sep) end
                        RageUI.ButtonWithStyle(Pz_admin.functions[i].label, "Appuyez pour faire cette action", isSubMenu[Pz_admin.functions[i].toSub], actualRankPermissions[i] == true, function(_,a,s)
                            if a then playerMarker(selected.c) end
                            if s then
                                Pz_admin.functions[i].press(selected)
                            end
                        end)
                    end
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_self'),true,true,true,function()
                menu = true
                for i = 1,#Pz_admin.functions do
                    if Pz_admin.functions[i].cat == "self" then
                        if Pz_admin.functions[i].sep ~= nil then RageUI.Separator(Pz_admin.functions[i].sep) end
                        RageUI.ButtonWithStyle(Pz_admin.functions[i].label, "Appuyez pour faire cette action", isSubMenu[Pz_admin.functions[i].toSub], actualRankPermissions[i] == true, function(_,a,s)
                            if s then
                                Pz_admin.functions[i].press()
                            end
                        end)
                    end
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_veh'),true,true,true,function()
                menu = true
                local pos = GetEntityCoords(PlayerPedId())
                local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                if dst ~= nil then RageUI.Separator("~s~Distance: ~b~"..math.floor(dst+0.5).."m") end
                for i = 1,#Pz_admin.functions do
                    if Pz_admin.functions[i].cat == "veh" then
                        if Pz_admin.functions[i].sep ~= nil then RageUI.Separator(Pz_admin.functions[i].sep) end
                        RageUI.ButtonWithStyle(Pz_admin.functions[i].label, "Appuyez pour faire cette action", isSubMenu[Pz_admin.functions[i].toSub], actualRankPermissions[i] == true, function(_,a,s)
                            
                            if a then 
                                pos = GetEntityCoords(veh)
                                DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                            end
                            if s then
                                local co = GetEntityCoords(PlayerPedId())
                                local veh, dst = ESX.Game.GetClosestVehicle({x = co.x, y = co.y, z = co.z})
                                Pz_admin.functions[i].press(veh)
                            end
                        end)
                    end
                end
            end, function()    
            end, 1)

            

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_players_remb'),true,true,true,function()
                menu = true
                RageUI.Separator("↓ ~b~Paramètrage ~s~↓")

                RageUI.List("Quantité: ~s~", possiblesQty, qty, nil, {}, true, function(Hovered, Active, Selected, Index)
                    qty = Index
                end)
                RageUI.Separator("↓ ~o~Liste d'items ~s~↓")

                for k,v in pairs(items) do
                    RageUI.ButtonWithStyle(v.label, "Appuyez pour donner cet item", { RightLabel = "~b~Donner ~s~→→" }, true, function(_,a,s)
                        if s then
                            TriggerServerEvent("pz_admin:remb", selected.s, v.name, v.label, qty)
                        end
                    end)
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_param'),true,true,true,function()
                menu = true
                RageUI.Checkbox("NoClip", nil, NoClip, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    NoClip = Checked;
                end, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    NoClip = true
                    invisible = true
                    initializeNoclip()
                    initializeInvis()
                end, function()
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    SetEntityCollision(GetPlayerPed(-1), 1, 1)
                    SetEntityVisible(GetPlayerPed(-1), 1, 0)
                    NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), 0)
                    invisible = false
                    NoClip = false
                end)

                RageUI.Checkbox("Invisibilité", nil, invisible, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    invisible = Checked;
                end, function()
                    invisible = true
                    initializeInvis()
                end, function()
                    invisible = false
                    SetEntityVisible(GetPlayerPed(-1), 1, 0)
                    NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), 0)
                end)

                RageUI.Checkbox("Afficher les noms", nil, ShowName, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    ShowName = Checked;
                end, function()
                    ShowName = true
                    initializeNames()
                end, function()
                    ShowName = false
                    for _,v in pairs(GetActivePlayers()) do
                        RemoveMpGamerTag(gamerTags[v])
                    end
                end)
            end, function()    
            end, 1)
            
            Citizen.Wait(0)
            dynamicMenu2 = menu
        end
    end)
end
end

RegisterNetEvent("pz_admin:remb")
AddEventHandler("pz_admin:remb", function(id)
    if colorVar == nil then return end
    RageUI.CloseAll()
    Citizen.Wait(100)
    RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_players_remb'), not RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_players_remb')))
end)

RegisterNetEvent("pz_admin:teleport")
AddEventHandler("pz_admin:teleport", function(pos)
    SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z, false, false, false, false)
end)

RegisterNetEvent("pz_admin:getItems")
AddEventHandler("pz_admin:getItems", function(table)
    items = table
end)

RegisterNetEvent("pz_admin:canUse")
AddEventHandler("pz_admin:canUse", function(ok, rank, license)
    if ok then initializeThread(rank,license) end
end)

RegisterNetEvent("pz_admin:options")
AddEventHandler("pz_admin:options", function()
    if colorVar == nil then return end
    RageUI.CloseAll()
    Citizen.Wait(100)
    RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_param'), not RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_param')))
end)


----trigger pour bring le joueur
RegisterNetEvent('pz_admin:bringplayer')
AddEventHandler('pz_admin:bringplayer', function(plyPedCoords)
	SetEntityCoords(PlayerPedId(), plyPedCoords)
end)
pzCore.staff = {}
pzCore.staff.init = init

--- Revive Administration
RegisterNetEvent('ambulance:revive')
AddEventHandler('ambulance:revive', function(untiezx)
	if untiezx == nil then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		TriggerServerEvent('ambulance:setDeathStatus', false)
		DisplayRadar(true)
		TriggerEvent('esx_status:setDisplay', 1.0)
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		RespawnPed(playerPed, formattedCoords, 0.0)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		isDead = false
		MenuOpen = false
		DidCall = false
	else
		local playerPed = PlayerPedId()
		TriggerServerEvent('ambulance:setDeathStatus', false)
		DisplayRadar(true)
		TriggerEvent('esx_status:setDisplay', 1.0)
		RageUI.GoBack()
		RageUI.CloseAll()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = vector3(-459.43, -283.37, 34.91)

		RespawnPed(playerPed, formattedCoords, 0.0, true)
		RemoveItemsAfterRPDeath("oui")
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end
end)

function RespawnPed(ped, coords, heading, df)
	print(ped,  coords.x, coords.y, coords.z, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
	isDead = false
end
