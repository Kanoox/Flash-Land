local defaultDormantNameFormat = "/!\\ #%i"
local seeBlips = false;

local farBlips = {}
local playerBlips = {}
local latestBlipsUpdate = {}
local evaluationPlayers = {}

local blipsColor = {
    [`taxi`] = 5,

    [`polvic`] = 3,
    [`polchar`] = 3,
    [`poltaurus`] = 3,
    [`17fusionrb`] = 3,
    [`explorer`] = 3,
    [`fbi`] = 3,
    [`police4`] = 3,
    [`policeb`] = 3,
    [`pbus`] = 3,
    [`riot`] = 3,
    [`riot2`] = 3,
    [`scorcher`] = 3,
    [`police`] = 3,
    [`police2`] = 3,
    [`police3`] = 3,
    [`polmav`] = 3,
    [`sherrif2`] = 3,
}

local blipsType = {
	[`taxi`] = 198,

	[`nightshark`] = 225,

	[`rhino`] = 421,

	[`lazer`] = 424,
	[`besra`] = 424,
	[`hydra`] = 424,

	[`insurgent`] = 426,
	[`insurgent2`] = 426,
	[`insurgent3`] = 426,

	[`limo2`] = 460,

	[`blazer5`] = 512,

	[`phantom2`] = 528,
	[`boxville5`] = 529,
	[`ruiner2`] = 530,
	[`dune4`] = 531,
	[`dune5`] = 531,
	[`wastelander`] = 532,
	[`voltic2`] = 533,
	[`technical2`] = 534,
	[`technical3`] = 534,
	[`technical`] = 534,

	[`apc`] = 558,
	[`oppressor`] = 559,
	[`oppressor2`] = 559,
	[`halftrack`] = 560,
	[`dune3`] = 561,
	[`tampa3`] = 562,
	[`trailersmall2`] = 563,

	[`alphaz1`] = 572,
	[`bombushka`] = 573,
	[`havok`] = 574,
	[`howard`] = 575,
	[`hunter`] = 576,
	[`microlight`] = 577,
	[`mogul`] = 578,
	[`molotok`] = 579,
	[`nokota`] = 580,
	[`pyro`] = 581,
	[`rogue`] = 582,
	[`starling`] = 583,
	[`seabreeze`] = 584,
	[`tula`] = 585,

	[`avenger`] = 589,

	[`stromberg`] = 595,
	[`deluxo`] = 596,
	[`thruster`] = 597,
	[`khanjali`] = 598,
	[`riot2`] = 599,
	[`volatol`] = 600,
	[`barrage`] = 601,
	[`akula`] = 602,
    [`chernobog`] = 603,

    [`trash`] = 318,
    [`trash2`] = 318,

    [`police`] = 56,
    [`police2`] = 56,
    [`police3`] = 56,
    [`police4`] = 56,
    [`polvic`] = 56,
    [`policet`] = 56,
    [`polchar`] = 56,
    [`poltaurus`] = 56,
    [`17fusionrb`] = 56,
    [`explorer`] = 56,
    [`fbi`] = 56,
    [`fbi2`] = 56,
    [`pbus`] = 56,
    [`riot`] = 56,
    [`riot2`] = 56,
    [`scorcher`] = 56,

    [`apc`] = 421,
    [`minitank`] = 421,
    [`chernobog`] = 421,
    [`rhino`] = 421,
    [`khanjali`] = 598,
    [`scarab`] = 667,
    [`scarab2`] = 667,
    [`scarab3`] = 667,

    [`cargobob`] = 481,
    [`cargobob2`] = 481,
    [`cargobob3`] = 481,
    [`cargobob4`] = 481,

    [`pbus`] = 631,
    [`pbus2`] = 631,
    [`rentalbus`] = 513,
    [`tourbus`] = 513,
    [`airbus`] = 513,
    [`bus`] = 513,
    [`coach`] = 513,

    [`havok`] = 574,

    [`oppressor`] = 639,
    [`oppressor2`] = 639,

    [`blimp`] = 638,
    [`blimp2`] = 638,
    [`blimp3`] = 638,

    [`formula`] = 646,
    [`formula2`] = 646,
    [`openwheel1`] = 646,
    [`openwheel2`] = 646,
}

