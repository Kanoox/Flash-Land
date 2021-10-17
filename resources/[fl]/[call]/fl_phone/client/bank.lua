local bank = 0

function SetBankBalance(value)
	bank = value
	SendNUIMessage({event = 'updateBankBalance', banking = ESX.Math.GroupDigits(bank) .. ' $'})
end

function RefreshBankSocietyMoney()
	if ESX == nil or ESX.PlayerData.job == nil then return end
	ESX.TriggerServerCallback('fl_society:getSocietyMoney', function(money)
		if ESX.PlayerData.job.grade_name == 'boss' then
			SendNUIMessage({event = 'updateSocietyBankbalance', banking = ESX.Math.GroupDigits(money) .. ' $'})
		else
			SendNUIMessage({event = 'updateSocietyBankbalance', banking = 'Inconnu'})
		end
	end, ESX.GetPlayerData().job.name)
end

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	for _, account in ipairs(ESX.GetPlayerData().accounts) do
		if account.name == 'bank' then
			SetBankBalance(account.money)
			break
		end
	end
	RefreshBankSocietyMoney()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	RefreshBankSocietyMoney()
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == 'bank' then
		SetBankBalance(account.money)
	end
end)

RegisterNetEvent('fl_data:updateAddonAccountMoney')
AddEventHandler('fl_data:updateAddonAccountMoney', function(society, money)
	RefreshBankSocietyMoney()
end)