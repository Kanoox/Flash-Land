local CurrentlyHoldingUp = false
local CurrentBank = ''
local SecondsRemaining = 0
local BlipRobbery = nil

function DisplayHoldUpBlips()
	for _,Bank in pairs(Config.Banks) do
		Bank.holdupBlip = AddBlipForCoord(Bank.holdupPosition)
		SetBlipSprite(Bank.holdupBlip, 255) -- 156
		SetBlipScale(Bank.holdupBlip, 0.8)
		SetBlipColour(Bank.holdupBlip, 75)
		SetBlipDisplay(Bank.holdupBlip, 5)
		SetBlipAsShortRange(Bank.holdupBlip, true)
	end
end

function HideHoldUpBlips()
	print('HideHoldUpBlips()')
	for _,Bank in pairs(Config.Banks) do
		RemoveBlip(Bank.holdupBlip)
		Bank.holdupBlip = nil
	end
end

RegisterNetEvent('fl_bank:currentlyRobbing')
AddEventHandler('fl_bank:currentlyRobbing', function(RobbingBank)
	CurrentlyHoldingUp = true
	CurrentBank = RobbingBank
	SecondsRemaining = 600
end)

RegisterNetEvent('fl_bank:endHoldUp')
AddEventHandler('fl_bank:endHoldUp', function()
	CurrentlyHoldingUp = false
	CurrentBank = ''
	SecondsRemaining = 0
end)

RegisterNetEvent('fl_bank:killBlip')
AddEventHandler('fl_bank:killBlip', function()
    RemoveBlip(BlipRobbery)
    BlipRobbery = nil
end)

RegisterNetEvent('fl_bank:setBlip')
AddEventHandler('fl_bank:setBlip', function(RobbingBank)
	if BlipRobbery then RemoveBlip(BlipRobbery)	end
    BlipRobbery = AddBlipForCoord(Config.Banks[RobbingBank].holdupPosition)
    SetBlipSprite(BlipRobbery, 161)
    SetBlipScale(BlipRobbery, 2.0)
    SetBlipColour(BlipRobbery, 3)
    PulseBlip(BlipRobbery)
end)

-- Currently not stopping on end
RegisterNetEvent('fl_bank:startDrill')
AddEventHandler('fl_bank:startDrill', function(source)
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CONST_DRILL", 0, true)
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentlyHoldingUp then
			Citizen.Wait(1000)
			if SecondsRemaining > 0 then
				SecondsRemaining = SecondsRemaining - 1
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		if not CurrentlyHoldingUp then
			local sleep = true

			if ESX.PlayerData.job.name ~= 'banker' then
				for i,Bank in pairs(Config.Banks) do
					local holdupDistance = #(Bank.holdupPosition - playerPos)

					if holdupDistance < 15.0 then
						sleep = false
						DrawMarker(1, Bank.holdupPosition - vector3(0, 0, 1), 0, 0, 0, 0, 0, 0, 1.3, 1.3, 0.8, 1555, 0, 0, 255, 0, 0, 0, 0)

						if holdupDistance < 1.0 then
							if Bank.PedHoldUp then
								ESX.ShowHelpNotification('Appuyer sur ~INPUT_CONTEXT~ pour braquer ~b~' .. Bank.nameofbank, true)
								if IsControlJustReleased(1, 51) then
									TriggerServerEvent('fl_bank:rob', i)
									local coords  = GetEntityCoords(PlayerPedId())
									local district = GetLabelText(GetNameOfZone(Bank.holdupPosition))
									local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))

									TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~Inconnue\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos : ~s~Braquage de banque ! \n", Bank.holdupPosition)
									TriggerServerEvent("fl_appels:Zebi", "Braquage de bijouterie", Bank.holdupPosition, 'Civil')
								end
							else
								ESX.ShowHelpNotification('~r~Braquez d\'abord les employés de la banque !', true)
							end
						end
					end
				end
			end

			if sleep then
				Citizen.Wait(500)
			end
		else
			BeginTextCommandPrint('STRING')
			AddTextComponentSubstringPlayerName('Braquage de banque ~r~' .. SecondsRemaining .. ' ~w~secondes restantes')
			EndTextCommandPrint(1000, true)

			if #(Config.Banks[CurrentBank].holdupPosition - playerPos) > 7.5 then
				TriggerServerEvent('fl_bank:toofar', CurrentBank)
			end
		end

		Citizen.Wait(0)
	end
end)