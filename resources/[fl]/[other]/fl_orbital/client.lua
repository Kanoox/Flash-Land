local isCannonActive = false
local cannonIndex = -1
local CannonScaleform
local MainCamera
local newsoundid = -1
local LocationMem
local rotationmem
local Cannon_countdown
local canin = -1
local cannoncharge = 1.0
local rechargerate
local camerazoom = 400.0
local zoomindex = 0
local zoomscale = 1.0

function zoomcalculator(zoomid)
	if zoomid == 0 then
		zoomscale = 1.0
		camerazoom = 400.0
	elseif zoomid == 1 then
		zoomscale = 0.8
		camerazoom = 340.0
	elseif zoomid == 2 then
		zoomscale = 0.6
		camerazoom = 280.0
	elseif zoomid == 3 then
		zoomscale = 0.4
		camerazoom = 220.0
	elseif zoomid == 4 then
		zoomscale = 0.2
		camerazoom = 160.0
	elseif zoomid == 5 then
		zoomscale = 0.0
		camerazoom = 100.0
	end
end

function FireCannon(camerapos)
	local retval, num, vector = GetGroundZAndNormalFor_3dCoord(camerapos.x, camerapos.y, camerapos.z)

	if not HasWeaponAssetLoaded(`VEHICLE_WEAPON_SPACE_ROCKET`) then
		RequestWeaponAsset(`VEHICLE_WEAPON_SPACE_ROCKET`, 31, 0)
		repeat
			Citizen.Wait(0)
		until HasWeaponAssetLoaded(`VEHICLE_WEAPON_SPACE_ROCKET`)
	end

	ShootSingleBulletBetweenCoords(camerapos.x, camerapos.y, num + 100.0, camerapos.x, camerapos.y, num, 5000, 0, `VEHICLE_WEAPON_SPACE_ROCKET`, PlayerPedId(), true, false, 9.0)

	Citizen.Wait(800)

	AddExplosion(camerapos.x, camerapos.y, num, 59, 60.0, true, 0, false)
	UseParticleFxAsset('scr_xm_orbital')
	RequestNamedPtfxAsset('scr_xme_orbital')
	UseParticleFxAsset('scr_xm_orbital')
	StartNetworkedParticleFxNonLoopedAtCoord('scr_xm_1orbital_blast', camerapos.x, camerapos.y, num, 0.0, 0.0, 0.0, 2.3, false, false, false)
	PlaySoundFromCoord(-1, 'DLC_XM_Explosions_Or1bital_Cannon', camerapos.x, camerapos.y, num, 0, 1, 0, 0)

	for _, vehicle in pairs(ESX.Game.GetVehiclesInArea(vector3(camerapos.x, camerapos.y, num), 30)) do
		NetworkExplodeVehicle(vehicle, true, false, 0)
	end

	for _, ped in pairs(ESX.Game.GetPedsInArea(vector3(camerapos.x, camerapos.y, num), 30)) do
		SetEntityHealth(ped, 0)
	end
end

