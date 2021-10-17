RegisterServerEvent('fl_property_util:save')
AddEventHandler('fl_property_util:save', function(type, name, label, entering, exit, inside, outside, interiorId, ipls, isSingle, isRoom, isGateway, roomMenu, price, clothingMenu, soldby, poids, garage, GarageType)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= nil and xPlayer.job.name == 'realestateagent' or xPlayer.job.name == '_dev' then
		local rip = string.gsub(name, "%s+", "")
		entering = RoundV3(entering)
		garage = RoundV3(garage)
		exit = RoundV3(exit)
		inside = RoundV3(inside)
		outside = RoundV3(outside)
		roomMenu = RoundV3(roomMenu)
		if clothingMenu then
			clothingMenu = json.encode(RoundV3(clothingMenu))
		end

		MySQL.Async.fetchAll("SELECT name FROM properties WHERE name = @name", {
		['@name'] = name,
		}, function(result)
			if result[1] ~= nil then
				xPlayer.showNotification('Ce nom existe déja !')
			else
				MySQL.Async.execute('INSERT INTO properties ' ..
				'(type, name, label, entering, `exit`, inside, outside, interiorId, ipls, is_single, is_room, is_gateway, room_menu, price, clothing_menu, soldby, poids, garage, GarageType) ' ..
				'VALUES(@type, @name, @label, @entering, @exit, @inside, @outside, @interiorId, @ipls, @isSingle, @isRoom, @isGateway, @roomMenu, @price, @clothingMenu, @soldby, @poids, @garage, @GarageType)', {
					['@type'] = type,
					['@name'] = rip,
					['@label'] = label,
					['@entering'] = json.encode(entering),
					['@exit'] = json.encode(exit),
					['@inside'] = json.encode(inside),
					['@outside'] = json.encode(outside),
					['@interiorId'] = json.encode(interiorId),
					['@ipls'] = ipls,
					['@isSingle'] = isSingle,
					['@isRoom'] = isRoom,
					['@isGateway'] = isGateway,
					['@roomMenu'] = json.encode(roomMenu),
					['@clothingMenu'] = clothingMenu,
					['@soldby'] = soldby,
					['@price'] = price,
					['@poids'] = poids,
					['@garage'] = json.encode(garage),
					['@GarageType'] = GarageType
				}, function (rowsChanged)
					if rowsChanged == 1 then
						xPlayer.showNotification('~g~Propriété créée avec succès !')
						--TriggerEvent('fl_property:reloadProperties')
                        ReloadProperties()
						TriggerEvent('fl_property:discordLogs', xPlayer, type, name, label, entering, exit, inside, outside, interiorId, ipls, isSingle, isRoom, isGateway, roomMenu, clothingMenu, soldby, poids, garage)
					else
						xPlayer.showNotification('~r~Erreur ! (' .. tostring(rowsChanged) .. ')')
					end
				end)
			end
		end)
	end
end)

function RoundV3(vector)
	if vector == nil then return nil end
	return { x = ESX.Math.Round(vector.x, 2), y = ESX.Math.Round(vector.y, 2), z = ESX.Math.Round(vector.z, 2)}
end

