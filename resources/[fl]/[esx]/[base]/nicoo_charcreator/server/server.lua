ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("modeo:UpdatePrenom")
AddEventHandler("modeo:UpdatePrenom", function(prenomInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newPrenom = prenomInput
	if (tostring(newPrenom) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET firstname=@prenomInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@prenomInput'] = tostring(newPrenom)})
end)

RegisterServerEvent("modeo:UpdateName")
AddEventHandler("modeo:UpdateName", function(nameInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newName = nameInput
	if (tostring(newName) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET lastname=@nameInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@nameInput'] = tostring(newName)})
end)

RegisterServerEvent("modeo:UpdateTaille")
AddEventHandler("modeo:UpdateTaille", function(tailleInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newTaille = tailleInput
	if (tonumber(tailleInput) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET height=@tailleInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@tailleInput'] = tonumber(newTaille)})
end)

RegisterServerEvent("modeo:Updatesex")
AddEventHandler("modeo:Updatesex", function(sexInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newsex = sexInput
	if (tostring(newsex) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET sex=@sexInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@sexInput'] = tostring(newsex)})
end)

RegisterServerEvent("modeo:Updatedate")
AddEventHandler("modeo:Updatedate", function(dateInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newdate = dateInput
	if (tostring(dateInput) == nil) then
      return false
	end
	MySQL.Async.execute("UPDATE users SET dateofbirth=@dateInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@dateInput'] = tostring(newdate)})
end)

RegisterServerEvent("modeo:Updateorigine")
AddEventHandler("modeo:Updateorigine", function(origineInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local neworigine = origineInput
	if (tostring(origineInput) == nil) then
      return false
	end
	MySQL.Async.execute("UPDATE users SET origine=@origineInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@origineInput'] = tostring(neworigine)})
end)