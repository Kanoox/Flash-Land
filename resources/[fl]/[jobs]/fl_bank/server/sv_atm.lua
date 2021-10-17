RegisterNetEvent('fl_bank:destroyAtm')
AddEventHandler('fl_bank:destroyAtm', function(CurrentATM)
	if not CurrentATM then error('No CurrentATM specified') end
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = math.random(Config.AtmRewardMin, Config.AtmRewardMax)
	xPlayer.addMoney(amount)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez obtenu ~g~$' .. amount .. '~s~ en détruisant cet ~b~ATM~s~')
	TriggerClientEvent('fl_bank:destroyedAtm', -1, CurrentATM.ObjectCoord)
end)

RegisterNetEvent('fl_bank:hackAtm')
AddEventHandler('fl_bank:hackAtm', function(CurrentATM)
	if not CurrentATM then error('No CurrentATM specified') end
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = math.random(Config.AtmHackRewardMin, Config.AtmHackRewardMax)
	xPlayer.addMoney(amount)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez obtenu ~g~$' .. amount .. '~s~ en hackant cet ~b~ATM~s~')
	TriggerClientEvent('fl_bank:hackedAtm', -1, CurrentATM.ObjectCoord)
end)

RegisterNetEvent('fl_bank:robAtm')
AddEventHandler('fl_bank:robAtm', function()
	SendNotificationToCops("")
end)