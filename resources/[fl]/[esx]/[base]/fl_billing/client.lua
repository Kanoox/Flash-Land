Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5 * 60 * 1000)

		ESX.TriggerServerCallback('fl_billing:getBills', function(bills)
			local total = 0
			for _,AnyBill in pairs(bills) do total = total + AnyBill.amount end

			if total >= 5000 then
				ESX.ShowAdvancedNotification('Banque', 'Factures', '~r~Vous avez des factures impayées d\'un total de $' .. ESX.Math.GroupDigits(total) .. ' ! Votre compte bancaire risque d\'être bloqué.', 'CHAR_BANK_MAZE', 9)
			end
		end)
	end
end)