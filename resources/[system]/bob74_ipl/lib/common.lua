-- Global variables
Global = {
    currentInteriorId = 0,

    -- The current interior is set to True by 'interiorIdObserver'
    Online = {
        isInsideApartmentHi1 = false,
        isInsideApartmentHi2 = false,
        isInsideHouseHi1 = false,
        isInsideHouseHi2 = false,
        isInsideHouseHi3 = false,
        isInsideHouseHi4 = false,
        isInsideHouseHi5 = false,
        isInsideHouseHi6 = false,
        isInsideHouseHi7 = false,
        isInsideHouseHi8 = false,
        isInsideHouseLow1 = false,
        isInsideHouseMid1 = false
    },
    Biker = {
        isInsideClubhouse1 = false,
        isInsideClubhouse2 = false
    },
    FinanceOffices = {
        isInsideOffice1 = false,
        isInsideOffice2 = false,
        isInsideOffice3 = false,
        isInsideOffice4 = false
    },
    HighLife = {
        isInsideApartment1 = false,
        isInsideApartment2 = false,
        isInsideApartment3 = false,
        isInsideApartment4 = false,
        isInsideApartment5 = false,
        isInsideApartment6 = false

    },


    -- Set all interiors variables to false
    -- The loop inside 'interiorIdObserver' will set them to true
    ResetInteriorVariables = function()
        for _, parentKey in pairs{"Biker", "FinanceOffices", "HighLife"} do
            local t = Global[parentKey]
            for key in pairs(t) do
                t[key] = false
            end
        end
    end
}




exports('GVariables', function()
    return Global
end)

exports('EnableIpl', function(ipl, activate)
    return EnableIpl(ipl, activate)
end)

exports('GetPedheadshotTexture', function(ped)
    return GetPedheadshotTexture(ped)
end)

local listSimple = {}
local listComplexe = {}

Citizen.CreateThread(function()
    Citizen.Wait(10)
    listSimple = {
        GTAOApartmentHi1, GTAOApartmentHi2, GTAOHouseHi1, GTAOHouseHi2, GTAOHouseHi3, GTAOHouseHi4, GTAOHouseHi5, GTAOHouseHi6, GTAOHouseHi7, GTAOHouseHi8, GTAOHouseLow1, GTAOHouseMid1,
        HLApartment1, HLApartment2, HLApartment3, HLApartment4, HLApartment5, HLApartment6,
        BikerClubhouse1, BikerClubhouse2,
        Franklin, Michael, Floyd, Simeon,
    }

    listComplexe = {
        FinanceOffice1, FinanceOffice2, FinanceOffice3, FinanceOffice4,
        ExecApartment1, ExecApartment2, ExecApartment3,
    }
end)

exports('GetObjectFromInteriorId', function(interiorId)
    for _,Object in pairs(listSimple) do
        if Object.interiorId == interiorId then
            return {
                InteriorObject = Object,
                InteriorTheme = nil,
            }
        end
    end

    for _,ObjectComplex in pairs(listComplexe) do
        for ThemeName,Theme in pairs(ObjectComplex.Style.Theme) do
            if Theme.interiorId == interiorId then
                return {
                    InteriorObject = ObjectComplex,
                    InteriorTheme = ThemeName,
                }
            end
        end
    end

    return nil
end)

-- Load or remove IPL(s)
function EnableIpl(ipl, activate)
    if IsTable(ipl) then
        for key, value in pairs(ipl) do
            EnableIpl(value, activate)
        end
    else
        if activate then
            if string.find(ipl, "milo") then
                return
            end

            if not IsIplActive(ipl) then
                RequestIpl(ipl)
                repeat
                    Citizen.Wait(10)
                until IsIplActive(ipl)
            end
        else
            if IsIplActive(ipl) then RemoveIpl(ipl) end
        end
    end
end

