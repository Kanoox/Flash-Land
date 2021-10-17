function CreateAddonAccount(name, owner, money)
	local self = {}

	self.name = name
	self.owner = owner
	self.money = money

	self.getMoney = function()
		return self.money
	end

	self.addMoney = function(m)
		self.money = self.money + m
		self.save()

		TriggerClientEvent('fl_data:updateAddonAccountMoney', -1, self.name, self.money)
	end

	self.removeMoney = function(m)
		self.money = self.money - m
		self.save()

		TriggerClientEvent('fl_data:updateAddonAccountMoney', -1, self.name, self.money)
	end

	self.setMoney = function(m)
		self.money = m
		self.save()

		TriggerClientEvent('fl_data:updateAddonAccountMoney', -1, self.name, self.money)
	end

	self.exist = function(cb)
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name AND owner = @owner', {
			['@account_name'] = account_name,
			['@owner'] = owner,
		}, function(result)
			cb(result[1] ~= nil)
		end)
	end

	self.insert = function(cb)
		MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
			['@account_name'] = self.name,
			['@money'] = self.money,
			['@owner'] = self.owner
		}, function(nbLine)
			if nbLine == 1 then
				print('Inserted new account')
				if self.owner == nil then
					SharedAccounts[self.name] = self
				else
					if not Accounts[self.name] then
						table.insert(AccountsIndex, self.name)
						Accounts[self.name] = {}
					end
					table.insert(Accounts[self.name], self)
				end
				cb()
			else
				error('Unable to input addonaccount')
			end
		end)
	end

	self.save = function()
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name', {
				['@account_name'] = self.name,
				['@money'] = self.money
			})
		else
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name AND owner = @owner', {
				['@account_name'] = self.name,
				['@money'] = self.money,
				['@owner'] = self.owner
			})
		end
	end

	return self
end