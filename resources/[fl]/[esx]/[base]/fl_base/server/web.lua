SetHttpHandler(function(req, res)
	local decodedPath = urldecode(req.path)

	if string.startwith(req.path, '/playerinfo/') then
		local discord = string.sub(req.path, string.len('/playerinfo/')+1)

		MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `discord` = @discord', {
			['@discord'] = discord
		}, function(result)
			res.send(json.encode(result))
		end)
	elseif string.startwith(req.path, '/search') then
		local name = string.sub(decodedPath, string.len('/search/')+1)
		name = '%' .. name .. '%'
		MySQL.Async.fetchAll('SELECT * FROM `users` WHERE name LIKE @name OR firstname LIKE @name OR lastname LIKE @name OR discord LIKE @name;', { ['@name'] = name },
		function(result)
			res.send(json.encode(result))
		end)
	elseif string.startwith(req.path, '/jobsgrades') then
		MySQL.Async.fetchAll('SELECT * FROM `job_grades`', {},
		function(result)
			res.send(json.encode(result))
		end)
	elseif string.startwith(req.path, '/jobs') then
		MySQL.Async.fetchAll('SELECT * FROM `jobs`', {},
		function(result)
			res.send(json.encode(result))
		end)
	elseif string.startwith(req.path, '/saveMusic') and req.method == 'POST' then
		local address = tostring(req.address:gsub(":.*", ""))
		req.setDataHandler(function(body)
			local data = json.decode(body)
			SetResourceKvpInt('loadingscreen:music_' .. address, data.music == 'true')
			res.send(json.encode({ok = true}))
		end)
	elseif string.startwith(req.path, '/getMusic') then
		local address = tostring(req.address:gsub(":.*", ""))
		res.send(json.encode({music = GetResourceKvpInt('loadingscreen:music_' .. address) == 1}))
	else
		res.send(json.encode({'Unknown endpoint : ' .. req.path}))
	end

	return
end)

function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end

function string.startwith(String,Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function char_to_hex(c)
	return string.format("%%%02X", string.byte(c))
end

function hex_to_char(x)
	return string.char(tonumber(x, 16))
end

function urlencode(url)
	if url == nil then
		return
	end
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", char_to_hex)
	url = url:gsub(" ", "+")
	return url
end

function urldecode(url)
	if url == nil then
		return
	end
	url = url:gsub("+", " ")
	url = url:gsub("%%(%x%x)", hex_to_char)
	return url
end