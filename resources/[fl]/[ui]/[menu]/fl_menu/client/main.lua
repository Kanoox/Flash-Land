local PersonalMenu = {
	ItemSelected = {},
	ItemIndex = {},
	WeaponData = {},
	WalletIndex = {},
	WalletList = {_U('wallet_option_give'), _U('wallet_option_drop')},
	BillData = {},
	ClothesButtons = {'torso', 'pants', 'shoes', 'bag', 'bproof'},
	DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
		Hood = false,
		Trunk = false
	},
	DoorIndex = 1,
	DoorList = {_U('vehicle_door_frontleft'), _U('vehicle_door_frontright'), _U('vehicle_door_backleft'), _U('vehicle_door_backright')},
	GPSIndex = 1,
	GPSList = {},
	HasWeapons = false,
}

playersName = {}

Player = {
	inAnim = false,
	crouched = false,
	pointing = false,
	noclip = false,
	godmode = false,
	ghostmode = false,
	showCoords = false,
	showName = false,
	gamerTags = {},
}

local connectedPlayers = {}

Citizen.CreateThread(function()
	if ESX.PlayerData.group ~= nil and
		(ESX.PlayerData.group == 'mod' or
		ESX.PlayerData.group == 'admin' or
		ESX.PlayerData.group == 'superadmin' or
		ESX.PlayerData.group == 'owner' or
		ESX.PlayerData.group == '_dev') then
		UpdateDisplayReports()
	end

	while actualSkin == nil do
		TriggerEvent('skinchanger:getSkin', function(skin)
			actualSkin = skin
		end)

		Citizen.Wait(10)
	end

	PersonalMenu.WeaponData = ESX.GetWeaponList()

	for i = 1, #PersonalMenu.WeaponData, 1 do
		if PersonalMenu.WeaponData[i].name == 'WEAPON_UNARMED' then
			PersonalMenu.WeaponData[i] = nil
		else
			PersonalMenu.WeaponData[i].hash = GetHashKey(PersonalMenu.WeaponData[i].name)
		end
	end

	for i = 1, #Config.GPS, 1 do
		table.insert(PersonalMenu.GPSList, Config.GPS[i].label)
	end

	ESX.TriggerServerCallback('fl_billing:getBills', function(bills)
		PersonalMenu.BillData = bills
	end)

	RMenu.Add('rageui', 'personal', RageUI.CreateMenu(Config.MenuTitle, _U('mainmenu_subtitle'), 0, 0, 'commonmenu', 'interaction_bgd', 255, 255, 255, 255))
	RMenu.Add('personal', 'inventory', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('inventory_title')))
	RMenu.Add('personal', 'weapons', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), 'Gestion Armes'), function()
		return PersonalMenu.HasWeapons
	end)
	RMenu.Add('personal', 'manageclothes', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), 'Gestion Vêtements'))
	RMenu.Add('personal', 'wallet', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('wallet_title')))
	RMenu.Add('personal', 'billing', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('bills_title')), function()
		return #PersonalMenu.BillData > 0
	end)
	RMenu.Add('manageclothes', 'clothes', RageUI.CreateSubMenu(RMenu.Get('personal', 'manageclothes'), _U('clothes_title')))
	RMenu.Add('personal', 'animation', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('animation_title')))
	RMenu.Add('personal', 'pub', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), "Pub"))
	RMenu.Add('personal', 'divers', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), "Divers"))
	RMenu.Add('personal', 'vehicle', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('vehicle_title')), function()
		if IsPedSittingInAnyVehicle(plyPed) then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed then
				return true
			end
		end

		return false
	end)

	RMenu.Add('personal', 'boss', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('bossmanagement_title')), function()
		return ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss'
	end)

	RMenu.Add('personal', 'admin', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('admin_title')), function()
		return ESX.PlayerData.group ~= nil and (ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'owner' or ESX.PlayerData.group == '_dev')
	end)

	RMenu.Add('admin', 'items', RageUI.CreateSubMenu(RMenu.Get('personal', 'admin'), "Items"))
	RMenu.Add('admin', 'joueurs', RageUI.CreateSubMenu(RMenu.Get('personal', 'admin'), "Joueurs"))

	RMenu.Add('inventory', 'actions', RageUI.CreateSubMenu(RMenu.Get('personal', 'inventory'), _U('inventory_actions_title')))
	RMenu.Get('inventory', 'actions').Closed = function()
		PersonalMenu.ItemSelected = nil
	end

	RMenu.Add('weapons', 'actions', RageUI.CreateSubMenu(RMenu.Get('personal', 'weapons'), _U('inventory_actions_title')))
	RMenu.Get('weapons', 'actions').Closed = function()
		PersonalMenu.ItemSelected = nil
	end

	RMenu.Add('clothes', 'actions', RageUI.CreateSubMenu(RMenu.Get('personal', 'manageclothes'), _U('inventory_actions_title')))
	RMenu.Get('clothes', 'actions').Closed = function()
		PersonalMenu.ItemSelected = nil
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	RageUI.CloseAll()
	ESX.UI.Menu.CloseAll()
