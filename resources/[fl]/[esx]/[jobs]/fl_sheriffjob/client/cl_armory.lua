Citizen.CreateThread(function()
	RefreshPed()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	RefreshPed()
end)

RefreshPed = function(spawn)
	ESX.TriggerServerCallback("qalle_sheriffarmory:pedExists", function(Exists)
		if Exists and not spawn then
			return
		else
			LoadModels({ GetHashKey(Config.Armory["hash"]) })

			local pedId = CreatePed(5, Config.Armory["hash"], Config.Armory["x"], Config.Armory["y"], Config.Armory["z"] - 0.985, Config.Armory["h"], true)

			SetPedCombatAttributes(pedId, 46, true)
			SetPedFleeAttributes(pedId, 0, 0)
			SetBlockingOfNonTemporaryEvents(pedId, true)

			SetEntityAsMissionEntity(pedId, true, true)
			SetEntityInvincible(pedId, true)

			FreezeEntityPosition(pedId, true)
			UnloadModels()
		end
	end)
end

local CachedModels = {}

LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			ESX.Streaming.RequestModel(model)
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)

				Citizen.Wait(10)
			end
		end
	end
end

UnloadModels = function()
	for modelIndex = 1, #CachedModels do
		local model = CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)
		end

		table.remove(CachedModels, modelIndex)
	end
end