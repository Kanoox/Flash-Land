local fov_max = 80.0
local fov_min = 10.0
local fov = (fov_max+fov_min)*0.5
local speed_lr = 5.0
local speed_ud = 5.0
local zoomspeed = 6.0
local currentCamera = -1
local lookCamera = false
local cam = 0
local scaleform = -1

local controlCoord = vector3(445.12, -997.43, 34.97)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if #(controlCoord - GetEntityCoords(PlayerPedId())) <= 3.0 then
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_ENTER~ pour accèder aux caméras")
			if IsControlJustPressed(1, 23) then
				TriggerEvent('ui:toggle', false)
				lookCamera = true
				if currentCamera == -1 then
					currentCamera = 1
				end
				chargeCamera()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		if lookCamera then
			if IsControlJustPressed(1, 174) then -- Left
				if currentCamera-1 > 0 then
					currentCamera = currentCamera-1
				else
					currentCamera = #Config.Camera
				end
				changeCamera()
			end

			if IsControlJustPressed(1, 175) then -- Right
				if currentCamera+1 <= #Config.Camera then
					currentCamera = currentCamera+1
				else
					currentCamera = 1
				end
				changeCamera()
			end

			if IsControlJustPressed(1, 177) then
				lookCamera = false
				SetEntityCoords(PlayerPedId(), controlCoord, 0, 0, 0, 0)
				SetEntityVisible(PlayerPedId(), true)
				FreezeEntityPosition(PlayerPedId(), false)
				TriggerEvent('ui:toggle', true)
				ClearTimecycleModifier("scanline_cam_cheap")
			end

			if IsControlJustPressed(1, 18) then
				local n = KeyboardInput('CCTV', 'N° de caméra', '', 8)

				if n and tonumber(n) > 0 and tonumber(n) < #Config.Camera then
					currentCamera = tonumber(n)
					changeCamera()
				else
					ESX.ShowNotification('Numéro invalide...')
				end
			end

			local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
			CheckForRotation(cam,zoomvalue)
			HandleZoom(cam)
			scaleform = RequestScaleformMovie("HELI_CAM")
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(1) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()
			PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
			PopScaleformMovieFunctionVoid()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.45)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Caméra N°"..currentCamera)
			DrawText(0.45, 0.90)

			for i=1, 22 do
				HideHudComponentThisFrame(i)
			end

		else
			RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
			DestroyAllCams(false)
			SetSeethrough(false)

			Citizen.Wait(500)
		end
	end

end)

function changeCamera()
	SetEntityCoords(PlayerPedId(), Config.Camera[currentCamera].x, Config.Camera[currentCamera].y, -10.0, 0, 0, 0, 0)
	SetEntityHeading(PlayerPedId(), Config.Camera[currentCamera].w - 180)
	SetCamCoord(cam, Config.Camera[currentCamera].x, Config.Camera[currentCamera].y, Config.Camera[currentCamera].z - 0.5)
	SetCamRot(cam, 0.0, 0.0, Config.Camera[currentCamera].w - 180)
end

function chargeCamera()
	SetTimecycleModifier("scanline_cam_cheap")
	SetTimecycleModifierStrength(2.0)
	cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

	SetEntityVisible(PlayerPedId(), false)
	SetCamRot(cam, 0.0, 0.0, Config.Camera[currentCamera].w - 180.0)
	changeCamera()
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	FreezeEntityPosition(PlayerPedId(), true)
end

function CheckForRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0,241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local blips = {}
RegisterNetEvent('fl_computer:blipCamera')
AddEventHandler('fl_computer:blipCamera', function()
	if #blips == 0 then
		for _,pos in pairs(Config.Camera) do
			local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
			SetBlipSprite(blip, 604)
			SetBlipScale(blip, 0.5)
			SetBlipRotation(blip, pos.w)
			SetBlipAsShortRange(blip, true)
			SetBlipColour(blip, 1)
			SetBlipAlpha(blip, 180)
			SetBlipShowCone(blip, true)
			table.insert(blips, blip)
		end
	else
		for _,blip in pairs(blips) do
			RemoveBlip(blip)
		end
		blips = {}
	end
end)