end)

-- Weapon Menu --
RegisterNetEvent('fl_menu:Weapon_addAmmoToPedC')
AddEventHandler('fl_menu:Weapon_addAmmoToPedC', function(value, quantity)
	local weaponHash = GetHashKey(value)

	if HasPedGotWeapon(plyPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
		AddAmmoToPed(plyPed, value, quantity)
	end
end)

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.017, 0.977)
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

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(anim, function()
		SetPedMotionBlur(plyPed, false)
		SetPedMovementClipset(plyPed, anim, true)
		RemoveAnimSet(anim)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				Player.pointing = false
				ClearPedTasks(plyPed)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				Player.pointing = false
				ClearPedTasks(plyPed)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function CheckQuantity(number)
	number = tonumber(number)

	if type(number) == 'number' then
		number = ESX.Math.Round(number)

		if number > 0 then
			return true, number
		end
	end

	return false, number
end

function RenderPersonalMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #RMenu['personal'], 1 do
			if type(RMenu['personal'][i].Restriction) == 'function' then
				if RMenu['personal'][i].Restriction() then
					RageUI.Button(RMenu['personal'][i].Menu.Title, nil, {RightLabel = "→→→"}, true, function() end, RMenu['personal'][i].Menu)
				else
					RageUI.Button(RMenu['personal'][i].Menu.Title, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function() end, RMenu['personal'][i].Menu)
				end
			else
				RageUI.Button(RMenu['personal'][i].Menu.Title, nil, {RightLabel = "→→→"}, true, function() end, RMenu['personal'][i].Menu)
			end
		end

		RageUI.List(_U('mainmenu_gps_button'), PersonalMenu.GPSList, PersonalMenu.GPSIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
			if Selected then
				if Config.GPS[Index].coords ~= nil then
					SetNewWaypoint(Config.GPS[Index].coords)
				else
					DeleteWaypoint()
				end

				ESX.ShowNotification(_U('gps', Config.GPS[Index].label))
			end

			PersonalMenu.GPSIndex = Index
		end)
	end)
end

