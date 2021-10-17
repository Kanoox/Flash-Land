local holdingup = false
local store = ''
local blipRobbery = nil

function DisplayHelpText(str)
	SetTextComponentFormat('STRING')
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if (outline) then
		SetTextOutline()
	end
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end

RegisterNetEvent('fl_vangelico_robbery:currentlyrobbing')
AddEventHandler('fl_vangelico_robbery:currentlyrobbing',
	function(robb)
		holdingup = true
		store = robb
	end
)

RegisterNetEvent('fl_vangelico_robbery:killblip')
AddEventHandler('fl_vangelico_robbery:killblip',
	function()
		RemoveBlip(blipRobbery)
	end
)

RegisterNetEvent('fl_vangelico_robbery:setblip')
AddEventHandler('fl_vangelico_robbery:setblip',
	function(position)
		blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
		SetBlipSprite(blipRobbery, 161)
		SetBlipScale(blipRobbery, 0.8)
		SetBlipColour(blipRobbery, 3)
		PulseBlip(blipRobbery)
	end
)

RegisterNetEvent('fl_vangelico_robbery:toofarlocal')
AddEventHandler('fl_vangelico_robbery:toofarlocal',
	function(robb)
		holdingup = false
		ESX.ShowNotification(_U('robbery_cancelled'))
		robbingName = ''
		incircle = false
	end
)

