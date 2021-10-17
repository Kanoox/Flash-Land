AccountsIndex, Accounts, SharedAccounts = {}, {}, {}
local EndedInitializationAccounts = false

MySQL.ready(function()
	MySQL.Async.execute('DELETE FROM `addon_inventory_items` WHERE `count` <= 0', nil, function(rowsChanged)
		if rowsChanged > 0 then
			print('Cleaned ' .. tostring(rowsChanged) .. ' empty items in addon_inventory_items')
		end
	end)

	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account')

	for i=1, #result, 1 do
		local name = result[i].name
		local label = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
			['@account_name'] = name
		})

		if shared == 0 then
			table.insert(AccountsIndex, name)
			Accounts[name] = {}

			for j=1, #result2, 1 do
				local addonAccount = CreateAddonAccount(name, result2[j].owner, result2[j].money)
				table.insert(Accounts[name], addonAccount)
			end
		else
			local money = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, NULL)', {
					['@account_name'] = name,
					['@money'] = 0
				})

				money = 0
			else
				money = result2[1].money
			end

			local addonAccount   = CreateAddonAccount(name, nil, money)
			SharedAccounts[name] = addonAccount
		end
	end

	EndedInitializationAccounts = true
end)

function GetAccount(name, owner)
	if Accounts[name] == nil then
		error('No Account with name : ' .. tostring(name))
	end

	for i=1, #Accounts[name], 1 do
		if Accounts[name][i].owner == owner then
			return Accounts[name][i]
		end
	end

	print('No Account with name : ' .. tostring(name) .. ' - ' .. tostring(owner))
	return nil
end

function GetSharedAccount(name)
	while not EndedInitializationAccounts do
		Citizen.Wait(0)
	end

	if SharedAccounts[name] == nil then
		error('No SharedAccount with name : ' .. tostring(name))
	end

	return SharedAccounts[name]
end

AddEventHandler('fl_data:getOrCreateAddonAccount', function(name, owner, cb)
	local account = GetAccount(name, owner..'')

	if account == nil then
		account = CreateAddonAccount(name, owner, 0)
		account.exist(function(doAccountExist)
			if not doAccountExist then
				account.insert(function()
					cb(account)
				end)
			else
				error('Account exist but not returned by GetAccount')
			end
		end)
	else
		cb(account)
	end
end)

AddEventHandler('fl_data:getAddonAccount', function(name, owner, cb)
	cb(GetAccount(name, owner..''))
end)

AddEventHandler('fl_data:getSharedAccount', function(name, cb)
	cb(GetSharedAccount(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonAccounts = {}

	for i=1, #AccountsIndex, 1 do
		local name = AccountsIndex[i]
		local account = GetAccount(name, xPlayer.discord)

		if account == nil then
			MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
				['@account_name'] = name,
				['@money'] = 0,
				['@owner'] = xPlayer.discord
			})

			account = CreateAddonAccount(name, xPlayer.discord, 0)
			table.insert(Accounts[name], account)
		end

		table.insert(addonAccounts, account)
	end

	xPlayer.set('addonAccounts', addonAccounts)
end)

local InventoriesIndex, Inventories, SharedInventories = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory')

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		LoadAddonInventory(name, label, shared)
	end
end)

function InsertAddonInventory(name, label, shared, cb)
	MySQL.Async.execute('INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, @shared)', {
		['@name'] = name,
		['@label'] = label,
		['@shared'] = shared,
	}, function(rowsChanged)
		LoadAddonInventory(name, label, shared, cb)
	end)
end

function LoadAddonInventory(name, label, shared, cb)
	MySQL.Async.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
		['@inventory_name'] = name
	}, function(addonInventoryItems)
		if shared == 0 or not shared then
			table.insert(InventoriesIndex, name)

			Inventories[name] = {}
			local items       = {}

			for j=1, #addonInventoryItems, 1 do
				local itemName  = addonInventoryItems[j].name
				local itemCount = addonInventoryItems[j].count
				local itemOwner = addonInventoryItems[j].owner

				if items[itemOwner] == nil then
					items[itemOwner] = {}
				end

				if itemCount > 0 then
					local isDuplicate = false
					for _,anyItem in pairs(items) do
						if anyItem.name == itemName then
							isDuplicate = true
						end
					end

					local label = 'Inconnu (' .. itemName .. ')'
					if ESX.ExistItem(itemName) then
						label = ESX.GetItem(itemName).label
					end

					if not isDuplicate then
						table.insert(items[itemOwner], {
							name  = itemName,
							count = itemCount,
							label = label
						})
					else
						print('Dupe item in inventory ' .. tostring(name) .. ' : ' .. tostring(itemName))

						MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE id = @id', {
							['@id'] = addonInventoryItems[j].id,
						}, function(rowsChanged) end)
					end
				end
			end

			for k,v in pairs(items) do
				local addonInventory = CreateAddonInventory(name, k, v)
				table.insert(Inventories[name], addonInventory)
			end

			if cb then error('Not supported') end
		else
			local items = {}

			for j=1, #addonInventoryItems, 1 do
				local itemName  = addonInventoryItems[j].name
				local itemCount = addonInventoryItems[j].count

				if itemCount > 0 then
					local isDuplicate = false
					for _,anyItem in pairs(items) do
						if anyItem.name == itemName then
							isDuplicate = true
						end
					end

					local label = 'Inconnu (' .. itemName .. ')'
					if ESX.ExistItem(itemName) then
						label = ESX.GetItem(itemName).label
					end

					if not isDuplicate then
						table.insert(items, {
							name  = itemName,
							count = itemCount,
							label = label
						})
					else
						print('Dupe item in inventory ' .. tostring(name) .. ' : ' .. tostring(itemName))

						MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE id = @id', {
							['@id'] = addonInventoryItems[j].id,
						}, function(rowsChanged) end)
					end
				end
			end

			local addonInventory    = CreateAddonInventory(name, nil, items)
			SharedInventories[name] = addonInventory
			if cb then
				cb(SharedInventories[name])
			end
		end
	end)

