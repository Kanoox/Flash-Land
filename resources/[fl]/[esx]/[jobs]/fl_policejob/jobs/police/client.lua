isPolice = false 
inServicePolice = false
dragStatus = {}
dragStatus.isDragged = false
identityStats = nil
vehicleStats = nil
orgByService = {["police"] = "~b~Dept. de la justice"}
local menuThread = false
local blips = {}
local isHandcuffed = false
local JobBlips = {}



RMenu.Add("police_dynamicmenu", "police_dynamicmenu_main", RageUI.CreateMenu("Menu Police","Interactions possibles"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_main"):SetStyleSize(0)
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_main").Closed = function()
	MenuLSPDOpen = false
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_citizen', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Interactions citoyens", "Interactions avec un citoyen"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_citizen"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_citizen').Closed = function()
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_veh', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Interactions véhicules", "Interactions avec un véhicule"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_veh"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_veh').Closed = function()
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_personal', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Interactions perso", "Interactions personnelles"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_personal"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_personal').Closed = function()
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_K9', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Interactions Chien", "Interactions chien"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_K9"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_K9').Closed = function()
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_appelsmain', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Interactions appels", "Gestion d'appels"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_appelsmain"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_appelsmain').Closed = function()
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_actappel', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Gestion de l'appel", "Séléctionnez une action !"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_actappel"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_actappel').Closed = function()
end


RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_arretNPC', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Gestion NPC", "Séléctionnez une action !"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_arretNPC"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_arretNPC').Closed = function()
end


RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_identity', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_citizen'), "Carte d'identité", "Carte d'identité de la personne"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_identity"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_identity').Closed = function()
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_carinfos', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_veh'), "Informations véhicule", "Informations du véhicule"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_carinfos"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_carinfos').Closed = function()
end

RMenu.Add('police_dynamicmenu', 'police_dynamicmenu_codes', RageUI.CreateSubMenu(RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_main'), "Communications radio", "Communication"))
RMenu:Get("police_dynamicmenu", "police_dynamicmenu_codes"):SetStyleSize(0)
RMenu:Get('police_dynamicmenu', 'police_dynamicmenu_codes').Closed = function()
end


function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
		RemoveBlip(JobBlips[i])
		JobBlips[i] = nil
		end
	end
end



local function init()
	isPolice = true
	inServicePolice = false
	
end

local function jobChanged()
	if ESX.IsPlayerLoaded() then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "police" then
			isPolice = true
			inServicePolice = false
			
		else
			isPolice = false
			inServicePolice = false
			deleteBlips()
		end
	end
end

local function getInformations(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		Citizen.SetTimeout(1100, function()
		identityStats = data
		end)
	end, GetPlayerServerId(player))
end

local function getVehicleInfos(vehicleData)
	if vehicleData ~= nil then
		ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(data)
			Citizen.SetTimeout(1100, function()
				vehicleStats = data
			end)
		end, vehicleData.plate)
	else
		ESX.ShowNotification('Il n\'y a pas de ~r~véhicule !')
	end
end


local function setUniform(uniform, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = flCore.jobs[ESX.PlayerData.job.name].config[uniform].male
		else
			uniformObject = flCore.jobs[ESX.PlayerData.job.name].config[uniform].female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 17 then
				SetPedArmour(playerPed, 100)
			end
		else
			-- Rien
		end
	end)
end


local function setUniformJail(ped)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = flCore.jobs[ESX.PlayerData.job.name].config.jail.male
		else
			uniformObject = flCore.jobs[ESX.PlayerData.job.name].config.jail.female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 6 then
				SetPedArmour(playerPed, 100)
			end
		else
			-- Rien
		end
	end)
end

local function LookupVehicle(input)
	local entrer = input
	local plaque = string.len(entrer)
	if plaque == '' or plaque < 2 or plaque > 13 then
		ESX.ShowNotification('Ce n\'est ~r~pas~s~ un ~y~numéro d\'enregistrement valide~s~')
	else
		ESX.TriggerServerCallback('fl_policejob:getVehicleFromPlate', function(owner, found)
			if found then
				ESX.ShowNotification('Le véhicule est ~y~enregistré~s~ à ~b~ '..owner, owner)
			else
				ESX.ShowNotification('Le véhicule est ~y~enregistré~s~ à ~b~John Doe~s~ ~r~(CIVIL)')
			end
		end, entrer)
	end
