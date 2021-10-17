local function init()
    for _,job in pairs(flCore.jobs) do 
        if job.createBlip ~= nil then job.createBlip() end
    end

    local job = ESX.PlayerData.job.name
    if job == 'police' then
        if ESX.IsPlayerLoaded() then
            if flCore.jobs[job] ~= nil then 
                flCore.jobs[job].init() 
            end
        end
    end
end

local function changed()
    for k,v in pairs(flCore.jobs) do 
        if v.jobChanged ~= nil then 
            v.jobChanged() 
        end 
    end
end

flCore.jobs = {}
flCore.jobsFunc = {}
flCore.jobsFunc.init = init
flCore.jobsFunc.changed = changed