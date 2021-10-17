CreateJobLoop('police', function()
	local coords = GetEntityCoords(PlayerPedId())
	local sleep = true

	for _, v in pairs(Config.Marker) do
		if #(coords - v.Pos) < 20 then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			sleep = false
		end

		if #(coords - v.Pos) < v.Size.x then
			ESX.ShowHelpNotification(v.Hint)
			if not v.inMarker then
				v.inMarker = true
				EnterMarker(v)
			end
		else
			v.inMarker = false
		end
	end

	if sleep then
		Citizen.Wait(1000)
	end
end)

-- Key event
function EnterMarker(v)
	Citizen.CreateThread(function()
		while v.inMarker do
			Wait(0)
			if IsControlJustReleased(0, 38) then
				ESX.TriggerServerCallback('jsfour-criminalrecord:fetch', function( d )
					SetNuiFocus(true, true)

					SendNUIMessage({
					  action = "open",
						array = d
					})
				end, {}, 'start')
			end
		end
	end)
end

-- NUI Callback - Close
RegisterNUICallback('escape', function(data, cb)
	SetNuiFocus(false, false)
	cb('ok')
end)

-- NUI Callback - Fetch
RegisterNUICallback('fetch', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:fetch', function( d )
    cb(d)
  end, data, data.type)
end)

-- NUI Callback - Search
RegisterNUICallback('search', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:search', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Add
RegisterNUICallback('add', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:add', function( d )
		cb(d)
  end, data)
end)

-- NUI Callback - Update
RegisterNUICallback('update', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:update', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Remove
RegisterNUICallback('remove', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:remove', function( d )
		cb(d)
	end, data)
end)
