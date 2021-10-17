Citizen.CreateThread(function()
    for ShopId, Shop in pairs(Config.Shops) do
        CreatePedForShop(ShopId)
    end

    while true do
        for ShopId, Shop in pairs(Config.Shops) do
            if not Shop.robbed then
                if not DoesEntityExist(Shop.ped) then
                    CreatePedForShop(ShopId)
                end

                if GetEntityHealth(Shop.ped) <= 0 then
                    CreatePedForShop(ShopId)
                end
            end
            Citizen.Wait(50)
        end

        Citizen.Wait(60 * 1000)
    end
end)

function CreatePedForShop(ShopId)
    local Shop = Config.Shops[ShopId]
    if DoesEntityExist(Shop.ped) then
        DeleteEntity(Shop.ped)
    end

    Shop.ped = CreatePed(26, Config.Shopkeeper, Shop.coords.x, Shop.coords.y, Shop.coords.z, Shop.heading)
    SetPedRandomComponentVariation(Shop.ped)
    SetPedRandomProps(Shop.ped)
    FreezeEntityPosition(Shop.ped, true)
    Shop.pedNetId = NetworkGetNetworkIdFromEntity(Shop.ped)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for ShopId, Shop in pairs(Config.Shops) do
        if DoesEntityExist(Shop.ped) then
            DeleteEntity(Shop.ped)
        end
    end
end)

RegisterNetEvent('fl_shops:pickUp')
AddEventHandler('fl_shops:pickUp', function(ShopId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Shop = Config.Shops[ShopId]

    if not Shop.robbed then
        xPlayer.showNotification('Non. (Erreur #54165)')
        return
    end

    if Shop.pickedUp then
        xPlayer.showNotification('Non. (Erreur #24354)')
        return
    end

    print(('[^2fl_shoprobbery^7] "%s^7" picked up at %s'):format(xPlayer.getName(), ShopId))

    Shop.pickedUp = true

    TriggerClientEvent('fl_shops:removePickup', -1, ShopId)

    if xPlayer.job.name == 'police' then
        xPlayer.showNotification('Vous avez rendu l\'argent à l\'épicier')
        return
    end

    local randomAmount = math.random(Config.minMoney, Config.maxMoney)
    xPlayer.addMoney(randomAmount)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez récupéré ~g~$' .. randomAmount)
end)

ESX.RegisterServerCallback('fl_shops:canRob', function(xPlayer, source, cb, PedNetId)
    local Shop = nil
    local ShopId = nil
    for AnyShopId, AnyShop in pairs(Config.Shops) do
        if AnyShop.pedNetId == PedNetId then
            Shop = AnyShop
            ShopId = AnyShopId
        end
    end

    if Shop == nil or ShopId == nil then
        cb('unknown', 0)
        return
    end

    local cops = #ESX.GetPlayersWithJob('police')

    if cops < Config.minCops and xPlayer.group ~= '_dev' then
        cb('no_cops')
        return
    end

    if Shop.robbed then
        cb('robbed')
        return
    end

    cb(DoesEntityExist(Shop.ped) and GetEntityHealth(Shop.ped) > 0, ShopId)
end)

RegisterNetEvent('fl_shops:rob')
AddEventHandler('fl_shops:rob', function(ShopId)
    local Shop = Config.Shops[ShopId]
    local xPlayer = ESX.GetPlayerFromId(source)
    local xSource = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    if Shop.robbed then
        TriggerClientEvent('esx:showNotification', source, '~r~Deja en cours...')
        return
    end
    print(('[^2fl_shoprobbery^7] "%s^7" rob %s'):format(xPlayer.getName(), ShopId))

    Shop.robbed = true
    Shop.pickedUp = false

    for k, v in pairs(xPlayers) do
		local xPlayer = ESX.GetPlayerFromId(v)
		if xPlayer.job.name == "police" then
            xPlayer.triggerEvent("iCore:getCallMsg", "Un ~b~braquage de supérette~s~ est en cours !", vector3(Config.Shops[ShopId].coords.x, Config.Shops[ShopId].coords.y, Config.Shops[ShopId].coords.z), xPlayer)
		end
	end


    Wait(math.random(20, 40) * 60 * 1000)

    print(('[^2fl_shoprobbery^7] %s robbery reset'):format(ShopId))

    Shop.robbed = false
    Shop.pickedUp = false
    CreatePedForShop(ShopId)
end)