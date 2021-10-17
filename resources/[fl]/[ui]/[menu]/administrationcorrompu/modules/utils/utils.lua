local Utils = {
    help = function(mess)
        AddTextEntry("TEST", mess)
        DisplayHelpTextThisFrame("TEST", false)
    end,
}   

local function loadESX()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    
    -- PlayerData
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    ESX.PlayerData = ESX.GetPlayerData()
end

local function trace(mess)
    print(pzCore.prefix..mess)
end


RegisterCommand("coords", function(source, args, rawcommand)
    local pos = GetEntityCoords(PlayerPedId())
    local playerH = GetEntityHeading(PlayerPedId())
    print(pos.x..", "..pos.y..", "..pos.z..","..playerH)
end, false)

local function showLoading(message)
    if type(message) == "string" then
        Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
        AddTextComponentSubstringPlayerName(message)
        Citizen.InvokeNative(0xBD12F8228410D9B4, 3)
    else
        Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
        AddTextComponentSubstringPlayerName("")
        Citizen.InvokeNative(0xBD12F8228410D9B4, -1)
    end
end

local function mug(title, subject, msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end

local function loadAll()
    pzCore.load(false)
end

local function notNilString(str)
    if str == nil then
        return ""
    else
        return str
    end
end

local function getWeaponName(name)
    local wp = {
        ["weapon_nightstick"] = "Matraque"
    }

    if wp[string.lower(name)] == nil then
        return string.lower(name)
    else
        return wp[string.lower(name)]
    end
end

local function getItemName(name)
    local items = {
        ["bread"] = "Pain",
        ["bandage"] = "Bandage"
    }

    if items[string.lower(name)] == nil then
        return string.lower(name)
    else
        return items[string.lower(name)]
    end
end

local function keyboard(title,mess)
    AddTextEntry("FMMC_MPM_NA", title)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", mess, "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
end

local function bigKeyboard(title,mess)
    AddTextEntry("FMMC_KEY_TIP8", title)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", mess, "", "", "", "", 5000)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
end

local function getGround(vector)
    return vector3(vector.x, vector.y, GetGroundZFor_3dCoord(vector.x,vector.y,vector.z,0))
end

pzCore.loadESX = loadESX
pzCore.trace = trace
pzCore.utils = Utils
pzCore.load = showLoading
pzCore.mug = mug
pzCore.loadAll = loadAll
pzCore.getWeaponName = getWeaponName
pzCore.getItemName = getItemName
pzCore.notNil = notNilString
pzCore.keyboard = keyboard
pzCore.bigKeyboard = bigKeyboard
pzCore.getGround = getGround