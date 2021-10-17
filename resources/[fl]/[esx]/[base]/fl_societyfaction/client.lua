function OpenBossMenuFaction(society, close, options)
	local isBoss = nil
	local options = options or {}
	local elements = {}

	ESX.TriggerServerCallback('fl_societyfaction:isBossFaction', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		withdraw = true,
		deposit = true,
		employees = true,
		grades = true
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.withdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	--[[if options.grades then
		table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
	end]]--

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title = _U('boss_menu'),
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = _U('withdraw_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('fl_societyfaction:withdrawMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = _U('deposit_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('fl_societyfaction:depositMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenuFaction(society)
		elseif data.current.value == 'manage_grades' then
			OpenManageGradesMenuFaction(society)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenManageEmployeesMenuFaction(society)
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title = _U('employee_management'),
		elements = {
			{label = _U('employee_list'), value = 'employee_list'},
			{label = _U('recruit'), value = 'recruit'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeListFaction(society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenuFaction(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeListFaction(society)

	ESX.TriggerServerCallback('fl_societyfaction:getEmployeesFaction', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].faction.grade_label == '' and employees[i].faction.label or employees[i].faction.grade_label)

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
				OpenPromoteMenuFaction(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('fl_societyfaction:setFaction', function()
					OpenEmployeeList(society)
				end, employee.discord, 'resid', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenuFaction(society)
		end)

	end, society)

end

function OpenRecruitMenuFaction(society)

	ESX.TriggerServerCallback('fl_societyfaction:getOnlinePlayersFaction', function(players)

		local elements = {}

		for i=1, #players, 1 do
			if players[i].faction.name ~= society then
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
					{label = _U('no'), value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('fl_societyfaction:setFaction', function()
						OpenRecruitMenuFaction(society)
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

function OpenPromoteMenuFaction(society, employee)

	ESX.TriggerServerCallback('fl_societyfaction:getFaction', function(faction)

		local elements = {}

		for i=1, #faction.grades, 1 do
			local gradeLabel = (faction.grades[i].label == '' and faction.label or faction.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = faction.grades[i].grade,
				selected = (employee.faction.grade == faction.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title = _U('promote_employee', employee.name),
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('fl_societyfaction:setFaction', function()
				OpenEmployeeListFaction(society)
			end, employee.discord, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeListFaction(society)
		end)

	end, society)

end

function OpenManageGradesMenuFaction(society)

	ESX.TriggerServerCallback('fl_societyfaction:getFaction', function(faction)

		local elements = {}

		for i=1, #faction.grades, 1 do
			local gradeLabel = (faction.grades[i].label == '' and faction.label or faction.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = faction.grades[i].grade,
				rightLabel = _U('money_generic', ESX.Math.GroupDigits(faction.grades[i].salary)),
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

					ESX.TriggerServerCallback('fl_societyfaction:setFactionSalary', function()
						OpenManageGradesMenuFaction(society)
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

AddEventHandler('fl_societyfaction:openBossMenuFaction', function(society, close, options)
	OpenBossMenuFaction(society, close, options)
end)