ESX.RegisterServerCallback('fl_gouv:getLicenseList', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT name, licenses.type, firstname, lastname, label FROM user_licenses, users, licenses WHERE user_licenses.owner = users.discord AND user_licenses.type = licenses.type ORDER BY `users`.`lastname` ASC', {}, function(result)
		local licenseList = {}

		for i=1, #result, 1 do
			table.insert(licenseList, {
				name = result[i].name,
				type = result[i].type,
				label = result[i].label,
				firstname = result[i].firstname,
				lastname = result[i].lastname,
			})
		end

		cb(licenseList)
	end)
end)
