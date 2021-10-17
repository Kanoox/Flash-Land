
-- Utiliser Brolly
ESX.RegisterUsableItem('brolly', function(source)
	TriggerClientEvent('fl_useitem:brolly', source)
end)

-- Utiliser Kitpic
ESX.RegisterUsableItem('kitpic', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fl_useitem:kitpic', source)
	xPlayer.removeInventoryItem('kitpic', 1)
end)

-- Utiliser Ball
ESX.RegisterUsableItem('ball', function(source)
	TriggerClientEvent('fl_useitem:ball', source)
end)

-- Utiliser Swim
ESX.RegisterUsableItem('mask_swim', function(source)
	TriggerClientEvent('fl_useitem:swim', source)

	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('swim', 1)
end)

-- Utiliser Bong
ESX.RegisterUsableItem('bong', function(source)
	TriggerClientEvent('fl_useitem:bong', source)
end)

RegisterNetEvent('fl_useitem:bong')
AddEventHandler('fl_useitem:bong', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bong', 1)
	TriggerClientEvent('fl_status:add', source, 'drunk', 450000)
end)

-- Utiliser Tatgun
ESX.RegisterUsableItem('tatgun', function(source)
	TriggerClientEvent('fl_useitem:tatgun', source)
end)

-- Utiliser Gillet par balle 1
ESX.RegisterUsableItem('bullet1', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fl_useitem:bullet1', source)
	xPlayer.removeInventoryItem('bullet1', 1)
end)

-- Utiliser Gillet par balle 2
ESX.RegisterUsableItem('bullet2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('fl_useitem:bullet2', source)
    xPlayer.removeInventoryItem('bullet2', 1)
end)

-- Utiliser Gillet par balle 3
ESX.RegisterUsableItem('bullet3', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('fl_useitem:bullet3', source)
    xPlayer.removeInventoryItem('bullet3', 1)
end)

-- Utiliser Gillet par balle 4
ESX.RegisterUsableItem('bullet4', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('fl_useitem:bullet4', source)
    xPlayer.removeInventoryItem('bullet4', 1)
end)

-- Utiliser ROSE
ESX.RegisterUsableItem('rose', function(source)
	TriggerClientEvent('fl_useitem:rose', source)
end)

-- Utiliser NOTEPAD
ESX.RegisterUsableItem('notepad', function(source)
	TriggerClientEvent('fl_useitem:notepad', source)
end)

-- Utiliser NightVision
ESX.RegisterUsableItem('nightvision', function(source)
	TriggerClientEvent('fl_useitem:nightvision', source)
end)


-- Tenues

--HAZMAT NOIRE
ESX.RegisterUsableItem('hazmat1', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuehaz1', _source)
end)

--HAZMAT BLEUE
ESX.RegisterUsableItem('hazmat2', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuehaz2', _source)
end)

--HAZMAT BREAKINGBAD
ESX.RegisterUsableItem('hazmat3', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuehaz3', _source)
end)

--HAZMAT BLANCHE
ESX.RegisterUsableItem('hazmat4', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuehaz4', _source)
end)

--CASA PAPEL
ESX.RegisterUsableItem('militaire', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuecasa', _source)
end)

--TENUE KARTING
ESX.RegisterUsableItem('karting1', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuekarting1', _source)
end)

--TENUE MILITAIRE
ESX.RegisterUsableItem('militaire', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuemilitaire', _source)
end)

--TENUE SKYDIVING
ESX.RegisterUsableItem('skydiving', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenueskydivingcl', _source)
end)

--TENUE PRISON
ESX.RegisterUsableItem('prisonnier', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:settenuejailer', _source)
end)

--Badge FBI
ESX.RegisterUsableItem('badgefbi', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:setbadgefbi', _source)
end)

--Masque Covid
ESX.RegisterUsableItem('covid', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('fl_objects:setcovid', _source)
end)