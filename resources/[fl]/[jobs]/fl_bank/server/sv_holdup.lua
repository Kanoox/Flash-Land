Config.NumberOfCopsRequired = 0 -- 5
Config.TimeBetweenRobbing = 12 * 60 * 60 -- 12 Hours

local CurrentlyRobbing = false
local Robbers = {}

RegisterNetEvent('fl_bank:toofar')
AddEventHandler('fl_bank:toofar', function(RobbingBank)
	local xPlayers = ESX.GetPlayers()
	CurrentlyRobbing = false

	SendNotificationToCops('~r~Braquage annulé à ~b~' .. Config.Banks[RobbingBank].nameofbank, RobbingBank)

	if Robbers[source] then
		TriggerClientEvent('fl_bank:endHoldUp', source)
		Robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, '~r~Le braquage a été annulé...')
	end
end)

RegisterNetEvent('fl_bank:rob')
AddEventHandler('fl_bank:rob', function(RobbingBank)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xSource = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	local BankInfo = Config.Banks[RobbingBank]

	if BankInfo.LastRobbed and (os.time() - BankInfo.LastRobbed) < Config.TimeBetweenRobbing then
		TriggerClientEvent('esx:showNotification', source, 'Cette banque a déjà été braqué. Veuillez attendre ' .. (2 - (os.time() - BankInfo.LastRobbed)) .. 'secondes.')
		return
	end

	if CurrentlyRobbing then
		TriggerClientEvent('esx:showNotification', source, '~r~Un braquage est déjà en cours.')
		return
	end

	if xPlayer.getInventoryItem('drill').count < 1 then
		TriggerClientEvent('esx:showNotification', source, '~r~Vous n\'avez pas de perceuse...')
		return
	end

	xPlayer.removeInventoryItem('drill', 1)

	if GetNumberOfCops() < Config.NumberOfCopsRequired then
		TriggerClientEvent('esx:showNotification', source, 'Pour braquer il faut minimum un minimum de ' .. Config.NumberOfCopsRequired .. ' policier')
		return
	end

	CurrentlyRobbing = true
	--[[for k, v in pairs(xPlayers) do
		local xPlayer = ESX.GetPlayerFromId(v)
		if xPlayer.job.name == "police" then
			xPlayer.triggerEvent("iCore:getCallMsg", "Un ~b~braquage de banque~s~ est en cours !\nBanque : ~b~" .. BankInfo.nameofbank, Config.Banks[RobbingBank].holdupPosition, xSource)
		end
	end]]


	TriggerClientEvent('esx:showNotification', source, 'Vous avez commencé à braquer ' .. BankInfo.nameofbank .. ', ne vous éloignez pas !')
	TriggerClientEvent('esx:showNotification', source, 'L\'alarme a été déclenché')
	TriggerClientEvent('esx:showNotification', source, 'Tenez la position pendant 5 minutes et l\'argent est à vous !')
	-- TriggerClientEvent('fl_bank:startDrill', source)
	TriggerClientEvent('fl_bank:currentlyRobbing', source, RobbingBank)
	Config.Banks[RobbingBank].LastRobbed = os.time()
	Robbers[source] = RobbingBank
	local savedSource = source
	SetTimeout(600000, function()
		if Robbers[savedSource] then
			CurrentlyRobbing = false
			TriggerClientEvent('esx:showNotification', savedSource, '~r~ Braquage terminé.~s~ ~h~ Fuie ! ' .. BankInfo.reward)
			TriggerClientEvent('fl_bank:endHoldUp', savedSource)
			if xPlayer then
				xPlayer.addAccountMoney('black_money', BankInfo.reward)
				SendNotificationToCops('~r~Braquage terminé à ~b~' .. BankInfo.nameofbank, RobbingBank)
			end
		end
	end)
end)

function GetNumberOfCops()
	local xPlayers = ESX.GetPlayers()
	local cops = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
	return cops
end

function SendNotificationToCops(msg, RobbingBank)
	for _, xPlayerPolice in pairs(ESX.GetPlayersWithJob('police')) do
		xPlayerPolice.showNotification(msg)

		if CurrentlyRobbing then
			xPlayerPolice.triggerEvent('fl_bank:setBlip', RobbingBank)
		else
			xPlayerPolice.triggerEvent('fl_bank:killBlip')
		end
	end
end
