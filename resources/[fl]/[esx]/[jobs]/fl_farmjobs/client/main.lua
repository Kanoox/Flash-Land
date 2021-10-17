local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local menuIsShowed = false
local hintIsShowed = false
local hasAlreadyEnteredMarker = false
local Blips = {}
local JobBlips = {}

local collectedItem = nil
local collectedQtty = 0
local collectedQttyUpToDate = false
local previousCollectedItem = nil
local previousCollectedQtty = 0
local isInMarker = false
local isInPublicMarker = false

local newTask = false
local hintToDisplay = "no hint to display"
local jobDone = false
local onDuty = false
local moneyInBank = 0
local spawner = 0
local myPlate = {}
local isJobVehicleDestroyed = false

local cautionVehicleInCaseofDrop = 0
local maxCautionVehicleInCaseofDrop = 0
local vehicleObjInCaseofDrop = nil
local vehicleInCaseofDrop = nil
local vehicleHashInCaseofDrop = nil
local vehicleMaxHealthInCaseofDrop = nil
local vehicleOldHealthInCaseofDrop = nil
ESX = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent('fl_jobs:giveBackCautionInCaseOfDrop')
    refreshBlips()
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	refreshBlips()
end)

function OpenMenu()
	--ESX.UI.Menu.CloseAll()
  
	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'cloakroom',
	  {
		title = _U('cloakroom'),
		elements = {
		  {label = 'Garde robe perso', value = 'clotheshop'},
		  {label = _U('job_wear'), value = 'job_wear'},
		  {label = _U('citizen_wear'), value = 'citizen_wear'},
		}
	  },
	  function(data, menu)
		if data.current.value == 'citizen_wear' then
		  onDuty = false
		  ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin)
			  TriggerEvent('skinchanger:loadSkin', skin)
		  end)
		  Citizen.Wait(500)
		  SetPedComponentVariation(PlayerPedId(), 9,	0, 0, 2)
		elseif data.current.value == 'job_wear' then
		  onDuty = true
		  ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, jobSkin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
			end
		  end)
		elseif data.current.value == 'clotheshop' then
				  TriggerEvent('fl_clotheshop:openNonEditableDessing')
		end
		menu.close()
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  end

AddEventHandler('fl_jobs:action', function(job, zone)
  menuIsShowed = true
  if zone.Type == "cloakroom" then
    OpenMenu()
  elseif zone.Type == "work" then
    hintToDisplay = "no hint to display"
    hintIsShowed = false
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, 0) then
      TriggerEvent('esx:showNotification', _U('foot_work'))
    else
      TriggerServerEvent('fl_jobs:startWork', zone.Item)
    end
  elseif zone.Type == "vehspawner" then
    TriggerServerEvent('fl_jobs:requestPlayerData', 'refresh_bank_account')
    local spawnpt = nil
    local deliverypt = nil
    local vehicle = nil

    for k,v in pairs(Config.Jobs) do
      if ESX.PlayerData.job.name == k then
        for l,w in pairs(v.Zones) do
          if (w.Type == "vehspawnpt") and (w.Spawner == zone.Spawner) then
            spawnpt = w
            spawner = w.Spawner
          end
        end
        for m,x in pairs(v.Vehicles) do
          if (x.Spawner == zone.Spawner) then
            vehicle = x
          end
        end
      end
    end

    local caution = zone.Caution

    if deliverypt == nil then
      deliverypt = 0
    end

    TriggerServerEvent('fl_jobs:setCautionInCaseOfDrop', caution)
    cautionVehicleInCaseofDrop = caution
    maxCautionVehicleInCaseofDrop = cautionVehicleInCaseofDrop

    spawncar(spawnpt, vehicle)

  elseif zone.Type == "vehdelete" then
    local looping = true
    for k,v in pairs(Config.Jobs) do
      if ESX.PlayerData.job.name == k then
        for l,w in pairs(v.Zones) do
          if (w.Type == "vehdelete") and (w.Spawner == zone.Spawner) then
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, 0) then
              local vehicle = GetVehiclePedIsIn(playerPed, 0)
              local plate = GetVehicleNumberPlateText(vehicle)
              plate = string.gsub(plate, " ", "")
              local driverPed = GetPedInVehicleSeat(vehicle, -1)
              for i=1, #myPlate, 1 do
                if (myPlate[i] == plate) and (playerPed == driverPed) then
                  TriggerServerEvent('fl_jobs:caution', "give_back", cautionVehicleInCaseofDrop, 0, 0)
                  DeleteVehicle(GetVehiclePedIsIn(playerPed, 0))

                  if w.Teleport then
                    SetEntityCoords(PlayerPedId(), w.Teleport.x, w.Teleport.y, w.Teleport.z)
                  end

                  table.remove(myPlate, i)

                  if vehicleObjInCaseofDrop.HasCaution then
                    cautionVehicleInCaseofDrop = 0
                    maxCautionVehicleInCaseofDrop = 0
                    vehicleInCaseofDrop = nil
                    vehicleHashInCaseofDrop = nil
                    vehicleMaxHealthInCaseofDrop = nil
                    vehicleOldHealthInCaseofDrop = nil
                    vehicleObjInCaseofDrop = nil
                    TriggerServerEvent('fl_jobs:setCautionInCaseOfDrop', 0)
                  end

                  break
                end
              end
            end
            looping = false
            break
          end
          if not looping then
            break
          end
        end
      end
      if not looping then
        break
      end
    end
  elseif zone.Type == "delivery" then
    if Blips['delivery'] ~= nil then
      RemoveBlip(Blips['delivery'])
      Blips['delivery'] = nil
    end
    hintToDisplay = "no hint to display"
    hintIsShowed = false
    TriggerServerEvent('fl_jobs:startWork', zone.Item)
  end
  --nextStep(zone.GPS)