RegisterNetEvent('fl_vangelico_robbery:robberycomplete')
AddEventHandler('fl_vangelico_robbery:robberycomplete',
	function(robb)
		holdingup = false

		TriggerEvent(
			'skinchanger:getSkin',
			function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
						['bags_1'] = 41,
						['bags_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				else
					local clothesSkin = {
						['bags_1'] = 41,
						['bags_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
			end
		)
		ESX.ShowNotification(_U('robbery_complete'))
		store = ''
		incircle = false
	end
)

Citizen.CreateThread(
	function()
		for k, v in pairs(Stores) do
			local ve = v.position

			local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
			SetBlipSprite(blip, 439)
			SetBlipScale(blip, 0.8)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('shop_robbery'))
			EndTextCommandSetBlipName(blip)
		end
	end
)

incircle = false

hasrobbed = false
hasrobbed2 = false
hasrobbed3 = false
hasrobbed4 = false
hasrobbed5 = false
hasrobbed6 = false
hasrobbed7 = false
hasrobbed8 = false
hasrobbed9 = false
hasrobbed10 = false
hasrobbed11 = false
hasrobbed12 = false
hasrobbed13 = false
hasrobbed14 = false
hasrobbed15 = false
hasrobbed16 = false
hasrobbed17 = false
hasrobbed18 = false
hasrobbed19 = false
hasrobbed20 = false

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

Citizen.CreateThread(
	function()
		while true do
			local sleep = true
			local pos = GetEntityCoords(PlayerPedId(), true)

			for k, v in pairs(Stores) do
				if #(pos - v.position) < 15.0 then
					sleep = false
					if not holdingup then
						DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)

						if #(pos - v.position) < 1.0 then
							if not incircle then
								DisplayHelpText(_U('press_to_rob'))
							end
							incircle = true
							if IsPedShooting(PlayerPedId()) then
								gioielli1 = AddBlipForCoord(-626.5326, -238.3758, 38.05)
								SetBlipSprite(gioielli1, 1)
								SetBlipColour(gioielli1, 16742399)
								SetBlipScale(gioielli1, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli1)

								gioielli2 = AddBlipForCoord(-625.6032, -237.5273, 38.05)
								SetBlipSprite(gioielli2, 1)
								SetBlipColour(gioielli2, 16742399)
								SetBlipScale(gioielli2, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli2)

								gioielli3 = AddBlipForCoord(-626.9178, -235.5166, 38.05)
								SetBlipSprite(gioielli3, 1)
								SetBlipColour(gioielli3, 16742399)
								SetBlipScale(gioielli3, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli3)

								gioielli4 = AddBlipForCoord(-625.6701, -234.6061, 38.05)
								SetBlipSprite(gioielli4, 1)
								SetBlipColour(gioielli4, 16742399)
								SetBlipScale(gioielli4, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli4)

								gioielli5 = AddBlipForCoord(-626.8935, -233.0814, 38.05)
								SetBlipSprite(gioielli5, 1)
								SetBlipColour(gioielli5, 16742399)
								SetBlipScale(gioielli5, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli5)

								gioielli6 = AddBlipForCoord(-627.9514, -233.8582, 38.05)
								SetBlipSprite(gioielli6, 1)
								SetBlipColour(gioielli6, 16742399)
								SetBlipScale(gioielli6, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli6)

								gioielli7 = AddBlipForCoord(-624.5250, -231.0555, 38.05)
								SetBlipSprite(gioielli7, 1)
								SetBlipColour(gioielli7, 16742399)
								SetBlipScale(gioielli7, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli7)

								gioielli8 = AddBlipForCoord(-623.0003, -233.0833, 38.05)
								SetBlipSprite(gioielli8, 1)
								SetBlipColour(gioielli8, 16742399)
								SetBlipScale(gioielli8, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli8)

								gioielli9 = AddBlipForCoord(-620.1098, -233.3672, 38.05)
								SetBlipSprite(gioielli9, 1)
								SetBlipColour(gioielli9, 16742399)
								SetBlipScale(gioielli9, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli9)

								gioielli10 = AddBlipForCoord(-620.2979, -234.4196, 38.05)
								SetBlipSprite(gioielli10, 1)
								SetBlipColour(gioielli10, 16742399)
								SetBlipScale(gioielli10, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli10)

								gioielli11 = AddBlipForCoord(-619.0646, -233.5629, 38.05)
								SetBlipSprite(gioielli11, 1)
								SetBlipColour(gioielli11, 16742399)
								SetBlipScale(gioielli11, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli11)

								gioielli12 = AddBlipForCoord(-617.4846, -230.6598, 38.05)
								SetBlipSprite(gioielli12, 1)
								SetBlipColour(gioielli12, 16742399)
								SetBlipScale(gioielli12, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli12)

								gioielli13 = AddBlipForCoord(-618.3619, -229.4285, 38.05)
								SetBlipSprite(gioielli13, 1)
								SetBlipColour(gioielli13, 16742399)
								SetBlipScale(gioielli13, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli13)

								gioielli14 = AddBlipForCoord(-619.6064, -230.5518, 38.05)
								SetBlipSprite(gioielli14, 1)
								SetBlipColour(gioielli14, 16742399)
								SetBlipScale(gioielli14, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli14)

								gioielli15 = AddBlipForCoord(-620.8951, -228.6519, 38.05)
								SetBlipSprite(gioielli15, 1)
								SetBlipColour(gioielli15, 16742399)
								SetBlipScale(gioielli15, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli15)

								gioielli16 = AddBlipForCoord(-619.7905, -227.5623, 38.05)
								SetBlipSprite(gioielli16, 1)
								SetBlipColour(gioielli16, 16742399)
								SetBlipScale(gioielli16, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli16)

								gioielli17 = AddBlipForCoord(-620.6110, -226.4467, 38.05)
								SetBlipSprite(gioielli17, 1)
								SetBlipColour(gioielli17, 16742399)
								SetBlipScale(gioielli17, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli17)

								gioielli18 = AddBlipForCoord(-623.9951, -228.1755, 38.05)
								SetBlipSprite(gioielli18, 1)
								SetBlipColour(gioielli18, 16742399)
								SetBlipScale(gioielli18, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli18)

								gioielli19 = AddBlipForCoord(-624.8832, -227.8645, 38.05)
								SetBlipSprite(gioielli19, 1)
								SetBlipColour(gioielli19, 16742399)
								SetBlipScale(gioielli19, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli19)

								gioielli20 = AddBlipForCoord(-623.6746, -227.0025, 38.05)
								SetBlipSprite(gioielli20, 1)
								SetBlipColour(gioielli20, 16742399)
								SetBlipScale(gioielli20, 0.5)
								BeginTextCommandSetBlipName('STRING')
								AddTextComponentString(_U('jewelsblipmap'))
								EndTextCommandSetBlipName(gioielli20)

								TriggerServerEvent('fl_vangelico_robbery:rob', k)
								local coords  = GetEntityCoords(PlayerPedId())
								local district = GetLabelText(GetNameOfZone(v.position.x, v.position.y, v.position.z))
								local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))

								TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~Inconnue\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos : ~s~Braquage de bijouterie ! \n", v.position)
								TriggerServerEvent("fl_appels:Zebi", "Braquage de bijouterie", v.position, 'Civil')
							end
						elseif #(pos - v.position) > 1.0 then
							incircle = false
						end
					end
				end
			end

			if holdingup then
				if #(GetEntityCoords(PlayerPedId()) - vector3(-626.5326, -238.3758, 38.05)) < 0.5 then
					sleep = false
					if not hasrobbed then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -626.5326, -238.3758, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli1)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-625.6032, -237.5273, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed2 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -625.6032, -237.5273, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli2)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed2 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-626.9178, -235.5166, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed3 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -626.9178, -235.5166, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli3)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed3 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-625.6701, -234.6061, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed4 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -625.6701, -234.6061, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli4)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed4 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-626.8935, -233.0814, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed5 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -626.8935, -233.0814, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli5)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed5 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-627.9514, -233.8582, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed6 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -627.9514, -233.8582, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli6)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed6 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-624.5250, -231.0555, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed7 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -624.5250, -231.0555, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli7)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed7 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-623.0003, -233.0833, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed8 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -623.0003, -233.0833, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli8)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed8 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-620.1098, -233.3672, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed9 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -620.1098, -233.3672, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli9)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed9 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-620.2979, -234.4196, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed10 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -620.2979, -234.4196, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli10)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed10 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-619.0646, -233.5629, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed11 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -619.0646, -233.5629, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli11)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed11 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-617.4846, -230.6598, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed12 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -617.4846, -230.6598, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli12)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed12 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-618.3619, -229.4285, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed13 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -618.3619, -229.4285, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli13)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed13 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-619.6064, -230.5518, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed14 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -619.6064, -230.5518, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli14)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed14 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-620.8951, -228.6519, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed15 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -620.8951, -228.6519, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli15)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed15 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-619.7905, -227.5623, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed16 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -619.7905, -227.5623, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli16)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed16 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-620.6110, -226.4467, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed17 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -620.6110, -226.4467, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli17)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed17 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-623.9951, -228.1755, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed18 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -623.9951, -228.1755, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli18)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed18 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-624.8832, -227.8645, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed19 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -624.8832, -227.8645, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli19)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed19 = true
						end
					end
				end

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-623.6746, -227.0025, 38.05)) < 0.5) then
					sleep = false
					if not hasrobbed20 then
						DisplayHelpText(_U('field'))
						if IsControlJustReleased(1, 51) then
							local player = GetPlayerPed(-1)
							if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
								RequestNamedPtfxAsset('scr_jewelheist')
							end
							while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
								Citizen.Wait(0)
							end
							SetPtfxAssetNextCall('scr_jewelheist')
							StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', -623.6746, -227.0025, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict('missheist_jewel')
							TaskPlayAnim(player, 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							DisplayHelpText(_U('collectinprogress'))
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(PlayerPedId())
							RemoveBlip(gioielli20)
							TriggerServerEvent('fl_vangelico_robbery:gioielli1')
							PlaySound(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
							hasrobbed20 = true
						end
					end
				end

				if
					hasrobbed and hasrobbed2 and hasrobbed3 and hasrobbed4 and hasrobbed5 and hasrobbed6 and hasrobbed7 and hasrobbed8 and hasrobbed9 and
						hasrobbed10 and
						hasrobbed11 and
						hasrobbed12 and
						hasrobbed13 and
						hasrobbed14 and
						hasrobbed15 and
						hasrobbed16 and
						hasrobbed17 and
						hasrobbed18 and
						hasrobbed19 and
						hasrobbed20
				 then
					holdingup = false

					hasrobbed = false
					hasrobbed2 = false
					hasrobbed3 = false
					hasrobbed4 = false
					hasrobbed5 = false
					hasrobbed6 = false
					hasrobbed7 = false
					hasrobbed8 = false
					hasrobbed9 = false
					hasrobbed10 = false
					hasrobbed11 = false
					hasrobbed12 = false
					hasrobbed13 = false
					hasrobbed14 = false
					hasrobbed15 = false
					hasrobbed16 = false
					hasrobbed17 = false
					hasrobbed18 = false
					hasrobbed19 = false
					hasrobbed20 = false
					TriggerServerEvent('fl_vangelico_robbery:endrob', store)
					ESX.ShowNotification(_U('lester'))
					TriggerEvent(
						'skinchanger:getSkin',
						function(skin)
							if skin.sex == 0 then
								local clothesSkin = {
									['bags_1'] = 41,
									['bags_2'] = 0
								}
								TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
							else
								local clothesSkin = {
									['bags_1'] = 41,
									['bags_2'] = 0
								}
								TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
							end
						end
					)
				end

				local pos2 = Stores[store].position

				if (#(GetEntityCoords(PlayerPedId()) - vector3(-622.566, -230.183, 38.057)) > 11.5) then
					TriggerServerEvent('fl_vangelico_robbery:toofar', store)
					holdingup = false
					RemoveBlip(gioielli1)
					RemoveBlip(gioielli2)
					RemoveBlip(gioielli3)
					RemoveBlip(gioielli4)
					RemoveBlip(gioielli5)
					RemoveBlip(gioielli6)
					RemoveBlip(gioielli7)
					RemoveBlip(gioielli8)
					RemoveBlip(gioielli9)
					RemoveBlip(gioielli10)
					RemoveBlip(gioielli11)
					RemoveBlip(gioielli12)
					RemoveBlip(gioielli13)
					RemoveBlip(gioielli14)
					RemoveBlip(gioielli15)
					RemoveBlip(gioielli16)
					RemoveBlip(gioielli17)
					RemoveBlip(gioielli18)
					RemoveBlip(gioielli19)
					RemoveBlip(gioielli20)

					hasrobbed = false
					hasrobbed2 = false
					hasrobbed3 = false
					hasrobbed4 = false
					hasrobbed5 = false
					hasrobbed6 = false
					hasrobbed7 = false
					hasrobbed8 = false
					hasrobbed9 = false
					hasrobbed10 = false
					hasrobbed11 = false
					hasrobbed12 = false
					hasrobbed13 = false
					hasrobbed14 = false
					hasrobbed15 = false
					hasrobbed16 = false
					hasrobbed17 = false
					hasrobbed18 = false
					hasrobbed19 = false
					hasrobbed20 = false
				end
			end

			if sleep then
				Citizen.Wait(600)
			end

			if #(GetEntityCoords(PlayerPedId()) - vector3(-622.566, -230.183, 38.057)) > 80.0 then
				Citizen.Wait(2000)
			end

			Citizen.Wait(0)
		end
	end
)

RegisterNetEvent('fl_vangelico_robbery:togliblip')
AddEventHandler('fl_vangelico_robbery:togliblip',
	function(robb)
		RemoveBlip(gioielli1)
		RemoveBlip(gioielli2)
		RemoveBlip(gioielli3)
		RemoveBlip(gioielli4)
		RemoveBlip(gioielli5)
		RemoveBlip(gioielli6)
		RemoveBlip(gioielli7)
		RemoveBlip(gioielli8)
		RemoveBlip(gioielli9)
		RemoveBlip(gioielli10)
		RemoveBlip(gioielli11)
		RemoveBlip(gioielli12)
		RemoveBlip(gioielli13)
		RemoveBlip(gioielli14)
		RemoveBlip(gioielli15)
		RemoveBlip(gioielli16)
		RemoveBlip(gioielli17)
		RemoveBlip(gioielli18)
		RemoveBlip(gioielli19)
		RemoveBlip(gioielli20)
	end
)

Citizen.CreateThread(
	function()
		TriggerEvent('lester:createBlip', 77, 435.73, 215.24, 103.17)

		while true do
			Citizen.Wait(0)
			playerPed = PlayerPedId()
			local pos = GetEntityCoords(PlayerPedId(), true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(1265.26, -703.02, 64.58)) <= 5 then
				TriggerServerEvent('lester:vendita')
				Citizen.Wait(4000)
				TriggerEvent(
					'skinchanger:getSkin',
					function(skin)
						if skin.sex == 0 then
							local clothesSkin = {
								['bags_1'] = 0,
								['bags_2'] = 0
							}
							TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
						else
							local clothesSkin = {
								['bags_1'] = 0,
								['bags_2'] = 0
							}
							TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
						end
					end
				)
			else
				Citizen.Wait(1000)
			end
		end
	end
)
