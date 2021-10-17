local elementsInRoomInv = {}
local elementsInPlayerInv = {}
local listOfKeysOnProperty = {}
local poidsDansLeCoffre = 0
local inventoryWeight = 0

function OpenGatewayMenu()
	local elements = {}

	local gatewayProperties = GetLinkedProperties(CurrentProperty)
	local nbProperties = 0
	local onlyProperty = nil

	for i=1, #gatewayProperties, 1 do
		local OwnedProperties = GetOwnedPropertiesOfType(gatewayProperties[i])
		for _,OwnedProperty in pairs(OwnedProperties) do
			nbProperties = nbProperties + 1
			onlyProperty = OwnedProperty
		end
	end

	if nbProperties > 1 then
		table.insert(elements, {label = _U('owned_properties'), value = 'owned_properties'})
	elseif nbProperties == 0 then
		table.insert(elements, {label = 'Aucune propriété...', value = 'nope'})
	else
		local label = 'Propriété n°' .. onlyProperty.id
		if onlyProperty.societyLabel then
			label =  onlyProperty.societyLabel .. ' - ' .. label
		end

		table.insert(elements, { label = label, value = 'only_property' })
	end

	if ESX.PlayerData.job.name == CurrentProperty.soldby then
		table.insert(elements, {label = _U('available_properties'), value = 'available_properties'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'gateway', {
		title = 'Propriété',
		description = CurrentProperty.label,
		elements = elements
	}, function(data, menu)
		if data.current.value == 'owned_properties' then
			OpenGatewayOwnedPropertiesMenu()
		elseif data.current.value == 'available_properties' then
			OpenGatewayAvailablePropertiesMenu()
		elseif data.current.value == 'only_property' then
			ClickOnPropertiesInGateway(onlyProperty.property, onlyProperty)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'property_menu'
		CurrentActionMsg = _U('press_to_menu')
	end)
end



function OpenGatewayAvailablePropertiesMenu()
	local gatewayProperties = GetLinkedProperties(CurrentProperty)
	local elements = {}

	for i=1, #gatewayProperties, 1 do
		local displayLabel = gatewayProperties[i].label
		if ESX.PlayerData.job.name == gatewayProperties[i].soldby then
			displayLabel = displayLabel .. ' $' .. ESX.Math.GroupDigits(gatewayProperties[i].price)
		end

		table.insert(elements, {
			label = displayLabel,
			value = gatewayProperties[i].name,
			price = gatewayProperties[i].price,
			property = gatewayProperties[i],
		})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'gateway_available_properties', {
		title = _U('available_properties'),
		description = CurrentProperty.label,
		elements = elements
	}, function(data, menu)
		menu.close()

		local availableElements = {}
		if ESX.PlayerData.job.name == data.current.property.soldby then
			table.insert(availableElements, {label = 'Faire visiter', value = 'visit'})
		else
			table.insert(availableElements, {label = 'Visite réservées au ' .. data.current.property.soldby, value = 'unable_visit'})
		end

		if ESX.PlayerData.job.name == data.current.property.soldby then
			table.insert(availableElements, {label = 'Vendre cash à un client', value = 'sellClient'})
			table.insert(availableElements, {label = 'Vendre à un client', value = 'sellBankClient'})
			table.insert(availableElements, {label = 'Louer à un client', value = 'rentClient'})
			table.insert(availableElements, {label = 'Acheter pour soi', value = 'buySelf'})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'gateway_available_properties_actions', {
			title = _U('available_properties'),
			description = CurrentProperty.label,
			elements = availableElements,
		}, function(data2, menu2)
			menu2.close()

			if data2.current.value == 'buySelf' then
				TriggerServerEvent('fl_realestateagentjob:buySelf', data.current.property)
			elseif data2.current.value == 'sellClient' then
				TriggerEvent('fl_realestateagentjob:actionMenuFor', 'sell', data.current.property.name)
			elseif data2.current.value == 'rentClient' then
				TriggerEvent('fl_realestateagentjob:actionMenuFor', 'rent', data.current.property.name)
			elseif data.current.value == 'sellBankClient' then
				TriggerEvent('fl_realestateagentjob:actionMenuFor', 'sellBank', data.current.property.name)
			elseif data2.current.value == 'visit' then
				VisitProperty(CurrentProperty)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

local SpawnedBoats = {}
function OpenBoatMenu()
	local HasPermisionForBoats = false
	local Property = GetProperty(LastMarkerProperty)
	local OwnedProperties = GetOwnedPropertiesOfType(Property)

	for _,OwnedProperty in pairs(OwnedProperties) do
		if HasPermissionOnOwnedProperty(Property, OwnedProperty) then
			HasPermisionForBoats = true
		end
	end

	if not HasPermisionForBoats and not (ESX.PlayerData.job.name == Property.soldby and #OwnedProperties == 0) then
		ESX.ShowNotification('~r~Vous ne pouvez pas accèder au garage personnel du Yacht...')
		return
	end

	local CurrentBoatInfo = nil

	for _,BoatInfo in pairs(Config.Boats) do
		if BoatInfo.PropertyName == Property.name then
			CurrentBoatInfo = BoatInfo
		end
	end

	local elements = {
			{label = 'Jetsky', value = 'seashark'},
			{label = 'Speeder', value = 'speeder'},
			{label = 'Ranger un bateau', value = 'delete'},
	}

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'boat_menu', {
		title = 'Garage à bateau',
		elements = elements
	}, function(data, menu)
		local ClosestVehicle, ClosestDistance = ESX.Game.GetClosestVehicle(CurrentBoatInfo.Spawn)

		if data.current.value == 'delete' then
			if ClosestDistance > 30 then
				ESX.ShowNotification('~r~Aucun bateau à rentrer')
				return
			end

			for i,vehicle in pairs(SpawnedBoats) do
				if vehicle == ClosestVehicle then
					table.remove(SpawnedBoats, i)
				end
			end

			ESX.Game.DeleteVehicle(ClosestVehicle)
			ESX.ShowNotification('Bateau rentré !')
			return
		end

		if ClosestDistance < 3 then
			ESX.ShowNotification('~r~Pas de place pour sortir le bateau...')
			return
		end

		for i,boat in pairs(SpawnedBoats) do
			if not DoesEntityExist(boat) then
				table.remove(SpawnedBoats, i)
			end
		end

		ESX.Game.SpawnVehicle(data.current.value, CurrentBoatInfo.Spawn, CurrentBoatInfo.SpawnHeading, function(vehicle)
			table.insert(SpawnedBoats, vehicle)
			if #SpawnedBoats > 3 then
				ESX.Game.DeleteVehicle(SpawnedBoats[1])
				table.remove(SpawnedBoats, 1)
			end
			ESX.UI.Menu.CloseAll()
			CurrentAction = 'boat_menu'
			CurrentActionMsg = _U('press_to_menu')
		end)
	end, function(data, menu)
		menu.close()

		CurrentAction = 'boat_menu'
		CurrentActionMsg = _U('press_to_menu')
	end)
end

function OpenGatewayOwnedPropertiesMenu()
	local gatewayProperties = GetLinkedProperties(CurrentProperty)

	local ownedElements = {}
	local societyElements = {}
	local allElements = {}

	for i=1, #gatewayProperties, 1 do
		local OwnedProperties = GetOwnedPropertiesOfType(gatewayProperties[i])
		for _,OwnedProperty in pairs(OwnedProperties) do
			if OwnedProperty.society then
				table.insert(societyElements, {
					label = OwnedProperty.societyLabel .. ' - Propriété n°' .. OwnedProperty.id,
					value = gatewayProperties[i].name,
					property = gatewayProperties[i],
					ownedproperty = OwnedProperty,
				})
			elseif HasPermissionOnOwnedProperty(gatewayProperties[i], OwnedProperty) then
				table.insert(ownedElements, {
					label = 'Propriété n°' .. OwnedProperty.id,
					value = gatewayProperties[i].name,
					property = gatewayProperties[i],
					ownedproperty = OwnedProperty,
				})
			else
				table.insert(allElements, {
					label = 'Propriété n°' .. OwnedProperty.id,
					value = gatewayProperties[i].name,
					property = gatewayProperties[i],
					ownedproperty = OwnedProperty,
				})
			end
		end
	end
	local elements = {}

	if #ownedElements > 0 then
		table.insert(elements, {label = '-- Mes Propriétés --'})

		for _,e in pairs(ownedElements) do
			table.insert(elements, e)
		end
	end

	if #societyElements > 0 then
		table.insert(elements, {label = '-- Sociétés --'})

		for _,e in pairs(societyElements) do
			table.insert(elements, e)
		end
	end

	if #allElements > 0 then
		table.insert(elements, {label = '-- Autres Propriétés --'})

		for _,e in pairs(allElements) do
			table.insert(elements, e)
		end
	end

	if #allElements == 0 and #societyElements == 0 and #ownedElements == 0 then
		table.insert(elements, {label = 'Aucune propriétés ...'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'gateway_owned_properties', {
		title = _U('owned_properties'),
		description = CurrentProperty.label,
		elements = elements
	}, function(data, menu)
		if not data.current.property then return end
		ClickOnPropertiesInGateway(data.current.property, data.current.ownedproperty)
	end, function(data, menu)
		menu.close()
	end)
end

function ClickOnPropertiesInGateway(Property, OwnedProperty)
	local elements = {}
	if HasPermissionOnOwnedProperty(Property, OwnedProperty) then
		table.insert(elements, {label = _U('enter'), value = 'enter'})
	else
		table.insert(elements, {label = 'Toquer la porte', value = 'wantToEnter'})
	end

	if ESX.PlayerData.job.name == OwnedProperty.soldby then
		table.insert(elements, {label = 'Propriétaire : ' .. tostring(OwnedProperty.ownerFirstname) .. ' ' .. tostring(OwnedProperty.ownerLastname), value = 'nothing'})
		if not HasPermissionOnOwnedProperty(Property, OwnedProperty) then
			if OwnedProperty.rented then
				table.insert(elements, {label = 'Utiliser des clés agent immobilier', value = 'agent_enter'})
			else
				table.insert(elements, {label = 'Aucune clé pour cette propriété', value = 'agent_enter'})
			end
		end
		table.insert(elements, {label = 'Expulser le propriétaire', value = 'revoke'})
		if OwnedProperty.society then
			table.insert(elements, {label = 'Retirer la liaison société', value = 'unlink_society'})
		else
			table.insert(elements, {label = 'Lier à une société', value = 'link_society'})
		end
		-- TODO MODIFY
	end

	if ESX.PlayerData.job.name == 'police' then
		table.insert(elements, {label = 'Perquisitionner AVEC MANDAT', value = 'police_enter'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'gateway_owned_properties_actions', {
		title = 'Propriété',
		description = 'Propriété n°' .. OwnedProperty.id,
		elements = elements
	}, function(data2, menu2)
		menu2.close()

		if data2.current.value == 'enter' then
			if HasPermissionOnOwnedProperty(Property, OwnedProperty) then
				EnterProperty(CurrentProperty, OwnedProperty)
			else
				ESX.ShowNotification('Vous n\'avez pas les clés de cet propriété.')
			end
			ESX.UI.Menu.CloseAll()
		elseif data2.current.value == 'police_enter' then
			if ESX.PlayerData.job.name == 'police' --[[and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'lieutenant']] then
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('~o~La perquisition d\'une propriété est une action grave. Soyez sûr d\'avoir UN MANDAT VALIDE')
				--TriggerServerEvent('esx:perquis', OwnedProperty.id, OwnedProperty.owner)
				EnterToPerquis(CurrentProperty, OwnedProperty)
			else
				ESX.ShowNotification('~r~Votre grade ne vous permet pas de perquisitionner (Lieutenant ou plus)')
			end
		elseif data2.current.value == 'agent_enter' then
			if ESX.PlayerData.job.name == OwnedProperty.soldby and ESX.PlayerData.job.grade_name == 'boss' then
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('~o~Vous utilisez une clé d\'agent immobilier sur cette propriété loué')
				EnterProperty(CurrentProperty, OwnedProperty)
			else
				ESX.ShowNotification('~r~Votre grade ne vous permet pas de rentrer')
			end
		elseif data2.current.value == 'revoke' then
			TriggerServerEvent('fl_property:removeOwnedPropertyId', OwnedProperty.id)
			ESX.ShowNotification('~r~Propriétaire expulsé')
			ESX.UI.Menu.CloseAll()
			Citizen.Wait(500)
			OpenGatewayOwnedPropertiesMenu()
		elseif data2.current.value == 'wantToEnter' then
			TriggerServerEvent('fl_property:wantToEnter', CurrentProperty, OwnedProperty, GetPlayerServerId(OwnedProperty.owner))


			ESX.ShowNotification('~g~Vous toquez à la porte...')
			ESX.UI.Menu.CloseAll()
			hasAlreadyEnteredMarker = false
		elseif data2.current.value == 'link_society' then
			ESX.ShowNotification('~r~Réserver aux propriétaires pour le moment... Allez dans la propriété !') -- TODO MODIFY
		elseif data2.current.value == 'unlink_society' then
			--TriggerServerEvent('fl_property:resetPropertyAsSociety', OwnedProperty.id, OwnedProperty.owner)
			ESX.ShowNotification('~r~Liaison société supprimée')
			ESX.UI.Menu.CloseAll()
		elseif data2.current.value == 'nothing' then
		else
			error('Unknown button for gateway_owned_properties_actions')
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end

RegisterCommand('TestDebug', function()
	TriggerServerEvent('fl_property:deleteLastProperty')
end)

IsInInviteMenu = false
function OpenInviteMenu()
	local entering = nil
	IsInInviteMenu = true
	if CurrentProperty.isSingle then
		entering = CurrentProperty.entering
	else
		entering = GetGateway(CurrentProperty).entering
	end

	if not entering then return end

	local playersInArea = ESX.Game.GetPlayersInArea(entering, 10.0)
	local elements      = {}

	for i=1, #playersInArea, 1 do
		if playersInArea[i] ~= PlayerId() then
			table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
		end
	end

	if #elements == 0 then
		table.insert(elements, {label = 'Aucun joueur à inviter', value = 'nope'})		
	end


	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'room_invite', {
		title = _U('invite'),
		description = CurrentProperty.label,
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'nope' then return end
		TriggerServerEvent('fl_property:InviteInYourInstance', GetPlayerServerId(data.current.value), CurrentOwnedProperty)
		
		ESX.ShowNotification(_U('you_invited', GetPlayerName(data.current.value)))
		menu.removeElement({ value = data.current.value })
	end, function(data, menu)
		menu.close()
		Wait(500)
		IsInInviteMenu = false
	end)
end


function OpenGiveOtherKeysMenu()
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer == -1 or closestPlayerDistance > 3.0 then
	    ESX.ShowNotification('~r~Aucun joueur près de vous.')
	else
		ESX.TriggerServerCallback('esx:getOtherPlayerData', function(xPlayer)
			hasAlreadyEnteredMarker = false
			for _,AnyOtherKey in pairs(CurrentOwnedProperty.otherKeys) do
				if AnyOtherKey.discord == xPlayer.discord then
					ESX.ShowNotification('~r~' .. xPlayer.name .. ' a déjà un double des clés')
					return
				end
			end

			table.insert(CurrentOwnedProperty.otherKeys, {
				discord = xPlayer.discord,
				name = xPlayer.name,
			})
			TriggerServerEvent('fl_property:updateOtherKeys', CurrentOwnedProperty.id, CurrentOwnedProperty.otherKeys)
			ESX.ShowNotification('~g~Vous donnez un double des clés à ' .. xPlayer.name)
		end, GetPlayerServerId(closestPlayer))
	end
end

function OpenListOtherKeysMenu()
	listOfKeysOnProperty = {}
	if not CurrentOwnedProperty.otherKeys then
		ESX.ShowNotification('~r~Vous n\'avez attribué aucune clé pour le moment...')
		return
	end

	for i,AnyOtherKey in pairs(CurrentOwnedProperty.otherKeys) do
		table.insert(listOfKeysOnProperty, {
			label = AnyOtherKey.name,
			value = i
		})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'list_other_keys', {
		title = 'Liste Clé',
		description = CurrentProperty.label,
		elements = listKeysElements
	}, function(dataList, menuList)
		CurrentOwnedProperty.otherKeys[dataList.current.value] = nil
		ESX.ShowNotification('~g~Suppression de la clé...')
		TriggerServerEvent('fl_property:updateOtherKeys', CurrentOwnedProperty.id, CurrentOwnedProperty.otherKeys)
		menuList.close()
		Citizen.Wait(500)
		hasAlreadyEnteredMarker = false
	end, function(dataList, menuList)
		menuList.close()
	end)
end


function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end





local MenuRoomOpen = false


RMenu.Add("fl_gestionpropri", "fl_gestionpropri_main", RageUI.CreateMenu("Menu Propriété","Gestion de la propriété"))
RMenu:Get("fl_gestionpropri", "fl_gestionpropri_main"):SetStyleSize(0)
RMenu:Get("fl_gestionpropri", "fl_gestionpropri_main").Closed = function()
	MenuRoomOpen = false
	FreezeEntityPosition(PlayerPedId(), false)
end


RMenu.Add('fl_gestionstock', 'fl_gestionstock_main', RageUI.CreateSubMenu(RMenu:Get("fl_gestionpropri", "fl_gestionpropri_main"), "Coffre de la propriété","Gestion du stock"))
RMenu:Get("fl_gestionstock", "fl_gestionstock_main"):SetStyleSize(0)
RMenu:Get('fl_gestionstock', 'fl_gestionstock_main').Closed = function()
end

RMenu.Add('fl_takeobj', 'fl_takeobj_main', RageUI.CreateSubMenu(RMenu:Get("fl_gestionstock", "fl_gestionstock_main"), "Prendre un objet","Servez-vous !"))
RMenu:Get("fl_takeobj", "fl_takeobj_main"):SetStyleSize(0)
RMenu:Get('fl_takeobj', 'fl_takeobj_main').Closed = function()
end

RMenu.Add('fl_depobj', 'fl_depobj_main', RageUI.CreateSubMenu(RMenu:Get("fl_gestionstock", "fl_gestionstock_main"), "Déposer un objet","Déposez un objet."))
RMenu:Get("fl_depobj", "fl_depobj_main"):SetStyleSize(0)
RMenu:Get('fl_depobj', 'fl_depobj_main').Closed = function()
end

RMenu.Add('fl_keymanage', 'fl_keymanage_main', RageUI.CreateSubMenu(RMenu:Get("fl_gestionpropri", "fl_gestionpropri_main"), "Gestion des clés","Gérez vos clés"))
RMenu:Get("fl_keymanage", "fl_keymanage_main"):SetStyleSize(0)
RMenu:Get('fl_keymanage', 'fl_keymanage_main').Closed = function()
end

RMenu.Add('fl_listkey', 'fl_listkey_main', RageUI.CreateSubMenu(RMenu:Get('fl_keymanage', 'fl_keymanage_main'), "Liste des clés","Voici la liste des clés."))
RMenu:Get("fl_listkey", "fl_listkey_main"):SetStyleSize(0)
RMenu:Get('fl_listkey', 'fl_listkey_main').Closed = function()
end


function OpenRoomMenu()
	if not MenuRoomOpen then 
        MenuRoomOpen = true
		RageUI.Visible(RMenu:Get('fl_gestionpropri', 'fl_gestionpropri_main'), true)

		local job = ESX.PlayerData.job.name
		local jobgrade = ESX.PlayerData.job.grade_name 
		local fps = CurrentOwnedProperty
		local fps2 = CurrentOwnedProperty.society
		local fps3 = HasPermissionOnThisOwnedProperty

		Citizen.CreateThread(function()
			while MenuRoomOpen do
				FreezeEntityPosition(PlayerPedId(), true)
				RageUI.IsVisible(RMenu:Get("fl_gestionpropri",'fl_gestionpropri_main'),true,true,true,function()
					RageUI.Separator('↓ ~y~Gestion de la propriété ~s~↓')
					

					if fps then
						if fps3 and jobgrade == 'boss' and fps2 then
							RageUI.ButtonWithStyle("Gestion de la société", 'Gérer sa société.', { RightLabel = "→" }, true, function(_,_,s)
								if s then
									TriggerEvent('fl_society:openBossMenu', CurrentOwnedProperty.society, function(data, menu)
										menu.close()
									end)
									RageUI.CloseAll()
									MenuRoomOpen = false
									FreezeEntityPosition(PlayerPedId(), false)
								end
							end)
						end

						-- @TODO --> Fix le soucis d'invitation (ne détecte aucun joueurs..)

						--[[RageUI.ButtonWithStyle("Inviter un joueur", 'Inviter une personne.', { RightLabel = "→" }, true, function(_,_,s)
							if s then
								OpenInviteMenu()
								RageUI.CloseAll()
								MenuRoomOpen = false
								FreezeEntityPosition(PlayerPedId(), false)
							end
						end)]] 

						RageUI.ButtonWithStyle("Accéder au coffre", 'Accédez au coffre.', { RightLabel = "→" }, true, function(_,_,s)
							if s then 
								RefreshInvRoom()
								RefreshInvPlayerInv()
							end
						end, RMenu:Get("fl_gestionstock", "fl_gestionstock_main"))

						
						if CurrentOwnedProperty.owner == ESX.PlayerData.discord then

							RageUI.ButtonWithStyle("Gestion des clés", 'Attribuer des clés.', { RightLabel = "→" }, true, function(_,_,s)
							end, RMenu:Get("fl_keymanage", "fl_keymanage_main"))

						end
					end

					
					if fps3 then
						if fps then
							if fps2 then
								RageUI.ButtonWithStyle("Retirer la liaison", 'Supprimer sa société de la propriété !', { RightLabel = "→" }, true, function(_,_,s)
									if s then
										RageUI.CloseAll()
										MenuRoomOpen = false
										TriggerServerEvent('fl_property:resetPropertyAsSociety', CurrentOwnedProperty.id, CurrentOwnedProperty.owner)
										FreezeEntityPosition(PlayerPedId(), false)
									end
								end)
							elseif job ~= 'unemployed' then
								RageUI.ButtonWithStyle("Lier", 'Lier sa société à la propriété !', { RightLabel = "→" }, true, function(_,_,s)
									if s then
										RageUI.CloseAll()
										MenuRoomOpen = false
										FreezeEntityPosition(PlayerPedId(), false)
										LinkWithMySociety()
									end
								end)
							end
						end
					end

				end, function()    
                end, 1)


				RageUI.IsVisible(RMenu:Get("fl_gestionstock",'fl_gestionstock_main'),true,true,true,function()

					RageUI.ButtonWithStyle("Prendre un objet", 'Prendre un objet dans le coffre.', { RightLabel = "→" }, true, function(_,_,s)
					end, RMenu:Get("fl_takeobj", "fl_takeobj_main"))


					RageUI.ButtonWithStyle("Déposer un objet", 'Déposer un objet dans le coffre.', { RightLabel = "→" }, true, function(_,_,s)
					end, RMenu:Get("fl_depobj", "fl_depobj_main"))

				end, function()    
				end, 1)
					
				RageUI.IsVisible(RMenu:Get("fl_takeobj",'fl_takeobj_main'),true,true,true,function()
					RageUI.Separator('~o~Poids~s~ : '..poidsDansLeCoffre..' / '..CurrentOwnedProperty.property.poids..' KG')
					if #elementsInRoomInv < 1 then
						RageUI.Separator('')
						RageUI.Separator('~r~Pas d\'items trouvés.')
						RageUI.Separator('')
					else
						for i = 1, #elementsInRoomInv, 1 do
							RageUI.ButtonWithStyle(""..elementsInRoomInv[i].label, nil, { RightLabel = ""..elementsInRoomInv[i].rightLabelColor.. ""..elementsInRoomInv[i].rightLabel }, true, function(_,_,s)
								if s then
									local amountToTake = tonumber(KeyboardInput('Quantité', 'Nombre d\'objets que tu veux', '', 8))
									TriggerServerEvent('fl_property:getItem', CurrentOwnedProperty.id, elementsInRoomInv[i].itemType, elementsInRoomInv[i].value, amountToTake)

									RageUI.Visible(RMenu:Get('fl_gestionpropri', 'fl_gestionpropri_main'), true)
								end
							end)
						end
					end

				end, function()    
				end, 1)

				RageUI.IsVisible(RMenu:Get("fl_depobj",'fl_depobj_main'),true,true,true,function()

					RageUI.Separator('~o~Poids~s~ : '..poidsDansLeCoffre..' / '..CurrentOwnedProperty.property.poids..' KG')
					
					if #elementsInPlayerInv < 1 then
						RageUI.Separator('')
						RageUI.Separator('~r~Pas d\'items trouvés.')
						RageUI.Separator('')
					else
						for i = 1, #elementsInPlayerInv, 1 do
							RageUI.ButtonWithStyle(""..elementsInPlayerInv[i].label, nil, { RightLabel = ""..elementsInPlayerInv[i].rightLabelColor.. ""..elementsInPlayerInv[i].rightLabel }, true, function(_,_,s)
								if s then
									local amountToDepos = tonumber(KeyboardInput('Quantité', 'Nombre d\'objets que tu veux déposer', '', 8))
									TriggerServerEvent('fl_property:putItem', CurrentOwnedProperty.id, elementsInPlayerInv[i].itemType, elementsInPlayerInv[i].value, amountToDepos, CurrentOwnedProperty.property.poids)
																		
									RageUI.Visible(RMenu:Get('fl_gestionpropri', 'fl_gestionpropri_main'), true)
								end
							end)
						end
					end

				end, function()    
				end, 1)
					
	
				RageUI.IsVisible(RMenu:Get("fl_keymanage", "fl_keymanage_main"),true,true,true,function()

					RageUI.ButtonWithStyle("Liste des clés", 'Accédez à la liste des clés.', { RightLabel = "→" }, true, function(_,_,s)
						if s then
							OpenListOtherKeysMenu()
						end
					end, RMenu:Get("fl_listkey", "fl_listkey_main"))


					RageUI.ButtonWithStyle("Donner un double de clé", 'Ayez ~r~confiance~s~ en la personne.', { RightLabel = "→" }, true, function(_,_,s)
						if s then
							OpenGiveOtherKeysMenu()
						end
					end)

				end, function()    
				end, 1)

				RageUI.IsVisible(RMenu:Get("fl_listkey", "fl_listkey_main"),true,true,true,function()
					
					if not CurrentOwnedProperty.otherKeys then
						ESX.ShowNotification('~r~Vous n\'avez attribué aucune clé pour le moment...')
						return
					end

					local listKeysElements = {}

					for i,AnyOtherKey in pairs(CurrentOwnedProperty.otherKeys) do
						table.insert(listKeysElements, {
							label = AnyOtherKey.name,
							value = i
						})
					end

					if listOfKeysOnProperty ~= nil and #listOfKeysOnProperty < 1 then
						RageUI.Separator('')
						RageUI.Separator('~r~Aucune clé attribuée.')
						RageUI.Separator('')
					else
						for i = 1, #listOfKeysOnProperty, 1 do
							RageUI.ButtonWithStyle(""..listKeysElements[i].label, 'Supprimez ce double de clé.', { RightLabel = "→" }, true, function(_,_,s)
								if s then
									CurrentOwnedProperty.otherKeys[i].value = nil
									ESX.ShowNotification('~g~Suppression de la clé...')
									TriggerServerEvent('fl_property:updateOtherKeys', CurrentOwnedProperty.id, CurrentOwnedProperty.otherKeys)
									Wait(250)
									hasAlreadyEnteredMarker = false
								end
							end)
						end
					end

				end, function()    
				end, 1)
						
				Wait(1)
			end
			Wait(0)
			MenuRoomOpen = false
		end)
	end
end





function RefreshInvRoom()
	elementsInRoomInv = {}
	ESX.TriggerServerCallback('fl_property:getPropertyInventory', function(inventory)

		if inventory.money > 0 then
			table.insert(elementsInRoomInv, {
				label = _U('money'),
				rightLabel = '$' .. ESX.Math.GroupDigits(inventory.money),
				rightLabelColor = '~g~',
				itemType = 'money',
				value = 'money'
			})
		end

		if inventory.blackMoney > 0 then
			table.insert(elementsInRoomInv, {
				label = _U('dirty_money'),
				rightLabel = '$' .. ESX.Math.GroupDigits(inventory.blackMoney),
				rightLabelColor = '~r~',
				itemType = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elementsInRoomInv, {
					label = item.label,
					rightLabel = 'x' .. item.count,
					rightLabelColor = '',
					itemType = 'item_standard',
					value = item.name
				})
			end
		end	


		if inventory.poids == nil then
			poidsDansLeCoffre = 0
		else
			poidsDansLeCoffre = inventory.poids
		end
	end, CurrentOwnedProperty.id)
end

function RefreshInvPlayerInv()
	elementsInPlayerInv = {}
	poidsDansLeCoffre = nil
	ESX.TriggerServerCallback('fl_property:getPlayerInventory', function(inventory)

		if inventory.money > 0 then
			table.insert(elementsInPlayerInv, {
				label = _U('money'),
				itemType = 'money',
				rightLabel = '$' .. ESX.Math.GroupDigits(inventory.money),
				rightLabelColor = '~g~',
				value = 'money'
			})
		end

		if inventory.blackMoney > 0 then
			table.insert(elementsInPlayerInv, {
				label = _U('dirty_money'),
				rightLabel = '$' .. ESX.Math.GroupDigits(inventory.blackMoney),
				rightLabelColor = '~r~',
				itemType = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elementsInPlayerInv, {
					label = item.label,
					rightLabel = 'x' .. item.count,
					rightLabelColor = '',
					itemType = 'item_standard',
					value = item.name
				})
			end
		end
	end)
end



