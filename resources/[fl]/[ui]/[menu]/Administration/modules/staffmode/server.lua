local items = {}
local Reports = {};
local ModsInService = {};

local apiScreenShot = "https://discord.com/api/webhooks/876930823230726225/YAssv5PacY_YeXLLn6NoHFdLnQ8PFMVJBv2Tde99lc6UyDTvY2_5eSX3zhxbSkX2Vvbz"
local apiAdmin = "https://discord.com/api/webhooks/876930823230726225/YAssv5PacY_YeXLLn6NoHFdLnQ8PFMVJBv2Tde99lc6UyDTvY2_5eSX3zhxbSkX2Vvbz"

local function getLicense(source)
    local discord = nil
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end
    end
    return discord
end

local function canUse(source)
    local discord = getLicense(source)
    if discord == nil then 
        return 
    end
    return Pz_admin.staffList[discord] ~= nil
end

local function getRank(source)
    local discord = getLicense(source)
    if discord == nil then return end
    return Pz_admin.staffList[discord], discord
end

local function getItems()
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
        return result
    end)
end

RegisterNetEvent('pz_admin:freezePlayer')
AddEventHandler('pz_admin:freezePlayer', function(target)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
	TriggerClientEvent("esx:freeze", target)
end)

RegisterNetEvent('pz_admin:healPlayer')
AddEventHandler('pz_admin:healPlayer', function(target)
	local _Source = source
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
	TriggerClientEvent("esx:setHealth", target, 200)
end)

RegisterNetEvent('pz_admin:teleportTo')
AddEventHandler('pz_admin:teleportTo', function(target)
	local _Source = source
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
	local targetCoords = GetEntityCoords(GetPlayerPed(target))
	SetEntityCoords(GetPlayerPed(_Source), targetCoords)
end)

RegisterServerEvent("pz_admin:getPlayerInformation")
AddEventHandler("pz_admin:getPlayerInformation", function(target)
	local _Source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		local inventory = xPlayer.getInventory()
		local money = xPlayer.getAccount("money").money
		local bank = xPlayer.getAccount("bank").money
		local black = xPlayer.getAccount("black_money").money
		local ping = GetPlayerPing(xPlayer.source)
		TriggerClientEvent("pz_admin:getPlayerInformation", _Source, {inventory = inventory, money = money, bank = bank, black = black, ping = ping})
	end
end)

RegisterNetEvent("pz_admin:getPlayers")
AddEventHandler("pz_admin:getPlayers", function()
    local _Source = source
	local allPlayers = ESX.GetPlayers()
	local dataPlayers = {}
	for i=1, #allPlayers, 1 do
		table.insert(dataPlayers, {id = allPlayers[i], name = GetPlayerName(allPlayers[i])})
	end
	TriggerClientEvent("pz_admin:getPlayers", _Source, dataPlayers)
end)

RegisterNetEvent("pz_admin:screenshot")
AddEventHandler("pz_admin:screenshot", function(target)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
    TriggerClientEvent("pz_admin:screenshot", target, apiScreenShot)
end)

RegisterNetEvent("pz_admin:message")
AddEventHandler("pz_admin:message", function(id,mess)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
    TriggerClientEvent("esx:showNotification", id, "~r~Message du staff : ~s~"..mess)
end)

RegisterNetEvent("pz_admin:bring")
AddEventHandler("pz_admin:bring", function(id,pos)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
    TriggerClientEvent("pz_admin:teleport", id, pos)

end)

RegisterNetEvent("pz_admin:remb")
AddEventHandler("pz_admin:remb", function(id,item,label,qty)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
    xPlayer.addInventoryItem(item,qty)

end)

RegisterNetEvent("pz_admin:revive")
AddEventHandler("pz_admin:revive", function(id)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
    TriggerClientEvent("ambulance:revive", id)

end)

RegisterNetEvent("pz_admin:ban")
AddEventHandler("pz_admin:ban", function(initial,id,reason,time)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
    local n = GetPlayerName(_src)
    time = tonumber(time)
    local license,identifier,liveid,xblid,discord,playerip
    local targetplayername = GetPlayerName(id)
        for k,v in ipairs(GetPlayerIdentifiers(id))do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                identifier = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                liveid = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                xblid  = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                playerip = v
            end
        end
    if time > 0 then
        TriggerEvent("fivemban", initial,license,identifier,liveid,xblid,discord,playerip,targetplayername,n,time,reason,0) --Timed ban here
        DropPlayer(id, "Vous avez été banni(e) temporairement: | Raison : "..reason.." | Par "..n.." | Date du ban : "..getDate().." | Durée du ban : "..time.. " secondes")
    else
        TriggerEvent("fivemban", initial,license,identifier,liveid,xblid,discord,playerip,targetplayername,n,time,reason,1)
        DropPlayer(id, "Vous avez été banni(e) à vie: | Date du ban : "..getDate().." | Raison : "..reason.." | Banni(e) par "..n)
    end
end)

