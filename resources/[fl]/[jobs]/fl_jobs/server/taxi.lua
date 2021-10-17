RegisterNetEvent('fl_jobs:taxi:successTaxi')
AddEventHandler('fl_jobs:taxi:successTaxi', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= 'taxi' then
        print(('fl_jobs:taxi: %s attempted to trigger success!'):format(xPlayer.discord))
        return
    end

    math.randomseed(os.time())

    local total = math.random(Config.NPCTaxiJobEarnings.min, Config.NPCTaxiJobEarnings.max)
    local winMoney = ESX.Math.Round(total / 100 * 70)

    TriggerEvent('fl_data:getSharedAccount', "society_taxi", function(account)
        account.addMoney(winMoney)
        xPlayer.showNotification('Vous avez gagné ' .. winMoney .. ' ~g~$~s~')
    end)
end)