end



local function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('fl_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = bill.label,
				rightLabel = '$%s', ESX.Math.GroupDigits(bill.amount),
				rightLabelColor = 'rouge',
				billId = bill.id,
			})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'billing', {
			title = ('gérer les amendes impayées'),
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end


AddEventHandler('playerSpawned', function(spawn)
	TriggerEvent('fl_policejob:unrestrain')
end)



RegisterNetEvent("fl_core:police:code")
AddEventHandler("fl_core:police:code", function(typeIndex, index, typeDesc, codeDesc, _, _, name, initialLoc, src)
	if isPolice and inServicePolice then
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(src))
		UnregisterPedheadshot(mugshot)
		if index == 11 then
			PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
			PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
			Wait(1000)
			PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
			color = 2
			Citizen.CreateThread(function()
				local blip = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				local color = 69
				SetBlipSprite(blip, 304)
				SetBlipAsShortRange(blip, false)
				SetBlipColour(blip, color)
				SetBlipScale(blip, 0.5)
				SetBlipCategory(blip, 12)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Code 2")
				EndTextCommandSetBlipName(blip)
				
				local radius = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				SetBlipSprite(radius, 161)
				SetBlipScale(radius, 2.0)
				SetBlipColour(radius, color)
				PulseBlip(radius)

				Citizen.CreateThread(function()
					while blip ~= nil do
						Citizen.Wait(600)
						if color == 69 then
							color = 37
						else
							color = 69
						end
						SetBlipColour(blip, color)
					end
				end)
				Citizen.Wait(25000)
				RemoveBlip(blip)
				RemoveBlip(radius)

			end)
			
		end

		if index == 12 then
			PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
			PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
			Wait(1000)
			PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
			color = 47
			Citizen.CreateThread(function()
				local blip = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				local color = 47
				SetBlipSprite(blip, 304)
				SetBlipAsShortRange(blip, false)
				SetBlipColour(blip, color)
				SetBlipScale(blip, 0.5)
				SetBlipCategory(blip, 12)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Code 3")
				EndTextCommandSetBlipName(blip)
				
				local radius = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				SetBlipSprite(radius, 161)
				SetBlipScale(radius, 2.0)
				SetBlipColour(radius, color)
				PulseBlip(radius)

				Citizen.CreateThread(function()
					while blip ~= nil do
						Citizen.Wait(400)
						if color == 47 then
							color = 37
						else
							color = 47
						end
						SetBlipColour(blip, color)
					end
				end)
				Citizen.Wait(25000)
				RemoveBlip(blip)
				RemoveBlip(radius)

			end)
		end

		if index == 13 then
			PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
			PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
			PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
			Wait(1000)
			PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
			PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
			color = 1
			Citizen.CreateThread(function()
				local blip = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				local color = 59
				SetBlipSprite(blip, 304)
				SetBlipAsShortRange(blip, false)
				SetBlipColour(blip, color)
				SetBlipScale(blip, 0.5)
				SetBlipCategory(blip, 12)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Code 99")
				EndTextCommandSetBlipName(blip)
				
				local radius = AddBlipForCoord(initialLoc.x, initialLoc.y, initialLoc.z)
				SetBlipSprite(radius, 161)
				SetBlipScale(radius, 2.0)
				SetBlipColour(radius, color)
				PulseBlip(radius)

				Citizen.CreateThread(function()
					while blip ~= nil do
						Citizen.Wait(150)
						if color == 59 then
							color = 37
						else
							color = 59
						end
						SetBlipColour(blip, color)
					end
				end)
				Citizen.Wait(25000)
				RemoveBlip(blip)
				RemoveBlip(radius)

			end)
		end
	end
end)

----- HANDCUFF

RegisterNetEvent('fl_policejob:handcuff')
AddEventHandler('fl_policejob:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	if isHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(100)
		end

		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(false)

	else

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)


