--[[
local bankIndex = 0
RegisterCommand('nextbank', function()
	bankIndex = bankIndex + 1
	SetEntityCoords(PlayerPedId(), Config.BankLocations[bankIndex], 0, 0, 0, 0)
end)
--]]
RegisterCommand('atm', function()
	print('CurrentATM:' .. dump(CurrentATM))

end, false)

RegisterCommand('playsound', function(argN, args)
	PlaySoundFrontend(-1, args[2], args[1], false)
end, false)

RegisterCommand('playsoundn', function(argN, args)
	PlaySoundFrontend(-1, args[1], 0, false)
end, false)

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

-- -1026892662
-- 1086547934
