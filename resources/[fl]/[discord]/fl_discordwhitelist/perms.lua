function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..Config.DiscordToken})

    while data == nil do
        Citizen.Wait(0)
    end

    return data
end

function GetDiscordId(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end
	return discordId
end

function GetRoles(user)
	if user == nil then error('GetRoles invalid args') end
	local discordId = GetDiscordId(user)

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			return data.roles
		else
			print("An error occured (" .. tostring(member.code) .. ")")
			return {}
		end
	else
		--print('Player without discord id')
		return {}
	end

	print('Unknown error occured')
	return {}
end

function IsRolePresent(user, role)
	if user == nil or role == nil then error('IsRolePresent invalid args') end
	local roles = GetRoles(user)

	local theRole = nil
	if type(role) == "number" then
		theRole = tostring(role)
	else
		theRole = Config.Roles[role]
	end

	for i=1, #roles do
		if roles[i] == theRole then
			return true
		end
	end

	return false
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/"..Config.GuildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print("Linked to guild : "..data.name.." ("..data.id..")")
	else
		error("An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code))
	end
end)

function io.fileexists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function io.linesfrom(file)
	if not io.fileexists(file) then return {} end
	lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end