function RenderActionsMenu(type)
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		if PersonalMenu.ItemSelected.usable then
			RageUI.Button(_U('inventory_use_button'), "", {}, true, function(Hovered, Active, Selected)
				if Selected then
					if PersonalMenu.ItemSelected.usable then
						if PersonalMenu.ItemSelected.usableCloseMenu then
							RageUI.CloseAll()
						end
						if PersonalMenu.ItemSelected.name == "radio" then
							RageUI.CloseAll()
						end
						TriggerServerEvent('esx:useItem', PersonalMenu.ItemSelected.name)
					else
						ESX.ShowNotification(_U('not_usable', PersonalMenu.ItemSelected.label))
					end
				end
			end)
		end

		RageUI.Button(_U('inventory_give_button'), "", {}, true, function(Hovered, Active, Selected)
			if Selected then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestDistance ~= -1 and closestDistance <= 3 then
					local closestPed = GetPlayerPed(closestPlayer)

					if PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name] ~= nil and PersonalMenu.ItemSelected.count > 0 then
						TriggerServerEvent('3dme:shareDisplay', '*La personne donne ' .. PersonalMenu.ItemSelected.label .. '*')
						TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', PersonalMenu.ItemSelected.name, PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name])
						RageUI.CloseAll()
					else
						ESX.ShowNotification(_U('amount_invalid'))
					end
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			end
		end)

		RageUI.Button(_U('inventory_drop_button'), "", {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
			if Selected then
				if PersonalMenu.ItemSelected.canRemove then
					if not IsPedSittingInAnyVehicle(plyPed) then
						if PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name] ~= nil then
							if IsEntityVisible(PlayerPedId()) then
								TriggerServerEvent('3dme:shareDisplay', '*La personne jette ' .. PersonalMenu.ItemSelected.label .. '*')
							end
							TriggerServerEvent('esx:removeInventoryItem', 'item_standard', PersonalMenu.ItemSelected.name, PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name])
							RageUI.CloseAll()
						else
							ESX.ShowNotification(_U('amount_invalid'))
						end
					else
						ESX.ShowNotification(_U('in_vehicle_drop', PersonalMenu.ItemSelected.label))
					end
				else
					ESX.ShowNotification(_U('not_droppable', PersonalMenu.ItemSelected.label))
				end
			end
		end)
	end)
end

function RenderInventoryMenu(renderItems, renderWeapons, renderClothes)
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		if renderClothes then
			RageUI.Button('~h~Mettre/Enlever ses vêtements', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
				if Selected then
				end
			end, RMenu.Get('manageclothes', 'clothes'))
		end

		for _,item in pairs(ESX.PlayerData.inventory) do
			local isWeapon = IsWeaponCategory(item.name)
			local isClothe = IsClothesCategory(item.name)
			local render = renderItems and not isWeapon and not isClothe
			render = render or (isWeapon and renderWeapons)
			render = render or (isClothe and renderClothes)

			if item.count > 0 and render then
				local invCount = {}

				for i = 1, item.count do
					table.insert(invCount, i)
				end

				if PersonalMenu.ItemIndex[item.name] then
					if PersonalMenu.ItemIndex[item.name] > item.count then
						PersonalMenu.ItemIndex[item.name] = item.count
					end
				end

				local txt = 'inventory'
				if renderWeapons then
					txt = 'weapons'
				end
				if renderClothes then
					txt = 'clothes'
				end

				RageUI.List(item.label .. ' (' .. tostring(item.weight * item.count) .. 'kg)', invCount, PersonalMenu.ItemIndex[item.name] or item.count, nil, {}, true, function(Hovered, Active, Selected, Index)
					if Selected then
						PersonalMenu.ItemSelected = item
					end

					PersonalMenu.ItemIndex[item.name] = Index
				end, RMenu.Get(txt, 'actions'))
			end
		end
	end)
end

function RenderWalletMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Button(_U('wallet_job_button', ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label), nil, {}, true, function() end)

		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'black_money' then
				if PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] == nil then PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = 1 end
				RageUI.List(_U('wallet_blackmoney_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), PersonalMenu.WalletList, PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
					if Selected then
						if Index == 1 then
							local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

							if post then
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

								if closestDistance ~= -1 and closestDistance <= 3 then
									local closestPed = GetPlayerPed(closestPlayer)

									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
									RageUI.CloseAll()
								else
									ESX.ShowNotification(_U('players_nearby'))
								end
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						elseif Index == 2 then
							local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

							if post then
								TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
								RageUI.CloseAll()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						end
					end

					PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = Index
				end)
			elseif ESX.PlayerData.accounts[i].name == 'money' then
				if PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] == nil then PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = 1 end
				RageUI.List(_U('wallet_money_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), PersonalMenu.WalletList, PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
					if Selected then
						if Index == 1 then
							local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

							if post then
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

								if closestDistance ~= -1 and closestDistance <= 3 then
									local closestPed = GetPlayerPed(closestPlayer)

									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
									RageUI.CloseAll()
								else
									ESX.ShowNotification(_U('players_nearby'))
								end
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						elseif Index == 2 then
							local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

							if post then
								TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
								RageUI.CloseAll()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						end
					end

					PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = Index
				end)
			end
		end

		if Config.JSFourIDCard then
			RageUI.Button(_U('wallet_show_idcard_button'), nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI.Button(_U('wallet_check_idcard_button'), nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
				end
			end)

			RageUI.Button(_U('wallet_show_firearms_button'), nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI.Button(_U('wallet_check_firearms_button'), nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
				end
			end)
		end
	end)
end

function RenderItemsMenu()
	if PersonalMenu.ListItems == nil then print('No data') return end

	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Button('~b~~h~Recherche', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
			if Selected then
				local input = KeyboardInput('SEARCH_ITEMS', 'Rechercher un item', '', 20)
				if input == nil or string.gsub(input, ' ', '') == '' then
					ESX.ShowNotification("~r~Recherche annulée")
				else
					local tb = {}
					for _, AnyItem in pairs(PersonalMenu.ListItems) do
						if string.match(AnyItem.name, input) or string.match(AnyItem.label, input) then
							table.insert(tb, AnyItem)
						end
					end

					if #tb == 0 then
						ESX.ShowNotification("~r~Aucun résultat...")
					elseif #tb > 1 then
						ESX.ShowNotification('~h~' .. #tb .. ' résultats')
						print('~h~' .. #tb .. ' résultats')
						for _,AnyItem in pairs(tb) do
							ESX.ShowNotification(AnyItem.name)
							print(AnyItem.label .. ' : ' .. AnyItem.name)
						end
					else
						ESX.ShowNotification("Résultat de recherche : ~g~" .. tb[1].name)
					end
				end
			end
		end)

		for _, AnyItem in pairs(PersonalMenu.ListItems) do
			RageUI.Button(AnyItem.label, nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					ESX.ShowNotification("~g~" .. AnyItem.name)
				end
			end)
		end
	end)
end

function RenderPubMenu()
	local jobspris = {'police', 'ambulance', 'journaliste', 'gouv'}
	if PersonalMenu.PermittedAds == nil then print('No data') return end
	

	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		for k = 1, #jobspris, 1 do
			if ESX.PlayerData.job.name == jobspris[k] then
				RageUI.Button(ESX.PlayerData.job.label, 'Faire une publicité pour le job : '..ESX.PlayerData.job.label..'', {}, true, function(_, _, s)
					if s then
						local input = KeyboardInput('PUB_SUBJECT', 'Raison de votre publicité', '', 99)
						local input2 = KeyboardInput('PUB_SUBJECT', 'Précision de votre publicité', '', 99)
						if input == nil or input2 == nil or string.gsub(input, ' ', '') == '' then
							ESX.ShowNotification("~r~Publicité annulée")
						else
							TriggerServerEvent('fl_pub:personnalisée', input, input2)
						end
					end
				end)
			end
		end

		for i = 1, #PersonalMenu.PermittedAds, 1 do
			local additive = '- ' .. PersonalMenu.PermittedAds[i].subject

			if additive == '- {user}' or additive == '- ' then additive = '' end
			RageUI.Button(PersonalMenu.PermittedAds[i].sender .. additive, nil, {}, true, function(Hovered, Active, Selected)
				if Selected then
					local input = KeyboardInput('PUB_SUBJECT', 'Texte de votre publicité : ' .. PersonalMenu.PermittedAds[i].sender .. '', '', 99)
					if input == nil or string.gsub(input, ' ', '') == '' then
						ESX.ShowNotification("~r~Publicité annulée")
					else
						TriggerServerEvent('fl_society:adFromClient', PersonalMenu.PermittedAds[i].id, input, true)
					end
				end
			end)
		end
	end)
end

function RenderBillingMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.BillData, 1 do
			RageUI.Button(PersonalMenu.BillData[i].label, nil, {RightLabel = '$' .. ESX.Math.GroupDigits(PersonalMenu.BillData[i].amount)}, true, function(Hovered, Active, Selected)
				if Selected then
					ESX.TriggerServerCallback('fl_billing:payBill', function()
						ESX.TriggerServerCallback('fl_billing:getBills', function(bills)
							PersonalMenu.BillData = bills
						end)
					end, PersonalMenu.BillData[i].id)
				end
			end)
		end
	end)
end

function RenderClothesMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.ClothesButtons, 1 do
			RageUI.Button(_U(('clothes_%s'):format(PersonalMenu.ClothesButtons[i])), nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
				if Selected then
					setUniform(PersonalMenu.ClothesButtons[i], plyPed)
				end
			end)
		end
	end)
