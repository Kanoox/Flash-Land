AddEventHandler('esx:onPlayerSpawn', function()
	if firstSpawn then
		Citizen.CreateThread(function()
			while not ESX.IsPlayerLoaded() do
				Citizen.Wait(0)
			end

			ESX.TriggerServerCallback('fl_property:getLastProperty', function(CurrentPropId)
				if CurrentPropId ~= nil then


					EnterProperty(CurrentPropId.CurrentProp, CurrentPropId.OwnedProp)


					IsInProperty = true

					CurrentProperty = CurrentPropId.CurrentProp
					CurrentOwnedProperty = CurrentPropId.OwnedProp
				

					HasPermissionOnThisOwnedProperty = HasPermissionOnOwnedProperty(CurrentProperty, CurrentOwnedProperty)
				
					if CurrentOwnedProperty and (CurrentProperty.openHouseRadius <= 0 or CurrentProperty.open_house_radius <= 0) then
						TriggerServerEvent('fl_property:saveLastProperty', CurrentOwnedProperty.id)
					end
				
					TriggerServerEvent('fl_property:EnterInInstance', CurrentPropId.OwnedProp)
						
				end
			end)
		end)

		firstSpawn = false
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	repeat Citizen.Wait(0) until ESX
	ESX.TriggerServerCallback('fl_property:getProperties', function(properties)
		Config.Properties = properties
		CreateBigMapBlips()
	end)
	ESX.TriggerServerCallback('fl_property:getOwnedProperties', function(OwnedPropertiesData)
		AllOwnedProperties = OwnedPropertiesData
		UpdateSocietyLabels()
		CreateBigMapBlips()
	end)
end)


RegisterNetEvent('fl_realestateagentjob:actionMenuFor')
AddEventHandler('fl_realestateagentjob:actionMenuFor', function(action, propertyName)
	if action ~= 'rent' and action ~= 'sell' and action ~= 'sellBank' then
		ESX.ShowNotification('~r~Action inconnu, rapporter ce bug...')
		return
	end

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'action_property_amount', {
		title = _U('amount')
	}, function(data, menu)
		local amount = tonumber(data.value)

		if amount == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification(_U('no_play_near'))
				menu.close()
			else
				TriggerServerEvent('fl_realestateagentjob:'..action, GetPlayerServerId(closestPlayer), propertyName, amount)
				menu.close()
			end

			OpenGatewayAvailablePropertiesMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end)


RegisterNetEvent('esx:changedPlayerData')
AddEventHandler('esx:changedPlayerData', function()
	if CurrentProperty then
		HasPermissionOnThisOwnedProperty = HasPermissionOnOwnedProperty(CurrentProperty, CurrentOwnedProperty)
	end
	CreateBigMapBlips()
end)

-- only used when script is restarting mid-session
RegisterNetEvent('fl_property:sendProperties')
AddEventHandler('fl_property:sendProperties', function(properties)
	print('fl_property:sendProperties received mid-session')
	Config.Properties = properties
	repeat
		Citizen.Wait(0)
	until ESX

	ESX.TriggerServerCallback('fl_property:getOwnedProperties', function(OwnedPropertiesData)
		AllOwnedProperties = OwnedPropertiesData
		UpdateSocietyLabels()
		CreateBigMapBlips()
	end)

	ESX.TriggerServerCallback('fl_property:getLastProperty', function(CurrentPropId)
		if CurrentPropId ~= nil then

			TriggerServerEvent('fl_property:BeUnstuck')


			IsInProperty = true

			CurrentProperty = CurrentPropId.CurrentProp
			CurrentOwnedProperty = CurrentPropId.OwnedProp
		

			HasPermissionOnThisOwnedProperty = HasPermissionOnOwnedProperty(CurrentProperty, CurrentOwnedProperty)
		
			if CurrentOwnedProperty and (CurrentProperty.openHouseRadius <= 0 or CurrentProperty.open_house_radius <= 0) then
				TriggerServerEvent('fl_property:saveLastProperty', CurrentOwnedProperty.id)
			end
		
			TriggerServerEvent('fl_property:EnterInInstance', CurrentPropId.OwnedProp)	
		end
	end)
end)



