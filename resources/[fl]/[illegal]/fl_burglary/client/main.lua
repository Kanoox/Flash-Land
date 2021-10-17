cachedData = {
	houseData = {},
	Cameras = {}
}

Citizen.CreateThread(function()
	if ESX.IsPlayerLoaded() then
		FetchHouseData()
	end
end)

AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'burglary', function(instance) end, function(instance) end)
end)
TriggerEvent('instance:isLoaded')

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if not instance then error('instance:onCreate return nil instance') end
	if instance.type == 'burglary' then
		TriggerEvent('instance:enter', instance)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	FetchHouseData()
end)

RegisterCommand("debug_burglary_fetch", function()
	FetchHouseData()
end)

RegisterNetEvent("fl_burglary:eventHandler")
AddEventHandler("fl_burglary:eventHandler", function(response, eventData)
	if response == "lockpick_house" then
		cachedData.houseData[eventData.houseId] = {
			Lootables = {}
		}
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "police" then
			local district = GetStreetNameFromHashKey(GetStreetNameAtCoord(Config.Coords[eventData.houseId].Pos.x, Config.Coords[eventData.houseId].Pos.y, Config.Coords[eventData.houseId].Pos.z))
		
	--		TriggerServerEvent("iCore:sendCallMsg", "Un ~b~civil ~s~a vu quelqu'un s'introduire dans une ~b~propriété !\nPrès de : ~b~" .. district, Config.Coords[eventData.houseId].Pos)
		end
	elseif response == "lock_house" then
		cachedData.houseData[eventData.houseId] = {
			locked = true
		}
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "police" then
			if DoesBlipExist(cachedData[eventData.houseId].Blip) then
				RemoveBlip(cachedData[eventData.houseId].Blip)
			end
		end
	elseif response == "loot_place" then
		cachedData.houseData[eventData.houseId].Lootables[eventData.lootSpot] = true
	else
 		print("Wrong event handler: " .. tostring(response))
	end
end)

Citizen.CreateThread(function()
	Wait(500)

	while true do
		local sleepThread = 500

		if Config.PoliceCameras and ESX.PlayerData.job and ESX.PlayerData.job.name == "police" then
			if not cachedData.cameraMode then
				local ped = PlayerPedId()
				local pedCoords = GetEntityCoords(ped)
				local dstCheck = #(Config.CameraComputer - pedCoords)

				if dstCheck <= 3.0 then
					sleepThread = 5
					if dstCheck <= 1.2 then
						ESX.ShowHelpNotification("~INPUT_CONTEXT~ Caméra des cambriolages")

						if IsControlJustReleased(0, 38) then
							CameraMenu()
						end

					end
					DrawMarker(6, Config.CameraComputer-vector3(0.0,0.0,0.975), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 55, 100, 200, 155, 0, false, false, 0, false, false, false, false)
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	Wait(500)
	while true do
		local sleep = 500
		local pedCoords = GetEntityCoords(PlayerPedId())

		for id,data in pairs(Config.Coords) do
			local dstcheck = #(data.Pos - pedCoords)
			local text = data.Info

			if dstcheck <= 5.5 then
				sleep = 5
				if dstcheck <= 1.3 then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == "police" then
						text = "[~b~E~s~] " .. (cachedData.houseData[id] and "Enter | [~r~H~s~] Lock." or "Lockpick") .. " \n" .. data.Info
						if IsControlJustReleased(0, 38) or IsControlJustReleased(0, 74) then
							if cachedData.houseData[id] and not cachedData.houseData[id].locked then
								LockHouse(id, data)
							else
								ESX.ShowNotification("Déjà verrouillé !")
							end
						end
					else
						text = "[~b~E~s~] " .. (cachedData.houseData[id] and "Enter" or "Lockpick") .. " \n" .. data.Info
						if IsControlJustReleased(0, 38) then
							if not cachedData.houseData[id] then
								if HasLockPick() then ESX.TriggerServerCallback("fl_burglary:isHouseRobbable", function(robbable) if robbable then		
									
									local coords  = GetEntityCoords(PlayerPedId())
									local district = GetLabelText(GetNameOfZone(data.Pos.x, data.Pos.y, data.Pos.z))
									local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))
									TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~Voisinage\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos : ~s~Cambriolage \n", data.Pos)
									TriggerServerEvent("fl_appels:Zebi", "Cambriolage", data.Pos, 'Inconnu')
									
									BeginLockpick(id, data)
								 else ESX.ShowNotification("~r~Pas assez de policier") end end) else ESX.ShowNotification("~r~Vous n'avez pas de lockpick") end
							elseif cachedData.houseData[id] and not cachedData.houseData[id].locked then
								EnterHouse(id, data)
							else
								ESX.ShowNotification("Il semble que vous ne puissiez pas crocheter celle-là.")
							end
						end
					end
				end
				if Config.EnableHouseText then ESX.Game.Utils.DrawText3D(data.Pos, text, 0.6) end
				DrawMarker(6, data.Pos-vector3(0.0,0.0,0.975), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 55, 100, 200, 155, 0, false, false, 0, false, false, false, false)
			end

		end
		Citizen.Wait(sleep)
	end
end)
