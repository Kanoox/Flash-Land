local RegisteredLicensesPoints = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT licenses_points.*,sex,height,dateofbirth FROM `licenses_points`,users WHERE licenses_points.owner = users.discord', {}, function(results)
		for _,LicensePoints in pairs(results) do
			RegisterLicensePoint(LicensePoints)
		end
	end)
end)

function RegisterLicensePoint(LicensePoints)
	local wasRegistered = RegisteredLicensesPoints[LicensePoints.id] ~= nil
	LicensePoints.createdDate = os.date("%d/%m/%Y", LicensePoints.created/1000)

	MySQL.Async.fetchAll('SELECT * FROM `user_licenses` WHERE `owner` = @owner', { ['@owner'] = LicensePoints.owner }, function(typeUserLicenses)
		local listLicense = {}
		for _,typeUser in pairs(typeUserLicenses) do
			if typeUser.type and (typeUser.type == 'boating' or typeUser.type:find('drive')) then
				table.insert(listLicense, typeUser.type)
			end
		end
		LicensePoints.typeList = listLicense
		RegisteredLicensesPoints[LicensePoints.id] = LicensePoints
	end)

	if wasRegistered then return end

	ESX.RegisterTempItem(Config.PrefixLicensePoints..LicensePoints.id, 'Permis à points N°' .. LicensePoints.id .. '', 0.01, -1, 0)

	ESX.RegisterCloseMenuUsableItem(Config.PrefixLicensePoints .. LicensePoints.id, true)
	ESX.RegisterUsableItem(Config.PrefixLicensePoints .. LicensePoints.id, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local RefreshedLicensePoints = RegisteredLicensesPoints[LicensePoints.id]

		TriggerClientEvent('fl_dmvschool:seeLicensePoints', xPlayer.source, RefreshedLicensePoints)
	end)
end

function CreateLicensePoint(target)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('INSERT INTO `licenses_points` (`owner`, `firstname`, `lastname`, `type`, `points`) VALUES (@owner, @firstname, @lastname, @type, @initial);', {
		['@owner'] = xPlayerTarget.discord,
		['@lastname'] = xPlayerTarget.lastname,
		['@firstname'] = xPlayerTarget.firstname,
		['@type'] = json.encode({}),
		['@initial'] = Config.MaxPoints,
	}, function(lineInserted)
		if lineInserted ~= 1 then error('Insert error') end

		MySQL.Async.fetchAll('SELECT licenses_points.*,sex,height,dateofbirth FROM `licenses_points`,users WHERE licenses_points.owner = users.discord AND `id` = (SELECT MAX(id) FROM licenses_points);', {}, function(results)
			if not results[1] then error('No result') end
			RegisterLicensePoint(results[1])
			xPlayerTarget.addInventoryItem(Config.PrefixLicensePoints .. results[1].id, 1)
		end)
	end)
end

function UpdateData(LicensePointID, cb)
	MySQL.Async.fetchAll('SELECT licenses_points.*,sex,height,dateofbirth FROM `licenses_points`,users WHERE licenses_points.owner = users.discord AND id = @id', { ['@id'] = LicensePointID }, function(results)
		RegisterLicensePoint(results[1])
		cb(RegisteredLicensesPoints[LicensePointID])
	end)
end

function SetPoints(LicensePointID, Points, cb)
	if Points < 0 then Points = 0 end
	MySQL.Async.execute('UPDATE `licenses_points` SET `points`=@points WHERE `id` = @id;', {
		['@points'] = Points,
		['@id'] = LicensePointID,
	}, function(lineInserted)
		if lineInserted ~= 1 then error('Update error') end
		UpdateData(LicensePointID, cb)
	end)
end

RegisterNetEvent('fl_dmvschool:createLicensePoint')
AddEventHandler('fl_dmvschool:createLicensePoint', function()
	CreateLicensePoint(source)
end)

RegisterNetEvent('fl_dmvschool:showToOther')
AddEventHandler('fl_dmvschool:showToOther', function(target, LicensePointID)
	local LicensePoints = RegisteredLicensesPoints[LicensePointID]
	TriggerServerEvent('jsfour-idcard:openCustom', target, 'driver', LicensePoints.firstname, LicensePoints.lastname, LicensePoints.dateofbirth, LicensePoints.sex, LicensePoints.height, LicensePoints.typeList)
end)

RegisterNetEvent('fl_dmvschool:removePoints')
AddEventHandler('fl_dmvschool:removePoints', function(LicensePointID, Points)
	local LicensePoints = RegisteredLicensesPoints[LicensePointID]
	local xPlayer = ESX.GetPlayerFromId(source)
	if LicensePoints.points - Points < 0 then
		Points = LicensePoints.points
	end

	if Points > 0 then
		xPlayer.showNotification('~y~Vous avez retirer ' .. Points .. ' points du permis n°' .. LicensePoints.id)
		local xPlayerOwner = ESX.GetPlayerFromDiscordIdentifier(LicensePoints.owner)
		if xPlayerOwner then
			xPlayerOwner.showNotification('~r~Vous avez perdu ' .. Points .. ' sur votre permis n°' .. LicensePoints.id)
		end
	end

	SetPoints(LicensePoints.id, LicensePoints.points - Points, function(LicensePoints)
	end)
end)

ESX.RegisterServerCallback('fl_dmvschool:hasAnyLicensePoint', function(xPlayer, source, cb)
	MySQL.Async.fetchAll('SELECT id FROM `licenses_points` WHERE `owner` = @owner', { ['@owner'] = xPlayer.discord }, function(results)
		cb(results[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('fl_dmvschool:searchLicenseById', function(xPlayer, source, cb, LicensePointID)
	local LicensePoints = nil

	for _,AnyLicensePoints in pairs(RegisteredLicensesPoints) do
		if AnyLicensePoints.id == LicensePointID then
			LicensePoints = AnyLicensePoints
		end
	end

	cb(LicensePoints)
end)

-- Vendredi 23h00
TriggerEvent('cron:runAtDay', 6, 23, 00, function()
	for _,LicensePoints in pairs(RegisteredLicensesPoints) do
		if LicensePoints.points < Config.MaxPoints - Config.RegenPointsPerWeek then
			SetPoints(LicensePoints.id, LicensePoints.points + Config.RegenPointsPerWeek, function(LicensePoints)
				local xPlayer = ESX.GetPlayerFromDiscordIdentifier(LicensePoints.owner)
				if xPlayer then
					xPlayer.showNotification('~g~Vous avez regagné 2 points de permis ! (N° ' .. LicensePoints.id .. ')')
				end
			end)
		elseif LicensePoints.points < Config.MaxPoints then
			SetPoints(LicensePoints.id, 12, function(LicensePoints)
				local xPlayer = ESX.GetPlayerFromDiscordIdentifier(LicensePoints.owner)
				if xPlayer then
					xPlayer.showNotification('~g~Vous avez regagné tout vos points de permis ! (N° ' .. LicensePoints.id .. ')')
				end
			end)
		end
	end
end)