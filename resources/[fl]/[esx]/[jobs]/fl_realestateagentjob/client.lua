local hasAlreadyEnteredMarker, CurrentActionData = false, {}
local CurrentAction, CurrentActionMsg, LastZone

AddEventHandler('fl_property:openSocietyMenu', function(society)
	if society == 'realestateagent' then
		OpenRealestateAgentMenu()
	end
end)

function OpenRealestateAgentMenu()
	local elements = {
	--	{label = _U('properties'), value = 'properties'},
	--	{label = _U('clients'), value = 'customers'},
		{label = 'Facturer un client', value = 'billing'},
	}

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'realestateagent' and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {
			label = _U('boss_action'),
			value = 'boss_actions'
		})
	end

	-- ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'realestateagent', {
		title = _U('realtor'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'billing' then
			OpenBillingMenu()
		elseif data.current.value == 'properties' then
			OpenPropertyMenu()
		elseif data.current.value == 'customers' then
			OpenCustomersMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('fl_society:openBossMenu', 'realestateagent', function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction = 'realestateagent_menu'
		CurrentActionMsg = _U('press_to_access')
		CurrentActionData = {}
	end)
end

function OpenBillingMenu()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer == -1 or closestDistance > 3.0 then
		ESX.ShowNotification('~r~Aucun client à proximité')
		return
	end
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'realestateagent_billing',
		{
			title = 'Montant de la facture'
		},
		function(data, menu)
			local amount = tonumber(data.value)
			if amount == nil then
				ESX.ShowNotification('~r~Montant invalide')
			else
				menu.close()
				TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_realestateagent', 'realestateagent', amount)
			end
		end,
	function(data, menu)
		menu.close()
	end)
end

function OpenPropertyMenu()
	TriggerEvent('fl_property:getProperties', function(properties)

		local elements = {
			head = {_U('property_name'), _U('property_actions')},
			rows = {}
		}

		for i=1, #properties, 1 do
			if not properties[i].isGateway then
				table.insert(elements.rows, {
					data = properties[i],
					cols = {
						properties[i].label,
						_U('property_actionbuttons')
					}
				})
			end
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'properties', elements, function(data, menu)
			if data.value == 'buySelf' then
				TriggerServerEvent('fl_realestateagentjob:buySelf', data.data.name)
			elseif data.value == 'rent' or data.value == 'sell' or data.value == 'sellBank' then
				menu.close()
				TriggerEvent('fl_realestateagentjob:actionMenuFor', data.value, data.data.name)
			elseif data.value == 'gps' then
				TriggerEvent('fl_property:getProperty', data.data.name, function(property)
					if property.isSingle then
						SetNewWaypoint(property.entering.x, property.entering.y)
					else
						TriggerEvent('fl_property:getGateway', property, function(gateway)
							SetNewWaypoint(gateway.entering.x, gateway.entering.y)
						end)
					end
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

AddEventHandler('fl_realestateagentjob:actionMenuFor', function(action, propertyName)
	if action ~= 'rent' and action ~= 'sell' and action ~= 'sellBank' then
		ESX.ShowNotification('~r~Action inconnu, rapporter ce bug...')
		return
	end

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'action_property_amount', {
		title = _U('amount')
	}, function(data, menu)
		local amount = tonumber(data.value)

		if amount == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification(_U('no_play_near'))
				menu.close()
			else
				TriggerServerEvent('fl_realestateagentjob:'..action, GetPlayerServerId(closestPlayer), propertyName, amount)
				menu.close()
			end

			OpenPropertyMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end)

function OpenCustomersMenu()
	ESX.ShowNotification('~y~Chargement de la liste client...')
	ESX.TriggerServerCallback('fl_realestateagentjob:getCustomers', function(customersS)
		customers = customersS
	end)
	Wait(250)
		ESX.TriggerServerCallback('fl_realestateagentjob:getCustomers', function(customersS)
			customers = customersS
		end)
	Wait(250)

	if customers then
		local elements = {
			head = {_U('customer_client'), _U('customer_property'), 'N°', 'Prix', _U('customer_agreement'), _U('customer_actions')},
			rows = {}
		}

		for i=1, #customers, 1 do
			table.insert(elements.rows, {
				data = customers[i],
				cols = {
					customers[i].name,
					customers[i].propertyLabel,
					'N°'..tostring(customers[i].propertyId),
					'$' .. tostring(customers[i].propertyPrice),
					(customers[i].propertyRented and _U('customer_rent') or _U('customer_sell')),
					_U('customer_contractbuttons')
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'customers', elements, function(data, menu)
			if data.value == 'revoke' then
				TriggerServerEvent('fl_realestateagentjob:revoke', data.data.propertyId)
				Citizen.Wait(1000)
				OpenCustomersMenu()
			elseif data.value == 'gps' then
				TriggerEvent('fl_property:getProperty', data.data.propertyName, function(property)
					if property.isSingle then
						SetNewWaypoint(property.entering.x, property.entering.y)
					else
						TriggerEvent('fl_property:getGateway', property, function(gateway)
							SetNewWaypoint(gateway.entering.x, gateway.entering.y)
						end)
					end
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		return
	end
end

AddEventHandler('fl_realestateagentjob:hasEnteredMarker', function(zone)
	if zone == 'OfficeEnter' then
		CurrentAction = 'realestateagent_enter'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'OfficeExit' then
		CurrentAction = 'realestateagent_exit'
		CurrentActionMsg = _U('press_to_exit')
		CurrentActionData = {}
	elseif zone == 'OfficeActions' and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'realestateagent' then
		CurrentAction = 'realestateagent_menu'
		CurrentActionMsg = _U('press_to_access')
		CurrentActionData = {}
	end
end)

AddEventHandler('fl_realestateagentjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)