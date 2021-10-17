jobsMarkers = {
    
    subscribe = function()
        local playerJob = ESX.PlayerData.job.name
        if jobsMarkers.list[playerJob] == nil then return end 

        for job,marker in pairs(jobsMarkers.list[playerJob]) do
            flCore.markers.subscribe(marker)
        end
    end,

    unsubscribe = function()
        local playerJob = ESX.PlayerData.job.name
        if jobsMarkers.list[playerJob] == nil then return end 

        for job,marker in pairs(jobsMarkers.list[playerJob]) do
            flCore.markers.unsubscribe(marker)
        end
    end,

    unsubscribeAll = function()
        for job,marker in pairs(jobsMarkers.list) do
            for _,a in pairs(jobsMarkers.list[job]) do 
                flCore.markers.unsubscribe(a)
            end
        end
    end,


    list = {

        ["police"] = {
            "police_clothes",
            "police_armory",
            "police_vehicle",
            "police_boat",
            "police_vehicleClear",
            "police_helicopter",
            "police_helicopterClear",
            "police_boss",
            "police_inventory",
            "police_perquise"
        },

    },
}

flCore.jobsMarkers = jobsMarkers