RegisterNetEvent('chat:init')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('_chat:messageEntered')
RegisterNetEvent('chat:clear')
RegisterNetEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
	if not message or not author then
		return
	end

	TriggerEvent('chatMessage', source, author, message)
	print(author .. '^7: ' .. message .. '^7')
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
	TriggerEvent('chatMessage', source, GetPlayerName(source), '/' .. command)
	CancelEvent()
end)

-- command suggestions for clients
local function refreshCommands(player)
	if GetRegisteredCommands then
		local registeredCommands = GetRegisteredCommands()

		local suggestions = {}

		for _, command in ipairs(registeredCommands) do
			if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
				table.insert(suggestions, {
					name = '/' .. command.name,
					help = ''
				})
			end
		end

		TriggerClientEvent('chat:addSuggestions', player, suggestions)
	end
end

AddEventHandler('chat:init', function()
	refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
	Wait(500)

	for _, player in ipairs(GetPlayers()) do
		refreshCommands(player)
	end
end)
