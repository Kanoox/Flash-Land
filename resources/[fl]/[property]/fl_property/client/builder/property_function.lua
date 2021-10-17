function OpenKeyboardText(text)
    AddTextEntry('FMMC_KEY_TIP1', text)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 40)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(500) 
		blockinput = false 
        if tostring(result) == nil and tostring(result) ~= -1 then 
        	ESX.ShowNotification("Vous devez entré un texte !")
        	return
        end
        return tostring(result)
	else
		Citizen.Wait(500)
		blockinput = false 
		return nil
	end
end



function Cam(cameraData)
	if cam ~= nil then
		DestroyCam(cam)
	end

	cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	SetFocusArea(cameraData.focus, 0.0, 0.0, 0.0)
	SetCamCoord(cam, cameraData.focus)
	SetCamRot(cam, cameraData.rot)
	SetCamActive(cam,  true)

	local interiorId = GetInteriorAtCoords(cameraData.focus)
	PinInteriorInMemory(interiorId)
	CapInterior(interiorId, false)
	DisableInterior(interiorId, false)
	SetInteriorActive(interiorId, true)

	RenderScriptCams(true,  false,  0,  true,  true)
	FreezeEntityPosition(PlayerPedId(), true)
	TriggerEvent('ui:toggle', false)
	DisplayRadar(false)
end

function Destroy()
	if cam ~= nil then
		SetCamActive(cam,  false)
		DestroyCam(cam)
		cam = nil

		FreezeEntityPosition(PlayerPedId(), false)
		RenderScriptCams(false,  false,  0,  false,  false)
		SetFocusEntity(PlayerPedId())
		TriggerEvent('ui:toggle', true)
		DisplayRadar(true)
	end
end