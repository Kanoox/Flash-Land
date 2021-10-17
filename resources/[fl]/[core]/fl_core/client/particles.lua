local activeID = {}

RegisterCommand('particle', function(source, args, rawCommand)
	local dict = args[1]
	local name = args[2]
	local loop = tostring(args[3])
	local time = tonumber(tostring(args[4]))

	if dict == nil or name == nil then
		Citizen.Trace('[Particles] Invalid arguments.')
		TriggerEvent('chatMessage', '', {255,255,255}, '[Particles] ^8Error: ^1Invalid arguments.')
	else
		local id = math.random(100000, 999999)
		local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.5)
		TriggerServerEvent('fl_particles:sync', id, coords, dict, name, loop == "true" or loop == "1", time)
	end
end, false)

RegisterCommand('particle_wtf', function(source, args, rawCommand)
	local dict = args[1]
	local name = args[2]
	local time = tonumber(args[3])
	local notloop = tonumber(args[4]) == 0
	local timebetween = tonumber(args[5])

	if dict == nil or name == nil or time == nil then
		Citizen.Trace('[Particles] Invalid arguments.')
		TriggerEvent('chatMessage', '', {255,255,255}, '[Particles] ^8Error: ^1Invalid arguments.')
	else
		local id = math.random(100000, 999999)
		for x=0,10 do
			for y=0,10 do
				Citizen.CreateThread(function()
					local xi = (math.random(0, 10) - 5) / 10
					Citizen.Wait(math.random(1, timebetween or 15))
					TriggerServerEvent('fl_particles:sync', id, GetOffsetFromEntityInWorldCoords(PlayerPedId(), x - 5.0 + xi, y - 5.0 + xi, -0.5  + xi), dict, name, notloop, time)
				end)
			end
		end
	end
end, true)

RegisterCommand('particle_disable', function(source, args, rawCommand)
	local id = tonumber(args[1])
	TriggerServerEvent('fl_particles:disable', id)
end, true)

RegisterCommand('particle_disableall', function(source, args, rawCommand)
	TriggerServerEvent('fl_particles:disableall')
end, true)

RegisterNetEvent('fl_particles:disable')
AddEventHandler('fl_particles:disable', function(id)
	activeID[id] = false
end)

RegisterNetEvent('fl_particles:disableall')
AddEventHandler('fl_particles:disableall', function()
	print('disableall')
	for i,v in pairs(activeID) do
		if v then activeID[i] = false end
	end
end)

RegisterNetEvent('fl_particles:sync')
AddEventHandler('fl_particles:sync', function(id, coords, dict, name, loop, time)
	--if activeID[id] == nil or not activeID[id] then
	--	print('NetID: ' .. tostring(id))
	--end

	activeID[id] = true
	RequestNamedPtfxAsset(dict)
	while not HasNamedPtfxAssetLoaded(dict) do
		Citizen.Wait(0)
	end

	UseParticleFxAssetNextCall(dict)
	if loop then
		local particle = StartParticleFxLoopedAtCoord(name, coords, 1.0, 1.0, 1.0, 1.0, false, false)

		if time and time > 0 then
			Citizen.Wait(time * 1000)
		else
			Citizen.Wait(5000)
		end

		StopParticleFxLooped(particle)
	else
		if time and time > 0 then
			repeat
				local particle = StartParticleFxNonLoopedAtCoord(name, coords, 1.0, 1.0, 1.0, 1.0, false, false)
				time = time - 1
				UseParticleFxAssetNextCall(dict)
				Citizen.Wait(600)
			until time <= 0 or not activeID[id]
		else
			StartParticleFxNonLoopedAtCoord(name, coords, 1.0, 1.0, 1.0, 1.0, false, false)
		end
	end
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/particle', 'Spawn a particle 8 meters in front of you.', {{name="dictionary", help="This is the name of the particle dictionary."}, {name="effect", help="This is the name of the particle effect."}, {name="looped", help="True/False (should the animation be looped?)"}})
end)