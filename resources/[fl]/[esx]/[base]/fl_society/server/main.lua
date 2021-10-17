local Jobs = {}
local RegisteredSocieties = {}

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end

	if name ~= 'unemployed' then
		--print('[society:GetSociety] Unknown society : ' .. tostring(name))
	end
end
exports("GetSociety", GetSociety);

MySQL.ready(function()
	local resultJobs = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #resultJobs, 1 do
		Jobs[resultJobs[i].name] = resultJobs[i]
		Jobs[resultJobs[i].name].grades = {}
	end

	local resultJobGrades = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #resultJobGrades, 1 do
		Jobs[resultJobGrades[i].job_name].grades[tostring(resultJobGrades[i].grade)] = resultJobGrades[i]
	end

	for SocietyName, SocietyLabel in pairs(Config.Societies) do
		local society = {
			name = SocietyName,
			label = SocietyLabel,
			account = 'society_' .. SocietyName,
			datastore = 'society_' .. SocietyName,
			inventory = 'society_' .. SocietyName,
			data = {},
		}

		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('fl_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('fl_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterNetEvent('fl_society:withdrawMoney')
AddEventHandler('fl_society:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if not xPlayer then
		error('No xPlayer')
	end

	if not society then
		error('No society')
	end

	if xPlayer.job.name ~= society.name then
		print(('fl_society: %s attempted to call withdrawMoney!'):format(xPlayer.discord))
		return
	end

	TriggerEvent('fl_data:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			xPlayer.showNotification(_U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	end)
end)

RegisterNetEvent('fl_society:depositMoney')
AddEventHandler('fl_society:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('fl_society: %s attempted to call depositMoney!'):format(xPlayer.discord))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('fl_data:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		xPlayer.showNotification(_U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		xPlayer.showNotification(_U('invalid_amount'))
	end
end)

RegisterNetEvent('fl_society:putVehicleInGarage')
AddEventHandler('fl_society:putVehicleInGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('fl_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterNetEvent('fl_society:removeVehicleFromGarage')
AddEventHandler('fl_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('fl_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('fl_society:getSocietyMoney', function(xPlayer, source, cb, societyName)
	local society = GetSociety(societyName)

	if societyName == 'unemployed' then
		cb(0)
		return
	end

	if society then
		TriggerEvent('fl_data:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		if societyName ~= 'unemployed' then
		--	print('[society:getSocietyMoney] Unknown society : ' .. tostring(societyName))
		end
		cb(0)
	end
end)

ESX.RegisterServerCallback('fl_society:getSocietyLabel', function(xPlayer, source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		cb(society.label)
	else
	--	print('[society:getSocietyLabel] Unknown society : ' .. tostring(societyName))
		cb('?ERROR?')
	end
end)

ESX.RegisterServerCallback('fl_society:getEmployees', function(xPlayer, source, cb, society)
	MySQL.Async.fetchAll('SELECT firstname, lastname, discord, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = society
	}, function (results)
		local employees = {}

		for i=1, #results, 1 do
			table.insert(employees, {
				name = results[i].firstname .. ' ' .. results[i].lastname,
				discord = results[i].discord,
				job = {
					name = results[i].job,
					label = Jobs[results[i].job].label,
					grade = results[i].job_grade,
					grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
					grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)

ESX.RegisterServerCallback('fl_society:getJob', function(xPlayer, source, cb, society)
	local job = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)


ESX.RegisterServerCallback('fl_society:setJob', function(xPlayer, source, cb, discord, job, grade, type)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromDiscordIdentifier(discord)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getJob().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE discord = @discord', {
				['@job'] = job,
				['@job_grade'] = grade,
				['@discord'] = discord
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('fl_society: %s attempted to setJob'):format(xPlayer.discord))
		cb()
	end
end)

ESX.RegisterServerCallback('fl_society:setJobSalary', function(xPlayer, source, cb, job, grade, salary)
	local isBoss = isPlayerBoss(source, job)

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary'] = salary,
				['@job_name'] = job,
				['@grade'] = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer.job.name == job and xPlayer.job.grade == grade then
						xPlayer.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('fl_society: %s attempted to setJobSalary over config limit!'):format(xPlayer.discord))
			cb()
		end
	else
		print(('fl_society: %s attempted to setJobSalary'):format(xPlayer.discord))
		cb()
	end
end)

ESX.RegisterServerCallback('fl_society:getOnlinePlayers', function(xPlayer, source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source = xPlayer.source,
			discord = xPlayer.discord,
			name = xPlayer.name,
			job = xPlayer.job
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback('fl_society:getVehiclesInGarage', function(xPlayer, source, cb, societyName)
	local society = GetSociety(societyName)

	TriggerEvent('fl_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('fl_society:isBoss', function(xPlayer, source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('fl_society: %s attempted open a society boss menu!'):format(xPlayer.discord))
		return false
	end
end
