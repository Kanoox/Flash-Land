TriggerEvent('cron:runAt', 10, 30, function()
	TriggerEvent('fl_datastore:getAllSharedDataStores', function(SharedDataStores)
		for _, SharedDataStore in pairs(SharedDataStores) do
			if SharedDataStore.get('NumberMachines') ~= nil then
				local CurrentlyWashing = SharedDataStore.getNumber('CurrentlyWashing')
				local AlreadyWashed = SharedDataStore.getNumber('AlreadyWashed')

				SharedDataStore.set('CurrentlyWashing', 0)
				SharedDataStore.set('AlreadyWashed', AlreadyWashed + CurrentlyWashing)
			end
		end
	end)
end)

ESX.RegisterServerCallback('fl_washmoney:getWasherData', function(xPlayer, source, cb, TargetSociety)
	TriggerEvent('fl_datastore:getSharedDataStore', 'society_' .. TargetSociety, function(SharedDataStore)
		if SharedDataStore.get('NumberMachines') == nil then
			SharedDataStore.set('NumberMachines', 0)
			SharedDataStore.set('CurrentlyWashing', 0)
			SharedDataStore.set('AlreadyWashed', 0)
		end

		cb({
			Society = TargetSociety,
			NumberMachines = SharedDataStore.getNumber('NumberMachines'),
			CurrentlyWashing = SharedDataStore.getNumber('CurrentlyWashing'),
			AlreadyWashed = SharedDataStore.getNumber('AlreadyWashed'),
		})
	end)
end)

function RestingDays()
	local weekDay = tonumber(os.date('%w', os.time()))
	if weekDay == 0 then
		return 9999
	elseif weekDay == 1 then
		return 6
	elseif weekDay == 2 then
		return 5
	elseif weekDay == 3 then
		return 4
	elseif weekDay == 4 then
		return 3
	elseif weekDay == 5 then
		return 2
	elseif weekDay == 6 then
		return 1
	end

	error(weekDay)
end

ESX.RegisterServerCallback('fl_washmoney:getRestingDays', function(xPlayer, source, cb)
	cb(RestingDays())
end)

RegisterNetEvent('fl_washmoney:rentMachine')
AddEventHandler('fl_washmoney:rentMachine', function(Society)
	local xPlayer = ESX.GetPlayerFromId(source)
	local blackMoneyAccount = xPlayer.getAccount('black_money')
	local restingDays = RestingDays()

	if tonumber(os.date('%w', os.time())) == 0 then
		xPlayer.showNotification('~r~Le fournisseur ne travaille pas le dimanche... Revenez demain')
		return
	end

	if blackMoneyAccount.money < Config.RentWashPrice * restingDays then
		xPlayer.showNotification('~r~Pas assez d\'argent pour acheter une machine en plus')
		return
	end

	TriggerEvent('fl_datastore:getSharedDataStore', 'society_' .. Society, function(SharedDataStore)
		local NumberMachines = SharedDataStore.getNumber('NumberMachines')
		if NumberMachines < 4 then
			xPlayer.removeAccountMoney('black_money', Config.RentWashPrice * restingDays)
			SharedDataStore.set('NumberMachines', NumberMachines + 1)
			xPlayer.showNotification('~g~Nouvelle machine loué pour $' .. ESX.Math.GroupDigits(ESX.Math.Round(Config.RentWashPrice * restingDays)) .. ' pour ' .. restingDays .. ' jours')
			TriggerClientEvent('fl_washmoney:updateCurrentData', xPlayer.source, Society)
		end
	end)
end)

RegisterNetEvent('fl_washmoney:getMoneyWashed')
AddEventHandler('fl_washmoney:getMoneyWashed', function(Society)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('fl_datastore:getSharedDataStore', 'society_' .. Society, function(SharedDataStore)
		local AlreadyWashed = SharedDataStore.getNumber('AlreadyWashed')
		if AlreadyWashed > 0 then
			xPlayer.addMoney(AlreadyWashed * Config.Washers[Society].rate)
			SharedDataStore.set('AlreadyWashed', 0)
			xPlayer.showNotification('~g~Vous récupérez $' .. ESX.Math.GroupDigits(ESX.Math.Round(AlreadyWashed * Config.Washers[Society].rate)) .. ' d\'argent propre')
			TriggerClientEvent('fl_washmoney:updateCurrentData', xPlayer.source, Society)
		end
	end)
end)

RegisterNetEvent('fl_washmoney:putMoneyInWashing')
AddEventHandler('fl_washmoney:putMoneyInWashing', function(Society)
	local xPlayer = ESX.GetPlayerFromId(source)

	local blackMoneyAccount = xPlayer.getAccount('black_money')
	if blackMoneyAccount.money < Config.WashingMachine then
		xPlayer.showNotification('~r~Quantité argent insuffisant...')
		return
	end

	TriggerEvent('fl_datastore:getSharedDataStore', 'society_' .. Society, function(SharedDataStore)
		local NumberMachines = SharedDataStore.getNumber('NumberMachines')
		local CurrentlyWashing = SharedDataStore.getNumber('CurrentlyWashing')
		local AlreadyWashed = SharedDataStore.getNumber('AlreadyWashed')

		if CurrentlyWashing < (NumberMachines * Config.WashingMachine) - AlreadyWashed then
			SharedDataStore.set('CurrentlyWashing', CurrentlyWashing + Config.WashingMachine)
			xPlayer.removeAccountMoney('black_money', Config.WashingMachine)
			xPlayer.showNotification('~g~Lancement du lavage de $' .. ESX.Math.GroupDigits(ESX.Math.Round(Config.WashingMachine)))
			TriggerClientEvent('fl_washmoney:updateCurrentData', xPlayer.source, Society)
		else
			xPlayer.showNotification('~r~Capacité de lavage insuffisante...')
		end
	end)
end)