-- Enable or disable the specified props in an interior
function SetIplPropState(interiorId, props, state, refresh)
    if refresh == nil then refresh = false end
    if IsTable(interiorId) then
        for key, value in pairs(interiorId) do
            SetIplPropState(value, props, state, refresh)
        end
    else
        if IsTable(props) then
            for key, value in pairs(props) do
                SetIplPropState(interiorId, value, state, refresh)
            end
        else
            if state then
                if not IsInteriorPropEnabled(interiorId, props) then EnableInteriorProp(interiorId, props) end
            else
                if IsInteriorPropEnabled(interiorId, props) then DisableInteriorProp(interiorId, props) end
            end
        end
        if refresh then RefreshInterior(interiorId) end
    end
end

function CreateNamedRenderTargetForModel(name, model)
    local handle = 0
    if not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, false)
    end
    if not IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end
    if IsNamedRendertargetRegistered(name) then
        handle = GetNamedRendertargetRenderId(name)
    end

    return handle
end

function DrawEmptyRect(name, model)
    local step = 250
    local timeout = 5 * 1000
    local currentTime = 0
    local renderId = CreateNamedRenderTargetForModel(name, model)

    while (not IsNamedRendertargetRegistered(name)) do
        Citizen.Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return false end
    end
    if (IsNamedRendertargetRegistered(name)) then
        SetTextRenderId(renderId)
        SetUiLayer(4)
        DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 0)
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())

        ReleaseNamedRendertarget(0, name)
    end

    return true
end

function SetupScaleform(movieId, scaleformFunction, parameters)
    BeginScaleformMovieMethod(movieId, scaleformFunction)
    N_0x77fe3402004cd1b0(name)
    if (IsTable(parameters)) then
        for i = 0, Tablelength(parameters) - 1 do
            local p = parameters["p" .. tostring(i)]
            if (p.type == "bool") then
                PushScaleformMovieMethodParameterBool(p.value)
            elseif (p.type == "int") then
                PushScaleformMovieMethodParameterInt(p.value)
            elseif (p.type == "float") then
                PushScaleformMovieMethodParameterFloat(p.value)
            elseif (p.type == "string") then
                PushScaleformMovieMethodParameterString(p.value)
            elseif (p.type == "buttonName") then
                PushScaleformMovieMethodParameterButtonName(p.value)
            end
        end
    end
    EndScaleformMovieMethod()
    N_0x32f34ff7f617643b(movieId, 1)
end

function LoadStreamedTextureDict(texturesDict)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0

    RequestStreamedTextureDict(texturesDict, 0)
    while not HasStreamedTextureDictLoaded(texturesDict) do
        Citizen.Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return false end
    end
    return true
end

function LoadScaleform(scaleform)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0
    local handle = RequestScaleformMovie(scaleform)

    while (not HasScaleformMovieLoaded(handle)) do
        Citizen.Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return -1 end
    end

    return handle
end

function GetPedheadshot(ped)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0
    local pedheadshot = RegisterPedheadshot(ped)

    while not IsPedheadshotReady(pedheadshot) do
        Citizen.Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return -1 end
    end

    return pedheadshot
end

function GetPedheadshotTexture(ped)
    local textureDict = nil
    local pedheadshot = GetPedheadshot(ped)

    if (pedheadshot ~= -1) then
        textureDict = GetPedheadshotTxdString(pedheadshot)
        local IsTextureDictLoaded = LoadStreamedTextureDict(textureDict)
        if (not IsTextureDictLoaded) then
            Citizen.Trace("ERROR: BikerClubhouseDrawMembers - Textures dictionnary \"" .. tostring(textureDict) .. "\" cannot be loaded.")
        end
    else
        Citizen.Trace("ERROR: BikerClubhouseDrawMembers - PedHeadShot not ready.")
    end

    return textureDict
end

-- Check if a variable is a table
function IsTable(T)
    return type(T) == 'table'
end
-- Return the number of elements of the table
function Tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

