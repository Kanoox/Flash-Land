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
    local wait = {30,60,50,80}
    flCore.load("Initialisation flCore")
    Citizen.Wait(1000)
    local i = 0
    local max = 0
    for k,v in pairs(flCore.markers.list) do
        max = max + 1
    end
    for k,v in pairs(flCore.markers.list) do
        i = i + 1
        flCore.load("Initialisation flCore - Zones ("..i.."/"..max..")")
        Citizen.Wait(wait[math.random(1,#wait)])
    end
    flCore.load("Initialisation flCore - Métiers..")
    Citizen.Wait(1400)
    wait = {100,200,300,100}
    i = 0
    max = 0
    for k,v in pairs(flCore.jobs) do
        max = max + 1
    end
    for k,v in pairs(flCore.jobs) do
        i = i + 1
        flCore.load("Initialisation flCore - Métiers ("..i.."/"..max..")")
        Citizen.Wait(wait[math.random(1,#wait)])
    end
    flCore.load("Initialisation flCore - Lancement..")
    Citizen.Wait(500)
    flCore.load(false)
end

local function notNilString(str)
    if str == nil then
        return ""
    else
        return str
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


flCore.loadESX = loadESX
flCore.utils = Utils
flCore.load = showLoading
flCore.mug = mug
flCore.loadAll = loadAll
flCore.notNil = notNilString
flCore.keyboard = keyboard