end)

function nextStep(gps)
  if gps ~= 0 then
    if Blips['delivery'] ~= nil then
      RemoveBlip(Blips['delivery'])
      Blips['delivery'] = nil
    end
    Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
    SetBlipRoute(Blips['delivery'], true)
    TriggerEvent('esx:showNotification', _U('next_point'))
  end
end

AddEventHandler('fl_jobs:hasExitedMarker', function(zone)
	TriggerServerEvent('fl_jobs:stopWork')
	hintToDisplay = "no hint to display"
	menuIsShowed = false
	hintIsShowed = false
	isInMarker = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	onDuty = false
	myPlate = {} -- loosing vehicle caution in case player changes job.
	spawner = 0
	deleteBlips()
	refreshBlips()
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function spawncar(spawnPoint, vehicle)
	hintToDisplay = "no hint to display"
	hintIsShowed = false
	TriggerServerEvent('fl_jobs:caution', "take", cautionVehicleInCaseofDrop, spawnPoint, vehicle)
  end

function refreshBlips()
	local zones = {}
	local blipInfo = {}

	if PlayerData.job ~= nil then
		for jobKey,jobValues in pairs(Config.Jobs) do

			if jobKey == PlayerData.job.name then
				for zoneKey,zoneValues in pairs(jobValues.Zones) do

					if zoneValues.Blip then
						local _Pos = {}
						if (zoneValues.Zone) then
							TriggerEvent("izone:getZoneCenter", zoneValues.Zone, function(_center)
								if (_center) then
									_Pos = _center
								end
							end)
						else
							_Pos = zoneValues.Pos
						end
					--	print(_Pos.x)
						local blip = AddBlipForCoord(_Pos.x, _Pos.y, _Pos.z)
						SetBlipSprite (blip, jobValues.BlipInfos.Sprite)
						SetBlipDisplay (blip, 4)
						SetBlipScale (blip, 0.7)
						SetBlipCategory(blip, 1)
						SetBlipColour (blip, jobValues.BlipInfos.Color)
						SetBlipAsShortRange(blip, true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(zoneValues.Name)
						EndTextCommandSetBlipName(blip)
						table.insert(JobBlips, blip)
					end
				end
			end
		end
	end
end

function spawnVehicle(spawnPoint, vehicle, vehicleCaution)
	hintToDisplay = 'no hint to display'
	hintIsShowed = false
	TriggerServerEvent('fl_jobs:caution', 'take', vehicleCaution, spawnPoint, vehicle)
end

RegisterNetEvent('fl_jobs:spawnJobVehicle')
AddEventHandler('fl_jobs:spawnJobVehicle', function(spawnPoint, vehicle)
	local playerPed = PlayerPedId()

	ESX.Game.SpawnVehicle(vehicle.Hash, spawnPoint.Pos, spawnPoint.Heading, function(spawnedVehicle)

		if vehicle.Trailer ~= "none" then
			ESX.Game.SpawnVehicle(vehicle.Trailer, spawnPoint.Pos, spawnPoint.Heading, function(trailer)
				AttachVehicleToTrailer(spawnedVehicle, trailer, 1.1)
			end)
		end

		-- save & set plate
		local plate = 'WORK' .. math.random(100, 900)
		SetVehicleNumberPlateText(spawnedVehicle, plate)
		table.insert(myPlate, plate)
		TriggerServerEvent('fl_controlvehicle:giveKey', plate)

		TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)

		if vehicle.HasCaution then
			vehicleInCaseofDrop = spawnedVehicle
			vehicleObjInCaseofDrop = vehicle
			vehicleMaxHealth = GetVehicleEngineHealth(spawnedVehicle)
		end
	end)
end)

-- Show top left hint
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if hintIsShowed then
			ESX.ShowHelpNotification('Appuyer sur ~INPUT_CONTEXT~ pour faire l\'action')
		else
			Citizen.Wait(500)
		end
	end
end)

