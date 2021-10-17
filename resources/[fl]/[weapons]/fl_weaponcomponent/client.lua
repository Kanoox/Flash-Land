local used = {}
for _,ComponentType in pairs(Config.Components) do
	used[ComponentType] = 0
end

RegisterNetEvent('fl_weaponcomponent:equip')
AddEventHandler('fl_weaponcomponent:equip', function(component)
	local inventory = ESX.GetPlayerData().inventory

	local itemNumber = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == component then
			itemNumber = inventory[i].count
		end
	end

	local ped = PlayerPedId()
	local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == `WEAPON_UNARMED` then
		ESX.ShowNotification('~r~Vous n\'avez pas d\'arme en main')
		return
	end

	for Component, ComponentType in pairs(Config.Components) do
		if string.lower(ComponentType) == component then
			local ComponentHash = GetHashKey(Component)
			if DoesWeaponTakeWeaponComponent(currentWeaponHash, ComponentHash) then

				if HasPedGotWeaponComponent(ped, currentWeaponHash, ComponentHash) then
					RemoveWeaponComponentFromPed(ped, currentWeaponHash, ComponentHash)
					ESX.ShowNotification('Vous venez de retirer ~b~' .. GetLabelText(ComponentType) .. '~w~')
					if used[ComponentType] > 0 then
						used[ComponentType] = used[ComponentType] - 1
					end
					return
				end

				if used[ComponentType] >= itemNumber then
					ESX.ShowNotification('~r~Vous avez utiliser tout vos ~b~' .. GetLabelText(ComponentType) .. '~w~')
					return
				end

				GiveWeaponComponentToPed(ped, currentWeaponHash, ComponentHash)
				ESX.ShowNotification('Vous venez d\'équiper ~b~' .. GetLabelText(ComponentType) .. '~w~ (pour cette session)')
				used[ComponentType] = used[ComponentType] + 1
				return
			end
		end
	end

	ESX.ShowNotification('~r~Votre arme ne supporte pas cet accessoire.')
end)


RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, silent)
	if used[item.name] == nil or used[item.name] <= 0 then
		return
	end

	local inventory = ESX.GetPlayerData().inventory

	if item.count >= used[item.name] then
		return
	end

	used[item.name] = used[item.name] - count

	local ped = PlayerPedId()

	for Component, ComponentType in pairs(Config.Components) do
		local ComponentHash = GetHashKey(Component)

		for _,Weapon in pairs(Config.Weapons) do
			if HasPedGotWeaponComponent(ped, Weapon.hash, ComponentHash) then
				RemoveWeaponComponentFromPed(ped, Weapon.hash, ComponentHash)
				count = count - 1

				if count <= 0 then
					return
				end
			end
		end
	end

	error('Unable to remove any component from ped, wtf')
end)

AddEventHandler('esx:onPlayerSpawn', function()
	used = {}

	for _,ComponentType in pairs(Config.Components) do
		used[ComponentType] = 0
	end
end)
