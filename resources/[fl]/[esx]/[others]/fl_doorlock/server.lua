local doorInfo = {}

ESX.RegisterServerCallback('fl_doorlock:getUsergroup', function(xPlayer, source, cb)
     cb(xPlayer.getGroup())
end)

RegisterNetEvent('fl_doorlock:updateState')
AddEventHandler('fl_doorlock:updateState', function(doorID, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(doorID) ~= 'number' then
		print(('fl_doorlock: %s didn\'t send a number!'):format(xPlayer.discord))
		return
	end

	if type(state) ~= 'boolean' then
		print(('fl_doorlock: %s attempted to update invalid state!'):format(xPlayer.discord))
		return
	end

	if not Config.DoorList[doorID] then
		print(('fl_doorlock: %s attempted to update invalid door!'):format(xPlayer.discord))
		return
	end

	if not IsAuthorized(xPlayer.getGroup(), xPlayer.job.name, xPlayer.faction.name, Config.DoorList[doorID]) then
		print(('fl_doorlock: %s was not authorized to open a locked door!'):format(xPlayer.discord))
		return
	end

	doorInfo[doorID] = state

	TriggerClientEvent('fl_doorlock:setState', -1, doorID, state)
end)

ESX.RegisterServerCallback('fl_doorlock:getDoorInfo', function(xPlayer, source, cb)
	cb(doorInfo)
end)

function IsAuthorized(groupName, jobName, faction, doorID)
	if groupName == 'mod' or groupName == 'admin' or groupName == 'superadmin' or groupName == 'owner' or groupName == '_dev' then
		return true
	end

	for _,job in pairs(doorID.authorizedJobs) do
		if job == jobName or job == faction then
			return true
		end
	end

	return false
end

ESX.RegisterCommand('debug_detectdoor', 'mod', function(xPlayer, args, showError)
	xPlayer.triggerEvent('fl_doorlock:debug')
end, true, {})