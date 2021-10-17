function CreateExtendedPlayer(playerId, discord, group, accounts, inventory, weight, job, faction, name, coords, firstname, lastname)
	local self = {}

	self.accounts = accounts
	self.coords = coords
	self.group = group
	self.discord = discord
	self.inventory = inventory
	self.job = job
	self.faction = faction
	self.name = name
	self.firstname = firstname
	self.lastname = lastname
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	self.weightCapacitor = {}

	ExecuteCommand(('remove_principal identifier.%s group'):format(self.discord))
	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.discord, self.group))

	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.setMoney = function(money)
		money = ESX.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	self.getMoney = function()
		return self.getAccount('money').money
	end

	self.setCoords = function(coords)
		self.updateCoords(coords)
		self.triggerEvent('esx:teleport', coords)
	end

	self.updateCoords = function(coords)
		self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
	end

	self.getCoords = function(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	self.getFirstname = function()
		return self.firstname
	end

	self.getLastname = function()
		return self.lastname
	end

	self.getBank = function()
		return self.getAccount('bank').money
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.addMoney = function(money)
		money = ESX.Math.Round(money)
		self.addAccountMoney('money', money)
	end

	self.removeMoney = function(money)
		money = ESX.Math.Round(money)
		self.removeAccountMoney('money', money)
	end

	self.addBank = function(money)
		money = ESX.Math.Round(money)
		self.addAccountMoney('bank', money)
	end

	self.removeBank = function(money)
		money = ESX.Math.Round(money)
		self.removeAccountMoney('bank', money)
	end

	self.getDiscordIdentifier = function()
		return self.discord
	end

	self.setGroup = function(newGroup)
		ExecuteCommand(('remove_principal identifier.%s group'):format(self.discord))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.discord, self.group))
	end

	self.getGroup = function()
		return self.group
	end

	self.isStaff = function()
		return self.group == 'superadmin' or self.group == '_dev'
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory = function(minimal)
		if minimal then
			local minimalInventory = {}

			for k,v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		else
			return self.inventory
		end
	end

	self.getJob = function()
		return self.job
	end

	self.getFaction = function()
		return self.faction
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			else
				error('Unknown account : ' .. accountName)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			else
				error('Unknown account : ' .. accountName)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			else
				error('Unknown account : ' .. accountName)
			end
		end
	end

	self.getInventoryItem = function(name)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end

		if not ESX.ExistItem(name) then
			print('ERROR : Unknown item : ' .. name)
			return {
				name = name,
				count = 0,
				label = 'Inconnu (' .. name .. ')',
				limit = 0,
				usable = false,
				usableCloseMenu = ESX.UsableItemsCloseMenu[name] ~= nil,
				canRemove = false,
				weight = 0,
			}
		end

		return {
			name = name,
			count = 0,
			label = ESX.Items[name].label,
			limit = ESX.Items[name].limit,
			usable = ESX.UsableItemsCallbacks[name] ~= nil,
			usableCloseMenu = ESX.UsableItemsCloseMenu[name] ~= nil,
			canRemove = ESX.Items[name].canRemove,
			needInsert = true,
			weight = ESX.Items[name].weight,
		}
	end

	self.addInventoryItem = function(name, count, silent)
		count = ESX.Math.Round(count)
		local item = self.getInventoryItem(name)

		if item.needInsert then
			item.needInsert = false
			table.insert(self.inventory, item)
		end

		item.count = item.count + count
		self.weight = self.weight + (item.weight * count)

		TriggerEvent('esx:onAddInventoryItem', self.source, item, count)
		self.triggerEvent('esx:addInventoryItem', item, count, silent)
	end

	self.removeInventoryItem = function(name, count, silent)
		local item = self.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)
			local newCount = item.count - count

			if newCount >= 0 then
				item.count = newCount
				self.weight = self.weight - (item.weight * count)

				TriggerEvent('esx:onRemoveInventoryItem', self.source, item, count)
				self.triggerEvent('esx:removeInventoryItem', item, count, silent)
			end
		end
	end

	self.setInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item and count >= 0 then
			count = ESX.Math.Round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	self.getWeight = function()
		return self.weight
	end

	self.getMaxWeight = function()
		return self.maxWeight
	end

	self.canCarryItem = function(name, count)
		if name == nil then error('Can\'t compare nil item') end
		if count == nil then error('Can\'t compare nil count') end

		if not ESX.ExistItem(name) then
			print('Player ' .. self.getName() .. ' tried to canCarryItem unknown item : ' .. tostring(name))
			return false
		end

		local itemWeight = ESX.Items[name].weight
		local newWeight = self.weight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			self.job.skin_male = {}
			self.job.skin_female = {}

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job)
		else
			print(('[^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.discord))
		end
	end

	self.setFaction = function(faction, grade)
		grade = tostring(grade)
		local lastFaction = json.decode(json.encode(self.faction))

		if ESX.DoesFactionExist(faction, grade) then
			local factionObject, gradeObject = ESX.Factions[faction], ESX.Factions[faction].grades[grade]

			self.faction.id = factionObject.id
			self.faction.name = factionObject.name
			self.faction.label = factionObject.label

			self.faction.grade = tonumber(grade)
			self.faction.grade_name = gradeObject.name
			self.faction.grade_label = gradeObject.label
			self.faction.grade_salary = gradeObject.salary

			self.faction.skin_male = {}
			self.faction.skin_female = {}

			if gradeObject.skin_male then
				self.faction.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female then
				self.faction.skin_female = json.decode(gradeObject.skin_female)
			end

			TriggerEvent('esx:setFaction', self.source, self.faction, lastFaction)
			self.triggerEvent('esx:setFaction', self.faction)
		else
			print(('es_extended: ignoring setFaction for %s due to faction not found!'):format(self.source))
			print(('[^3WARNING^7] Ignoring invalid .setFaction() usage for "%s"'):format(self.discord))
		end
	end

	self.showNotification = function(msg)
		self.triggerEvent('esx:showNotification', msg)
	end

	self.showHelpNotification = function(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	self.sendChatMessage = function(msg, prefix, color)
		if prefix == nil then prefix = '' end
		if color == nil then color = {0,0,0} end
		TriggerClientEvent('chatMessage', self.source, prefix, color, msg)
	end

	self.save = function(cb)
		local asyncTasks = {}

		table.insert(asyncTasks, function(taskEnd)
			MySQL.Async.execute('UPDATE users SET accounts = @accounts, job = @job, job_grade = @job_grade, faction = @faction, faction_grade = @faction_grade, `group` = @group, position = @position, inventory = @inventory WHERE discord = @discord', {
				['@accounts'] = json.encode(self.getAccounts(true)),
				['@job'] = self.job.name,
				['@job_grade'] = self.job.grade,
				['@faction'] = self.faction.name,
				['@faction_grade'] = self.faction.grade,
				['@group'] = self.getGroup(),
				['@position'] = json.encode(self.getCoords()),
				['@discord'] = self.getDiscordIdentifier(),
				['@inventory'] = json.encode(self.getInventory(true))
			}, function(rowsChanged)
				taskEnd()
			end)
		end)

		Async.parallel(asyncTasks, function(results)
			if cb then
				cb()
			end
		end)
	end

	self.updateWeightCapacitor = function(weightCapacitorType, value)
		if Config.WeightCapacitor[weightCapacitorType] == nil then error('Unknown weightCapacitorType : ' .. tostring(weightCapacitorType)) end

		if self.weightCapacitor[weightCapacitorType] and not value then
			self.weightCapacitor[weightCapacitorType] = false
			self.maxWeight = self.maxWeight - Config.WeightCapacitor[weightCapacitorType]
			self.showNotification('~r~Votre capacité de poids a été réduite de '  .. Config.WeightCapacitor[weightCapacitorType] .. 'kg')
		elseif not self.weightCapacitor[weightCapacitorType] and value then
			self.weightCapacitor[weightCapacitorType] = true
			self.maxWeight = self.maxWeight + Config.WeightCapacitor[weightCapacitorType]
			self.showNotification('~b~Vous augmentez votre capacité de poids de ' .. Config.WeightCapacitor[weightCapacitorType] .. 'kg ' .. _('weight_capacitor_' .. weightCapacitorType))
		end
		self.triggerEvent('esx:onUpdateMaxWeight', self.maxWeight)
	end

	return self
end
