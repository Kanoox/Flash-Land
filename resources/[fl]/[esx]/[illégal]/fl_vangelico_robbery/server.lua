local rob = false
local robbers = {}
local PlayersCrafting = {}
local CopsConnected  = 0

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterNetEvent('fl_vangelico_robbery:toofar')
AddEventHandler('fl_vangelico_robbery:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Stores[robb].nameofstore)
		end
	end
	if(robbers[source])then
		TriggerClientEvent('fl_vangelico_robbery:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_cancelled') .. Stores[robb].nameofstore)
	end
end)

RegisterNetEvent('fl_vangelico_robbery:endrob')
AddEventHandler('fl_vangelico_robbery:endrob', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	if(robbers[source])then
		TriggerClientEvent('fl_vangelico_robbery:robberycomplete', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_ended') .. Stores[robb].nameofstore)
	end
end)

RegisterNetEvent('fl_vangelico_robbery:rob')
AddEventHandler('fl_vangelico_robbery:rob', function(robb)

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xSource = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < 600 and store.lastrobbed ~= 0 then
			TriggerClientEvent('fl_vangelico_robbery:togliblip', source)
			TriggerClientEvent('esx:showNotification', source, _U('already_robbed') .. (1800 - (os.time() - store.lastrobbed)) .. _U('seconds'))
			return
		end


		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end


		if not rob then

			if(cops >= Config.RequiredCopsRob)then

				rob = true
				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog') .. store.nameofstore)
						TriggerClientEvent('fl_vangelico_robbery:setblip', xPlayers[i], Stores[robb].position)
						--xPlayer.triggerEvent("iCore:getCallMsg", "Un ~b~braquage de bijouterie~s~ est en cours !", Stores[robb].position, xSource)
					end
				end

				TriggerClientEvent('esx:showNotification', source, _U('started_to_rob') .. store.nameofstore .. _U('do_not_move'))
				TriggerClientEvent('esx:showNotification', source, _U('alarm_triggered'))
				TriggerClientEvent('esx:showNotification', source, _U('hold_pos'))
				TriggerClientEvent('fl_vangelico_robbery:currentlyrobbing', source, robb)
				CancelEvent()
				Stores[robb].lastrobbed = os.time()
			else
				TriggerClientEvent('fl_vangelico_robbery:togliblip', source)
				TriggerClientEvent('esx:showNotification', source, _U('min_two_police'))
			end
		else
			TriggerClientEvent('fl_vangelico_robbery:togliblip', source)
			TriggerClientEvent('esx:showNotification', source, _U('robbery_already'))
		end
	end
end)

RegisterNetEvent('fl_vangelico_robbery:gioielli1')
AddEventHandler('fl_vangelico_robbery:gioielli1', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local i = math.random(5, 20)
	if not xPlayer.canCarryItem('jewels', i) then
		TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Vous n\'avez plus de place...')
		return
	end

	xPlayer.addInventoryItem('jewels', i)
end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

local function Craft(source)

	SetTimeout(4000, function()

		if PlayersCrafting[source] and CopsConnected >= Config.RequiredCopsSell then

			local xPlayer = ESX.GetPlayerFromId(source)
			local JewelsQuantity = xPlayer.getInventoryItem('jewels').count

			if JewelsQuantity < 20 then
				TriggerClientEvent('esx:showNotification', source, _U('notenoughgold'))
			else
				xPlayer.removeInventoryItem('jewels', 20)
				Citizen.Wait(5000)
				xPlayer.addAccountMoney('black_money', 4000)

				Craft(source)
			end
		else
			TriggerClientEvent('esx:showNotification', source, _U('copsforsell'))
		end
	end)
end

RegisterNetEvent('lester:vendita')
AddEventHandler('lester:vendita', function()
	local _source = source
	PlayersCrafting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('goldsell'))
	Craft(_source)
end)

RegisterNetEvent('lester:nvendita')
AddEventHandler('lester:nvendita', function()
	local _source = source
	PlayersCrafting[_source] = false
end)

