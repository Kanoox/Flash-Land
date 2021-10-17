local PlayersHarvestingTabac = {}
local PlayersCraftingTabac = {}
local PlayersCraftingTabac2 = {}
local PlayersCraftingTabac3 = {}
local PlayersSellingTabac = {}
local PlayersSellingTabac2 = {}

local function HarvestTabac(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    SetTimeout(4000, function()

        if PlayersHarvestingTabac[xPlayer.source] then
            if xPlayer.getInventoryItem('feuilletabac').count >= 100 then
                xPlayer.showNotification('~r~Vous n\'avez plus de place~s~')
            else
                xPlayer.addInventoryItem('feuilletabac', 5)
                HarvestTabac(xPlayer.source)
            end
        end
    end)
end

RegisterNetEvent('nwx_tabac:startHarvestTabac')
AddEventHandler('nwx_tabac:startHarvestTabac', function()
    if PlayersHarvestingTabac[source] then return end
    PlayersHarvestingTabac[source] = true
    TriggerClientEvent('esx:showNotification', source, 'Récupération des ~b~feuilles de tabac~s~...')
    HarvestTabac(source)
end)

RegisterNetEvent('nwx_tabac:stopHarvestTabac')
AddEventHandler('nwx_tabac:stopHarvestTabac', function()
    PlayersHarvestingTabac[source] = false
end)

-- Séchage du tabac
local function CraftTabac(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    SetTimeout(4000, function()
        if PlayersCraftingTabac[xPlayer.source] then
            if xPlayer.getInventoryItem('feuilletabac').count <= 1 then
                xPlayer.showNotification('Vous n\'avez ~r~pas assez~s~ de feuille de tabac !')
            else
                xPlayer.removeInventoryItem('feuilletabac', 2)
                xPlayer.addInventoryItem('tabacsec', 1)
                CraftTabac(xPlayer.source)
            end
        end
    end)
end

RegisterNetEvent('nwx_tabac:startCraftTabac')
AddEventHandler('nwx_tabac:startCraftTabac', function()
    if PlayersCraftingTabac[source] then return end
    PlayersCraftingTabac[source] = true
    TriggerClientEvent('esx:showNotification', source, 'Séchage en ~g~cours~s~...')
    CraftTabac(source)
end)

RegisterNetEvent('nwx_tabac:stopCraftTabac')
AddEventHandler('nwx_tabac:stopCraftTabac', function()
    PlayersCraftingTabac[source] = false
end)

-- Tabac sec en cigarette
local function CraftTabac2(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    SetTimeout(4000, function()

        if PlayersCraftingTabac2[xPlayer.source] then
            if xPlayer.getInventoryItem('tabacsec').count <= 1 then
                xPlayer.showNotification('Vous n\'avez ~r~pas assez~s~ de tabac sec !')
            else
                xPlayer.removeInventoryItem('tabacsec', 2)
                xPlayer.addInventoryItem('malbora', 1)

                CraftTabac2(xPlayer.source)
            end
        end
    end)
end

RegisterNetEvent('nwx_tabac:startCraftTabac2')
AddEventHandler('nwx_tabac:startCraftTabac2', function()
    if PlayersCraftingTabac2[source] then return end
    PlayersCraftingTabac2[source] = true
    TriggerClientEvent('esx:showNotification', source, 'Assemblage ~g~en cours~s~...')
    CraftTabac2(source)
end)

RegisterNetEvent('nwx_tabac:stopCraftTabac2')
AddEventHandler('nwx_tabac:stopCraftTabac2', function()
    PlayersCraftingTabac2[source] = false
end)

-- Tabac sec en cigar
local function CraftTabac3(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    SetTimeout(4000, function()
        if PlayersCraftingTabac3[xPlayer.source] then
            if xPlayer.getInventoryItem('tabacsec').count <= 2 then
                xPlayer.showNotification('Vous n\'avez ~r~pas assez~s~ de tabac sec !')
            else
                xPlayer.removeInventoryItem('tabacsec', 3)
                xPlayer.addInventoryItem('cigar', 1)

                CraftTabac3(xPlayer.source)
            end
        end
    end)
end

RegisterNetEvent('nwx_tabac:startCraftTabac3')
AddEventHandler('nwx_tabac:startCraftTabac3', function()
    if PlayersCraftingTabac3[source] then return end
    PlayersCraftingTabac3[source] = true
    TriggerClientEvent('esx:showNotification', source, 'Assemblage ~g~en cours~s~...')
    CraftTabac3(source)
end)

RegisterNetEvent('nwx_tabac:stopCraftTabac3')
AddEventHandler('nwx_tabac:stopCraftTabac3', function()
    PlayersCraftingTabac3[source] = false
end)

-- Vente des cigarettes
local function SellTabac(source, zone)

    if PlayersSellingTabac[source] then
        local xPlayer = ESX.GetPlayerFromId(source)

        if zone == 'TabacSellFarm' then
            if xPlayer.getInventoryItem('malbora').count <= 1 then
                TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas assez de cigarettes a vendre.')
                return
            end

            SetTimeout(5000, function()
                local money = math.random(10, 14)
                xPlayer.removeInventoryItem('malbora', 2)
                local societyAccount

                TriggerEvent('fl_data:getSharedAccount', 'society_tabac', function(account)
                    societyAccount = account
                end)
                if societyAccount ~= nil then
                    societyAccount.addMoney(money)
                    xPlayer.showNotification('Votre société a gagné ~g~$' .. money)
                end
                xPlayer.addMoney(2)
                xPlayer.showNotification('Vous avez gagné ~g~2$~s~')
                SellTabac(source, zone)
            end)
        end
    end
end

RegisterNetEvent('nwx_tabac:startSellTabac')
AddEventHandler('nwx_tabac:startSellTabac', function(zone)
    if PlayersSellingTabac[source] then return end
    PlayersSellingTabac[source] = true
    TriggerClientEvent('esx:showNotification', source, 'Vente en cours..')
    SellTabac(source, zone)
end)

RegisterNetEvent('nwx_tabac:stopSellTabac')
AddEventHandler('nwx_tabac:stopSellTabac', function()
    PlayersSellingTabac[source] = false
    TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
end)

-- Vente des cigarettes
local function SellTabac2(source, zone)

    if PlayersSellingTabac2[source] then
        local xPlayer = ESX.GetPlayerFromId(source)

        if zone == 'TabacSellFarm2' then
            if xPlayer.getInventoryItem('cigar').count <= 1 then
                TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas assez de cigarettes a vendre.')
                return
            end

            SetTimeout(5000, function()
                local money = math.random(12, 16)
                xPlayer.removeInventoryItem('cigar', 2)
                local societyAccount

                TriggerEvent('fl_data:getSharedAccount', 'society_tabac', function(account)
                    societyAccount = account
                end)
                if societyAccount ~= nil then
                    societyAccount.addMoney(money)
                    xPlayer.showNotification('Votre société a gagné ~g~$' .. money)
                end
                xPlayer.addMoney(4)
                xPlayer.showNotification('Vous avez gagné ~g~4$~s~')
                SellTabac2(source, zone)
            end)
        end
    end
end

RegisterNetEvent('nwx_tabac:startSellTabac2')
AddEventHandler('nwx_tabac:startSellTabac2', function(zone)
    if PlayersSellingTabac2[source] then return end
    PlayersSellingTabac2[source] = true
    TriggerClientEvent('esx:showNotification', source, 'Vente en cours..')
    SellTabac2(source, zone)
end)

RegisterNetEvent('nwx_tabac:stopSellTabac2')
AddEventHandler('nwx_tabac:stopSellTabac2', function()
    PlayersSellingTabac2[source] = false
    TriggerClientEvent('esx:showNotification', source, 'Vous sortez de la ~r~zone')
end)
