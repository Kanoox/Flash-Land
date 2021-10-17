function getMaximumGrade(jobname)
	if jobname == nil then error('jobname is nil') end

	local maxGrade = 0
	for grade,gradeData in pairs(ESX.GetJob(jobname).grades) do
		if tonumber(grade) > maxGrade then
			maxGrade = tonumber(grade)
		end
	end

	return maxGrade
end

function getAdminCommand(name)
	for i = 1, #Config.Admin, 1 do
		if Config.Admin[i].name == name then
			return i
		end
	end

	return false
end

function isAuthorized(index, group)
	for i = 1, #Config.Admin[index].groups, 1 do
		if Config.Admin[index].groups[i] == group then
			return true
		end
	end

	return false
end

-- Admin Menu --
RegisterNetEvent('fl_menu:Admin_Move')
AddEventHandler('fl_menu:Admin_Move', function(targetId, sourceId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('bring'), plyGroup) or isAuthorized(getAdminCommand('goto'), plyGroup) then
		local targetCoords = nil
		if sourceId then
			targetCoords = GetEntityCoords(GetPlayerPed(sourceId))
		else
			targetCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
		end

		SetEntityCoords(GetPlayerPed(targetId), targetCoords)
	end
end)

RegisterNetEvent('fl_menu:Admin_give')
AddEventHandler('fl_menu:Admin_give', function(account, money)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('givemoney'), plyGroup) then
		xPlayer.addAccountMoney(account, money)
		xPlayer.showNotification('GIVE de ' .. money .. '$ ' .. account)
	end
end)

-- Grade Menu --
RegisterNetEvent('fl_menu:Boss_promouvoirplayer')
AddEventHandler('fl_menu:Boss_promouvoirplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterNetEvent('fl_menu:Boss_destituerplayer')
AddEventHandler('fl_menu:Boss_destituerplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterNetEvent('fl_menu:Boss_recruterplayer')
AddEventHandler('fl_menu:Boss_recruterplayer', function(target, job, grade)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' then
		targetXPlayer.setJob(job, grade)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
	end
end)

RegisterNetEvent('fl_menu:Boss_virerplayer')
AddEventHandler('fl_menu:Boss_virerplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
		targetXPlayer.setJob('unemployed', 0)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end)


-- Pubs personnalisées (DM : Mr_JeJey#8785 si soucis)

RegisterNetEvent("fl_pub:personnalisée")
AddEventHandler("fl_pub:personnalisée", function(txt1, txt2)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local razon = txt1
    local details = txt2
    if xPlayer ~= nil and xPlayer.job.name == 'police' then
        TriggerClientEvent('fl_pub:police', -1, razon, details)
	elseif xPlayer ~= nil and xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('fl_pub:ems', -1, razon, details)
	elseif xPlayer ~= nil and xPlayer.job.name == 'gouv' then
		TriggerClientEvent('fl_pub:gouv', -1, razon, details)
	elseif xPlayer ~= nil and xPlayer.job.name == 'journaliste' then
		TriggerClientEvent('fl_pub:weazle', -1, razon, details)
    else
        xPlayer.showNotification('~r~Vous n\'êtes pas autorisés à exécuter cette commande !')
    end
end, false)
