AllOwnedProperties = {}
Blips = {}
CurrentPropertyBlips = {}

CurrentProperty = nil
CurrentOwnedProperty = nil
LastMarkerProperty = nil
LastMarkerPart = nil
CurrentAction = nil
CurrentActionMsg = nil
InteriorIplObject = nil

IsInProperty = false
IsInGarage = false
firstSpawn = true
hasAlreadyEnteredMarker = false
InPolicePerquis = false


-- Invite OneSync Bigmode
local inviteMode = false
local entering = nil
local beforeInviteModeCoords = nil

-- Methods

function UpdateSocietyLabels()
	for _,OwnedProperty in pairs(AllOwnedProperties) do
		if OwnedProperty.society then
			OwnedProperty.societyLabel = '?ERROR?'
			ESX.TriggerServerCallback('fl_society:getSocietyLabel', function(societyLabel)
				OwnedProperty.societyLabel = societyLabel
			end, OwnedProperty.society)
		end
	end
end

function DrawSub(text, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(time, 1)
end

function DeleteBigMapBlips()
	for _,Property in pairs(Config.Properties) do
		RemoveBlip(Blips[Property.name])
		Blips[Property.name] = nil
	end
end

function CreateBigMapBlips()
	if CurrentOwnedProperty then return end

	DeleteBigMapBlips()

	for _,Property in pairs(Config.Properties) do
		if Property.entering ~= nil and (Property.isSingle or Property.isGateway) then
			local Sprite = 0
			local Colour = 0
			local Scale = 0.7

			if Property.isGateway then
				Sprite = 476
			else
				if ESX.PlayerData.job.name == Property.soldby then
					Sprite = 350
					Scale = 0.5
				else
					Sprite = -1
				end
			end

			local OwnedProperties = GetOwnedPropertiesOfType(Property)
			local IsOwnedByAnyone = false
			IsOwner = false
			local ContainsSocieties = false
			for _,OwnedProperty in pairs(OwnedProperties) do
				IsOwnedByAnyone = true
				if HasPermissionOnOwnedProperty(Property, OwnedProperty) then
					IsOwner = true
				end

				if OwnedProperty.society == ESX.PlayerData.job.name then
					ContainsSocieties = true
					IsOwner = true
				end
			end

			if IsOwner then
				if Property.isGateway then
					Sprite = 475
				else
					Sprite = 357
				end

				if Property.interiorId == -60 then
					Sprite = 473
				end

				if Property.interiorId == -100 then
					Sprite = 557
				end
			end

			if Property.openHouseRadius > 0 then
				if IsOwnedByAnyone then
					Sprite = 40

					if not IsOwner then
						Colour = 39
					end
				else
					Sprite = 350
				end
			end

			-- Special for Yatch
			if Property.interiorId == -50 then
				Sprite = 455
				if not IsOwnedByAnyone then
					Colour = 39
				end
			end

			-- Special Warehouse
			if Property.interiorId == -60 then
				if IsOwner then
					Sprite = 473
				else
					if ESX.PlayerData.job.name == Property.soldby then
						Sprite = 474
						Scale = 0.3
					else
						Sprite = -1
					end
				end

				if Property.openHouseRadius > 0 and IsOwnedByAnyone then
					Sprite = 473
				end
			end

			if ContainsSocieties then
				Colour = 3
			end

			if IsOwner or Property.openHouseRadius > 0 then
				Scale = 0.7
			end

			if Sprite > 0 then
				Blips[Property.name] = AddBlipForCoord(Property.entering.x, Property.entering.y, Property.entering.z)

				SetBlipSprite(Blips[Property.name], Sprite)
				SetBlipColour(Blips[Property.name], Colour)
				SetBlipDisplay(Blips[Property.name], 4)
				SetBlipScale(Blips[Property.name], Scale)
				SetBlipAsShortRange(Blips[Property.name], true)
				SetBlipCategory(Blips[Property.name], 10)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(Property.label)
				EndTextCommandSetBlipName(Blips[Property.name])
			end
		end
	end

end

function GetProperties()
	return Config.Properties
end

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end

	error('Didnt find Property for name : ' .. name)
end

function GetGateway(Property)
	if Property.isGateway then
		error('This is already a gateway...')
	end

	for _,Gateway in pairs(Config.Properties) do
		if Gateway.isGateway and Gateway.name == Property.gateway then
			return Gateway
		end
	end

	error('Didnt find Gateway for Property : ' .. tostring(Property.name))
end

function GetLinkedProperties(Property)
	if not Property.isGateway then -- If not a gateway, return self property
		return {Property}
	end

	local LinkedProperties = {}

	for _,AnyProperty in pairs(Config.Properties) do
		if AnyProperty.gateway == Property.name then
			table.insert(LinkedProperties, AnyProperty)
		end
	end

	if LinkedProperties == {} then
		error('Didn\'t find any Property linked to this Gateway')
	end

	return LinkedProperties
end



function EnterProperty(property, owned)
	--if not property then error('Illegal args : EnterProperty(' .. tostring(property) .. '/' .. tostring(owned) .. ')') end
	FreezeEntityPosition(PlayerPedId(), true)
	IsInProperty = true

	CurrentProperty = property
	CurrentOwnedProperty = owned

	print(json.encode(CurrentProperty))
	print(json.encode(CurrentOwnedProperty))
	--print(json.encode(CurrentProperty.exit))

	--print('EnterProperty(' .. tostring(CurrentProperty.name) .. ')')
	if InPolicePerquis then
		ESX.ShowNotification('~r~Vous entrez dans une propriété perquisitionnée !')
	end
	HasPermissionOnThisOwnedProperty = HasPermissionOnOwnedProperty(CurrentProperty, CurrentOwnedProperty)
	--print('HasPermissionOnThisOwnedProperty:'..tostring(HasPermissionOnThisOwnedProperty))

	if CurrentOwnedProperty and (CurrentProperty.openHouseRadius <= 0 or CurrentProperty.open_house_radius <= 0) then
		TriggerServerEvent('fl_property:saveLastProperty', CurrentOwnedProperty.id)
	end

	TriggerServerEvent('fl_property:EnterInInstance', CurrentOwnedProperty)

	Citizen.CreateThread(function()
		LoadIplOfProperty()
		if CurrentProperty.inside then
			ESX.Game.Teleport(PlayerPedId(), CurrentProperty.inside)
		end

		DrawSub(CurrentProperty.label, 5000)
		FreezeEntityPosition(PlayerPedId(), false)
	end)
end

function EnterToPerquis(property, owned)
	if not property then error('Illegal args : EnterProperty(' .. tostring(property) .. '/' .. tostring(owned) .. ')') end
	FreezeEntityPosition(PlayerPedId(), true)
	IsInProperty = true

	CurrentProperty = property
	CurrentOwnedProperty = owned

	
	if InPolicePerquis then
		ESX.ShowNotification('~r~Vous entrez dans une propriété perquisitionnée !')
	end
	HasPermissionOnThisOwnedProperty = true

	if CurrentOwnedProperty and (CurrentProperty.openHouseRadius <= 0 or CurrentProperty.open_house_radius <= 0) then
		TriggerServerEvent('fl_property:saveLastProperty', CurrentOwnedProperty.id)
	end

	TriggerServerEvent('fl_property:EnterInInstance', CurrentOwnedProperty)

	Citizen.CreateThread(function()
		LoadIplOfProperty()
		if CurrentProperty.inside then
			ESX.Game.Teleport(PlayerPedId(), CurrentProperty.inside)
		end

		DrawSub(CurrentProperty.label, 5000)
		FreezeEntityPosition(PlayerPedId(), false)
	end)
end


function VisitProperty(property)
	if not property then error('Illegal args : EnterProperty(' .. tostring(property) .. '/' .. tostring(owned) .. ')') end

	CurrentProperty = property

	local entering = nil
	if CurrentProperty.isSingle then
		entering = CurrentProperty.entering
	else
		entering = GetGateway(CurrentProperty).entering
	end

	local playersInArea = ESX.Game.GetPlayersInArea(entering, 10.0)

	for _,AnyPlayerId in pairs(playersInArea) do
		if AnyPlayerId ~= PlayerId() then
			TriggerServerEvent('fl_property:InviteToVisit', GetPlayerServerId(AnyPlayerId), CurrentProperty)
		end
	end

	IsInProperty = true
	TriggerServerEvent('fl_property:VisitProperty', CurrentProperty)
	Citizen.CreateThread(function()
		LoadIplOfProperty()
		if CurrentProperty.inside then
			ESX.Game.Teleport(PlayerPedId(), CurrentProperty.inside)
		end

		DrawSub(CurrentProperty.label, 5000)
		FreezeEntityPosition(PlayerPedId(), false)
	end)

end

function ExitProperty(property)
	TriggerEvent('fl_property:onExitedProperty')
	local outside = nil
	TriggerServerEvent('fl_property:ExitInInstance', CurrentProperty)
	IsInProperty = false
	--CurrentProperty = nil
	CurrentOwnedProperty = nil

	if property.isSingle then
		outside = property.outside
	else
		outside = GetGateway(property).outside
	end

	TriggerServerEvent('fl_property:deleteLastProperty')

	Citizen.CreateThread(function()
		if outside then
			ESX.Game.Teleport(PlayerPedId(), outside)
			DetachEntity(PlayerPedId(), false, true)

			RemoveIplOfProperty(property)
		end
		CreateBigMapBlips()
	end)
end

function HasPermissionOnOwnedProperty(Property, OwnedProperty)
	if Property == nil and OwnedProperty == nil then error('???') end

	if Property and OwnedProperty == nil then
		return ESX.PlayerData.job.name == Property.soldby
	end

	if OwnedProperty.owner == ESX.GetPlayerData().discord then
		return true
	end

	if OwnedProperty.society == ESX.PlayerData.job.name then
		return true
	end

	if OwnedProperty.otherKeys then
		for _,AnyIdentifier in pairs(OwnedProperty.otherKeys) do
			if ESX.GetPlayerData().discord == AnyIdentifier.discord then
				return true
			end
		end
	end

	if InPolicePerquis then
		return true
	end

	return false
end

function GetOwnedPropertyFromId(OwnedPropertyId)
	for _,OwnedProperty in pairs(AllOwnedProperties) do
		if OwnedProperty.id == OwnedPropertyId then
			return OwnedProperty
		end
	end

	error('Did not find any property from id ' .. tostring(OwnedPropertyId) .. ' ')
end

function GetOwnedPropertiesOfType(TargetProperty)
	local OwnedProperties = {}
	for _,OwnedProperty in pairs(AllOwnedProperties) do
		if OwnedProperty.name == TargetProperty.name or (TargetProperty.isGateway and TargetProperty.name == OwnedProperty.property.gateway) then
			table.insert(OwnedProperties, OwnedProperty)
		end
	end
	return OwnedProperties
end

function CanSocietyBeLinked(SocietyName)
	for _,societyName in pairs(Config.AuthorizedSocieties) do
		if societyName == SocietyName then
			return true
		end
	end
	return false
end

function LinkWithMySociety()
	if not CurrentOwnedProperty then error('No CurrentOwnedProperty for LinkWithMySociety') end

	if ESX.PlayerData.job.name == 'unemployed' then
		ESX.ShowNotification('~r~Vous n\'êtes dans aucune société...')
		return
	end

	for _,OwnedProperty in pairs(AllOwnedProperties) do
		if OwnedProperty.society == ESX.PlayerData.job.name then
			ESX.ShowNotification('~r~Une propriété est déjà lié à votre société !')
			return
		end
	end

	TriggerServerEvent('fl_property:definedPropertyAsSociety', CurrentOwnedProperty.id, ESX.PlayerData.job.name)
end

function UpdateSocietyDisplay()
	FinanceOrganization = exports['bob74_ipl']:GetFinanceOrganizationObject()
	if CurrentProperty and not CurrentOwnedProperty then
    	FinanceOrganization.Name.Set('Propriété Témoin', FinanceOrganization.Name.Style.normal, FinanceOrganization.Name.Colors.black, FinanceOrganization.Name.Fonts.font5)
    	FinanceOrganization.Office.Enable(true)
	elseif CurrentOwnedProperty and CurrentOwnedProperty.society then
    	FinanceOrganization.Name.Set(CurrentOwnedProperty.societyLabel, FinanceOrganization.Name.Style.normal, FinanceOrganization.Name.Colors.black, FinanceOrganization.Name.Fonts.font10)
    	FinanceOrganization.Office.Enable(true)
    else
    	FinanceOrganization.Office.Enable(false)
	end
end

function LoadIplOfProperty()
	UpdateSocietyDisplay()
	if CurrentProperty.interiorId ~= nil and CurrentProperty.interiorId > 0 then
		local InteriorResponse = exports['bob74_ipl']:GetObjectFromInteriorId(CurrentProperty.interiorId)
		if InteriorResponse then
			InteriorIplObject = InteriorResponse.InteriorObject
			local ThemeName = InteriorResponse.InteriorTheme

			if not ThemeName then -- Simple
				if InteriorIplObject.Ipl then
					InteriorIplObject.Ipl.Interior.Remove()
					InteriorIplObject.Ipl.Interior.Load()
					for AnyName,Any in pairs(InteriorIplObject) do
						if type(Any) == 'table' then
							for MethodName,Method in pairs(Any) do
								if MethodName == 'Clear' then
									Method()
								end
							end
						end
					end
				else
					print('No ipl to load...')
				end
				RefreshInterior(InteriorIplObject.interiorId)
			else -- Complex
				InteriorIplObject.Style.Set(InteriorIplObject.Style.Theme[ThemeName], true)
			end
		end

		local timeout = 0
		while not IsInteriorReady(CurrentProperty.interiorId) and timeout <= 200 do
			timeout = timeout + 1
			PinInteriorInMemory(CurrentProperty.interiorId)
			CapInterior(CurrentProperty.interiorId, false)
			DisableInterior(CurrentProperty.interiorId, false)
			SetInteriorActive(CurrentProperty.interiorId, true)
			FreezeEntityPosition(PlayerPedId(), true)
			print('Interior not ready... (' .. CurrentProperty.interiorId .. ')')
			Citizen.Wait(100)
		end
	else
		--print('No interiorId to load for property : ' .. tostring(CurrentProperty) .. ' - ' .. tostring(CurrentProperty.name))
	end
end

function RemoveIplOfProperty(Property)
	if FinanceOrganization then
		FinanceOrganization.Office.Enable(false)
	end

	if Property.interiorId > 0 then
		local InteriorObject, ThemeName = exports['bob74_ipl']:GetObjectFromInteriorId(Property.interiorId)

		if not InteriorObject then
			error('Unable to find InteriorObject from interiorId : ' .. tostring(Property.interiorId))
		end

		if not ThemeName then-- Simple
			if InteriorObject.Ipl then
				InteriorObject.Ipl.Interior.Remove()
			end
			RefreshInterior(InteriorObject.interiorId)
		else -- Complex
			InteriorObject.Style.Clear()
		end
	end
end

-- Blips updater
Citizen.CreateThread(function()
	local wasInProperty = false
	while true do
		local playerCoords = GetEntityCoords(PlayerPedId())
		local interiorId = GetInteriorAtCoords(playerCoords.x, playerCoords.y, playerCoords.z)

		if IsInProperty and interiorId ~= 0 then
			wasInProperty = true

			-- Add gateway
			if CurrentProperty.isSingle then
				RemoveBlip(Blips[CurrentProperty.name])
				Blips[CurrentProperty.name] = nil
			else
				local TmpGateway = GetGateway(CurrentProperty)
				RemoveBlip(Blips[TmpGateway.name])
				Blips[TmpGateway.name] = nil
			end

			for i,CurrentPropertyBlip in pairs(CurrentPropertyBlips) do
				RemoveBlip(CurrentPropertyBlip)
				CurrentPropertyBlips[i] = nil
			end

			if CurrentProperty.roomMenu and math.abs(CurrentProperty.roomMenu.z - playerCoords.z) < Config.MaximumHeightBlip then
				local roomMenuBlip = AddBlipForCoord(CurrentProperty.roomMenu.x, CurrentProperty.roomMenu.y, CurrentProperty.roomMenu.z)

				SetBlipSprite(roomMenuBlip, 478)
				SetBlipDisplay(roomMenuBlip, 10)
				SetBlipScale(roomMenuBlip, 0.7)
				SetBlipAsShortRange(roomMenuBlip, true)
				SetBlipColour(roomMenuBlip, 2)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName('Coffre')
				EndTextCommandSetBlipName(roomMenuBlip)
				table.insert(CurrentPropertyBlips, roomMenuBlip)
			end

			if CurrentProperty.clothingMenu and math.abs(CurrentProperty.clothingMenu.z - playerCoords.z) < Config.MaximumHeightBlip then
				local clothingMenuBlip = AddBlipForCoord(CurrentProperty.clothingMenu.x, CurrentProperty.clothingMenu.y, CurrentProperty.clothingMenu.z)

				SetBlipSprite(clothingMenuBlip, 73)
				SetBlipDisplay(clothingMenuBlip, 10)
				SetBlipScale(clothingMenuBlip, 0.7)
				SetBlipAsShortRange(clothingMenuBlip, true)
				SetBlipColour(clothingMenuBlip, 29)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName('Vêtements')
				EndTextCommandSetBlipName(clothingMenuBlip)
				table.insert(CurrentPropertyBlips, clothingMenuBlip)
			end

			if CurrentProperty.exit and math.abs(CurrentProperty.exit.z - playerCoords.z) < Config.MaximumHeightBlip then
				local exitBlip = AddBlipForCoord(CurrentProperty.exit.x, CurrentProperty.exit.y, CurrentProperty.exit.z)

				SetBlipSprite(exitBlip, 619)
				SetBlipDisplay(exitBlip, 10)
				SetBlipScale(exitBlip, 0.7)
				SetBlipAsShortRange(exitBlip, true)
				SetBlipColour(exitBlip, 3)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName('Ascenseur')
				EndTextCommandSetBlipName(exitBlip)
				table.insert(CurrentPropertyBlips, exitBlip)
			end
		elseif wasInProperty then
			wasInProperty = false
			for i,CurrentPropertyBlip in pairs(CurrentPropertyBlips) do
				RemoveBlip(CurrentPropertyBlip)
				CurrentPropertyBlips[i] = nil
			end
			CreateBigMapBlips()
		elseif IsInProperty then
			if CurrentProperty.exit and #(vector3(CurrentProperty.exit.x, CurrentProperty.exit.y, CurrentProperty.exit.z) - playerCoords) > 50 and not inviteMode then
				Citizen.Wait(5000)

				if #(vector3(CurrentProperty.exit.x, CurrentProperty.exit.y, CurrentProperty.exit.z) - playerCoords) > 50 and not IsInInviteMenu then
					ESX.ShowNotification('~r~VOUS ÊTES TOUJOURS DANS UNE INSTANCE !\n~o~Le F2 en dehors des propriétés n\'est pas supporté ! (/stuck)')
				end
			end
		end
		Citizen.Wait(1000)
	end
end)



-- Enter / Exit marker events & Draw markers
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(1)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true
		local currentMarkerProperty, currentMarkerPart
		--local HasPermissionOnThisOwnedProperty = HasPermissionOnThisOwnedProperty(CurrentProperty, CurrentOwnedProperty)

		if not IsInProperty then
			for i=1, #Config.Properties, 1 do
				local property = Config.Properties[i]

				-- Entering
				if property.entering and property.openHouseRadius <= 0 then
					local distance = #(coords - vector3(property.entering.x, property.entering.y, property.entering.z))

					if distance < Config.DrawDistance then
						DrawMarker(Config.MarkerType, property.entering.x, property.entering.y, property.entering.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.EnterMarkerColor.r, Config.EnterMarkerColor.g, Config.EnterMarkerColor.b, 100, false, true, 2, false, nil, nil, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker = true
						currentMarkerProperty = property.name
						currentMarkerPart = 'entering'
					end
				end
				
				
				if property.garage and property.openHouseRadius <= 0 then
					local distance = #(coords - vector3(property.garage.x, property.garage.y, property.garage.z))

					if distance < Config.DrawDistance then
						DrawMarker(36, property.garage.x, property.garage.y, property.garage.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.7, 0, 180, 100, 125, false, true, 2, false, nil, nil, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker = true
						currentMarkerProperty = property.name
						currentMarkerPart = 'garage'
					end
				end
			
			end

			for _,BoatInfo in pairs(Config.Boats) do
				if #(coords - BoatInfo.Point) < Config.DrawDistance * 3 then
					DrawMarker(35, BoatInfo.Point, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, 1.5, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if #(coords - BoatInfo.Point) < Config.MarkerSize.x then
					isInMarker = true
					currentMarkerProperty = BoatInfo.PropertyName
					currentMarkerPart = 'boat'
				end
			end
		else
			-- Exit
			if CurrentProperty.exit then
				local distance = #(coords - vector3(CurrentProperty.exit.x, CurrentProperty.exit.y, CurrentProperty.exit.z))

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, CurrentProperty.exit.x, CurrentProperty.exit.y, CurrentProperty.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.ExitMarkerColor.r, Config.ExitMarkerColor.g, Config.ExitMarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentMarkerProperty = CurrentProperty.name
					currentMarkerPart = 'exit'
				end
			end

			-- Room menu
			if CurrentProperty.roomMenu and HasPermissionOnThisOwnedProperty then
				local distance = #(coords - vector3(CurrentProperty.roomMenu.x, CurrentProperty.roomMenu.y, CurrentProperty.roomMenu.z))

				if distance < Config.DrawDistance then
					DrawMarker(29, CurrentProperty.roomMenu.x, CurrentProperty.roomMenu.y, CurrentProperty.roomMenu.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, 1.5, Config.RoomMenuMarkerColor.r, Config.RoomMenuMarkerColor.g, Config.RoomMenuMarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentMarkerProperty = CurrentProperty.name
					currentMarkerPart = 'roomMenu'
				end
			end

			-- Clothing menu
			if CurrentProperty.clothingMenu and HasPermissionOnThisOwnedProperty then
				local distance = #(coords - vector3(CurrentProperty.clothingMenu.x, CurrentProperty.clothingMenu.y, CurrentProperty.clothingMenu.z))

				if distance < Config.DrawDistance then
					DrawMarker(20, CurrentProperty.clothingMenu.x, CurrentProperty.clothingMenu.y, CurrentProperty.clothingMenu.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, 1.5, Config.ClothingMenuMarkerColor.r, Config.ClothingMenuMarkerColor.g, Config.ClothingMenuMarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentMarkerProperty = CurrentProperty.name
					currentMarkerPart = 'clothingMenu'
				end
			end
		end


		if isInMarker and not hasAlreadyEnteredMarker or (isInMarker and (LastMarkerProperty ~= currentMarkerProperty or LastMarkerPart ~= currentMarkerPart) ) then
			hasAlreadyEnteredMarker = true
			LastMarkerProperty = currentMarkerProperty
			LastMarkerPart = currentMarkerPart

			TriggerEvent('fl_property:hasEnteredMarker', currentMarkerProperty, currentMarkerPart)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('fl_property:hasExitedMarker', LastMarkerProperty, LastMarkerPart)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)




-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				-- if not CurrentProperty then error('CurrentProperty=nil') end

				if CurrentAction == 'property_menu' then
					OpenGatewayMenu()
				elseif CurrentAction == 'garage_enter' then
					openGarageMenu()
				elseif CurrentAction == 'room_menu' then
					OpenRoomMenu()
				elseif CurrentAction == 'clothing_menu' then
					TriggerEvent('fl_clotheshop:openNonEditableDessing')
				elseif CurrentAction == 'boat_menu' then
					OpenBoatMenu()
				elseif CurrentAction == 'room_exit' then
					ExitProperty(CurrentProperty)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Open Houses
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local PlayerPos = GetEntityCoords(PlayerPedId())
		for _,Property in pairs(Config.Properties) do
			if Property.openHouseRadius > 0 then
				local distance = #(PlayerPos - vector3(Property.entering.x, Property.entering.y, Property.entering.z))
				if distance <= Property.openHouseRadius and CurrentProperty == nil then
					-- Entering
					print('Entering open house : ' .. Property.label)
					local OwnedProperties = GetOwnedPropertiesOfType(Property)
					if #OwnedProperties == 1 then
						EnterProperty(Property, OwnedProperties[1])
					elseif #OwnedProperties > 1 then
						EnterProperty(Property, OwnedProperties[1])
						ESX.ShowNotification('~r~Un problème est survenu car plusieurs propriétaires sont définis pour cette propriété.')
					else
						print('No owned house of this open house.')
						EnterProperty(Property, nil)
					end
				elseif distance > Property.openHouseRadius and CurrentProperty == Property then
					-- Exiting
					print('Exiting open house : ' .. Property.label)
					ExitProperty(CurrentProperty)
				end
			end
		end
	end
end)

-- Invite OneSync Bigmode
Citizen.CreateThread(function()
	while true do
		if inviteMode then
			SetEntityInvincible(PlayerPedId(), true)
			SetEntityCollision(playerPed, false, false)
		else
			Citizen.Wait(2000)
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		InviteMode()
		Citizen.Wait(500)
	end
end)

function InviteMode()
	if CurrentProperty and ESX.UI.Menu.IsOpen('native', GetCurrentResourceName(), 'room_invite') then
		local playerPed = PlayerPedId()

		if not inviteMode then
			inviteMode = true
			SetEntityVisible(playerPed, false, false)
			FreezeEntityPosition(playerPed, true)
			SetTimecycleModifier("scanline_cam_cheap")
			SetTimecycleModifierStrength(2.0)

			beforeInviteModeCoords = GetEntityCoords(playerPed, false)

			if CurrentProperty.isSingle then
				entering = CurrentProperty.entering
			else
				entering = GetGateway(CurrentProperty).entering
			end
		end

		SetEntityInvincible(PlayerPedId(), true)
		SetEntityCoords(playerPed, entering.x, entering.y, entering.z, 0, 0, 0, 0)
		Citizen.Wait(100)
		if not IsControlJustPressed(0, 202) then
			OpenInviteMenu()
		end
	else
		if inviteMode then
			local playerPed = PlayerPedId()

			inviteMode = false
			ClearTimecycleModifier("scanline_cam_cheap")
			SetEntityVisible(playerPed, true, false)
			SetEntityCollision(playerPed, true, true)
			FreezeEntityPosition(playerPed, false)
			SetEntityInvincible(playerPed, false)
			SetEntityCoords(playerPed, beforeInviteModeCoords, 0, 0, 0, 0)
		end

		Citizen.Wait(2000)
	end
end

DebugOpenHouseRadius = false
Citizen.CreateThread(function()
	while true do
		if DebugOpenHouseRadius then
			for _,Property in pairs(Config.Properties) do
				if Property.openHouseRadius > 0 then
					DrawMarker(23, Property.entering.x, Property.entering.y, Property.entering.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
						Property.openHouseRadius*2.0, Property.openHouseRadius*2.0, 1.5,
						255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				end
			end
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)


local instanceInvite = nil
RegisterNetEvent('fl_property:onInvite')
AddEventHandler('fl_property:onInvite', function(Property)
	instanceInvite = true
	IsInProperty = true
	Citizen.CreateThread(function()
		while instanceInvite do
			Citizen.Wait(0)

			ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour entrer dans la propriété.')

			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('fl_property:VisitProperty', Property)
				

				Citizen.CreateThread(function()
					LoadIplOfProperty()
					if CurrentProperty.inside then
						ESX.Game.Teleport(PlayerPedId(), Property.inside)
					end

					DrawSub(CurrentProperty.label, 5000)
					FreezeEntityPosition(PlayerPedId(), false)
				end)
				
				ESX.ShowNotification("Vous êtes ~g~entrer dans la propriété.")
				instanceInvite = nil
			end
		end
	end)
	
	Citizen.CreateThread(function()
		-- Controls for invite
		Citizen.Wait(10000)

		if instanceInvite then
			ESX.ShowNotification('L\'invitation a ~r~expirée.')
			instanceInvite = nil
		end
	end)
		
end)