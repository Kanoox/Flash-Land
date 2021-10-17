RegisterNetEvent('fl_coiffeur:getSkin')
AddEventHandler('fl_coiffeur:getSkin', function(target)
	TriggerClientEvent('fl_coiffeur:getSkin', target, source)
end)

RegisterNetEvent('fl_coiffeur:save')
AddEventHandler('fl_coiffeur:save', function(target)
	TriggerClientEvent('fl_coiffeur:save', target)
end)

RegisterNetEvent('fl_coiffeur:setSkin')
AddEventHandler('fl_coiffeur:setSkin', function(skin, target)
	TriggerClientEvent('fl_coiffeur:setSkin', target, skin, source)
end)

RegisterNetEvent('fl_coiffeur:change')
AddEventHandler('fl_coiffeur:change', function(target, name, value)
	TriggerClientEvent('fl_coiffeur:change', target, name, value)
end)

RegisterNetEvent('fl_coiffeur:resetSkin')
AddEventHandler('fl_coiffeur:resetSkin', function(target)
	TriggerClientEvent('fl_coiffeur:resetSkin', target)
end)
