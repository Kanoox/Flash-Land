local spikeModel = -874338148
local vehicle = nil
local spikes = nil
local ped = nil

local tires = {
    {bone = "wheel_lf", index = 0},
    {bone = "wheel_rf", index = 1},
    {bone = "wheel_lm", index = 2},
    {bone = "wheel_rm", index = 3},
    {bone = "wheel_lr", index = 4},
    {bone = "wheel_rr", index = 5}
}

Citizen.CreateThread(function()
    while true do
        ped = GetPlayerPed(PlayerId())
        vehicle = GetVehiclePedIsIn(ped, false)
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                local vehiclePos = GetEntityCoords(vehicle, false)
                spikes = GetClosestObjectOfType(vehiclePos.x, vehiclePos.y, vehiclePos.z, 80.0, spikeModel, 0, 0, 0)
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(400)
    end
end)

------------------
-- Tire Popping --
------------------
Citizen.CreateThread(function()
    while true do
        if spikes ~= 0 then
            for a = 1, #tires do
                local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                local spikePos = GetEntityCoords(spikes, false)
                local distance = #(tirePos - spikePos)

                if distance < 1.8 then
                    if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                        SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                    end
                end
            end
        else
            Citizen.Wait(500)
        end

        Citizen.Wait(50)
    end
end)