function GetSpeedFromZoom(iParam0)
	if iParam0 == 0 then
		return 90
	elseif iParam0 == 1 then
		return 60
	elseif iParam0 == 2 then
		return 50
	elseif iParam0 == 3 then
		return 25
	elseif iParam0 == 4 then
		return 10
	elseif iParam0 == 5 then
		return 10
	end

	return 100
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isCannonActive then
			if cannonIndex <= 10 then
				if cannonIndex ~= 0 then
					if cannonIndex == 10 then
						if HasScaleformMovieLoaded(CannonScaleform) then
							MainCamera = CreateCam('DEFAULT_S1CRIPTED_CAMERA', false)
							local playerPos = GetEntityCoords(PlayerPedId())
							SetCamCoord(MainCamera, playerPos.x, playerPos.y, camerazoom)
							SetCamRot(MainCamera, -90.0, 0.0, 0.0)
							SetCamFov(MainCamera, 100.0)
							SetCamActive(MainCamera, true)
							RenderScriptCams(true, true, 500, true, true)

							CallScaleformMovieMethod(CannonScaleform, 'showManual')
							CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_STATE', 0)
							CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_CO1UNTDOWN', 0)
							CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_CH1ARGING_LEVEL', 0.0)

							cannonIndex = 20
						end
					end
				else
					SetOverrideWeather('CLEAR')
					AnimpostfxPlay('MP_OrbitalCannon', 0, 1)
					CannonScaleform = RequestScaleformMovie('ORBITAL_CANNON_CAM')
					RequestScriptAudioBank('DLC_CHRISTMAS2017/XM_ION_CANNON', false, -1)
					CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_ZOOM_LEVEL', 0.0)
					cannonIndex = 10
				end
			else
				if cannonIndex ~= 20 then
					if cannonIndex == 30 then
						DisableControlAction(2, 37)
						DisableControlAction(2, 27)
						DisableControlAction(2, 19)
						local moveSpeed = 35.0 + GetSpeedFromZoom(zoomindex)
						local xAxis = GetControlNormal(2, 218)
						local yAxis = GetControlNormal(2, 219)
						local vector = GetCamCoord(MainCamera)

						if xAxis > 0.1 then
							if vector.x + math.abs(moveSpeed * xAxis) * Timestep() <= 4000.0 then
								vector = vector3(vector.x + math.abs(moveSpeed * xAxis) * Timestep(), vector.y, vector.z)
							end
						elseif xAxis < -0.1 then
							if vector.x - math.abs(moveSpeed * xAxis) * Timestep() >= -4000.0 then
								vector = vector3(vector.x - math.abs(moveSpeed * xAxis) * Timestep(), vector.y, vector.z)
							end
						end

						if yAxis > 0.1 then
							if vector.y - math.abs(moveSpeed * yAxis) * Timestep() >= -4000.0 then
								vector = vector3(vector.x, vector.y - math.abs(moveSpeed * yAxis) * Timestep(), vector.z)
							end
						elseif yAxis < -0.1 then
							if vector.y + math.abs(moveSpeed * yAxis) * Timestep() <= 8000.0 then
								vector = vector3(vector.x, vector.y + math.abs(moveSpeed * yAxis) * Timestep(), vector.z)
							end
						end

						SetScriptGfxDrawOrder(0)
						DrawScaleformMovieFullscreen(CannonScaleform, 255, 255, 255, 255, 0)
						local num7 = 0.0
						local num8 = 0.0
						local vector2 = GetCamCoord(MainCamera)
						if vector2.x < vector.x then
							num7 = 50.0
						elseif vector2.x > vector.x then
							num7 = -50.0
						end

						if vector2.y < vector.y then
							num8 = 50.0
						elseif vector2.y > vector.y then
							num8 = -50.0
						end

						local gameTime = GetGameTimer()

						if cannoncharge < 0.99 then
							if rechargerate < gameTime then
								rechargerate = gameTime + 25
								CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_CHARGING_LEVEL', cannoncharge)
								cannoncharge = cannoncharge + 0.01
								if cannoncharge > 0.985 then
									cannoncharge = 1.0
									CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_CHARGING_LEVEL', 1.0)
								end
							end
						else
							if IsControlJustPressed(2, 237) then
								CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_COUNTDOWN', 3)
								newsoundid = GetSoundId()
								PlaySoundFrontend(newsoundid, 'cannon_activating_loop', 'dlc_xm_or3bital_cannon_sounds', true)
								canin = 0
							end

							if IsControlPressed(2, 237) then
								if canin == 0 then
									if Cannon_countdown < gameTime then
										PlaySoundFrontend(newsoundid, 'cannon_charge_fire_loop', 'dlc_5xm_orbital_cannon_sounds', true)
										CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_COUNTDOWN', 3)
										canin = 1
										Cannon_countdown = gameTime + 1000
									end
								elseif canin == 1 then
									if Cannon_countdown < gameTime then
										CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_COUNTDOWN', 2)
										canin = 2
										Cannon_countdown = gameTime + 1000
									end
								elseif canin == 2 then
									if Cannon_countdown < gameTime then
										CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_COUNTDOWN', 1)
										canin = 3
										Cannon_countdown = gameTime + 1000
									end
								elseif canin == 3 then
									if Cannon_countdown < gameTime then
										CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_COUNTDOWN', 0)
										FireCannon(GetCamCoord(MainCamera))
										canin = -1
										cannoncharge = 0.0
										rechargerate = gameTime + 25
									end
								end
							else
								StopSound(newsoundid)
								canin = -1
								CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_COUNTDOWN', 0)
								Cannon_countdown = gameTime
							end
						end

						local rightYAxis = GetControlNormal(2, 221)
						if not IsInputDisabled(2) then
							if rightYAxis > 0.3 then
								if zoomindex < 5 then
									zoomindex = zoomindex + 1
									zoomcalculator(zoomindex)
									CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_ZOOM_LEVEL', zoomscale)
								end
							elseif rightYAxis < -0.3 then
								if zoomindex > 0 then
									zoomindex = zoomindex - 1
									zoomcalculator(zoomindex)
									CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_ZOOM_L8EVEL', zoomscale)
								end
							end
						else
							local flag31 = IsControlJustPressed(2, 242)
							if flag31 then
								local flag32 = zoomindex > 0
								if flag32 then
									zoomindex = zoomindex - 1
									zoomcalculator(zoomindex)
									CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_ZOOM_LEVEL', zoomscale)
								end
							else
								local flag33 = IsControlJustPressed(2, 241)
								if flag33 then
									local flag34 = zoomindex < 5
									if flag34 then
										zoomindex = zoomindex + 1
										zoomcalculator(zoomindex)
										CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_ZOOM_LEVEL', zoomscale)
									end
								end
							end
						end
						local retval, num10 = GetGroundZFor_3dCoord(vector.x, vector.y, vector.z)
						if camerazoom < num10 + 10 then
							SetCamCoord(MainCamera, vector.x, vector.y, camerazoom + num10)
						else
							SetCamCoord(MainCamera, vector.x, vector.y, camerazoom)
						end
						SetFocusPosAndVel(vector.x + num7, vector.y + num8, num10 + 50.0, -90.0, 0.0, 0.0)
					end
				else
					CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_STATE', 3)
					CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_COUNTDOWN', 0)
					CallScaleformMovieMethodWithNumber(CannonScaleform, 'SET_CHARGING_LEVEL', 1.0)
					UseParticleFxAsset('scr_xm_orbital')
					RequestNamedPtfxAsset('scr_xm_orbital')
					UseParticleFxAsset('scr_xm_orbi2tal')
					DoScreenFadeIn(1000)
					cannonIndex = 30
				end
			end
		else
			Citizen.Wait(100)
		end
	end