RegisterNetEvent("pz_admin:kick")
AddEventHandler("pz_admin:kick", function(id,mess)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end
    DropPlayer(id, "Vous avez été expulsé: \""..mess.."\", par "..GetPlayerName(_src))
end)

RegisterNetEvent("pz_admin:getItems")
AddEventHandler("pz_admin:getItems", function()
    local _src = source
    TriggerClientEvent("pz_admin:getItems", _src, items)
end)

RegisterNetEvent("pz_admin:canUse")
AddEventHandler("pz_admin:canUse", function()
    local _src = source
    local state,license = canUse(_src)
    local rank = -1
    if state then rank = getRank(_src) end
    TriggerClientEvent("pz_admin:canUse", _src, state, rank, license)
end)

Citizen.CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
        items = result
    end)
end)

RegisterNetEvent("pz_admin:giveweapon")
AddEventHandler("pz_admin:giveweapon", function(id, weaponName)
    local xp1 = ESX.GetPlayerFromId(soure)
    local group = xp1.getGroup()
    if group == "user" then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(id)
    
    xPlayer.addWeapon(weaponName, 999)
end)

RegisterNetEvent("pz_admin:StaffOn")
AddEventHandler("pz_admin:StaffOn", function(state)
    local _source = source;

    if state == true then
        for i = 1, #ModsInService, 1 do
            TriggerClientEvent('esx:showNotification', "~b~" .. ModsInService[i].serverId,
                GetPlayerName(_source) .. ' ~s~ vient de commencer a moderer.');
        end

        table.insert(ModsInService, {
            serverId = _source,
            name = GetPlayerName(_source),
            label = ('[%s] %s'):format(_source, GetPlayerName(_source))
        });
        TriggerClientEvent('pz_admin:setReports', _source, Reports);
    else
        for i = 1, #ModsInService, 1 do
            if ModsInService[i].serverId == _source then
                table.remove(ModsInService, i)
            end
        end
    end
end)
-----------Systeme Report
----
-------Commande Report
RegisterServerEvent('pz_admin:addReport')
AddEventHandler('pz_admin:addReport', function(reportText)
    local _source = source;
    local playerName = GetPlayerName(_source);
    local label = ('[%s] %s'):format(_source, playerName);
    local date = os.date("*t");

    table.insert(Reports, {
        serverId = _source,
        name = playerName,
        label = label,
        text = ('%sh%s: %s'):format(date.hour, date.min, reportText),
        taken = nil
    });

    for i = 1, #ModsInService, 1 do
        TriggerClientEvent('esx:showNotification', ModsInService[i].serverId,
            ('[%s] ~b~%s~s~ vient de faire un report pour ~r~%s~s~'):format(_source,playerName, reportText));
        TriggerClientEvent('pz_admin:setReports', ModsInService[i].serverId, Reports);
    end
end)

----Prendre le Report
RegisterServerEvent('pz_admin:takeReport')
AddEventHandler('pz_admin:takeReport', function(serverId, text)
    for i = 1, #Reports, 1 do
        if Reports[i].serverId == serverId and Reports[i].text == text then
            Reports[i].taken = source;
        end
    end
    for i = 1, #ModsInService, 1 do
        TriggerClientEvent('pz_admin:setReports', ModsInService[i].serverId, Reports);
    end
end)


RegisterServerEvent("pz_admin:bringplayer")
AddEventHandler("pz_admin:bringplayer", function(plyId, plyPedCoords)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    local group = xPlayer.getGroup()
    if group == "user" then
        return
    end

    TriggerClientEvent('pz_admin:bringplayer', plyId, plyPedCoords)
end)

-----Supprimer le report
RegisterServerEvent('pz_admin:removeReport')
AddEventHandler('pz_admin:removeReport', function(serverId, text)
    for i = 1, #Reports, 1 do
        if Reports[i].serverId == serverId and Reports[i].text == text then
            table.remove(Reports, i);
        end
    end

    for i = 1, #ModsInService, 1 do
        TriggerClientEvent('pz_admin:setReports', ModsInService[i].serverId, Reports);
    end
end)

--- Revive administration

RegisterNetEvent('ambulance:revive')
AddEventHandler('ambulance:revive', function(playerId)
	  local xPlayer = ESX.GetPlayerFromId(source)
      local group = xPlayer.getGroup()
      if group == "user" then
          return
      end

	  if xPlayer and xPlayer.job.name == 'ambulance' then
		  local xTarget = ESX.GetPlayerFromId(playerId)

		  if xTarget then
			if deadPlayers[playerId] then
				xTarget.TriggerEvent('ambulance:revive')
				deadPlayers[playerId] = nil
			else
				TriggerClientEvent('esx:showNotification', source, "~g~La réanimation à fonctionné.\nPenser à lui dire de faire attention !", "", 1)
			end
		else
			TriggerClientEvent('esx:showNotification', source, "~r~Ce joueur n\'est plus en ligne.", "", 1)
		end
	  end
end)

RegisterServerEvent('ambulance:revive')
AddEventHandler('ambulance:revive', function(target)
	TriggerClientEvent('ambulance:revive', target)
end)
