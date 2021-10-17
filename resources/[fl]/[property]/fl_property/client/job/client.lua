local Zones = {
	Entrer = {
		Pos   = vector3(-1382.57, -500.55, 32.16),
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 25
	},

	Sortie = {
		Pos   = vector3(-141.15, -613.81, 167.9),
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 25
	},

	Interaction = {
		Pos   = vector3(-126.07, -641.13, 167.9),
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Type  = 25
	}

}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId())
		local playerPed = PlayerPedId()
        local fps = false
		local CurrentZone = nil
        for k,v in pairs(Zones) do
            if #(coords - v.Pos) < 1.5 then
                fps = true
                BeginTextCommandDisplayHelp('STRING') 
                AddTextComponentSubstringPlayerName("Appuyer sur ~INPUT_PICKUP~ pour intéragir.") 
                EndTextCommandDisplayHelp(0, false, true, -1)
                if IsControlJustReleased(0, 38) then
					if k == 'Entrer' then
						SetEntityCoords(playerPed, Zones.Sortie.Pos.x, Zones.Sortie.Pos.y, Zones.Sortie.Pos.z)
					elseif k == 'Sortie' then 
						SetEntityCoords(playerPed, Zones.Entrer.Pos.x, Zones.Entrer.Pos.y, Zones.Entrer.Pos.z)
					elseif k == 'Interaction' and ESX.PlayerData.job and ESX.PlayerData.job.name == 'realestateagent' then
						if MenuGestionJobAgence then MenuGestionJobAgence = false end
						openMenuAgenceImmobiliere()
					end
                end
            elseif #(coords - v.Pos) < 7.0 then
                fps = true
                DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end
        end
        if fps then
            Wait(1)
        else
            Wait(1500)
        end
    end
end)

local proprietesVendus = {}

local function GetListePropriete()
	proprietesVendus = {}
	ESX.ShowNotification('~y~Chargement de la liste client...')
	ESX.TriggerServerCallback('fl_realestateagentjob:getCustomers', function(customersS)
		customers = customersS
	end)
	Wait(250)
		ESX.TriggerServerCallback('fl_realestateagentjob:getCustomers', function(customersS)
			customers = customersS
		end)
	Wait(250)

	if customers then
		for i=1, #customers, 1 do
			table.insert(proprietesVendus, {
				data = customers[i],
				cols = {
					customers[i].name,
					customers[i].propertyLabel,
					'N°'..tostring(customers[i].propertyId),
					'$' .. tostring(customers[i].propertyPrice),
					(customers[i].propertyRented and _U('customer_rent') or _U('customer_sell')),
					_U('customer_contractbuttons')
				}
			})
		end
	end
end

local MenuGestionJobAgence = false
local proprietaireIci = nil
local idPropertySelect = nil

RMenu.Add("fl_menuimmo", "fl_menuimmo_main", RageUI.CreateMenu("Menu Agence Immo","Gestion de la société"))
RMenu:Get("fl_menuimmo", "fl_menuimmo_main"):SetStyleSize(0)
RMenu:Get("fl_menuimmo", "fl_menuimmo_main").Closed = function()
	MenuGestionJobAgence = false
end

RMenu.Add('fl_clients', 'fl_clients_main', RageUI.CreateSubMenu(RMenu:Get("fl_menuimmo", "fl_menuimmo_main"), "Liste des clients","Clients"))
RMenu:Get("fl_clients", "fl_clients_main"):SetStyleSize(0)
RMenu:Get('fl_clients', 'fl_clients_main').Closed = function()
end

RMenu.Add('fl_clientsgestion', 'fl_clientsgestion_main', RageUI.CreateSubMenu(RMenu:Get("fl_clients", "fl_clients_main"), "Gestion de la propriété","Gérez la propriété."))
RMenu:Get("fl_clientsgestion", "fl_clientsgestion_main"):SetStyleSize(0)
RMenu:Get('fl_clientsgestion', 'fl_clientsgestion_main').Closed = function()
end


function openMenuAgenceImmobiliere()
	if not MenuGestionJobAgence then 
        MenuGestionJobAgence = true
		RageUI.Visible(RMenu:Get('fl_menuimmo', 'fl_menuimmo_main'), true)

		Citizen.CreateThread(function()
			while MenuGestionJobAgence do
				RageUI.IsVisible(RMenu:Get("fl_menuimmo",'fl_menuimmo_main'),true,true,true,function()
					RageUI.Separator('↓ ~y~Gestion ~s~↓')


					RageUI.ButtonWithStyle("Liste des clients", 'Voir les propriétées vendues !', { RightLabel = "→" }, true, function(_,_,s)
						if s then
							GetListePropriete()
						end
					end, RMenu:Get("fl_clients", "fl_clients_main"))

					RageUI.ButtonWithStyle("Actions Patron", 'Accédez aux actions du patron !', { RightLabel = "→" }, true, function(_,_,s)
						if s then
							RageUI.CloseAll()
							MenuGestionJobAgence = false
							TriggerEvent('fl_society:openBossMenu', 'realestateagent', function(data, menu)
							end)
						end
					end)

				
                end, function()    
                end, 1)

				RageUI.IsVisible(RMenu:Get("fl_clients",'fl_clients_main'),true,true,true,function()
					RageUI.Separator('↓ ~y~Liste des clients ~s~↓')
					if #proprietesVendus == 0 then
						RageUI.Separator('')
						RageUI.Separator('~r~Aucune propriété enregistré.')
						RageUI.Separator('')
					else
						for i = 1, #proprietesVendus, 1 do
							if proprietesVendus[i].data.propertyRented == true then 
								label = "Oui\n~s~Prix : "..proprietesVendus[i].data.propertyPrice.." ~g~$ ~s~/ mois" 
							else 
								label = "Non" 
							end

							RageUI.ButtonWithStyle("Nom de la propriété : ~b~"..proprietesVendus[i].data.propertyLabel.."~s~", "Propriétaire : ~b~"..proprietesVendus[i].data.name.."~s~\nVendu par : ~b~"..proprietesVendus[i].data.propertySoldby.."\n~s~Location : ~b~"..label.."", { RightLabel = "→" }, true, function(_,_,s)
								if s then
									proprietaireIci = proprietesVendus[i].data.name
									idPropertySelect = proprietesVendus[i].data.propertyId
								end
							end, RMenu:Get("fl_clientsgestion", "fl_clientsgestion_main"))
						end
					end

	
                end, function()    
                end, 1)

				RageUI.IsVisible(RMenu:Get("fl_clientsgestion",'fl_clientsgestion_main'),true,true,true,function()

					RageUI.ButtonWithStyle("~r~Exclure le propriétaire", "Propriétaire : ~b~"..proprietaireIci.."", { RightLabel = "→" }, true, function(_,_,s)
						if s then
							TriggerServerEvent('fl_realestateagentjob:revoke', idPropertySelect)
							RageUI.CloseAll()
							MenuGestionJobAgence = false
							ESX.ShowNotification('La serrure de la porte a bien été ~o~changée~s~.')
						end
					end)

	
                end, function()    
                end, 1)
				Wait(1)
			end
			MenuGestionJobAgence = false
		end)
	end
end