function IsWeaponCategory(itemName)
	for _,Weapon in pairs(Config.Weapons) do
		if Weapon.item == itemName then
			return true
		end
	end

	return itemName:find('ammo') or itemName:find('bullet') or itemName:find('wct_')
end

function IsClothesCategory(itemName)
	return itemName:find('imask') or
		   itemName:find('iears') or
		   itemName:find('ihelmet') or
		   itemName:find('iglass') or
		   itemName:find('ibag') or
		   itemName:find('hazmat') or
		   itemName == 'covid'
end