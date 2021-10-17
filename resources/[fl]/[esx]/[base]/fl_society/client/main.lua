function OpenBossMenu(society, close, options)
	local isBoss = nil
	local options = options or {}
	local elements = {}

	ESX.TriggerServerCallback('fl_society:isBoss', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		chest = true,
		withdraw = true,
		deposit = true,
		employees = true,
		grades = true,
		billing = true,
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	if options.grades then
		table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
	end

	if options.billing then
		table.insert(elements, {label = 'Facturer un client', value = 'billing'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title = _U('boss_menu'),
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = _U('withdraw_amount')
			}, function(data, dialogMenu)
				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					-- menu.close()
					dialogMenu.close()
					TriggerServerEvent('fl_society:withdrawMoney', society, amount)
					Citizen.Wait(500)
					OpenBossMenu(society, close, options)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'billing' then
			OpenBillingMenu(society)
		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = _U('deposit_amount')
			}, function(data, dialogMenu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					-- menu.close()
					dialogMenu.close()
					TriggerServerEvent('fl_society:depositMoney', society, amount)
					Citizen.Wait(500)
					OpenBossMenu(society, close, options)
				end

			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(society)
		elseif data.current.value == 'manage_grades' then
			OpenManageGradesMenu(society)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenBillingMenu(society)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer == -1 or closestDistance > 3.0 then
		ESX.ShowNotification('~r~Aucun client à proximité')
		return
	end
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), society .. '_billing',
		{
			title = 'Montant de la facture'
		},
		function(data, menu)
			local amount = tonumber(data.value)
			if amount == nil then
				ESX.ShowNotification('~r~Montant invalide')
			else
				menu.close()
				TriggerServerEvent('fl_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_'..society, society, amount)
			end
		end,
	function(data, menu)
		menu.close()
	end)
end

function OpenManageEmployeesMenu(society)

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title = _U('employee_management'),
		elements = {
			{label = _U('employee_list'), value = 'employee_list'},
			{label = _U('recruit'), value = 'recruit'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenu(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeList(society)

	ESX.TriggerServerCallback('fl_society:getEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('fl_society:setJob', function()
					OpenEmployeeList(society)
				end, employee.discord, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu(society)
		end)

	end, society)

end

function OpenRecruitMenu(society)

	ESX.TriggerServerCallback('fl_society:getOnlinePlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			if players[i].job.name ~= society then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					discord = players[i].discord
				})
			end
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'recruit_' .. society, {
			title = _U('recruiting'),
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				title = _U('do_you_want_to_recruit', data.current.name),
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('fl_society:setJob', function()
						OpenRecruitMenu(society)
					end, data.current.discord, society, 0, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPromoteMenu(society, employee)
	ESX.TriggerServerCallback('fl_society:getJob', function(job)
		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.job.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title = _U('promote_employee', employee.name),
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('fl_society:setJob', function()
				OpenEmployeeList(society)
			end, employee.discord, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)

	end, society)

end

function OpenManageGradesMenu(society)

	ESX.TriggerServerCallback('fl_society:getJob', function(job)

		local elements = {}

		for i,grade in pairs(job.grades) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				rightLabel = _U('money_generic', ESX.Math.GroupDigits(job.grades[i].salary)),
				rightLabelColor = 'green',
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title = _U('salary_management'),
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = _U('salary_amount')
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

					ESX.TriggerServerCallback('fl_society:setJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, society)

end

AddEventHandler('fl_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

RegisterCommand('+opensociety', function()
	if ESX.IsPlayerDead() then return end
	TriggerEvent('fl_society:openMobileAction', ESX.PlayerData.job.name)
end)

RegisterCommand('-opensociety', function() end)