local holdingTablet = true
local tab = nil

TriggerEvent('chat:addSuggestion', '/dossier', ' Dossier Médical', {})

local disablechatmdt = false

CreateJobLoop('ambulance', function()
	if disablechatmdt then
		DisableControlAction(0, 245, true)
		DisableControlAction(0, 309, true)
	else
		Citizen.Wait(1000)
	end
end)

RegisterCommand('dossier',function()
	if ESX.PlayerData.job.name == 'ambulance' then
		if holdingTablet then
			TriggerEvent("tabletmdttemporal:ems")
			holdingTablet=false

			ESX.TriggerServerCallback('lrp-registromedico:fetch', function(d)
				disablechatmdt = true
				Citizen.Wait(2000)

				SetNuiFocus(true, true)
				SendNUIMessage({
						action = "open",
						array = d
				})
			end, data, 'start')
		else
			DeleteEntity(tab)
			ClearPedTasks(PlayerPedId())
			holdingTablet = true
		end
	else
		ESX.ShowHelpNotification('Vous n\'êtes pas médecin')
	end
end)


RegisterNetEvent("tabletmdttemporal:ems")
AddEventHandler("tabletmdttemporal:ems", function()
	local ped = PlayerPedId()

	if not IsEntityDead(ped) then
		if not IsEntityPlayingAnim(ped, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_c", 3) then
			RequestAnimDict("amb@world_human_seat_wall_tablet@female@idle_a")
			while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@idle_a") do
					Citizen.Wait(100)
			end

			TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_c", 8.0, -8, -1, 49, 0, 0, 0, 0)
			tab = CreateObject(`prop_cs_tablet`, 0, 0, 0, true, true, true)        ----0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.05, 0.13, -10.5, 180.0, 180.0, true, true, false, true, 1, true)
			 Citizen.Wait(2000)
			SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
		end
	end
end)

-- NUI Callback - Close
RegisterNUICallback('escape', function(data, cb)
	disablechatmdt = false

	EnableControlAction(0, 245, true)
	EnableControlAction(0, 309, true)
	Citizen.Wait(1000)
	DeleteEntity(tab)
	ClearPedTasks(PlayerPedId())
	SetNuiFocus(false, false)
	cb('ok')
end)

-- NUI Callback - Fetch
RegisterNUICallback('fetch', function(data, cb)
	ESX.TriggerServerCallback('lrp-registromedico:fetch', function( d )
		cb(d)
	end, data, data.type)
end)

-- NUI Callback - Search
RegisterNUICallback('search', function(data, cb)
	ESX.TriggerServerCallback('lrp-registromedico:search', function( d )
		cb(d)
	end, data)
end)

-- NUI Callback - Add
RegisterNUICallback('add', function(data, cb)
	ESX.TriggerServerCallback('lrp-registromedico:add', function( d )
		cb(d)
	end, data)
end)

-- NUI Callback - Update
RegisterNUICallback('update', function(data, cb)
	ESX.TriggerServerCallback('lrp-registromedico:update', function( d )
		cb(d)
	end, data)
end)

-- NUI Callback - Remove
RegisterNUICallback('remove', function(data, cb)
	ESX.TriggerServerCallback('lrp-registromedico:remove', function( d )
		cb(d)
	end, data)
end)