end

function RenderVehicleMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Button(_U('vehicle_engine_button'), nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if GetIsVehicleEngineRunning(plyVeh) then
						SetVehicleEngineOn(plyVeh, false, false, true)
						SetVehicleUndriveable(plyVeh, true)
					elseif not GetIsVehicleEngineRunning(plyVeh) then
						SetVehicleEngineOn(plyVeh, true, false, true)
						SetVehicleUndriveable(plyVeh, false)
					end
				end
			end
		end)

		RageUI.List(_U('vehicle_door_button'), PersonalMenu.DoorList, PersonalMenu.DoorIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
			if Selected then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if Index == 1 then
						if not PersonalMenu.DoorState.FrontLeft then
							PersonalMenu.DoorState.FrontLeft = true
							SetVehicleDoorOpen(plyVeh, 0, false, false)
						elseif PersonalMenu.DoorState.FrontLeft then
							PersonalMenu.DoorState.FrontLeft = false
							SetVehicleDoorShut(plyVeh, 0, false, false)
						end
					elseif Index == 2 then
						if not PersonalMenu.DoorState.FrontRight then
							PersonalMenu.DoorState.FrontRight = true
							SetVehicleDoorOpen(plyVeh, 1, false, false)
						elseif PersonalMenu.DoorState.FrontRight then
							PersonalMenu.DoorState.FrontRight = false
							SetVehicleDoorShut(plyVeh, 1, false, false)
						end
					elseif Index == 3 then
						if not PersonalMenu.DoorState.BackLeft then
							PersonalMenu.DoorState.BackLeft = true
							SetVehicleDoorOpen(plyVeh, 2, false, false)
						elseif PersonalMenu.DoorState.BackLeft then
							PersonalMenu.DoorState.BackLeft = false
							SetVehicleDoorShut(plyVeh, 2, false, false)
						end
					elseif Index == 4 then
						if not PersonalMenu.DoorState.BackRight then
							PersonalMenu.DoorState.BackRight = true
							SetVehicleDoorOpen(plyVeh, 3, false, false)
						elseif PersonalMenu.DoorState.BackRight then
							PersonalMenu.DoorState.BackRight = false
							SetVehicleDoorShut(plyVeh, 3, false, false)
						end
					end
				end
			end

			PersonalMenu.DoorIndex = Index
		end)

		RageUI.Button(_U('vehicle_hood_button'), nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if not PersonalMenu.DoorState.Hood then
						PersonalMenu.DoorState.Hood = true
						SetVehicleDoorOpen(plyVeh, 4, false, false)
					elseif PersonalMenu.DoorState.Hood then
						PersonalMenu.DoorState.Hood = false
						SetVehicleDoorShut(plyVeh, 4, false, false)
					end
				end
			end
		end)

		RageUI.Button(_U('vehicle_trunk_button'), nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if not PersonalMenu.DoorState.Trunk then
						PersonalMenu.DoorState.Trunk = true
						SetVehicleDoorOpen(plyVeh, 5, false, false)
					elseif PersonalMenu.DoorState.Trunk then
						PersonalMenu.DoorState.Trunk = false
						SetVehicleDoorShut(plyVeh, 5, false, false)
					end
				end
			end
		end)
	end)
end

function RenderBossMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()

		RageUI.Button(_U('bossmanagement_hire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('fl_menu:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement_fire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('fl_menu:Boss_virerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement_promote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('fl_menu:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement_demote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('fl_menu:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)
	end)
end

function RenderDiversMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Button("Sauvegarder son personnage", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				Citizen.Wait(500)
				TriggerServerEvent('esx:saveplayer')
				TriggerEvent('skinchanger:modelLoaded')
				ESX.ShowNotification('~b~Personnage sauvegardé~s~')
			end
		end)
		RageUI.Button("Mes clés", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				TriggerEvent('fl_controlvehicle:openKeysMenu')
				RageUI.CloseAll()
			end
		end)
		RageUI.Button("Enlever | Afficher HUD", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				openInterface()
			end
		end)
		RageUI.Button("Mode cinématique", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				OpenCinematic()
			end
		end)
		RageUI.Button("RockstarEditor | Record", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if IsRecording() then
					ESX.ShowNotification("You are already recording a clip, you need to stop recording first before you can start recording again!")
				else
					StartRecording(1);
				end
			end
		end)
		RageUI.Button("RockstarEditor | Stop", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				if not IsRecording() then
					Notify.Alert("You are currently NOT recording a clip, you need to start recording first before you can stop and save a clip.")
				else
					StopRecordingAndSaveClip()
				end
			end
		end)
		RageUI.Button("Aller dans le RockstarEditor", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				TriggerEvent('ui:toggle', false)
				ActivateRockstarEditor();
				while IsPauseMenuActive() do
					Citizen.Wait(0)
				end
				DoScreenFadeIn(1);
				TriggerEvent('ui:toggle', true)
			end
		end)
	end)
end

local interface = false
function openInterface()
	interface = not interface
	TriggerEvent('ui:toggle', interface)

	if interface then
		DisplayRadar(false)
		TriggerEvent('ui:toggle', false)
	else
		DisplayRadar(true)
		TriggerEvent('ui:toggle', true)
	end
end

local hasCinematic = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPauseMenuActive() then
		elseif hasCinematic then
            DrawRect(1.0, 1.0, 2.0, 0.25, 0, 0, 0, 255)
            DrawRect(1.0, 0.0, 2.0, 0.25, 0, 0, 0, 255)
            ThefeedHideThisFrame()
		elseif interface then
            ThefeedHideThisFrame()
		else
			Citizen.Wait(400)
		end
	end
end)

 function OpenCinematic()
	hasCinematic = not hasCinematic
	if hasCinematic then -- show
		SendNUIMessage({openCinema = true})
		DisplayRadar(false)
		TriggerEvent('ui:toggle', false)
	else
		SendNUIMessage({openCinema = false})
		DisplayRadar(true)
		TriggerEvent('ui:toggle', true)
	end
end

function UpdateDisplayReports()
	TriggerServerEvent('es_extended:displayReports', GetResourceKvpInt('hideReports') == 0)
end

local noclip = false
local noclip_speed = 1.0

function news_no_clip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- activé
    SetEntityInvincible(ped, true)
	SetEntityVisible(ped, false, false)
	invisible = true
  else -- désactivé
    SetEntityInvincible(ped, false)
	SetEntityVisible(ped, true, false)
	invisible = false
  end
end

function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if noclip then
		local ped = GetPlayerPed(-1)
		local x,y,z = getPosition()
		local dx,dy,dz = getCamDirection()
		local speed = noclip_speed
  
		-- reset du velocity
		SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
  
		-- aller vers le haut
		if IsControlPressed(0,32) then -- MOVE UP
		  x = x+speed*dx
		  y = y+speed*dy
		  z = z+speed*dz
		end
  
		-- aller vers le bas
		if IsControlPressed(0,269) then -- MOVE DOWN
		  x = x-speed*dx
		  y = y-speed*dy
		  z = z-speed*dz
		end
  
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
	  end
	end
end)

function RenderAdminMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		RageUI.Button('Items', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
			if Selected then
				ESX.TriggerServerCallback('esx:getListItems', function(items)
					PersonalMenu.ListItems = items
				end)
			end
		end, RMenu.Get('admin', 'items'))

		RageUI.Checkbox("Chat report", 'Active ou désactive l\'affichage des reports dans le chat', GetResourceKvpInt('hideReports') == 0, {}, {
			onChecked = function()
				SetResourceKvpInt('hideReports', 0)
				UpdateDisplayReports()
			end,
			onUnChecked = function()
				SetResourceKvpInt('hideReports', 1)
				UpdateDisplayReports()
			end
		})
		RageUI.Checkbox("No clip", 'Activez le noclip WOw !!', crossthemap, {}, {
			onChecked = function()
				crossthemap = Checked
				news_no_clip()
			end,
			onUnChecked = function()
				news_no_clip()
			end
		})

		for i = 1, #Config.Admin, 1 do
			local authorized = false

			for j = 1, #Config.Admin[i].groups, 1 do
				if Config.Admin[i].groups[j] == ESX.PlayerData.group then
					authorized = true
				end
			end

			if authorized then
				RageUI.Button(Config.Admin[i].label, nil, {}, true, function(Hovered, Active, Selected)
					if Selected then
						Config.Admin[i].command()
					end
				end)
			else
				RageUI.Button(Config.Admin[i].label, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function() end)
			end
		end

	end)
end

function UpdateWeight()
	local weightTxt = 'Poids : ' .. ESX.PlayerData.weight .. '/' .. ESX.PlayerData.maxWeight .. 'kg'
	RMenu.Get('personal', 'inventory'):SetSubtitle(weightTxt)
	RMenu.Get('personal', 'manageclothes'):SetSubtitle(weightTxt)
	RMenu.Get('personal', 'weapons'):SetSubtitle(weightTxt)

	PersonalMenu.HasWeapons = false
	for i = 1, #ESX.PlayerData.inventory, 1 do
		local item = ESX.PlayerData.inventory[i]
		if item.count and item.count > 0 and not PersonalMenu.HasWeapons then
			PersonalMenu.HasWeapons = IsWeaponCategory(item.name)
		end
	end
end
AddEventHandler('esx:changedPlayerData', UpdateWeight)

local lastRequest = 0
function GetAllInfo()
	UpdateWeight()
	if GetGameTimer() - lastRequest > 10000 then
		lastRequest = GetGameTimer()

		ESX.TriggerServerCallback('fl_billing:getBills', function(bills)
			PersonalMenu.BillData = bills
		end)

		ESX.TriggerServerCallback('fl_society:getAdsType', function(permittedAds)
			PersonalMenu.PermittedAds = permittedAds
		end)
	end
end













RegisterCommand('+openmainenu', function()
	if ESX.IsPlayerDead() then return end
	if RageUI.Visible() then return end

	GetAllInfo()
	RageUI.Visible(RMenu.Get('rageui', 'personal'), true)
end)
RegisterCommand('-openmainenu', function() end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local sleep = true

		if RageUI.Visible(RMenu.Get('rageui', 'personal')) then
			RenderPersonalMenu()
			PersonalMenu.ItemIndex = {}
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('inventory', 'actions')) then
			RenderActionsMenu('inventory')
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('weapons', 'actions')) then
			RenderActionsMenu('weapons')
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('clothes', 'actions')) then
			RenderActionsMenu('clothes')
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'inventory')) then
			RenderInventoryMenu(true, false, false)
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'weapons')) then
			RenderInventoryMenu(false, true, false)
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'manageclothes')) then
			RenderInventoryMenu(false, false, true)
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'wallet')) then
			RenderWalletMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'billing')) then
			RenderBillingMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'pub')) then
			RenderPubMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('manageclothes', 'clothes')) then
			RenderClothesMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'divers')) then
			RenderDiversMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'animation')) then
			RageUI.CloseAll()
			TriggerEvent("dp:RecieveMenu")
		end

		if RageUI.Visible(RMenu.Get('personal', 'vehicle')) then
			if not RMenu.Settings('personal', 'vehicle', 'Restriction')() then
				RageUI.GoBack()
			end
			RenderVehicleMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'boss')) then
			if not RMenu.Settings('personal', 'boss', 'Restriction')() then
				RageUI.GoBack()
			end
			RenderBossMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'admin')) then
			if not RMenu.Settings('personal', 'admin', 'Restriction')() then
				RageUI.GoBack()
			end
			RenderAdminMenu()
			sleep = false
		end

		if RageUI.Visible(RMenu.Get('personal', 'liste')) then
			if not RMenu.Settings('personal', 'liste', 'Restriction')() then
				RageUI.GoBack()
			end
			RenderListMenu()
		end

		if RageUI.Visible(RMenu.Get('admin', 'items')) then
			RenderItemsMenu()
			sleep = false
		end
		if RageUI.Visible(RMenu.Get('admin', 'joueurs')) then
			RenderItemsMenu()
			sleep = false
		end

		if sleep then
			Citizen.Wait(300)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if IsControlJustReleased(0, Config.Controls.StopTasks.keyboard) and IsInputDisabled(2) then
			Player.pointing = false
			ClearPedTasks(plyPed)
		end

		if Player.showCoords then
			local plyCoords = GetEntityCoords(plyPed, false)
			Text('~r~X~s~: ' .. plyCoords.x .. ' ~b~Y~s~: ' .. plyCoords.y .. ' ~g~Z~s~: ' .. plyCoords.z .. ' ~y~Angle~s~: ' .. GetEntityHeading(plyPed))
		end

		if Player.noclip then
			local plyCoords = GetEntityCoords(plyPed, false)
			local camCoords = getCamDirection()
			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				plyCoords = plyCoords + (Config.NoclipSpeed * camCoords)
			end

			if IsControlPressed(0, 269) then
				plyCoords = plyCoords - (Config.NoclipSpeed * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)
		end

		Citizen.Wait(0)
	end