RegisterNetEvent('fl_policejob:unrestrain')
AddEventHandler('fl_policejob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('fl_policejob:dragErrorResponse')
AddEventHandler('fl_policejob:dragErrorResponse', function()
	ESX.ShowNotification('~r~La personne n\'a pas de menotte...')
end)

RegisterNetEvent('fl_policejob:drag')
AddEventHandler('fl_policejob:drag', function(copId)
	if not IsHandcuffed then
		TriggerServerEvent('fl_policejob:dragErrorResponse', copId)
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)


Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		local fps = 1250

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				fps = 1
				local pp = GetPlayerFromServerId(dragStatus.CopId)
				if pp ~= -1 then
					targetPed = GetPlayerPed(pp)

					-- undrag if target is in an vehicle
					if not IsPedInAnyVehicle(targetPed, true) then
						AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					else
						dragStatus.isDragged = false
						DetachEntity(playerPed, true, false)
					end

					if IsPedDeadOrDying(targetPed, true) then
						dragStatus.isDragged = false
						DetachEntity(playerPed, true, false)
					end
				end

			else
				DetachEntity(playerPed, true, false)
			end
		end
		Wait(fps)
	end
end)

Citizen.CreateThread(function()
	while true do
		sleep = 1300
		if IsHandcuffed then
			sleep = 0
			local playerPed = PlayerPedId()

			if IsHandcuffed then
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Aim
				DisableControlAction(0, 263, true) -- Melee Attack 1
				DisableControlAction(0, 166, true) -- F5
				DisableControlAction(0, 45, true) -- Reload
				DisableControlAction(0, 22, true) -- Jump
				DisableControlAction(0, 44, true) -- Cover
				DisableControlAction(0, 37, true) -- Select Weapon
				DisableControlAction(0, 99, true) -- Next Weapon
				DisableControlAction(0, 100, true) -- Prec Weapon
				-- DisableControlAction(0, 23, true) -- Enter vehicle

				DisableControlAction(0, 288, true) -- F1
				DisableControlAction(0, 289, true) -- F2
				DisableControlAction(0, 170, true) -- Animations
				--DisableControlAction(0, 167, true) -- Job
				DisableControlAction(0, 168, true) -- Job
				DisableControlAction(0, 29, true) -- Pointing
				DisableControlAction(0, 32, true) -- Holster
				DisableControlAction(0, 74, true) -- H
				DisableControlAction(0, 38, true) -- E
				DisableControlAction(0, 243, true) -- ²

				DisableControlAction(0, 0, true) -- Disable changing view
				DisableControlAction(0, 26, true) -- Disable looking behind
				DisableControlAction(0, 73, true) -- Disable clearing animation
				DisableControlAction(2, 199, true) -- Disable pause screen

				DisableControlAction(0, 59, true) -- Disable steering in vehicle
				DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
				DisableControlAction(0, 72, true) -- Disable reversing in vehicle

				DisableControlAction(2, 36, true) -- Disable going stealth

				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle

				SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)

				if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 and not IsEntityInWater(PlayerPedId()) then
					ESX.Streaming.RequestAnimDict('mp_arresting', function()
						TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 53, 0.0, false, false, false)
					end)
				end
			end
		end
		Wait(sleep)
	end
end)

RegisterNetEvent('fl_policejob:putInVehicle')
AddEventHandler('fl_policejob:putInVehicle', function()
	if not IsHandcuffed then
		TriggerServerEvent('fl_policejob:dragErrorResponse', copId)
		return
	end

	local coords = GetEntityCoords(playerPed)
	local vehicle, distance = ESX.Game.GetClosestVehicle()

	if DoesEntityExist(vehicle) and distance < 8 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat then
			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, freeSeat)
			dragStatus.isDragged = false
		else
			print('No free seat')
		end
	else
		print('v2 Closest no' .. tostring(distance))
	end
end)

RegisterNetEvent('fl_policejob:OutVehicleErrorResponse')
AddEventHandler('fl_policejob:OutVehicleErrorResponse', function()
	ESX.ShowNotification('~r~La personne n\'est pas dans un véhicule')
end)

