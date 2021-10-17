if GetCurrentResourceName() == 'es_extended' then return end
ESX = nil

Citizen.CreateThread(function()
	repeat
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	until ESX

	ESX.PlayerData = ESX.GetPlayerData()

	repeat
		Citizen.Wait(0)
	until ESX.PlayerData.job

	ESX.PlayerLoaded = true
	StartJobThread(ESX.PlayerData.job.name)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	StartJobThread(job.name)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

AddEventHandler('esx:changedPlayerData', function(UpdatedPlayerData)
	ESX.PlayerData = UpdatedPlayerData
end)

local JobLoop = {}
local JobLoopRunning = {}

CreateJobLoop = function(jobName, func)
	if type(jobName) ~= 'string' then error('jobName must be a string') end
	if type(func) ~= 'function' then error('func must be a function') end

	if JobLoop[jobName] == nil then JobLoop[jobName] = {} end

	table.insert(JobLoop[jobName], func)

	if JobLoopRunning[jobName] then
		print('[JobLoop] Started specific job thread (' .. jobName .. ')')
		StartSpecificJobThread(jobName, func)
	elseif ESX and ESX.PlayerData.job and jobName == ESX.PlayerData.job.name then
		print('[JobLoop] Recovered lost JobThread (' .. jobName .. ')')
		StartJobThread(jobName)
	end
end

function StartJobThread(jobName)
	if type(jobName) ~= 'string' then error('jobName must be a string') end
	if JobLoop[jobName] == nil then return end
	if ESX.PlayerData.job.name ~= jobName then return end
	if JobLoopRunning[jobName] then return end

	print('[JobLoop] StartJobThread(' .. jobName .. ')')
	JobLoopRunning[jobName] = true

	for _, func in pairs(JobLoop[jobName]) do
		StartSpecificJobThread(jobName, func)
	end
end

function StartSpecificJobThread(jobName, func)
	if type(jobName) ~= 'string' then error('jobName must be a string') end
	if type(func) ~= 'function' then error('func must be a function') end

	Citizen.CreateThread(function()
		while ESX.PlayerData.job.name == jobName do
			Citizen.Wait(0)
			func()
		end

		if JobLoopRunning[jobName] then
			print('[JobLoop] JobThread(' .. jobName .. ') ended.')
			JobLoopRunning[jobName] = false
		end
	end)
end