end)


-- PUBS 

RegisterNetEvent('fl_pub:police')
AddEventHandler('fl_pub:police', function(txt1, txt2)
    local raison = txt1
    local detail = txt2
    exports['fl_notifs']:Custom({
        style  =  'lspd',
        duration  =  10500,
        title  =  'Los Santos Police Department',
        message  =  '**'..raison..'** \n '..detail..'',
        image = 'https://cdn.discordapp.com/attachments/843488358285967390/843965075446300682/latest.png',
        sound  =  true
    })
end)

RegisterNetEvent('fl_pub:weazle')
AddEventHandler('fl_pub:weazle', function(txt1, txt2)
    local raison = txt1
    local detail = txt2
    exports['fl_notifs']:Custom({
        style  =  'weazle',
        duration  =  10500,
        title  =  'Weazle News',
        message  =  '**'..raison..'** \n '..detail..'',
        image = 'https://cdn.discordapp.com/attachments/843488358285967390/843969927912357938/cropped-log00o.png',
        sound  =  true
    })
end)

RegisterNetEvent('fl_pub:ems')
AddEventHandler('fl_pub:ems', function(txt1, txt2)
    local raison = txt1
    local detail = txt2
    exports['fl_notifs']:Custom({
        style  =  'emsjob',
        duration  =  10500,
        title  =  'Emergency Medical Services',
        message  =  '**'..raison..'** \n '..detail..'',
        image = 'https://cdn.discordapp.com/attachments/843488358285967390/843971376515121173/51WVh2B2BG-vL.png',
        sound  =  true
    })
end)

RegisterNetEvent('fl_pub:gouv')
AddEventHandler('fl_pub:gouv', function(txt1, txt2)
    local raison = txt1
    local detail = txt2
    exports['fl_notifs']:Custom({
        style  =  'gouv',
        duration  =  10500,
        title  =  'Gouvernement de LS',
        message  =  '**'..raison..'** \n '..detail..'',
        image = 'https://cdn.discordapp.com/attachments/843488358285967390/843973835014799370/png-clipart-federal-government-of-the-united-states-great-seal-of-the-united-states-official-united-.png',
        sound  =  true
    })
end)

function RenderListMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		ESX.TriggerServerCallback("fl_joueurs:adminlist", function(players)
			connectedPlayers = players
		end)
		for i = 1, #connectedPlayers, 1 do
		RageUI.Button(connectedPlayers[i].name, nil, {RightLabel = connectedPlayers[i].id}, true, function(Hovered, Active, Selected)
			if Selected then
			end
		end)
	end
	end)
end