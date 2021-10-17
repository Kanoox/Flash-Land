local Status = {}
local StatusIsReady = false

function GetStatusData(minimal)
	local status = {}

	for _, anyStatus in pairs(Status) do
		if minimal then
			status[anyStatus.name] = anyStatus.val
		else
			table.insert(status, {
				name = anyStatus.name,
				val = anyStatus.val,
				color = anyStatus.color,
				visible = anyStatus.visible(anyStatus),
			})
		end
	end

	return status
end

RegisterNetEvent('fl_status:load')
AddEventHandler('fl_status:load', function(status)
	local hungerStatus = CreateStatus('hunger', 1000000, '#8c0606', function(_) return false end, function(hungerStatus) hungerStatus.remove(200) end)
	Status['hunger'] = hungerStatus

	local thirstStatus = CreateStatus('thirst', 1000000, '#0519a9', function(_) return false end, function(thirstStatus) thirstStatus.remove(250) end)
	Status['thirst'] = thirstStatus

	local drunkStatus = CreateStatus('drunk', 0, '#8F15A5', function(drunkStatus)
		if drunkStatus.val > 0 then return false else return false end
	end, function(drunkStatus) drunkStatus.remove(5000) end)
	Status['drunk'] = drunkStatus

	if status == nil or status == {} then
		print('had to reset because of invalid data : ' .. ESX.Dump(status))
		for statusName, anyStatus in pairs(Status) do
			anyStatus.set(Config.StatusMax / 2)
		end
		Status['drunk'].set(0)
	else
		for statusName, anySavedStatus in pairs(status) do
			Status[statusName].set(anySavedStatus)
		end
	end

	StatusIsReady = true
	Citizen.CreateThread(function()
		while true do
			for _, anyStatus in pairs(Status) do
				anyStatus.onTick()
			end

			TriggerEvent('fl_customui:updateStatus', GetStatusData(true))
			Citizen.Wait(Config.TickTime)
		end
	end)
end)

RegisterNetEvent('fl_status:set')
AddEventHandler('fl_status:set', function(name, val)
	Status[name].set(val)
end)

RegisterNetEvent('fl_status:add')
AddEventHandler('fl_status:add', function(name, val)
	Status[name].add(val)
end)

RegisterNetEvent('fl_status:remove')
AddEventHandler('fl_status:remove', function(name, val)
	Status[name].remove(val)
end)

AddEventHandler('fl_status:getStatus', function(name, cb)
	cb(Status[name])
end)

AddEventHandler('baseevents:onPlayerWasted', function()
	TriggerEvent('fl_status:set', 'hunger', 500000)
	TriggerEvent('fl_status:set', 'thirst', 500000)
end)

Citizen.CreateThread(function()
	repeat Citizen.Wait(1000) until StatusIsReady
	while true do
		TriggerServerEvent('fl_status:update', GetStatusData(true))
		Citizen.Wait(Config.UpdateInterval)
	end
end)


local DrunkLevel = -1

function Drunk(level)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()

		SetTimecycleModifier("spectator5")
		SetTimecycleModifierStrength(1.0)
		SetPedMotionBlur(playerPed, true)
		SetPedIsDrunk(playerPed, true)

		if DrunkLevel < 0 then
			DoScreenFadeOut(800)
			Citizen.Wait(15)
		end

		if level == 0 then
			SetTimecycleModifier("spectator9")

			ESX.Streaming.RequestAnimSet("move_m@drunk@slightlydrunk")
			SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
		elseif level == 1 then
			ESX.Streaming.RequestAnimSet("move_m@drunk@moderatedrunk")
			SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
		elseif level == 2 then
			ESX.Streaming.RequestAnimSet("move_m@drunk@verydrunk")
			SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)

			SetTimecycleModifier("BarryFadeOut")
			SetTimecycleModifierStrength(0.5)
		end

		if DrunkLevel < 0 then
			Reality()
		end

	end)
end

function Reality()
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)
	Citizen.Wait(15)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(playerPed, 0)
	SetPedIsDrunk(playerPed, false)
	SetPedMotionBlur(playerPed, false)
	DoScreenFadeIn(800)
end

Citizen.CreateThread(function()
	repeat Citizen.Wait(1000) until StatusIsReady
	while true do
		Wait(1000)
		local playerPed = PlayerPedId()
		local prevHealth = GetEntityHealth(playerPed)
		local health = prevHealth

		if Status['hunger'].val == 0 then
			health = health - 5
		end

		if Status['thirst'].val == 0 then
			health = health - 5
		end

		if health ~= prevHealth then
			SetEntityHealth(playerPed, health)
		end

		if Status['drunk'].val > 0 then
			local level = 0

			if Status['drunk'].val <= 30000 then
				level = -1
			elseif Status['drunk'].val <= 300000 then
				level = 0
			elseif Status['drunk'].val <= 600000 then
				level = 1
			else
				level = 2
			end

			if level ~= DrunkLevel then
				Drunk(level)
			end

			DrunkLevel = level
		else
			if DrunkLevel > 0 then
				Reality()
			end

			DrunkLevel = -1
		end
	end
end)