end

function GetInventory(name, owner)
	for i=1, #Inventories[name], 1 do
		if Inventories[name][i].owner == owner then
			return Inventories[name][i]
		end
	end

	local addonInventory = CreateAddonInventory(name, owner, {})
	table.insert(Inventories[name], addonInventory)
	return addonInventory
end

function GetSharedInventory(name, cb)
	if SharedInventories[name] then
		cb(SharedInventories[name])
		return
	end

	InsertAddonInventory(name, '!' .. name, true, cb)
end

AddEventHandler('fl_addoninventory:getInventory', function(name, owner, cb)
	cb(GetInventory(name, owner .. ''))
end)

AddEventHandler('fl_addoninventory:getSharedInventory', function(name, cb)
	GetSharedInventory(name, cb)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonInventories = {}

	for i=1, #InventoriesIndex, 1 do
		local name      = InventoriesIndex[i]
		local inventory = GetInventory(name, xPlayer.discord)

		if inventory == nil then
			inventory = CreateAddonInventory(name, xPlayer.discord, {})
			table.insert(Inventories[name], inventory)
		end

		table.insert(addonInventories, inventory)
	end

	xPlayer.set('addonInventories', addonInventories)
end)

local DataStores, DataStoresIndex, SharedDataStores = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM datastore')

	for i=1, #result, 1 do
		local name = result[i].name
		local label = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE name = @name', {
			['@name'] = name
		})

		if shared == 0 then
			table.insert(DataStoresIndex, name)
			DataStores[name] = {}

			for j=1, #result2, 1 do
				local storeName = result2[j].name
				local storeOwner = result2[j].owner
				local storeData = (result2[j].data == nil and {} or json.decode(result2[j].data))
				local dataStore = CreateDataStore(storeName, storeOwner, storeData)
				table.insert(DataStores[name], dataStore)
			end
		else
			local data = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, NULL, \'{}\')', {
					['@name'] = name
				})

				data = {}
			else
				data = json.decode(result2[1].data)
			end

			local dataStore = CreateDataStore(name, nil, data)
			SharedDataStores[name] = dataStore
		end
	end
end)

function GetAllDataStore(name)
	return DataStores[name]
end

function GetDataStore(name, owner)
	for i=1, #DataStores[name], 1 do
		if DataStores[name][i].owner == owner then
			return DataStores[name][i]
		end
	end
end

function GetDataStoreOwners(name)
	local discords = {}

	for i=1, #DataStores[name], 1 do
		table.insert(discords, DataStores[name][i].owner)
	end

	return discords
end

function GetSharedDataStore(name)
	if SharedDataStores[name] == nil then error('Unknown SharedDataStore : ' .. tostring(name)) end
	return SharedDataStores[name]
end

AddEventHandler('fl_datastore:getAllSharedDataStores', function(cb)
	cb(SharedDataStores)
end)

AddEventHandler('fl_datastore:getAllDataStore', function(name, cb)
	cb(GetAllDataStore(name))
end)

AddEventHandler('fl_datastore:getDataStore', function(name, owner, cb)
	cb(GetDataStore(name, owner))
end)

AddEventHandler('fl_datastore:insertToDataStore', function(name, owner, storingName, what)
	local store = GetDataStore(name, owner)
	local storing = store.get(storingName)
	if storing == nil then
		storing = {}
	end
	table.insert(storing, what)
	store.set(storingName, storing)
end)

AddEventHandler('fl_datastore:removeFromDataStore', function(name, owner, storingName, what)
	local store = GetDataStore(name, owner)
	local storing = store.get(storingName)

	if storing == nil then
		storing = {}
	end

	table.remove(storing, what)
	store.set(storingName, storing)
end)

AddEventHandler('fl_datastore:getDataStoreOwners', function(name, cb)
	cb(GetDataStoreOwners(name))
end)

AddEventHandler('fl_datastore:getSharedDataStore', function(name, cb)
	cb(GetSharedDataStore(name))
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	for i=1, #DataStoresIndex, 1 do
		local name = DataStoresIndex[i]
		local dataStore = GetDataStore(name, xPlayer.discord)

		if not dataStore then
			MySQL.Async.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, @owner, @data)', {
				['@name']  = name,
				['@owner'] = xPlayer.discord,
				['@data']  = '{}'
			})

			dataStore = CreateDataStore(name, xPlayer.discord, {})
			table.insert(DataStores[name], dataStore)
		end
	end
end)
