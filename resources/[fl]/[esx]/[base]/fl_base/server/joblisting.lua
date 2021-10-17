ESX.RegisterServerCallback('fl_joblisting:getJobsList', function(xPlayer, source, cb)
	MySQL.Async.fetchAll(
		'SELECT * FROM jobs WHERE whitelisted = false',
		{},
		function(result)
			local data = {}
			for i=1, #result, 1 do
				table.insert(data, {
					value = result[i].name,
					label = result[i].label,
				})
			end
			cb(data)
		end
	)
end)

RegisterNetEvent('fl_joblisting:setJob')
AddEventHandler('fl_joblisting:setJob', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setJob(job, 0)
end)
