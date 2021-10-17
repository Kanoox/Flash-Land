local function getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer.firstname .. ' ' .. xPlayer.lastname
end

RegisterServerEvent("ruben:sendMessageWebhookPub")
AddEventHandler("ruben:sendMessageWebhookPub", function(webhook,message)
    webhook = "MODIFIEZ MOI"
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end)

-- Events
ESX.RegisterServerCallback('fl_society:getAdsType', function(xPlayer, source, cb)
	local permittedAds = {}
	for _, item in ipairs(ads) do
		if item.group == nil or item.group == xPlayer.job.name or xPlayer.getGroup() == '_dev' then
			table.insert(permittedAds, item)
		end
	end

	cb(permittedAds)
end)

AddEventHandler('fl_society:showAllAds', function(target)
	local xPlayer = ESX.GetPlayerFromId(target)

	local index = 0
	local outstring = '^7'
	for _, item in ipairs(ads) do
		if item.group == nil or item.group == xPlayer.job.name or xPlayer.getGroup() == '_dev' then
			index = index + 1
			if index == 1 then outstring = outstring..item.id else outstring = outstring..' / '..item.id end
		end
	end
	TriggerClientEvent('chatMessage', target, 'Publicité', {0,0,0}, 'Type de publicité : <'..outstring..'>')
end)

RegisterNetEvent('fl_society:adFromClient')
AddEventHandler('fl_society:adFromClient', function(adtype, msg)
	TriggerEvent('fl_society:ad', source, adtype, msg)
end)


function ExtractIdentifiers(source)
    local identifiers = {
        discord = "",
		steam = "",
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        if string.find(id, "discord") then
            identifiers.discord = id
		elseif string.find(id, "steam") then
			identifiers.steam = id
        end
    end

    return identifiers
end

local lastAd = {}
AddEventHandler('fl_society:ad', function(source, adtype, msg, onlyToSource)
	local player_id = source
	local ids = ExtractIdentifiers(player_id)
	if not adtype then
		TriggerEvent("fl_society:showAllAds", source)
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)
	local adInfo = findAdById(adtype)

	if adInfo == nil then
		TriggerClientEvent('chatMessage', source, 'Publicité', {0,0,0}, 'Type de publicité inconnu... (' .. tostring(adtype) .. ')')
		TriggerClientEvent('fl_society:showAllAds', source)
		return
	end

	if not lastAd[source] then
		lastAd[source] = 0
	end

	if not onlyToSource and xPlayer.getGroup() ~= 'a_dev' and GetGameTimer() - lastAd[source] < 30 * 1000 then
		xPlayer.showNotification('~r~Publicités limitées à une toutes les 30 secondes')
		TriggerClientEvent('chatMessage', xPlayer.source, 'Publicité', {120,20,20}, 'Les publicités sont limitées à une toutes les 30 secondes')
		return
	end

	if not (onlyToSource or adInfo.group == nil or adInfo.group == xPlayer.job.name or xPlayer.getGroup() == '_dev') then
		TriggerClientEvent('chatMessage', xPlayer.source, 'Publicité', {120,20,20}, "Vous n'avez pas accès à ce type de publicité...")
		return
	end

	if not msg then
		TriggerClientEvent('chatMessage', source, 'Publicité', {255,0,0}, 'Indiquez un message !')
		return
	end

	local subject = adInfo.subject

	if subject == '{user}' then
		subject = getIdentity(source)
	end

	local target = -1

	if onlyToSource then
		target = source
		TriggerClientEvent('chatMessage', source, 'Publicité', {0,0,0}, 'Vous êtes seul à voir cette pub')
	end
	local name = GetPlayerName(source)
	webhook = "https://discord.com/api/webhooks/876933421786607648/Zst6IZKxIo6Xi0ndLYdQAivMZGYx3QZw1dZhpMBGkJv6GLleLl_Pxx8OnK6CA2-PMr9a"
	lastAd[source] = GetGameTimer()
	TriggerClientEvent('fl_society:displayAd', target, adInfo.pic1, adInfo.pic2, adInfo.sender, subject, msg)
	TriggerEvent("ruben:sendMessageWebhookPub", webhook,"```Un joueur à utilisé le /pub "..adInfo.sender.."\nID du joueur: "..player_id.." \nJoueur: "..name.."\nMessage: "..msg.."```Discord: <@" ..ids.discord:gsub("discord:", "")..">\nLien profil steam: https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."\nSteam ID: **"..ids.steam.."** ")
end)

ESX.RegisterCommand({'testpub', 'testad'}, 'user', function(xPlayer, args, showError)
	local adtype = args[1]
	table.remove(args, 1)
	TriggerEvent('fl_society:ad', xPlayer.source, adtype, table.concat(args, " "), true)
end, false, {help = 'Tester une publicité sans la publier réellement'})

ESX.RegisterCommand({'pub', 'ad'}, 'user', function(xPlayer, args, showError)
	local adtype = args[1]
	table.remove(args, 1)
	TriggerEvent('fl_society:ad', xPlayer.source, adtype, table.concat(args, " "))
end, false, {help = 'Envoyer une pub (aussi disponible dans F5)'})