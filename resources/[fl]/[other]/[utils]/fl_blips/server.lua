-- how many milliseconds to wait before sending updates to all players again
-- based on player count for key, so you can slow down updates depending on how many players are connected
-- for 5 updates per second use 1000 / 5
local updateIntervals = {
	[0] = 1000          -- once every second    | during 0-64 players
}

-- how many milliseconds to wait before sending an update to the next player in-loop
-- example: player A gets sent an update, server waits X milliseconds before sending to player B
-- can be useful for bandwidth reasons
local updateSpacing = 10

-- debug threshold limits
-- if enabled, it will notify you via server console that the server isn't meeting performance expectations
-- this is usually due to improper interval configuration that doesn't match your servers hardware

-- its recommended to leave this disabled unless you're testing high player counts or similar
-- since it can be used to identify if the script can "keep up" with the player count
local threadTimeWarnings = true
local mainThreadTimeThreshold = 10          -- parent thread
local updateThreadTimeThreshold = 10        -- blip updates thread

local lastBlipsUpdate = {}
local lastIntervalValue = 0

local permManagement = {}

function math.clamp(low, n, high)
	return math.min(math.max(n, low), high)
end

Citizen.CreateThread(function()
	for _, source in ipairs(GetPlayers()) do
		permManagement[tonumber(source)] = IsPlayerAceAllowed(source, 'vMenu.MiscSettings') or IsPlayerAceAllowed(source, 'vMenu.MiscSettings.All')
	end
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	permManagement[tonumber(source)] = IsPlayerAceAllowed(source, 'vMenu.MiscSettings') or IsPlayerAceAllowed(source, 'vMenu.MiscSettings.All')
end)

-- emitted when a player leaves the server
AddEventHandler("playerDropped", function()
	permManagement[tonumber(source)] = nil
	TriggerClientEvent("_bigmode:evaluateBlips", -1, source)
end)

-- this is the main update thread for pushing blip location updates to players
Citizen.CreateThread(function()
	while true do
		local mt_begin = GetGameTimer()

		-- get and store all of the currently-connected players
		local players = GetPlayers()


		-- iterate through the configured intervals and find the one that
		-- best suits the current number of players
		local updateInterval = 0
		local updateIntervalLimit = 0
		for limit, interval in pairs(updateIntervals) do
			if(limit <= #players) then
				updateInterval = interval
				updateIntervalLimit = limit
			end
		end

		if(lastIntervalValue ~= updateIntervalLimit) then
			lastIntervalValue = updateIntervalLimit
			print(string.format("[^2BigMode^7] Updated blip update interval to ^2%dms (%d) ^7due to ^2%d ^7players being connected.", updateInterval, updateIntervalLimit, #players))
		end

		if #players > 0 then

			-- this is where the heavy-lifting is done in the loop
			-- so we create a new thread so we can quickly move-on without waiting
			Citizen.CreateThread(function()
				local up_begin = GetGameTimer()

				players = GetPlayers()

				-- iterate through the players table above and build an event object
				-- that includes the players' server ID and their in-game position
				local blips = {}
				local vehicles = {
					[0] = 0,
				}
				for index, player in ipairs(players) do
					local playerPed = GetPlayerPed(player)

					-- check if ped exists to refrain from iterating potentially invalid player entities
					-- causes some players to not have blips if not double-checked
					if DoesEntityExist(playerPed) then
						local vehicle = GetVehiclePedIsIn(playerPed, false)
						local model = 0
						if vehicle ~= 0 then
							model = GetEntityModel(vehicle)
							if vehicles[vehicle] == nil then
								vehicles[vehicle] = 1
							else
								vehicles[vehicle] = vehicles[vehicle] + 1
							end
						end

						-- build the blip object
						local obj = {
							player,
							NetworkGetNetworkIdFromEntity(playerPed),
							GetPlayerName(player),
							GetEntityCoords(playerPed),
							math.ceil(GetEntityHeading(playerPed)),
							model,
							vehicle,
							0, -- Number of passenger
						}

						table.insert(blips, obj)
					end
				end
				for i, obj in pairs(blips) do
					--print(obj[7])
					obj[8] = vehicles[obj[7]]
					--print(obj[8])
				end

				-- create another thread to quickly move-on to the next tick
				Citizen.CreateThread(function()
					for index, player in ipairs(players) do
						if(DoesEntityExist(GetPlayerPed(player))) then
							local final = {}

							-- filter-out the players' blip from the blips array being sent
							for index, blip in ipairs(blips) do
								if(blip[1] ~= player) then
									table.insert(final, blip)
								end
							end

							if permManagement[tonumber(player)] == nil then
								permManagement[tonumber(player)] = IsPlayerAceAllowed(player, 'vMenu.MiscSettings') or IsPlayerAceAllowed(player, 'vMenu.MiscSettings.All')
							end

							if permManagement[tonumber(player)] then
								TriggerClientEvent("_bigmode:updateBlips", player, final)
							end

							Citizen.Wait(math.clamp(10, updateSpacing, 100))
						end
					end
				end)

				lastBlipsUpdate = blips

				-- if threadTimeWarnings is enabled, then calculate the time it took to run this thread
				-- and if its above the threshold then send a warning to the server console
				if(threadTimeWarnings) then
					local up_loopTime = GetGameTimer() - up_begin
					if(up_loopTime > updateThreadTimeThreshold) then
						print(string.format("[^2BigMode^7] Update thread loopTime: ^3%i ms ^7(your server is ^1lagging ^7or ^3updateThreadTimeThreshold ^7is too low)", up_loopTime))
					end
				end
			end)
		end

		-- if threadTimeWarnings is enabled, then calculate the time it took to run this thread
		-- and if its above the threshold then send a warning to the server console
		if(threadTimeWarnings) then
			local mt_loopTime = GetGameTimer() - mt_begin
			if(mt_loopTime > mainThreadTimeThreshold) then
				print(string.format("[^2BigMode^7] Main thread loopTime: ^1%i ms ^7(your server is ^1lagging ^7or ^1mainThreadTimeThreshold ^7is too low)", mt_loopTime))
			end
		end

		Citizen.Wait(updateInterval)
	end
end)

ESX.RegisterCommand('debug_blips', 'admin', function(xPlayer, args, showError)
	print(ESX.Dump(permManagement))
	xPlayer.triggerEvent('fl_blips:debug')
end, true, {help = 'Test debugblips', validate = true, arguments = {}})