local PlayersWorking = {}
local Players = {}


AddEventHandler('esx:playerLoaded', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.set('caution', 0)
end)

AddEventHandler('esx:playerDropped', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local caution = xPlayer.get('caution')
  TriggerEvent('fl_data:getAddonAccount', 'caution', xPlayer.discord, function(account)
    account.addMoney(caution)
  end)
end)

RegisterNetEvent('fl_jobs:setCautionInCaseOfDrop')
AddEventHandler('fl_jobs:setCautionInCaseOfDrop', function(caution)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.set('caution', caution)
end)

RegisterNetEvent('fl_jobs:giveBackCautionInCaseOfDrop')
AddEventHandler('fl_jobs:giveBackCautionInCaseOfDrop', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('fl_data:getAddonAccount', 'caution', xPlayer.discord, function(account)
    local caution = account.money
    account.removeMoney(caution)
    if caution > 0 then
      xPlayer.addAccountMoney('bank', caution)
      TriggerClientEvent('esx:showNotification', _source, _U('bank_deposit_g').. caution .. _U('bank_deposit2'))
    end
  end)
end)

local function Work(source, item)
  SetTimeout(item[1].time, function()

    if PlayersWorking[source] then

      local xPlayer = ESX.GetPlayerFromId(source)
      if xPlayer == nil then
        return
      end

      for i=1, #item, 1 do
        local itemQtty = 0
        if item[i].name ~= _U('delivery') then
          itemQtty = xPlayer.getInventoryItem(item[i].db_name).count
        end

        local requiredItemQtty = 0
        if item[1].requires ~= "nothing" then
          requiredItemQtty = xPlayer.getInventoryItem(item[1].requires).count
        end

        if item[i].name ~= _U('delivery') and itemQtty >= item[i].max then
          TriggerClientEvent('esx:showNotification', source, _U('max_limit') .. item[i].name)
        elseif item[i].requires ~= "nothing" and requiredItemQtty <= 0 then
          TriggerClientEvent('esx:showNotification', source, _U('not_enough') .. item[1].requires_name .. _U('not_enough2'))
        else
          if item[i].name ~= _U('delivery') then
            -- Chances to drop the item
            if item[i].drop == 100 then
            local itemQuantity = xPlayer.getInventoryItem(item[i].db_name).count
            if itemQuantity + item[i].add > 100 then
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Vous n\'avez plus de place...')
                return
            end
            xPlayer.addInventoryItem(item[i].db_name, item[i].add)
        else
              local chanceToDrop = math.random(100)
              if chanceToDrop <= item[i].drop then
                if xPlayer.canCarryItem(item[i].db_name, item[i].add) then
                  TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Vous n\'avez plus de place...')
                  return
                end
                xPlayer.addInventoryItem(item[i].db_name, item[i].add)
              end
            end
          else
            xPlayer.addMoney(item[i].price)
          end

        end
      end

      if item[1].requires ~= "nothing" then
        local itemToRemoveQtty = xPlayer.getInventoryItem(item[1].requires).count
        if itemToRemoveQtty > 0 then
          xPlayer.removeInventoryItem(item[1].requires, item[1].remove)
        end
      end
      Work(source, item)

    end
  end)
end

RegisterNetEvent('fl_jobs:startWork')
AddEventHandler('fl_jobs:startWork', function(item)
  local source = source
  PlayersWorking[source] = true
  Work(source, item)
end)

RegisterNetEvent('fl_jobs:stopWork')
AddEventHandler('fl_jobs:stopWork', function()
  local source = source
  PlayersWorking[source] = false
end)

RegisterNetEvent('fl_jobs:caution')
AddEventHandler('fl_jobs:caution', function(cautionType, cautionAmount, spawnPoint, vehicle)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if cautionType == "take" then
    xPlayer.removeAccountMoney('bank', cautionAmount)
    xPlayer.set('caution', cautionAmount)
    TriggerClientEvent('esx:showNotification', source, _U('bank_deposit_r') .. cautionAmount .. _U('caution_taken'))
    TriggerClientEvent('fl_jobs:spawnJobVehicle', source, spawnPoint, vehicle)
  elseif cautionType == "give_back" then
    xPlayer.addAccountMoney('bank', cautionAmount)
    xPlayer.set('caution', 0)
    TriggerClientEvent('esx:showNotification', source, _U('bank_deposit_g') .. cautionAmount .. _U('caution_returned'))
  end
end)