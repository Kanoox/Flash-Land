function CreateAddonInventory(name, owner, items)
	local self = {}

	self.name  = name
	self.owner = owner
	self.items = items

	self.addItem = function(name, count)
		local item = self.getItem(name)
		self.setItem(name, item.count + count)
	end

	self.removeItem = function(name, count)
		local item = self.getItem(name)
		self.setItem(name, item.count - count)
	end

	self.setItem = function(name, count)
		print('[^2AddonInventory^7] ' .. tostring(self.owner or self.name) .. '.setItem(' .. tostring(name) .. ',' .. tostring(count) .. ')^7')

		local item = self.getItem(name)
		item.count = count
		self.saveItem(name, item.count)
	end

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end

		local label = 'Inconnu (' .. name .. ')'

		if ESX.ExistItem(name) then
			label = ESX.GetItem(name).label
		end

		item = {
			name = name,
			count = 0,
			label = label,
		}

		table.insert(self.items, item)
		return item
	end

	self.insertItem = function(name, count)
		if self.owner == nil then
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (@inventory_name, @item_name, @count)', {
				['@inventory_name'] = self.name,
				['@item_name'] = name,
				['@count'] = count,
			}, function(numLineChanged)
				if numLineChanged <= 0 then
					error('(INSERT) No line changed in AddonInventory ' .. tostring(self.name) .. ' | ' .. tostring(numLineChanged) .. ' | ' .. tostring(owner))
				end
			end)
		else
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (@inventory_name, @item_name, @count, @owner)', {
				['@inventory_name'] = self.name,
				['@item_name'] = name,
				['@count'] = count,
				['@owner'] = self.owner
			}, function(numLineChanged)
				if numLineChanged <= 0 then
					error('(INSERT) No line changed in AddonInventory ' .. tostring(self.name) .. ' | ' .. tostring(numLineChanged) .. ' | ' .. tostring(owner))
				end
			end)
		end
	end

	self.saveItem = function(name, count)
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name', {
				['@inventory_name'] = self.name,
				['@item_name'] = name,
				['@count'] = count,
			}, function(numLineChanged)
				if numLineChanged == 0 then
					self.insertItem(name, count)
				elseif numLineChanged == 1 then
					-- Normal behavior
				else
					error('(UPDATE) No line changed in AddonInventory ' .. tostring(self.name) .. ' | ' .. tostring(numLineChanged))
				end
			end)
		else
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner', {
				['@inventory_name'] = self.name,
				['@item_name'] = name,
				['@count'] = count,
				['@owner'] = self.owner,
			}, function(numLineChanged)
				if numLineChanged == 0 then
					self.insertItem(name, count)
				elseif numLineChanged == 1 then
					-- Normal behavior
				else
					error('(UPDATE) No line changed in AddonInventory ' .. tostring(self.name) .. ' | ' .. tostring(numLineChanged) .. ' | ' .. tostring(owner))
				end
			end)
		end
	end

	return self
end

