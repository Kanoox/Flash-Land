local destroyedRadars = {}

Citizen.CreateThread(function()
	destroyedRadars = json.decode(GetResourceKvpString('destroyedRadars'))
	if destroyedRadars == nil or type(destroyedRadars) ~= 'table' then
		destroyedRadars = {}
	end

	ESX.RegisterTempItem('waze', 'Waze', 0.05, -1, 0)
	ESX.RegisterUsableItem('waze', function(source, xPlayer)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('waze', 1)
		xPlayer.triggerEvent('fl_speedradar:displayRadars')
		xPlayer.showNotification('~g~Votre waze est actif pour 1h')

		Citizen.SetTimeout(60 * 60 * 1000, function()
			xPlayer.triggerEvent('fl_speedradar:hideRadars')
			ESX.ShowNotification('~r~Le waze n\'est plus actif...')
		end)
	end)
end)

function ResetRadars()
	destroyedRadars = {}
	for RadarId,Radar in pairs(Config.Radars) do
		destroyedRadars[RadarId] = false
	end

	SetResourceKvp('destroyedRadars', json.encode(destroyedRadars))
	TriggerClientEvent('fl_speedradar:syncRadars', -1, destroyedRadars)

	for _, xPlayerPolice in pairs(ESX.GetPlayersWithJob('police')) do
		xPlayerPolice.showNotification("~g~Réparation de tous les radars par un technicien...")
	end
end

TriggerEvent('cron:runAtDay', 6, 23, 0, ResetRadars)

RegisterNetEvent('fl_speedradar:destroyedRadar')
AddEventHandler('fl_speedradar:destroyedRadar', function(RadarId)
	destroyedRadars[RadarId] = true
	SetResourceKvp('destroyedRadars', json.encode(destroyedRadars))
	TriggerClientEvent('fl_speedradar:syncRadars', -1, destroyedRadars)

	for _, xPlayerPolice in pairs(ESX.GetPlayersWithJob('police')) do
		xPlayerPolice.showNotification('~r~Radar détruit~w~ près de la ~b~'.. Config.Radars[RadarId].Name.."~w~.")
	end
end)

RegisterNetEvent('fl_speedradar:requestSyncRadars')
AddEventHandler('fl_speedradar:requestSyncRadars', function()
	TriggerClientEvent('fl_speedradar:syncRadars', source, destroyedRadars)
end)

RegisterNetEvent('fl_speedradar:flashed')
AddEventHandler('fl_speedradar:flashed', function(plate, vitesse, model, radarId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	vitesse = math.ceil(vitesse - 0.5)

	for _, xPlayerPolice in pairs(ESX.GetPlayersWithJob('police')) do
		xPlayerPolice.showNotification('~b~'.. model ..'~w~ immatriculé ~b~' .. plate .. '~w~ flashé à ~b~'.. vitesse .. 'KM/H~w~ près de la ~b~'.. Config.Radars[radarId].Name.."~w~.")
	end

	if xPlayer.getAccount('bank').money >= Config.BillPrice then
		xPlayer.showNotification('~b~Vous avez été flashé ! ~r~Vous avez payé ' .. Config.BillPrice .. '$ depuis votre compte bancaire ...')
		xPlayer.removeAccountMoney('bank', Config.BillPrice)
	else
		xPlayer.showNotification('~b~Vous avez été flashé ! ~r~Vous avez reçu une amende de ' .. Config.BillPrice .. '$ ...')
		TriggerEvent('fl_billing:sendBill', source, 'society_police', 'Amende pour excès de vitesse', Config.BillPrice)
	end
end)

ESX.RegisterCommand('blipradar', 'user', function(xPlayer, args, showError)
    if xPlayer.job.name == 'police' or xPlayer.getGroup() == '_dev' then
		xPlayer.triggerEvent('fl_speedradar:toggleRadars')
    else
        xPlayer.showNotification('~r~Vous n\'êtes pas policier...')
    end
end, false, {help = 'Activer/Désactiver les blips de radar'})

ESX.RegisterCommand('resetradar', '_dev', function(xPlayer, args, showError)
	ResetRadars()
	xPlayer.showNotification('~r~Reset radar')
end, false, {help = 'Activer/Désactiver les blips de radar'})