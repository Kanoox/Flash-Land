RegisterNetEvent('fl_dmvschool:seeLicensePoints')
AddEventHandler('fl_dmvschool:seeLicensePoints', function(LicensePoints)
	local elements = {}
	local closePlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), false), 2.0);

	table.insert(elements, {label = 'Regarder le permis', value = 'show'})
	table.insert(elements, {label = 'Montrer le permis', value = 'showToOther'})

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
		table.insert(elements, {label = 'Rechercher ce permis en BDD', value = 'searchPolice'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bracelet_put', {
		title = 'Permis à point N°' .. LicensePoints.id,
		elements = elements
	}, function(data, menu)
		if data.current.value == 'show' then
			TriggerEvent('jsfour-idcard:openCustom', 'driver', LicensePoints.firstname, LicensePoints.lastname, LicensePoints.dateofbirth, LicensePoints.sex, LicensePoints.height, LicensePoints.typeList)
			menu.close()
		elseif data.current.value == 'searchPolice' then
			ESX.TriggerServerCallback('fl_dmvschool:searchLicenseById', function(LicensePoints)
				ShowLicenseCompleteInfo(LicensePoints)
			end, LicensePoints.id)
		elseif data.current.value == 'showToOther' then
			if #closePlayers == 1 then
				ESX.ShowNotification('~r~Personne à qui montrer votre permis...')
			elseif #closePlayers == 2 then
    			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(player))
    			ESX.ShowAdvancedNotification('Permis à point', ' ', 'Vous montrer votre permis à quelqu\'un', mugshotStr, 1)
    			UnregisterPedheadshot(mugshot)

				TriggerServerEvent('fl_dmvschool:showToOther', GetPlayerServerId(player), LicensePoints.id)
				menu.close()
			elseif #closePlayers > 2 then
				ESX.ShowNotification('~r~Trop de monde autour de vous...')
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

AddEventHandler('fl_dmvschool:dialogFindLicenseById', function()
	DialogFindLicenseById()
end)

function DialogFindLicenseById()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dialog_amount', { title = 'Rechercher un n° de permis' },
		function(data, menu)
			local LicensePointID = tonumber(data.value)
			if LicensePointID == nil then
				ESX.ShowNotification('~r~N° invalide')
				return
			end
			menu.close()

			ESX.TriggerServerCallback('fl_dmvschool:searchLicenseById', function(LicensePoints)
				if LicensePoints == nil then
					ESX.ShowNotification('~r~Aucun permis avec ce numéro...')
					return
				end

				ShowLicenseCompleteInfo(LicensePoints)
			end, LicensePointID)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function ShowLicenseCompleteInfo(LicensePoints)
	local elements = {}

	table.insert(elements, {label = 'Nom : ' .. LicensePoints.firstname})
	table.insert(elements, {label = 'Prénom : ' .. LicensePoints.lastname})
	table.insert(elements, {label = 'Points : ' .. LicensePoints.points})
	table.insert(elements, {label = 'Attribué le : ' .. LicensePoints.createdDate})
	table.insert(elements, {type = 'separator'})

	for _,Type in pairs(LicensePoints.typeList) do
		table.insert(elements, {label = _U(Type)})
	end

	table.insert(elements, {type = 'separator'})
	table.insert(elements, {label = 'Enlever des points' , value = 'removePoints'})

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'license_show_full', {
		title = 'Permis à point N°' .. LicensePoints.id,
		elements = elements
	}, function(data, menu)
		if not data.current.value then return end

		if data.current.value == 'removePoints' then
			NumberOfPointsToRemove(LicensePoints)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function NumberOfPointsToRemove(LicensePoints)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dialog_amount', { title = 'Nombre de points à retirer' },
		function(data, menu)
			local number = tonumber(data.value)
			if number == nil then
				ESX.ShowNotification('~r~Nombre invalide')
				return
			end
			menu.close()

			TriggerServerEvent('fl_dmvschool:removePoints', LicensePoints.id, number)
			Citizen.Wait(1000)
			ESX.TriggerServerCallback('fl_dmvschool:searchLicenseById', function(LicensePoints)
				ShowLicenseCompleteInfo(LicensePoints)
			end, LicensePoints.id)
		end,
		function(data, menu)
			menu.close()
		end
	)
end