RegisterNetEvent('fl_policejob:OutVehicle')
AddEventHandler('fl_policejob:OutVehicle', function(copId)
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		TriggerServerEvent('fl_policejob:OutVehicleErrorResponse', copId)
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)


RegisterNetEvent('fl_policejob:getarrested')
AddEventHandler('fl_policejob:getarrested', function(playerheading, playercoords, playerlocation)
	local playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(playerPed, x, y, z)
	SetEntityHeading(playerPed, playerheading)
	Citizen.Wait(250)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuffseffect', 0.7)
	LoadAnimDictionary('mp_arrest_paired')
	TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	cuffed = true
	LoadAnimDictionary('mp_arresting')
	TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('fl_policejob:doarrested')
AddEventHandler('fl_policejob:doarrested', function()
	Citizen.Wait(250)
	LoadAnimDictionary('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end)

RegisterNetEvent('fl_policejob:douncuffing')
AddEventHandler('fl_policejob:douncuffing', function()
	Citizen.Wait(250)
	LoadAnimDictionary('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('fl_policejob:getuncuffed')
AddEventHandler('fl_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	z = z - 1.0
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	LoadAnimDictionary('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	cuffed = false
	ClearPedTasks(PlayerPedId())
end)

---------------


local function createBlip()
	local policeDept = vector3(442.69, -983.51, 30.68)

	local blip = AddBlipForCoord(policeDept.x, policeDept.y, policeDept.z)
	SetBlipSprite(blip, 60)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 38)
	SetBlipScale(blip, 0.8)
	SetBlipCategory(blip, 12)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Commissariat")
	EndTextCommandSetBlipName(blip)
end

-- Chien

local policeDog = false
followingDogs = false
local PlayerData = {}


Citizen.CreateThread(function()
    PlayerData = ESX.GetPlayerData()
    while true do
        local sleep = 3500
        if DoesEntityExist(policeDog) then
            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) >= 50 and not IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 3) and not IsPedInAnyVehicle(policeDog, false) then
                SetEntityCoords(policeDog, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, -0.98))
            end
            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) >= 2.0 and not IsPedInAnyVehicle(policeDog, true) and not IsEntityPlayingAnim(policeDog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 3) and IsPedStill(policeDog) then
                TaskGoToCoordAnyMeans(policeDog, GetEntityCoords(PlayerPedId()), 5.0, 0, 0, 786603, 0xbf800000)
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('esx_policedog:hasDrugs')
AddEventHandler('esx_policedog:hasDrugs', function(hadIt)
    if hadIt then
        ESX.ShowNotification('De la drogue a été ~g~trouvée !')
        loadDict('missfra0_chop_find')
        TaskPlayAnim(policeDog, 'missfra0_chop_find', 'chop_bark_at_ballas', 8.0, -8, -1, 0, 0, false, false, false)
    else
        ESX.ShowNotification('~r~Pas de drogues~s~ sur la personne !')
    end
end)

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end




-- Speedzones

local Speedzones = {}
local DrawSpeedzones = false
local InstructionScaleform = nil

AddEventHandler('fl_policejob:toggleSpeedzoneDraw', function()
	DrawSpeedzones = not DrawSpeedzones
	if DrawSpeedzones then
		ESX.ShowNotification('~g~Affichage des zones d\'arrêt NPC')
	else
		ESX.ShowNotification('~r~Zones d\'arrêt NPC masquées')
	end
end)

local sizeMax = 50.0
AddEventHandler('fl_policejob:promptSpeedzone', function()
	local BeforougerawSpeedzones = DrawSpeedzones
	DrawSpeedzones = true
	InDrawSpeedzones()
	local placed = false
	local size = 1.0

	InitInstructionScaleform()

	repeat
		DrawMarker(25, GetEntityCoords(PlayerPedId()) + vector3(0,0,-0.95), 0, 0, 0, GetEntityRotation(PlayerPedId()), size * 2.0, size * 2.0, 1.0, 10, 10, 10, 255, false, false, 2, false, nil, nil, false)
		DrawScaleformMovieFullscreen(InstructionScaleform, 255, 255, 255, 255, 0);


		if IsControlPressed(0, 172) then -- UP
			if size <= sizeMax then
				size = size + 0.1
			end
		elseif IsControlPressed(0, 173) then -- DOWN
			if size >= 1.0 then
				size = size - 0.08
			end
		end

		if IsControlJustReleased(1, 348) or IsControlJustPressed(1, 201) then
			placed = true
		end

		if IsControlJustReleased(1, 194) or IsPedInAnyVehicle(PlayerPedId(), true) then -- Cancel
			ESX.ShowNotification('~r~Zone d\'arrêt annulée')
			DrawSpeedzones = BeforougerawSpeedzones
			InDrawSpeedzones()
			TriggerEvent('fl_policejob:finishedPlacingSpeedzone')
			return
		end

		Citizen.Wait(0)
	until placed

	TriggerServerEvent('fl_policejob:addSpeedzone', GetEntityCoords(PlayerPedId()), size)
	DrawSpeedzones = BeforougerawSpeedzones
	InDrawSpeedzones()
end)

RegisterNetEvent('fl_policejob:addSpeedzone')
AddEventHandler('fl_policejob:addSpeedzone', function(whoCreated, pos, size)
	local zoneIndex = AddSpeedZoneForCoord(pos.x, pos.y, pos.z, size, 0.0, false)
	table.insert(Speedzones, {
		whoCreated = whoCreated,
		pos = pos,
		size = size,
		zoneIndex = zoneIndex,
	})
	if whoCreated == GetPlayerServerId(PlayerId()) then
		ESX.ShowNotification('~g~Zone d\'arrêt placée')
		TriggerEvent('fl_policejob:finishedPlacingSpeedzone')
	end
end)

RegisterNetEvent('fl_policejob:removeSpeedzone')
AddEventHandler('fl_policejob:removeSpeedzone', function(whoDeleted, deletedSpeedZone)
	for i,speedZone in pairs(Speedzones) do
		if speedZone.pos == deletedSpeedZone.pos then
			Speedzones[i] = nil
		end
	end
	RemoveSpeedZone(deletedSpeedZone.zoneIndex)
	if deletedSpeedZone.whoCreated ~= whoDeleted and deletedSpeedZone.whoCreated == GetPlayerServerId(PlayerId()) then
		ESX.ShowNotification('~r~Votre zone d\'arrêt a été supprimée')
	end
	if whoDeleted == GetPlayerServerId(PlayerId()) then
		ESX.ShowNotification('~r~Zone d\'arrêt supprimée')
	end
end)

function InitInstructionScaleform()
	InstructionScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
	repeat
		Citizen.Wait(0)
	until HasScaleformMovieLoaded(InstructionScaleform)

	BeginScaleformMovieMethod(InstructionScaleform, "CLEAR_ALL");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(6);
	PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_ACCEPT~");
	PushScaleformMovieMethodParameterString("~INPUT_MAP_POI~");
	PushScaleformMovieMethodParameterString("Poser la zone d'arrêt");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(5);
	PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_RRIGHT~");
	PushScaleformMovieMethodParameterString("Annuler");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(4);
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_UP~");
	PushScaleformMovieMethodParameterString("Agrandir la zone");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "SET_DATA_SLOT");
	ScaleformMovieMethodAddParamInt(3);
	PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_DOWN~");
	PushScaleformMovieMethodParameterString("Réduire la zone");
	EndScaleformMovieMethod();

	BeginScaleformMovieMethod(InstructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS");
	ScaleformMovieMethodAddParamInt(0);
	EndScaleformMovieMethod();
end

function DrawSpeedzone(Speedzone, Selected)
	if Selected then
		DrawMarker(25, Speedzone.pos + vector3(0,0,-0.95), 0, 0, 0, 0, 0, 0, Speedzone.size * 2.0, Speedzone.size * 2.0, 1.0, 127, 0, 0, 200, false, false, 2, false, nil, nil, false)
	else
		DrawMarker(25, Speedzone.pos + vector3(0,0,-0.95), 0, 0, 0, 0, 0, 0, Speedzone.size * 2.0, Speedzone.size * 2.0, 1.0, 0, 0, 127, 127, false, false, 2, false, nil, nil, false)
	end
end

function InDrawSpeedzones()
	if not DrawSpeedzones then return end

	Citizen.CreateThread(function()
		while DrawSpeedzones do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(PlayerPedId())
			local closest, closestDistance = nil, 1000

			for _,Speedzone in pairs(Speedzones) do
				local distance = #(Speedzone.pos - playerPos)
				if distance < 30 then
					DrawSpeedzone(Speedzone, false)
					if distance < closestDistance then
						closestDistance = distance
						closest = Speedzone
					end
				end
			end

			if closest and closestDistance < closest.size then
				DrawSpeedzone(closest, true)
				ESX.ShowHelpNotification('~INPUT_CELLPHONE_OPTION~ pour supprimer la zone d\'arrêt NPC')
				if IsControlJustReleased(1, 178) then
					TriggerServerEvent('fl_policejob:removeSpeedzone', closest)
				end
			end
		end
	end)
end

-- Bracelets

Blips = {}
ClientRegisterougeBracelet = {}

PoliceStationsB = {
	LSPD = {
		Cloakrooms = {
			vector3(461.83, -999.15, 30.68),
		},
	},
}

RegisterNetEvent('fl_policejob:updateBracelet')
AddEventHandler('fl_policejob:updateBracelet', function(RegisterougeBracelet)
	ClientRegisterougeBracelet = RegisterougeBracelet
	local random = 30
	local playerPos = GetEntityCoords(PlayerPedId())

	if #(playerPos.xy - PoliceStationsB.LSPD.Cloakrooms[1].xy) > 45 then
		for BraceletID,Bracelet in pairs(RegisterougeBracelet) do
			if Blips[BraceletID] then
				RemoveBlip(Blips[BraceletID])
				Blips[BraceletID] = nil
			end

			if Blips[1000000000 + BraceletID] then
				RemoveBlip(Blips[1000000000 + BraceletID])
				Blips[1000000000 + BraceletID] = nil
			end
		end

		return
	end

	for BraceletID,Bracelet in pairs(ClientRegisterougeBracelet) do
		if Bracelet.isActive and Bracelet.lastPosition then
			local coords = json.decode(Bracelet.lastPosition)
			if not coords or not coords.x or (coords.x == 0 and coords.y == 0 and coords.z == 0) or type(coords) == 'nil' or coords == nil then
				coords = {x = -5000.0, y = -5000.0, z = 0.0}
			end

			if Bracelet.currentPosition then
				coords.x = coords.x + math.random(-random, random)
				coords.y = coords.y + math.random(-random, random)
				coords.z = coords.z + math.random(-random, random)
			end

			local zoneBlip = nil
			if Blips[BraceletID] then
				zoneBlip = Blips[BraceletID]
				SetBlipCoords(zoneBlip, coords.x, coords.y, coords.z)
			else
				zoneBlip = AddBlipForRadius(coords.x, coords.y, coords.z, 70.0)
				Blips[BraceletID] = zoneBlip
			end

			SetBlipAlpha(zoneBlip, 120)
			SetBlipDisplay(zoneBlip, 3)

			if Bracelet.currentPosition then
				SetBlipColour(zoneBlip, 80)
			else
				SetBlipColour(zoneBlip, 85)
			end

			local humanBlip = nil
			if Blips[1000000000 + BraceletID] then
				humanBlip = Blips[1000000000 + BraceletID]
				SetBlipCoords(humanBlip, coords.x, coords.y, coords.z)
			else
				humanBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
				Blips[1000000000 + BraceletID] = humanBlip
			end

			SetBlipAlpha(humanBlip, 180)
			SetBlipSprite(humanBlip, 480)
			SetBlipScale(humanBlip, 0.8)
			SetBlipShrink(humanBlip, 1)
			SetBlipCategory(humanBlip, 7)
			SetBlipDisplay(humanBlip, 3)
			SetBlipAsShortRange(humanBlip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(Bracelet.info)
			EndTextCommandSetBlipName(humanBlip)

			if Bracelet.currentPosition then
				SetBlipColour(humanBlip, 80)
			else
				SetBlipColour(humanBlip, 85)
			end
		else
			if Blips[BraceletID] then
				RemoveBlip(Blips[BraceletID])
				Blips[BraceletID] = nil
			end

			if Blips[1000000000 + BraceletID] then
				RemoveBlip(Blips[1000000000 + BraceletID])
				Blips[1000000000 + BraceletID] = nil
			end
		end
	end
end)

RegisterNetEvent('fl_policejob:useBracelet')
AddEventHandler('fl_policejob:useBracelet', function(Bracelet, UseItem)
	if not Bracelet then error('Use no bracelet') end
	local lastUser = Bracelet.info
	if not lastUser then lastUser = 'Aucun'	end

	local elements = {
		{label = 'Numéro bracelet : ' .. Bracelet.id, value = 'info'},
		{label = 'Dernier utilisateur : ' .. lastUser, value = 'info'},
	}


	local player = GetPlayerFromServerId(Bracelet.serverId)
	local distance = 100
	if player ~= -1 then
		distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(player)))
	end

	if Bracelet.isActive and Bracelet.lastPosition and distance < 50 then
		table.insert(elements, {label = 'Enlever le bracelet', value = 'remove'})
	elseif UseItem then
		table.insert(elements, {label = 'Mettre le bracelet à un individu', value = 'put'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bracelet_info', {
		title = 'Information bracelet électronique',
		elements = elements,
	}, function(data, menu)

		if data.current.value == 'info' then
		elseif data.current.value == 'remove' then
			menu.close()
			if not Bracelet.lastPosition then
				ESX.ShowNotification('~r~Impossible d\'intéragir avec un bracelet hors du réseau...')
				return
			end

			TriggerServerEvent('fl_policejob:removeBracelet', Bracelet.id)
			ESX.UI.Menu.CloseAll()
		elseif data.current.value == 'put' then
			PutBracelet(Bracelet)
		else
			print('Unknown button bracelet_info' .. tostring(data.current.value))
		end

	end, function(data, menu)
		menu.close()
	end)
end)

function PutBracelet(Bracelet)
	local elements = {}
	local closePlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), false), 2.0);

	for _,anyPlayer in pairs(closePlayers) do
		if anyPlayer ~= PlayerId() then
			table.insert(elements, {label = GetPlayerName(anyPlayer), value = anyPlayer})
		end
	end

	if #closePlayers == 0 then
		table.insert(elements, {label = 'Aucun joueurs ...', value = 'nope'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bracelet_put', {
		title = 'Mettre le bracelet à',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'nope' then return end
		TriggerServerEvent('fl_policejob:putBracelet', Bracelet.id, GetPlayerServerId(data.current.value))
		ESX.UI.Menu.CloseAll()
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('fl_policejob:manageBracelet')
AddEventHandler('fl_policejob:manageBracelet', function()
	local elements = {}
	for BraceletID,Bracelet in pairs(ClientRegisterougeBracelet) do
		local braceletInfo = ''
		if Bracelet.info then
			if Bracelet.isActive then
				braceletInfo = 'Actif'
			else
				braceletInfo = 'Inactif'
			end
			braceletInfo = braceletInfo .. ' (' .. Bracelet.info .. ')'
		end
		table.insert(elements, {label = 'Bracelet n°' .. BraceletID .. ' ' .. braceletInfo, braceletId = BraceletID})
	end

	if #elements == 0 then
		table.insert(elements, {label = 'Aucun bracelet...'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'bracelet_manage', {
		title = 'Information bracelet électronique',
		elements = elements
	}, function(data, menu)
		if not data.current.braceletId then return end
		TriggerEvent('fl_policejob:useBracelet', ClientRegisterougeBracelet[data.current.braceletId])
	end, function(data, menu)
		menu.close()
	end)
end)



-- Shots
local lsZone = PolyZone:Create({
    vector2(1073.0, -2593.0),
    vector2(1155.0, -2013.0),
    vector2(1282.0, -1483.0),
    vector2(1190.0, -960.0),
    vector2(1214.0, -800.0),
    vector2(1356.0, -664.0),
    vector2(1454.0, -559.0),
    vector2(1329.0, -346.0),
    vector2(1107.0, -192.0),
    vector2(978.0, 126.0),
    vector2(624.0, 339.0),
    vector2(367.0, 592.0),
    vector2(-30.0, 969.0),
    vector2(-362.0, 916.0),
    vector2(-662.0, 937.0),
    vector2(-821.0, 915.0),
    vector2(-960.0, 866.0),
    vector2(-1060.0, 888.0),
    vector2(-1431.0, 629.0),
    vector2(-1546.0, 510.0),
    vector2(-1779.0, 496.0),
    vector2(-1885.0, 713.0),
    vector2(-2088.0, 668.0),
    vector2(-2366.0, 479.0),
    vector2(-2348.0, 130.0),
    vector2(-2121.0, 144.0),
    vector2(-1987.0, -80.0),
    vector2(-2200.0, -441.0),
    vector2(-1722.0, -791.0),
    vector2(-1772.0, -902.0),
    vector2(-1718.0, -1043.0),
    vector2(-1749.0, -1136.0),
    vector2(-1484.0, -1352.0),
    vector2(-1171.0, -1751.0),
    vector2(-1519.0, -2571.0),
    vector2(-1210.0, -2977.0),
    vector2(-979.0, -3092.0),
    vector2(-726.0, -2827.0),
    vector2(-758.0, -2678.0),
    vector2(-551.0, -2375.0),
    vector2(-498.0, -2253.0),
    vector2(-272.0, -2251.0),
    vector2(27.0, -2248.0),
    vector2(173.0, -2239.0),
    vector2(430.0, -2232.0),
    vector2(441.0, -2352.0),
    vector2(-289.0, -2397.0),
    vector2(-587.0, -2894.0),
    vector2(-313.0, -2787.0),
    vector2(-24.0, -2715.0),
    vector2(82.0, -2893.0),
    vector2(304.0, -2840.0),
    vector2(572.0, -2861.0),
    vector2(766.0, -2775.0),
    vector2(757.0, -2569.0)
  }, {
    name="lsmain",
    debugPoly = false,
})


local isShooting = false
local Silencieux = false

Citizen.CreateThread(function()
    while(true) do
		local sleep = 100
		local playerPed = PlayerPedId()
		
		isShooting = IsPedShooting(playerPed)
        Silencieux = IsPedCurrentWeaponSilenced(playerPed)
		
        if isShooting and not Silencieux then
            notifShot()
		end

        Citizen.Wait(sleep)
    end
end)

function notifShot()
	if lsZone:isPointInside(GetEntityCoords(ped)) then
		Wait(2500)
		ESX.ShowNotification('~r~Quelqu\'un vous a vu et/ou entendu tiré ! Faites attention.')
		local coords  = GetEntityCoords(PlayerPedId())
		local district = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
		local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))
		TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~Civil\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos : ~s~Des tirs ont été entendus ! \n", coords)
		TriggerServerEvent("fl_appels:Zebi", "Tirs", GetEntityCoords(GetPlayerPed(-1)), 'Civil')
		Wait(12500)
	end
end

-- CarJack

-- Désactivé pour le moment

local current = "police"

flCore.jobs[current].jobMenu = jobMenu
flCore.jobs[current].setUniform = setUniform
flCore.jobs[current].getWeapon = getWeapon
flCore.jobs[current].spawnCar = spawnCar
flCore.jobs[current].spawnBoat = spawnBoat
flCore.jobs[current].spawnHeli = spawnHeli
flCore.jobs[current].setUniformJail = setUniformJail
flCore.jobs[current].init = init
flCore.jobs[current].jobChanged = jobChanged 
flCore.jobs[current].getIdentity = getPlayerInv
flCore.jobs[current].getVehicleInfos = getVehicleInfos
flCore.jobs[current].LookupVehicle = LookupVehicle
flCore.jobs[current].loadDict = loadDict
flCore.jobs[current].OpenUnpaidBillsMenu = OpenUnpaidBillsMenu
flCore.jobs[current].getListeAppels = getListeAppels
flCore.jobs[current].hasBlip = true
flCore.jobs[current].createBlip = createBlip