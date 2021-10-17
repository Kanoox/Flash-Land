local guiEnabled = false
local myIdentity = {}

-- VARIABLES-
function EnableGui(enable)
	SetNuiFocus(enable, enable)
	guiEnabled = enable
	InGuiEnable()
	SendNUIMessage({
		type = "enableui",
		enable = enable
	})
end

-- Show Registration
RegisterNetEvent("fl_identity:showRegisterIdentity")
AddEventHandler("fl_identity:showRegisterIdentity", function()
	EnableGui(true)
end)

-- Close GUI
RegisterNUICallback('escape', function(data, cb)
	EnableGui(false)
end)

-- Register Callback
RegisterNUICallback('register', function(data, cb)
	myIdentity = data
	TriggerServerEvent('fl_identity:setIdentity', data)
	EnableGui(false)
	Citizen.Wait(1000)
	TriggerEvent('fl_skin:openSaveableMenu')
	TriggerServerEvent('fl_dmvschool:addLicense', 'drive')
	TriggerServerEvent('fl_dmvschool:addLicense', 'dmv')
end)

function InGuiEnable()
	if not guiEnabled then return end
	Citizen.CreateThread(function()
		while guiEnabled do
			DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
			DisableControlAction(0, 2, guiEnabled) -- LookUpDown
			DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate
			DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

			if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
				SendNUIMessage({
					type = "click"
				})
			end

			Citizen.Wait(10)
		end
	end)
end