-- Display markers (only if on duty and the player's job ones)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local zones = {}

		if PlayerData.job ~= nil then
			for k,v in pairs(Config.Jobs) do
				if PlayerData.job.name == k then
					zones = v.Zones
				end
			end

			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(zones) do
				if onDuty or v.Type == "cloakroom" then
					if (v.Zone) then
						TriggerEvent("izone:getZoneCenter", v.Zone, function(center)
							if (not(center == nil)) then
								if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, center.x, center.y, center.z, true) < Config.DrawDistance) then
									DrawMarker(v.Marker, center.x, center.y, center.z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
								end
							end
						end)
					else
						if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
							DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end
			end
		end
	end
end)


-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and PlayerData.job.name ~= 'unemployed' then
			local zones = nil
			local job = nil

			for k,v in pairs(Config.Jobs) do
				if PlayerData.job.name == k then
					job = v
					zones = v.Zones
				end
			end

			if zones ~= nil then
				local coords = GetEntityCoords(PlayerPedId())
				local currentZone = nil
				local zone  = nil
				local lastZone = nil

				for k,v in pairs(zones) do
					-- If we defined a zone from iZone
					if v.Zone then
						TriggerEvent("izone:isPlayerInZone", v.Zone, function(isIn)
							if isIn then
								isInMarker= true
								currentZone = k
								zone = v
								return
							else
								isInMarker = false
							end
						end)
						-- Because we were in a routine
						if isInMarker then
							break
						end
					-- Else use radius defined from center
					else
						if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
							isInMarker = true
							currentZone = k
							zone = v
							break
						else
							isInMarker = false
						end
					end
					
				end

				if IsControlJustReleased(0, Keys['E']) and not menuIsShowed and isInMarker then
					if onDuty or zone.Type == "cloakroom" then
						TriggerEvent('fl_jobs:action', job, zone)
					end
				end

				-- hide or show top left zone hints
				if isInMarker and not menuIsShowed then
					hintIsShowed = true
					if (onDuty or zone.Type == "cloakroom") and zone.Type ~= "vehdelete" then
						hintToDisplay = zone.Hint
						hintIsShowed = true
					elseif zone.Type == "vehdelete" then
						local playerPed = PlayerPedId()

						if IsPedInAnyVehicle(playerPed, false) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
							local driverPed = GetPedInVehicleSeat(vehicle, -1)
							local plate = GetVehicleNumberPlateText(vehicle)
							plate = string.gsub(plate, " ", "")

							if playerPed == driverPed then

								for i=1, #myPlate, 1 do
									if myPlate[i] == plate then
										hintToDisplay = zone.Hint
										break
									end
								end

							else
								hintToDisplay = _U('not_your_vehicle')
							end
						else
							hintToDisplay = _U('in_vehicle')
						end
						hintIsShowed = true
					elseif onDuty and zone.Spawner ~= spawner then
						hintToDisplay = _U('wrong_point')
						hintIsShowed = true
					else
						if not isInPublicMarker then
							hintToDisplay = "no hint to display"
							hintIsShowed = false
						end
					end
				end

				if isInMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
				end

				if not isInMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					TriggerEvent('fl_jobs:hasExitedMarker', zone)
				end
			end
		end
	end
end)

-- VEHICLE CAUTION
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if vehicleInCaseofDrop ~= nil then
			if onDuty and IsVehicleModel(vehicleInCaseofDrop, vehicleHashInCaseofDrop) then
				local vehicleHealth = GetEntityHealth(vehicleInCaseofDrop)

				if vehicleOldHealthInCaseofDrop ~= vehicleHealth then
					local cautionValue = 0
					vehicleOldHealthInCaseofDrop = vehicleHealth
					if vehicleHealth == vehicleMaxHealthInCaseofDrop then
						cautionValue = maxCautionVehicleInCaseofDrop
						cautionVehicleInCaseofDrop = cautionValue
					else
						local healthPct = (vehicleHealth * 100) / vehicleMaxHealthInCaseofDrop
						local damagePct = 100 - healthPct
						cautionValue =  math.ceil(cautionVehicleInCaseofDrop - cautionVehicleInCaseofDrop * damagePct * 2.5 / 100)
						if cautionValue < 0 then
							cautionValue = 0
						elseif cautionValue >= cautionVehicleInCaseofDrop then
							cautionValue = cautionVehicleInCaseofDrop
						end
						cautionVehicleInCaseofDrop = cautionValue
					end
					TriggerServerEvent('fl_jobs:setCautionInCaseOfDrop', cautionValue)
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)
