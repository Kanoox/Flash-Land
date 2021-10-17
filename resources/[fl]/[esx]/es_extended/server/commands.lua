local hideReports = {}

ESX.RegisterCommand({'setcoords', 'tp'}, 'admin', function(xPlayer, args, showError)
	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

ESX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job, args.grade) then
		args.playerId.setJob(args.job, args.grade)
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('setfaction', 'admin', function(xPlayer, args, showError)
	if ESX.DoesFactionExist(args.faction, args.grade) then
		args.playerId.setFaction(args.faction, args.grade)
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'faction', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand({'car', 'spawncar', 'moto', 'spawnmoto'}, 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:spawnCar', args.car)
end, false, {help = _U('command_car'), validate = false, arguments = {
	{name = 'car', help = _U('command_car_car'), type = 'any'}
}})

ESX.RegisterCommand({'cardel', 'dv'}, 'mod', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:deleteVehicle', args.radius)
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _U('command_cardel_radius'), type = 'any'}
}})

ESX.RegisterCommand('setaccountmoney', 'admin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveaccountmoney', 'admin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('givemoney', 'admin', function(xPlayer, args, showError)
	if args.playerId.getAccount('money') then
		args.playerId.addAccountMoney('money', args.amount)
		xPlayer.sendChatMessage('Money give avec succès')
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand({'giveitem', 'give'}, 'admin', function(xPlayer, args, showError)
	args.playerId.addInventoryItem(args.item, args.count)
	xPlayer.sendChatMessage('Item give avec succès')
end, true, {help = _U('command_giveitem'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
	{name = 'count', help = _U('command_giveitem_count'), type = 'number'}
}})

ESX.RegisterCommand({'clear', 'cls', 'clearall'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = _U('command_clear')})

ESX.RegisterCommand({'_clearall', 'debug_clearall', 'clsall'}, 'admin', function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = _U('command_clearall')})

ESX.RegisterCommand('clearinventory', 'admin', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
		end
	end
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('setgroup', 'admin', function(xPlayer, args, showError)
	args.playerId.setGroup(args.group)
end, true, {help = _U('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'},
}})

