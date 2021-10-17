RegisterNetEvent("fl_hookah:pay")
AddEventHandler("fl_hookah:pay", function()
	ESX.GetPlayerFromId(source).removeMoney(100)
end)

ESX.RegisterUsableItem('hookah', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('hookah', 1)
	TriggerClientEvent("fl_hookah:spawn", source)
end)

RegisterCommand("deletehookah", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
	local coords = xPlayer.getCoords(true)
	local minDist = 500
	local toDeleteId = 0

	for _, id in pairs(GetAllObjects()) do
		if GetEntityModel(id) == `prop_bong_01` then
			local dist = #(coords - GetEntityCoords(id))
			if dist < minDist then
				minDist = dist
				toDeleteId = id
			end
		end
	end

	if minDist < 5 then
		DeleteEntity(toDeleteId)
		xPlayer.addInventoryItem("hookah", 1)
	else
		xPlayer.showNotification('~r~Aucune Chicha à proximité')
	end
end)

RegisterCommand("debug_deletehookah", function(source, args, rawCommand)
	for _, id in pairs(GetAllObjects()) do
		if GetEntityModel(id) == `prop_bong_01` then
			DeleteEntity(id)
		end
	end
end)