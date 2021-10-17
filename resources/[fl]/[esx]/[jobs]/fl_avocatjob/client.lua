AddEventHandler('fl_society:openMobileAction', function(society)
	if society == 'avocat' and ESX.PlayerData.job.grade_name == "boss" then
		TriggerEvent('fl_society:openBossMenu', 'avocat', function(data, menu)
			menu.close()
		end)
	end
end)