ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local reportadmin = {

}

function reportadminok(player)
    local allowed = false
    for i,id in ipairs(reportadmin) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterServerEvent('checkreportadmin')
AddEventHandler('checkreportadmin', function()
	local id = source
	if reportadminok(id) then
		TriggerClientEvent("setreportadmin", source)
	end
end)

ESX.RegisterServerCallback('h4ci_report:affichereport', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}

    MySQL.Async.fetchAll('SELECT * FROM h4ci_report', {}, 
        function(result)
        for numreport = 1, #result, 1 do
            table.insert(keys, {
                id = result[numreport].id,
                type = result[numreport].type,
                reporteur = result[numreport].reporteur,
                nomreporter = result[numreport].nomreporter,
                raison = result[numreport].raison
            })
        end
        cb(keys)

    end)
end)

RegisterServerEvent('h4ci_report:ajoutreport')
AddEventHandler('h4ci_report:ajoutreport', function(typereport, reporteur, nomreporter, raison)
    MySQL.Async.execute('INSERT INTO h4ci_report (type, reporteur, nomreporter, raison) VALUES (@type, @reporteur, @nomreporter, @raison)', {
        ['@type'] = typereport,
        ['@reporteur'] = reporteur,
        ['@nomreporter'] = nomreporter,
        ['@raison'] = raison
    })
end)

RegisterServerEvent('h4ci_report:supprimereport')
AddEventHandler('h4ci_report:supprimereport', function(supprimer)
    MySQL.Async.execute('DELETE FROM h4ci_report WHERE id = @id', {
            ['@id'] = supprimer
    })
end)