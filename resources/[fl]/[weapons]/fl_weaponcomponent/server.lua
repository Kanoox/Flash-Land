local Registered = {}
local Defaults = {
	WCT_CLIP1_RV = true,
	WCT_CLIP1 = true,
	WCT_BARR  = true,
	WCT_MUZZ3 = true,
	WCT_SHELL = true,
	WCT_SB_BASE = true,
	WCT_KNUCK_01 = true,
}

for Component, ComponentType in pairs(Config.Components) do
	if not Registered[ComponentType] and Defaults[ComponentType] == nil then
		Registered[ComponentType] = true
		ESX.RegisterUsableItem(string.lower(ComponentType), function(source)
			TriggerClientEvent('fl_weaponcomponent:equip', source, string.lower(ComponentType))
		end)
	end
end