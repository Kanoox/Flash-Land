local inCameraMode = false
local frontCam = false

RegisterNetEvent('fl_phone:openCamera')
AddEventHandler('fl_phone:openCamera', function()
    CreateMobilePhone(1)
	CellCamActivate(true, true)
	TriggerEvent('ui:toggle', false)
	PhonePlayOut()

	inCameraMode = true
	while inCameraMode do
		Citizen.Wait(0)

		if IsControlJustPressed(1, 177) then -- CLOSE PHONE
			DestroyMobilePhone()
			inCameraMode = false
			CellCamActivate(false, false)
			TriggerEvent('ui:toggle', true)
		end

		if IsControlJustPressed(1, 27) then -- SELFIE MODE
			frontCam = not frontCam
		end

		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
		HideHudAndRadarThisFrame()

		SetTextRenderId(GetMobilePhoneRenderId())
		SetTextRenderId(1)
	end
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end