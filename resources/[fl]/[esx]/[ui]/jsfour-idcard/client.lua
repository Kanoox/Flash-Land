local open = false

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array = data,
		type = type
	})
end)

RegisterNetEvent('jsfour-idcard:openCustom')
AddEventHandler('jsfour-idcard:openCustom', function(type, firstname, lastname, dateofbirth, sex, height, licenses)
	open = true
	local licensesTypes = {}
	for _,l in pairs(licenses) do
		table.insert(licensesTypes, { type = l })
	end
	SendNUIMessage({
		action = 'open',
		array = {
			user = {{
				firstname = firstname,
				lastname = lastname,
				dateofbirth = dateofbirth,
				sex = sex,
				height = height,
			}},
			licenses = licensesTypes,
		},
		type = type,
	})
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if open then
			if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
				SendNUIMessage({
					action = "close"
				})
				open = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)