RegisterNetEvent('fl_property:ownedPropertyChanged')
AddEventHandler('fl_property:ownedPropertyChanged', function(OwnedProperties)
	repeat
		Citizen.Wait(0)
	until ESX
	AllOwnedProperties = OwnedProperties
	UpdateSocietyLabels()

	for _,OwnedProperty in pairs(AllOwnedProperties) do
		if CurrentOwnedProperty and OwnedProperty.id == CurrentOwnedProperty.id then
			local TmpCurrentOwnedProperty = CurrentOwnedProperty
			local TmpHasPermissionOnThisOwnedProperty = HasPermissionOnThisOwnedProperty
			CurrentOwnedProperty = OwnedProperty

			if CurrentOwnedProperty.society and not TmpCurrentOwnedProperty.society then
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('~g~La société est maintenant liée')

				ESX.TriggerServerCallback('fl_society:getSocietyLabel', function(societyLabel)
					CurrentOwnedProperty.societyLabel = societyLabel
				end, CurrentOwnedProperty.society)
			elseif not CurrentOwnedProperty.society and TmpCurrentOwnedProperty.society then
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('~r~La société n\'est plus liée')
				CurrentOwnedProperty.societyLabel = nil
			end
			HasPermissionOnThisOwnedProperty = HasPermissionOnOwnedProperty(CurrentProperty, CurrentOwnedProperty)

			if not TmpHasPermissionOnThisOwnedProperty and HasPermissionOnThisOwnedProperty then
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('~g~Vous avez obtenu des droits sur cette propriété')
			elseif TmpHasPermissionOnThisOwnedProperty and not HasPermissionOnThisOwnedProperty then
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('~r~Vous avez perdu vos droits sur cette propriété')
			end
			UpdateSocietyDisplay()
		end
	end
	CreateBigMapBlips()
end)

AddEventHandler('fl_property:getProperties', function(cb)
	cb(GetProperties())
end)

AddEventHandler('fl_property:getProperty', function(name, cb)
	cb(GetProperty(name))
end)

AddEventHandler('fl_property:getGateway', function(property, cb)
	cb(GetGateway(property))
end)

AddEventHandler('fl_property:hasEnteredMarker', function(name, part)
	if part == 'entering' then
		CurrentProperty = GetProperty(name)
		CurrentAction = 'property_menu'
		CurrentActionMsg = _U('press_to_menu')
	elseif part == 'garage' then
		CurrentProperty = GetProperty(name)
		CurrentAction = 'garage_enter'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour entrer dans votre garage'
	elseif part == 'exit' then
		CurrentAction = 'room_exit'
		CurrentActionMsg = _U('press_to_exit')
	elseif part == 'roomMenu' then
		CurrentAction = 'room_menu'
		CurrentActionMsg = _U('press_to_menu')
	elseif part == 'clothingMenu' then
		CurrentAction = 'clothing_menu'
		CurrentActionMsg = _U('press_to_menu')
	elseif part == 'boat' then
		CurrentProperty = GetProperty(name)
		CurrentAction = 'boat_menu'
		CurrentActionMsg = _U('press_to_menu')
	else
		print('Unknown part hasEnteredMarker : ' .. tostring(part))
	end
end)

AddEventHandler('fl_property:hasExitedMarker', function(name, part)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	if part == 'entering' and not IsInProperty then
		CurrentProperty = nil
	end
end)

RegisterNetEvent('instance:onMultipleWantToEnterPress')
AddEventHandler('instance:onMultipleWantToEnterPress', function()
	OpenInviteMenu()
end)

AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'property', function(instance)
		InPolicePerquis = instance.data.police
		EnterProperty(instance.data.property, instance.data.owned)
	end, function(instance)
		InPolicePerquis = false
		ExitProperty(instance.data.property)
	end)
end)
TriggerEvent('instance:isLoaded')

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	
	if not instance then error('instance:onCreate return nil instance') end
	if instance.type == 'property' then
		TriggerEvent('instance:enter', instance)
	end
end)

RegisterNetEvent('esx:print')
AddEventHandler('esx:print', function(msg)
	print(tostring(msg))
end)




RegisterNetEvent('fl_property:AcceptWantToEnter')
AddEventHandler('fl_property:AcceptWantToEnter', function(propCara, prop, plyWhichWant)
	local wantto = plyWhichWant
	local property = prop
	local owned = propCara


	WaitForAccept = true
	Citizen.CreateThread(function()
		while WaitForAccept do
			Citizen.Wait(0)

			ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour accueillir la personne qui sonne.')

			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('fl_property:EnterInPropAfterWanted', propCara, property, wantto)
				
				ESX.ShowNotification("La personne est ~g~entrée~s~ dans votre propriété.")
				WaitForAccept = nil
			end
		end
	end)
	
	Citizen.CreateThread(function()
		-- Controls for invite
		Citizen.Wait(10000)

		if WaitForAccept then
			ESX.ShowNotification('La sonnette s\'est ~r~arrêtée.')
			WaitForAccept = nil
		end
	end)

end)

local IsEntering = nil
RegisterNetEvent('fl_property:GoInHouseWhichWant')
AddEventHandler('fl_property:GoInHouseWhichWant', function(propCara, property)
	local propiii = propCara
	local prop = property

	IsEntering = true
	EnterProperty(propiii, prop)
	TriggerServerEvent('fl_property:EnterInInstance', prop)
	while IsEntering do
		Citizen.Wait(0)

		Citizen.CreateThread(function()
			LoadIplOfProperty()
			if propiii.inside then
				ESX.Game.Teleport(PlayerPedId(), propiii.inside)
			end

			DrawSub(propiii.label, 5000)
			FreezeEntityPosition(PlayerPedId(), false)
		end)

		ESX.ShowNotification("Vous êtes ~g~entré(e)~s~ dans la propriété.")
		IsEntering = nil
	end
end)

