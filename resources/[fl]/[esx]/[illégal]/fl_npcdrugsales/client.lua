local selling = false
local hasDrugs = false
local displayTip = false
local currentPed = nil
local freezedEntity = nil
local interactedWith = {}

AddEventHandler('esx:changedPlayerData', function()
	HasDrugs()
end)

function Tick()
	if not (hasDrugs and displayTip and currentPed) then
		return
	end

	if IsPedFleeing(currentPed) then
		ESX.ShowHelpNotification("Cette personne a peur de vous...")
		return
	end

	if interactedWith[currentPed] then
		ESX.ShowHelpNotification("Vous avez déjà vendu à cette personne...")
		return
	end

	ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour dealer...")
	if IsControlJustPressed(1, 86) then
		TaskStandStill(currentPed, 9.0)
		if IsPedInAnyVehicle(currentPed) then
			freezedEntity = GetVehiclePedIsIn(currentPed, false)
			FreezeEntityPosition(freezedEntity, true)
			RollDownWindows(freezedEntity)
		end
		TriggerServerEvent('fl_npcdrugsales:trigger')
		Citizen.Wait(2850)

		if IsPedFleeing(currentPed) then
			ESX.ShowHelpNotification("Cette personne a peur de vous...")
			return
		end

		if not DoesEntityExist(currentPed) and not DoesEntityExist(freezedEntity) then
			if DoesEntityExist(freezedEntity) then
				for i=0,3 do
					RollUpWindow(freezedEntity, i)
				end
				FreezeEntityPosition(freezedEntity, false)
				freezedEntity = nil
			else
				TaskWanderStandard(currentPed, 100, 100)
			end

			TriggerEvent('esx:showNotification', "~r~La personne n'est plus là...")
			return
		end

		local distance = #(GetEntityCoords(currentPed).xy - GetEntityCoords(PlayerPedId()).xy)

		if distance <= 2 then
			interactedWith[currentPed] = true
			TriggerServerEvent('fl_npcdrugsales:sell')
			HasDrugs()
		else
			TaskWanderStandard(currentPed, 100, 100)
			TriggerEvent('esx:showNotification', "~r~Vous vous êtes trop éloigné.")
		end

		SetPedAsNoLongerNeeded(currentPed)

		if freezedEntity then -- Only with vehicles
			for i=0,3 do
				RollUpWindow(freezedEntity, i)
			end
			FreezeEntityPosition(freezedEntity, false)
			freezedEntity = nil
		else
			TaskWanderStandard(currentPed, 10, 10)
		end
	end
end

Citizen.CreateThread(function()
	HasDrugs()
	while true do
		Citizen.Wait(0)
		Tick()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(800)

		displayTip = false
		currentPed = nil

		if hasDrugs and not IsPedInAnyVehicle(PlayerPedId()) then
			LoopThroughPeds()
		end
	end
end)

function LoopThroughPeds()
	local playerPedId = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPedId)
	for _, ped in pairs(ESX.Game.GetPeds(true)) do
		local pedType = GetPedType(ped)
		if pedType ~= 20 and
		   pedType ~= 21 and
		   pedType ~= 27 and
		   pedType ~= 28 and
		   pedType ~= 29 and
		   pedType ~= 6 and
		   not IsPedAPlayer(ped) then
			if not IsPedDeadOrDying(ped) and not IsEntityAMissionEntity(ped) and ped ~= playerPedId then
				local distance = #(playerCoords - GetEntityCoords(ped))
				if (IsPedInAnyVehicle(currentPed) and distance <= 4) or distance <= 2 then
					displayTip = true
					currentPed = ped
					return
				end
			end
		end
	end
end

RegisterNetEvent('fl_npcdrugsales:notifyCops')
AddEventHandler('fl_npcdrugsales:notifyCops', function()
	if currentPed or not IsPedDeadOrDying(currentPed) then
		ClearPedTasks(currentPed)
		TaskReactAndFleePed(currentPed, PlayerPedId())
	end
	local coords  = GetEntityCoords(PlayerPedId())
	local district = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
	local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))

	TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~Inconnue\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos : ~s~Un individu vend de la drogue ! \n", coords)
	TriggerServerEvent("fl_appels:Zebi", "Vente de drogue à un civil", GetEntityCoords(GetPlayerPed(-1)), 'Civil')
end)



RegisterNetEvent('animation')
AddEventHandler('animation', function()
	local pid = PlayerPedId()
	RequestAnimDict("amb@prop_human_bum_bin@idle_b")
	while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
		Citizen.Wait(0)
	end

	TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
	Wait(750)
	StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
end)

function HasDrugs()
	hasDrugs = false
	for _,item in ipairs(ESX.GetPlayerData().inventory) do
		if item.name == 'meth_pooch' and item.count >= 1 then
			hasDrugs = true
			break
		end

		if item.name == 'coke_pooch' and item.count >= 1 then
			hasDrugs = true
			break
		end

		if item.name == 'weed_pooch' and item.count >= 1 then
			hasDrugs = true
			break
		end
	
		if item.name == 'shit_pooch' and item.count >= 1 then
			hasDrugs = true
			break
		end
	end
end