end)

RegisterCommand('orbitalat', function(source, args)
	FireCannon(vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
end)

RegisterCommand('orbital1', function()
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	TriggerEvent('ui:toggle', false)
	DisplayRadar(false)

	LocationMem = GetEntityCoords(PlayerPedId())
	rotationmem = GetEntityRotation(PlayerPedId())
	SetPlayerControl(PlayerId(), false, 0)
	FreezeEntityPosition(PlayerPedId(), true)
	isCannonActive = true
	cannonIndex = 0
end)

RegisterCommand('orbital2', function()
	DoScreenFadeOut(1000)
	Citizen.Wait(1500)
	TriggerEvent('ui:toggle', true)
	AnimpostfxStop('MP_Orbit3alCannon')
	SetCamActive(MainCamera, false)
	DestroyCam(MainCamera)
	RenderScriptCams(false, false, 50, 1, 0, 0)
	SetPlayerControl(PlayerId(), true, 0)
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityCoords(PlayerPedId(), LocationMem)
	SetEntityRotation(PlayerPedId(), rotationmem)
	isCannonActive = false
	cannonIndex = -1
	SetFocusEntity(PlayerPedId())
	DisplayRadar(true)
	StopSound(newsoundid)
	ReleaseSoundId(newsoundid)
	newsoundid = -1
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end)