exports("GetLatestBlipsUpdate", function()
    return latestBlipsUpdate
end)

function table.filter(table, it)
    local ret = {}
    for key, value in pairs(table) do
        if it(value, key, table) then
            ret[key] = value
        end
    end

    return ret
end

local function GetServerPlayerIds()
    -- get all the players that are currently in the same instance
    -- as the local player ("active" players)
    local rawPlayers = GetActivePlayers()

    -- make a new table for storing player server IDs
    local playerIDs = {}

    -- iterate raw_players using ipairs and insert their server ID
    -- into the player_ids table
    for index, player in ipairs(rawPlayers) do
        table.insert(playerIDs, GetPlayerServerId(player))
    end

    return playerIDs
end

local function Evaluate()
    -- iterate through the players needed to be removed
    for _, player in ipairs(evaluationPlayers) do

        -- iterate through every blip handle we currently have stored
        for player, blip in pairs(farBlips) do

            -- filter through the most recent blips update for blips belonging to this player
            local results = table.filter(latestBlipsUpdate, function(blip, key, blips)
                return blip[1] == player
            end)

            -- if there are no blips belonging to this player, attempt to delete and dispose of handle
            if #results == 0 and farBlips[player] ~= nil then

                -- check if the blip handle does actually exist, if so, delete it
                if DoesBlipExist(farBlips[player]) then
                    RemoveBlip(farBlips[player])
                end

                -- remove the player blip handle from storage
                farBlips[player] = nil
            end
        end
    end

    for _, player in ipairs(evaluationPlayers) do

        -- iterate through every blip handle we currently have stored
        for player, blip in pairs(playerBlips) do

            -- filter through the most recent blips update for blips belonging to this player
            local results = table.filter(latestBlipsUpdate, function(blip, key, blips)
                return blip[1] == player
            end)

            -- if there are no blips belonging to this player, attempt to delete and dispose of handle
            if #results == 0 and playerBlips[player] ~= nil then

                -- check if the blip handle does actually exist, if so, delete it
                if DoesBlipExist(playerBlips[player]) then
                    RemoveBlip(playerBlips[player])
                end

                -- remove the player blip handle from storage
                playerBlips[player] = nil
            end
        end
    end

    evaluationPlayers = {}
end

local function Clear()
    for player, blip in pairs(farBlips) do
        if DoesBlipExist(farBlips[player]) then
            RemoveBlip(farBlips[player])
        end
        farBlips[player] = nil
    end
    for player, blip in pairs(playerBlips) do
        if DoesBlipExist(playerBlips[player]) then
            RemoveBlip(playerBlips[player])
        end
        playerBlips[player] = nil
    end
end

AddEventHandler("_bigmode:setSeeBlips", function(see)
    seeBlips = see
end)

-- this is called when a player leaves the server so clients can clean-up old blips
RegisterNetEvent("_bigmode:evaluateBlips")
AddEventHandler("_bigmode:evaluateBlips", function(player)
    table.insert(evaluationPlayers, player)
end)

