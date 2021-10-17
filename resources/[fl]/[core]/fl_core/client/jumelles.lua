local fov_max = 60.0
local fov_min = 5.0
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down

local binoculars = false
local fov = (fov_max+fov_min)*0.5

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if binoculars then
			local lPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(lPed)

			if not IsPedSittingInAnyVehicle(lPed) then
				TaskStartScenarioInPlace(lPed, 'WORLD_HUMAN_BINOCULARS', 0, 1)
			end

			Citizen.Wait(1500)

			SetTimecycleModifier('default')
			SetTimecycleModifierStrength(0.3)

			local scaleform = RequestScaleformMovie('BINOCULARS')

			repeat
				Citizen.Wait(10)
			until HasScaleformMovieLoaded(scaleform)

			local vehicle = GetVehiclePedIsIn(lPed)
			local cam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)

			AttachCamToEntity(cam, lPed, 0.0, 0.0, 1.0, true)
			SetCamRot(cam, 0.0, 0.0, GetEntityHeading(lPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)

			TriggerEvent('ui:toggle', false)

			while binoculars and not IsEntityDead(lPed) and GetVehiclePedIsIn(lPed) == vehicle and not IsControlJustPressed(0, 177) and not IsControlJustPressed(0, 73) and not IsControlJustPressed(0, 200) do
				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
				CheckInputRotation(cam, zoomvalue)
				HandleZoom(cam)
				HideHUDThisFrame()

				DrawRect(1.0, 0.0, 2.0, 0.1/3, 0, 0, 0, 255)
				DrawRect(0.0, 1.0, 0.1/3, 2.3, 0, 0, 0, 255)
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
				SetPlayerInvisibleLocally(PlayerId(), true)
				Citizen.Wait(0)
			end

			TriggerEvent('ui:toggle', true)

			PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
			ClearPedTasks(lPed)
			SetPlayerInvisibleLocally(PlayerId(), false)
			binoculars = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam, false)
			SetSeethrough(false)
		else
			Citizen.Wait(500)
		end
	end
end)

--EVENTS--

RegisterNetEvent('fl_jumelles:toggle')
AddEventHandler('fl_jumelles:toggle', function()
	binoculars = not binoculars
end)

--FUNCTIONS--
function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
	HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = PlayerPedId()

	if IsControlJustPressed(0, 241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end

	if IsControlJustPressed(0, 242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
	end

	local current_fov = GetCamFov(cam)

	if math.abs(fov-current_fov) < 0.1 then
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
end