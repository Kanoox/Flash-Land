local isTalking = false

AddEventHandler('no_hud', function(test)
	TriggerEvent('ui:toggle', test)
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	UpdatePlayerData(ESX.GetPlayerData())

	repeat
		Citizen.Wait(0)
	until NetworkIsSessionStarted()
	SendNUIMessage({action = "toggle", show = true})
end)

AddEventHandler('esx:loadingScreenOff', function()
	UpdatePlayerData(ESX.GetPlayerData())
	SendNUIMessage({action = "toggle", show = true})
end)

function UpdatePlayerData(xPlayer)
	for _,account in pairs(xPlayer.accounts) do
		if account.name == 'money' then
			SendNUIMessage({action = "setValue", key = "money", value = "$"..account.money})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
		end
	end

	local job = xPlayer.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
	local faction = xPlayer.faction
	SendNUIMessage({action = "setValue", key = "faction", value = faction.label.." - "..faction.grade_label, icon = faction.name})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not isTalking then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = "setTalking", value = true})
			end
		else
			if not NetworkIsPlayerTalking(PlayerId()) then
				isTalking = false
				SendNUIMessage({action = "setTalking", value = false})
			end
		end
	end
end)

AddEventHandler('ui:proximity', function(voiceMode)
	SendNUIMessage({action = "setProximity", value = voiceMode}) -- Custom UI Shit
end)

RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == 'money' then
		SendNUIMessage({action = "setValue", key = "money", value = "$"..account.money})
	elseif account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	SendNUIMessage({action = "setValue", key = "faction", value = faction.label.." - "..faction.grade_label, icon = faction.name})
end)

RegisterNetEvent('fl_customui:updateStatus')
AddEventHandler('fl_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)