-- this is called when the server sends a new or updated batch of player data
RegisterNetEvent("_bigmode:updateBlips")
AddEventHandler("_bigmode:updateBlips", function(blips)
    latestBlipsUpdate = blips

    if #evaluationPlayers >= 1 then
        Evaluate()
    end

    if not seeBlips then
    	Clear()
    	return
    end

    Citizen.CreateThread(function()
        -- iterate all dormant blips sent to us by the server
        for index, blip in pairs(blips) do
            local player = blip[1]
            local playerPed = NetworkDoesEntityExistWithNetworkId(blip[2]) and NetworkGetEntityFromNetworkId(blip[2]) or nil

            -- get the players name and coords from the blip
            local playerName = blip[3]
            local coords = blip[4]
            local heading = blip[5]
            local model = blip[6]
            local vehicle = tonumber(blip[7])
            local passengers = tonumber(blip[8])

            -- sanity check in-case the player name isn't sent by server
            if coords == nil then
                coords = playerName
                playerName = nil
            end

            local sprite = 1
            if blipsType[model] ~= nil then
                sprite = blipsType[model]
            elseif IsThisModelABike(model) then
                sprite = 348
            elseif IsThisModelABoat(model) then
                sprite = 427
            elseif IsThisModelAHeli(model) then
                sprite = 422
            elseif IsThisModelAPlane(model) then
                sprite = 423
            elseif IsThisModelACar(model) then
                sprite = 326
            end

            local color = 0
            if blipsColor[model] ~= nil then
                color = blipsColor[model]
            end

            -- if the player isn't in our instance and isn't our local player, draw this blip
            if playerPed == nil then
                if playerBlips[player] ~= nil then
                    RemoveBlip(playerBlips[player])
                    playerBlips[player] = nil
                end
                -- check if a blip already exists on the map for this player and
                -- if there is then use the stored handle, otherwise, create a
                -- new one and add it to the farBlips table
                local blip = 0
                if farBlips[player] ~= nil and DoesBlipExist(farBlips[player]) then
                    blip = farBlips[player]

                    -- update the blips position
                    ShowHeadingIndicatorOnBlip(blip, sprite == 1)
                    if sprite ~= 422 then
                        SetBlipRotation(blip, heading)
                    end
                    SetBlipCoords(blip, coords[1], coords[2], coords[3])
                else
                    blip = AddBlipForCoord(coords[1], coords[2], coords[3])

                    SetBlipRotation(blip, heading)
                    SetBlipAlpha(blip, 220)
                    SetBlipScale(blip, 0.6)
                    --SetBlipShrink(blip, 1)
                    SetBlipCategory(blip, 7)
                    SetBlipDisplay(blip, 6)

                    -- store the blip handle in the farBlips table using the players' server ID as key
                    farBlips[player] = blip
                end

                SetBlipSprite(blip, sprite)
                SetBlipColour(blip, color)
                SetBlipAsShortRange(blip, true)
                if passengers <= 1 then
                    HideNumberOnBlip(blip, passengers)
                else
                    ShowNumberOnBlip(blip, passengers)
                end

                -- set the blip name to the players' name, or the default dormant name if not sent by the server
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(playerName ~= nil and playerName or string.format(defaultDormantNameFormat, player))
                EndTextCommandSetBlipName(blip)
            else
                if farBlips[player] ~= nil then
                    RemoveBlip(farBlips[player])
                    farBlips[player] = nil
                end

                local blip = 0
                if playerBlips[player] == nil then
                    blip = AddBlipForEntity(playerPed)

                    SetBlipRotation(blip, heading)
                    SetBlipAlpha(blip, 220)
                    SetBlipScale(blip, 0.6)
                    --SetBlipShrink(blip, 1)
                    SetBlipCategory(blip, 7)
                    SetBlipDisplay(blip, 6)
                    playerBlips[player] = blip
                else
                    blip = playerBlips[player]

                    ShowHeightOnBlip(blip, sprite == 1)
                    ShowHeadingIndicatorOnBlip(blip, sprite == 1)
                    SetBlipCoords(blip, coords[1], coords[2], coords[3])
                end

                SetBlipSprite(blip, sprite)
                SetBlipColour(blip, color)
                SetBlipAsShortRange(blip, true)
                if passengers <= 1 then
                    HideNumberOnBlip(blip, passengers)
                else
                    ShowNumberOnBlip(blip, passengers)
                end

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(playerName ~= nil and playerName or string.format(defaultDormantNameFormat, player))
                EndTextCommandSetBlipName(blip)
            end
        end
    end)
end)

RegisterNetEvent('fl_blips:debug')
AddEventHandler('fl_blips:debug', function()
    print('debug_before', seeBlips)
    seeBlips = not seeBlips
    print('after', seeBlips)
end)