ESX.RegisterCommand('save', 'admin', function(xPlayer, args, showError)
	args.playerId.save(function()
		xPlayer.sendChatMessage('Joueur sauvegardé')
	end)
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('saveall', 'admin', function(xPlayer, args, showError)
	ESX.SavePlayers()
	xPlayer.sendChatMessage('Joueurs sauvegardés')
end, true, {help = _U('command_saveall')})

ESX.RegisterCommand('revive', 'mod', function(xPlayer, args, showError)
	TriggerClientEvent('fl_ambulancejob:revive', args.playerId.source)
end, true, {help = 'Revive un joueur', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand('skinadmin', 'admin', function(xPlayer, args, showError)
	TriggerClientEvent('fl_skin:openSaveableAdminMenu', args.playerId.source)
end, true, {help = 'Skinadmin (debug)', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand({'skinfor', 'skin'}, 'mod', function(xPlayer, args, showError)
	TriggerClientEvent('fl_skin:openSaveableMenu', args.playerId.source)
	xPlayer.sendChatMessage('Ouverture du menu skin pour ' .. args.playerId.getName())
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('stuck', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:stuck')
end, true, {help = _U('command_save'), validate = true, arguments = {}})

ESX.RegisterCommand('report', 'user', function(xPlayer, args, showError)
	TriggerClientEvent('chatMessage', xPlayer.source, "REPORT", {255, 0, 0}, " (^2" .. xPlayer.getName() .." | "..xPlayer.source.."^0) " .. table.concat(args, " "))
	for _,anyXPlayer in pairs(ESX.GetAllPlayers()) do
		if IsPlayerAceAllowed(anyXPlayer.source, 'command') and anyXPlayer ~= xPlayer and not hideReports[anyXPlayer.source] then
			TriggerClientEvent('chatMessage', anyXPlayer.source, "REPORT", {255, 0, 0}, " (^2" .. xPlayer.getName() .." | "..xPlayer.source.."^0) " .. table.concat(args, " "))
		end
	end
end, true, {help = 'Report au staff'})

ESX.RegisterCommand('annonce', 'admin', function(xPlayer, args, showError)
	if #args > 0 then
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(214, 168, 0, 1); border-radius: 3px;"><i class="fas fa-ad"></i> Annonce:<br> {1}<br></div>',
			args = { xPlayer.getName(), table.concat(args, " ") }
		})
	else
		showError('Donnez un message pour votre annonce...')
	end
end, true, {help = 'Passer une annonce globale'})

local response = {}
ESX.RegisterCommand('msg', 'mod', function(xPlayer, args, showError)
	TriggerEvent('esx:sendMessage', xPlayer.source, args)
end, true, {help = 'Envoyer un msg à un joueur'})

AddEventHandler('esx:sendMessage', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(args[1])
	if #args >= 2 or not xPlayerTarget then
		local msg = args
		table.remove(msg, 1)

		response[xPlayer.source] = xPlayerTarget.source
		response[xPlayerTarget.source] = xPlayer.source

		TriggerClientEvent('chatMessage', xPlayerTarget.source, "MSG", {255, 0, 0}, " (^2" .. xPlayer.getName()  .." | "..xPlayer.source.." ^0) " .. table.concat(msg, " "))
		TriggerClientEvent('chatMessage', xPlayer.source, "MSG", {255, 0, 0}, " (^2" .. xPlayerTarget.getName()  .." | "..xPlayerTarget.source.."^0) " .. table.concat(msg, " "))
	else
		xPlayer.sendChatMessage("ID de joueur incorrect !", "FreeLife", {255, 0, 0})
	end
end)

ESX.RegisterCommand('r', 'user', function(xPlayer, args, showError)
	if response[xPlayer.source] == nil then
		TriggerClientEvent('chatMessage', xPlayer.source, "MSG", {255, 0, 0}, "Personne à qui répondre ...")
		return
	end

	local xPlayerTarget = ESX.GetPlayerFromId(response[xPlayer.source])

	TriggerClientEvent('chatMessage', xPlayerTarget.source, "MSG", {255, 0, 0}, " (^2" .. xPlayer.getName()  .." | "..xPlayer.source.." ^0) " .. table.concat(args, " "))
	TriggerClientEvent('chatMessage', xPlayer.source, "MSG", {255, 0, 0}, " (^2" .. xPlayerTarget.getName()  .." | "..xPlayerTarget.source.."^0) " .. table.concat(args, " "))
end, true, {help = 'Envoyer un msg à un joueur'})

ESX.RegisterCommand('kick', 'mod', function(xPlayer, args, showError)
	if args[1] or not GetPlayerName(tonumber(args[1]))then
		local xPlayerTarget = ESX.GetPlayerFromId(args[1])

		local reason = args
		table.remove(reason, 1)
		if #reason == 0 then
			reason = "Kick: Vous avez été kick du serveur !"
		else
			reason = "Kick: " .. table.concat(reason, " ")
		end

		TriggerEvent('fl_discord_bot:kick', xPlayer.getName(), xPlayerTarget.getName(), reason)

		for _,anyXPlayer in pairs(ESX.GetAllPlayers()) do
			if IsPlayerAceAllowed(anyXPlayer.source, 'command') then
				anyXPlayer.sendChatMessage("^2" .. xPlayerTarget.getName() .. "^0 a été kick par ^2" .. xPlayer.getName() .. "^0 (^2" .. reason .. "^0)", "FreeLife", {255, 0, 0})
			end
		end
		xPlayerTarget.kick(reason)
	else
		xPlayer.sendChatMessage("ID de joueur incorrect !", "FreeLife", {255, 0, 0})
	end
end, true, {help = 'Kick'})

ESX.RegisterCommand('bring', 'mod', function(xPlayer, args, showError)
	SetEntityCoords(GetPlayerPed(args.playerId.source), xPlayer.getCoords(true), 0, 0, 0, 0)
	TriggerClientEvent('chatMessage', args.playerId.source, "FreeLife", {255, 0, 0}, "Vous avez teleporté par ^2" .. xPlayer.getName())
	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Player ^2" .. args.playerId.getName() .. "^0 a été teleporté")
end, true, {help = 'Téléporter un joueur à soi', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand({'bringall', 'tpall'}, 'superadmin', function(xPlayer, args, showError)
	for _,anyXPlayer in pairs(ESX.GetAllPlayers()) do
		if anyXPlayer ~= xPlayer then
			SetEntityCoords(GetPlayerPed(anyXPlayer.source), xPlayer.getCoords(true), 0, 0, 0, 0)
			TriggerClientEvent('chatMessage', anyXPlayer.source, "FreeLife", {255, 0, 0}, "Vous avez teleporté par ^2" .. xPlayer.getName())
			TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Player ^2" .. anyXPlayer.getName() .. "^0 a été teleporté")
		end
	end
end, true, {help = 'Bring all players', validate = true, arguments = {}})

ESX.RegisterCommand('goto', 'mod', function(xPlayer, args, showError)
	SetEntityCoords(xPlayer.source, args.playerId.getCoords(true), 0, 0, 0, 0)
	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Téléporté au joueur ^2" .. args.playerId.getName() .. "")
end, true, {help = 'Se téléporter à un joueur', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand('reviveall', 'mod', function(xPlayer, args, showError)
	TriggerClientEvent('fl_ambulancejob:revive', -1)
	TriggerClientEvent('chatMessage', xPlayer.source, "", {0,0,0}, "Revive de tous les joueurs...")
end, true, {help = 'Revive tous les joueurs', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand('die', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:setHealth', 0)
	TriggerClientEvent('chatMessage', xPlayer.source, "", {0,0,0}, "^1^*Tu t'es tué.")
end, true, {help = 'Suicide', validate = true, arguments = {}})

ESX.RegisterCommand({'slay', 'kill'}, 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:setHealth', 0)
	TriggerClientEvent('chatMessage', xPlayer.source, "", {0,0,0}, "^1^*Tu as tué " .. args.playerId.getName())
end, true, {help = 'Tuer un joueur', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand({'slayall', 'killall'}, 'superadmin', function(xPlayer, args, showError)
	for _,anyXPlayer in pairs(ESX.GetAllPlayers()) do
		if anyXPlayer ~= xPlayer then
			anyXPlayer.triggerEvent('esx:setHealth', 0)
			TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Le joueur ^2" .. anyXPlayer.getName() .. "^0 a été tué.")
		end
	end
end, true, {help = 'Tuer tous les joueurs', validate = true, arguments = {}})

ESX.RegisterCommand('heal', 'mod', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:setHealth', 200)
	TriggerClientEvent('chatMessage', args.playerId.source, "FreeLife", {255, 0, 0}, "Vous avez été soigné par ^2" .. xPlayer.getName())
	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Le joueur ^2" .. args.playerId.getName() .. "^0 a été soigné.")
end, true, {help = 'Heal un joueur', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand('freeze', 'mod', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:freeze')
	TriggerClientEvent('chatMessage', args.playerId.source, "FreeLife", {255, 0, 0}, "Vous avez été freeze par ^2" .. xPlayer.getName())
	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Le joueur ^2" .. args.playerId.getName() .. "^0 a été freeze.")
end, true, {help = 'Freeze un joueur', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand({'destroyvehicle'}, 'mod', function(xPlayer, args, showError)
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(args.playerId.source), false)
	args.playerId.triggerEvent('esx:setVehicleProps', NetworkGetNetworkIdFromEntity(vehicle), {
		bodyHealth = 0,
		engineHealth = 0,
		tankHealth = 0,
	})

	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Le joueur ^2" .. args.playerId.getName() .. "^0 a maintenant un véhicule détruit")
end, true, {help = 'Défini le modèle d\'un joueur', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
}})

ESX.RegisterCommand({'setmodel', 'playermodel'}, 'mod', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:setPlayerModel', args.model)
	TriggerClientEvent('chatMessage', args.playerId.source, "FreeLife", {255, 0, 0}, "Votre modèle à changer grâce à ^2" .. xPlayer.getName())
	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Le joueur ^2" .. args.playerId.getName() .. "^0 a changer de modèle")
end, true, {help = 'Défini le modèle d\'un joueur', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'model', help = 'Modèle', type = 'string'},
}})

ESX.RegisterCommand('setped', 'mod', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:setPlayerModel', args.model)
	TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Votre modèle a changé grâce à ^2" .. xPlayer.getName())
end, true, {help = 'Défini son model de joueur', validate = true, arguments = {
	{name = 'model', help = 'Modèle', type = 'string'},
}})

ESX.RegisterCommand('healall', 'superadmin', function(xPlayer, args, showError)
	for _,anyXPlayer in pairs(ESX.GetAllPlayers()) do
		if anyXPlayer ~= xPlayer then
			anyXPlayer.triggerEvent('esx:setHealth', 200)
			TriggerClientEvent('chatMessage', anyXPlayer.source, "FreeLife", {255, 0, 0}, "Vous avez été soigné par ^2" .. xPlayer.getName())
			TriggerClientEvent('chatMessage', xPlayer.source, "FreeLife", {255, 0, 0}, "Le joueur ^2" .. anyXPlayer.getName() .. "^0 a été soigné.")
		end
	end
end, true, {help = 'Heal tous les joueurs', validate = true, arguments = {}})

RegisterNetEvent('es_extended:displayReports')
AddEventHandler('es_extended:displayReports', function(displayReports)
	if displayReports then
		TriggerClientEvent('chatMessage', source, "FreeLife", {255, 0, 0}, "Les reports sont actuellement affichés")
		hideReports[source] = false
	else
		TriggerClientEvent('chatMessage', source, "FreeLife", {255, 0, 0}, "Les reports sont actuellement cachés")
		hideReports[source] = true
	end
end)
