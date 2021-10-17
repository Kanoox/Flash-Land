local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local useMouse = false
local ignoreFocus = false
local takePhoto = false
local hasFocus = false
local airplaneMode = false
hasAPhone = false

local inCall = false
local currentCall = nil

local currentPlaySound = false
local soundDistanceMax = 4.0

-- Configuration
local KeyToucheCloseEvent = {
	{code = 172, event = 'ArrowUp'},
	{code = 173, event = 'ArrowDown'},
	{code = 174, event = 'ArrowLeft'},
	{code = 175, event = 'ArrowRight'},
	{code = 176, event = 'Enter'},
	{code = 177, event = 'Backspace'},
}

local blackout = false

function TogglePhone()
	menuIsOpen = not menuIsOpen
	SendNUIMessage({show = menuIsOpen})
	if menuIsOpen and hasAPhone then
		PhonePlayIn()

		Citizen.CreateThread(function()
			while menuIsOpen do
				Citizen.Wait(0)
				for _, value in ipairs(KeyToucheCloseEvent) do
					if IsControlJustPressed(1, value.code) then
						SendNUIMessage({keyUp = value.event})
					end
				end

				if useMouse and hasFocus == ignoreFocus then
					local nuiFocus = not hasFocus
					SetNuiFocus(nuiFocus, nuiFocus)
					hasFocus = nuiFocus
				elseif not useMouse and hasFocus then
					SetNuiFocus(false, false)
					hasFocus = false
				end
			end
		end)
	else
		if hasFocus then
			SetNuiFocus(false, false)
			hasFocus = false
		end
		PhonePlayOut()
	end
end

RegisterCommand('+openPhone', function()
	if takePhoto then return end
	if hasAPhone then
		TogglePhone()
	else
		ESX.ShowNotification("Vous n'avez pas de ~r~téléphone~s~")
	end
end, false)
RegisterCommand('-openPhone', function() end, false)

Citizen.CreateThread(function() VerifyHasPhone() end)

AddEventHandler('esx:changedPlayerData', function()
	VerifyHasPhone()
end)

function VerifyHasPhone()
	local gotAPhone = hasAPhone
	hasAPhone = false

	for _,item in pairs(ESX.GetPlayerData().inventory) do
		if item.name == 'phone' and item.count > 0 then
			hasAPhone = true
		end
	end

	if gotAPhone and not hasAPhone and menuIsOpen then
		TogglePhone()
	end
end

RegisterNetEvent('vSync:blackout')
AddEventHandler('vSync:blackout', function(toggle)
    blackout = toggle
end)

RegisterNetEvent('fl_phone:internal_call')
AddEventHandler('fl_phone:internal_call', function(data)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local message = data.message
    local number = data.number
    if message == nil then
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
        while UpdateOnscreenKeyboard() == 0 do
            DisableAllControlActions(0);
            Wait(0);
        end
        if GetOnscreenKeyboardResult() then
            message = GetOnscreenKeyboardResult()
        end
    end
    if message ~= nil and message ~= "" then
        TriggerServerEvent('fl_phone:sendMessageToJob', number, message, coords)
    end
    if number == 'police' then
        TriggerServerEvent('fl_appels:Zebi', message, coords, nil)
        
        local coords  = GetEntityCoords(PlayerPedId())
        local district = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
        local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, district.x, district.y, district.z, true))
        TriggerServerEvent("iCore:sendCallMsg", "~b~Identité : ~s~"..tonumber(myPhoneNumber).."\n~b~Localisation : ~w~'"..district.."' ("..distance.."m) \n~b~Infos : ~s~"..message.." ! \n", coords)
    end
end)

RegisterNetEvent('fl_phone:setEnableApp')
AddEventHandler('fl_phone:setEnableApp', function(appName, enable)
	SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

RegisterNetEvent("fl_phone:myPhoneNumber")
AddEventHandler("fl_phone:myPhoneNumber", function(_myPhoneNumber)
	myPhoneNumber = _myPhoneNumber
	SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("fl_phone:contactList")
AddEventHandler("fl_phone:contactList", function(_contacts)
	SendNUIMessage({event = 'updateContacts', contacts = _contacts})
	contacts = _contacts
end)

RegisterNetEvent("fl_phone:allMessage")
AddEventHandler("fl_phone:allMessage", function(allmessages)
	SendNUIMessage({event = 'updateMessages', messages = allmessages})
	messages = allmessages
end)

RegisterNetEvent("fl_phone:receiveMessage")
AddEventHandler("fl_phone:receiveMessage", function(message)
	if blackout then
		return
	end

	if airplaneMode then
		return
	end

	table.insert(messages, message)
	if hasAPhone then
		SendNUIMessage({event = 'newMessage', message = message})
	else
		SendNUIMessage({event = 'updateMessages', messages = messages})
	end

	if not hasAPhone then return end
	if message.owner ~= 0 then return end

	local text = '~o~Nouveau message'
	if ShowNumberNotification then
		text = '~o~Nouveau message du ~y~'.. message.transmitter
		for _,contact in pairs(contacts) do
			if contact.number == message.transmitter then
				text = '~o~Nouveau message de ~g~'.. contact.display
				break
			end
		end
	end

	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
	Citizen.Wait(300)
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
	Citizen.Wait(300)
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
end)

RegisterNetEvent("fl_phone:waitingCall")
AddEventHandler("fl_phone:waitingCall", function(infoCall, initiator)
	if blackout then
		TriggerServerEvent('fl_phone:rejectCall', infoCall)
		if initiator then
			ESX.ShowNotification("~r~Vous n'avez pas de réseau...")
		end
		return
	end

	if airplaneMode then
		return
	end

	if not hasAPhone then
		return
	end

	print('Waiting Call : ' .. tostring(infoCall.transmitter_num))
	SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
	if initiator then
		PhonePlayCall()
		if not menuIsOpen and hasAPhone then
			TogglePhone()
		end
	end
end)

local currentCallStartTime = 0
RegisterNetEvent("fl_phone:acceptCall")
AddEventHandler("fl_phone:acceptCall", function(infoCall, initiator, startTime)
    currentCall = infoCall

    exports["pma-voice"]:addPlayerToCall(currentCall.id + 1)
    if initiator then
        currentCallStartTime = startTime
    end

    if not menuIsOpen then
        TogglePhone()
    end
    PhonePlayCall()
    SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)

RegisterNetEvent("fl_phone:rejectCall")
AddEventHandler("fl_phone:rejectCall", function(infoCall, endTime)
    if currentCall and infoCall.id == currentCall.id then
        currentCall = nil
        exports["pma-voice"]:addPlayerToCall(0)
        PhonePlayText()
    end

    if currentCallStartTime > 0 then
        TriggerServerEvent('fl_simcard:useCallCredit', tonumber(myPhoneNumber), endTime - currentCallStartTime)
    end

    SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
    currentCallStartTime = 0
end)

RegisterNetEvent("fl_phone:historiqueCall")
AddEventHandler("fl_phone:historiqueCall", function(historique)
	SendNUIMessage({event = 'historiqueCall', historique = historique})
end)

RegisterNetEvent('fl_phone:autoCall')
AddEventHandler('fl_phone:autoCall', function(number, extraData)
	if number == nil then error('fl_phone:autoCall number is nil') return end

	SendNUIMessage({event = "autoStartCall", number = number, extraData = extraData})
end)

RegisterNetEvent('fl_phone:autoCallNumber')
AddEventHandler('fl_phone:autoCallNumber', function(data)
	TriggerEvent('fl_phone:autoCall', data.number)
end)

RegisterNetEvent('fl_phone:autoAcceptCall')
AddEventHandler('fl_phone:autoAcceptCall', function(infoCall)
	SendNUIMessage({event = "autoAcceptCall", infoCall = infoCall})
end)

RegisterNUICallback('startCall', function(data, cb)
	ESX.TriggerServerCallback('fl_simcard:hasCallCredit', function(hasCredit)
		if hasCredit then
			TriggerServerEvent('fl_phone:startCall', data.numero, extraData)
		else
			ESX.ShowNotification("~r~Vous n'avez plus de crédit pour appeler avec cette sim !")
		end
	end, tonumber(myPhoneNumber))
	cb()
end)

RegisterNUICallback('acceptCall', function(data, cb)
	TriggerServerEvent('fl_phone:acceptCall', data.infoCall)
	cb()
end)

RegisterNUICallback('rejectCall', function(data, cb)
	TriggerServerEvent('fl_phone:rejectCall', data.infoCall)
	cb()
end)

RegisterNUICallback('ignoreCall', function(data, cb)
	TriggerServerEvent('fl_phone:ignoreCall', data.infoCall)
	cb()
end)

RegisterNUICallback('reponseText', function(data, cb)
	local limit = data.limit or 255
	local text = data.text or ''

	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
	while UpdateOnscreenKeyboard() == 0 do
		DisableAllControlActions(0);
		Wait(0);
	end
	if GetOnscreenKeyboardResult() then
		text = GetOnscreenKeyboardResult()
	end
	cb(json.encode({text = text}))
end)

RegisterNUICallback('getMessages', function(data, cb)
	cb(json.encode(messages))
end)

RegisterNUICallback('sendMessage', function(data, cb)
	if data.message == '%pos%' then
		local myPos = GetEntityCoords(PlayerPedId())
		data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
	end

	ESX.TriggerServerCallback('fl_simcard:hasSmsCredit', function(hasCredit)
		if hasCredit then
			TriggerServerEvent('fl_simcard:useSmsCredit', tonumber(myPhoneNumber))
			TriggerServerEvent('fl_phone:sendMessage', data.phoneNumber, data.message)
		else
			ESX.ShowNotification("~r~Vous n'avez plus de crédit pour envoyer un SMS avec cette sim ! (" .. tostring(data.phoneNumber) .. ')')
		end
	end, tonumber(myPhoneNumber))
end)

RegisterNUICallback('deleteMessage', function(data, cb)
	TriggerServerEvent('fl_phone:deleteMessage', data.id)
	for k, v in ipairs(messages) do
		if v.id == data.id then
			table.remove(messages, k)
			SendNUIMessage({event = 'updateMessages', messages = messages})
			return
		end
	end
	cb()
end)

RegisterNUICallback('deleteMessageNumber', function(data, cb)
	TriggerServerEvent('fl_phone:deleteMessageNumber', data.number)
	cb()
end)

RegisterNUICallback('deleteAllMessage', function(data, cb)
	TriggerServerEvent('fl_phone:deleteAllMessage')
	cb()
end)

RegisterNUICallback('setReadMessageNumber', function(data, cb)
	TriggerServerEvent('fl_phone:setReadMessageNumber', data.number)
	for k, v in ipairs(messages) do
		if v.transmitter == data.number then
			v.isRead = 1
		end
	end
	cb()
end)

RegisterNUICallback('addContact', function(data, cb)
	TriggerServerEvent('fl_phone:addContact', data.display, data.phoneNumber)
end)

RegisterNUICallback('updateContact', function(data, cb)
	TriggerServerEvent('fl_phone:updateContact', data.id, data.display, data.phoneNumber)
end)

RegisterNUICallback('deleteContact', function(data, cb)
	TriggerServerEvent('fl_phone:deleteContact', data.id)
end)

RegisterNUICallback('getContacts', function(data, cb)
	cb(json.encode(contacts))
end)

RegisterNUICallback('setGPS', function(data, cb)
	SetNewWaypoint(tonumber(data.x), tonumber(data.y))
	cb()
end)

RegisterNUICallback('ejectSim', function(data, cb)
	TriggerServerEvent('fl_simcard:changeNumber', 0)
	cb()
end)

RegisterNUICallback('callEvent', function(data, cb)
	local eventName = data.eventName or ''
	if not string.match(eventName, 'fl_phone') then error('Event unauthorized') return end

	if data.data ~= nil then
		TriggerEvent(data.eventName, data.data)
	else
		TriggerEvent(data.eventName)
	end
	cb()
end)

RegisterNUICallback('useMouse', function(um, cb)
	useMouse = um
end)

RegisterNUICallback('airplaneMode', function(am, cb)
	repeat Citizen.Wait(0) until ESX
	repeat Citizen.Wait(0) until ESX.IsPlayerLoaded()

	airplaneMode = am
	if not airplaneMode then
		TriggerServerEvent('fl_phone:allUpdate')
	end
end)

RegisterNUICallback('deleteALL', function(data, cb)
	TriggerServerEvent('fl_phone:deleteALL')
	cb()
end)

RegisterNUICallback('faketakePhoto', function(data, cb)
	if menuIsOpen then TogglePhone() end
	cb()
	TriggerEvent('fl_phone:openCamera')
end)

RegisterNUICallback('closePhone', function(data, cb)
	if menuIsOpen then
		TogglePhone()
	end
	cb()
end)

RegisterNUICallback('appelsDeleteHistorique', function(data, cb)
	TriggerServerEvent('fl_phone:appelsDeleteHistorique', data.numero)
	cb()
end)

RegisterNUICallback('appelsDeleteAllHistorique', function(data, cb)
	TriggerServerEvent('fl_phone:appelsDeleteAllHistorique')
	cb()
end)

RegisterNUICallback('setIgnoreFocus', function(data, cb)
	ignoreFocus = data.ignoreFocus
	cb()
end)

RegisterNUICallback('takePhoto', function(data, cb)

	CreateMobilePhone(1)
  	CellCamActivate(true, true)
	takePhoto = true
	Citizen.Wait(0)
	if hasFocus == true then
    	SetNuiFocus(false, false)
    	hasFocus = false
  	end
	while takePhoto do
    	Citizen.Wait(0)
		if IsControlJustPressed(1, 27) then -- Toogle Mode
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
   	 	elseif IsControlJustPressed(1, 177) then -- CANCEL
			DestroyMobilePhone()
			CellCamActivate(false, false)
			cb(json.encode({ url = nil }))
			takePhoto = false
			break
    	elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
			takePhoto = false
			ESX.ShowNotification("~y~Upload de la photo en cours.. Veuillez patienter !")
			DestroyMobilePhone()
			CellCamActivate(false, false)
			exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/876932504769159278/dkIOxy-U-V2MP2w82gQAmHNQHjL7aCizQEbll7aNkYe0eQkgsn-fHwgbAr8AmAmNTnNq", data.field, function(data)
				local image = json.decode(data)
				DestroyMobilePhone()
				CellCamActivate(false, false)
				cb(json.encode({ url = image.attachments[1].proxy_url }))
			  end)
		end
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
		HideHudAndRadarThisFrame()
	end
	Citizen.Wait(1000)
	PhonePlayAnim('text', false, true)
end)

RegisterCommand('debug_phone_currentcall', function()
	print(ESX.Dump(currentCall))
end, true)


RegisterCommand('debugPhone', function()
	if menuIsOpen and hasAPhone then
		DeletePhone()
		PhonePlayOut()
		TogglePhone()
		ESX.ShowNotification('Debug effectué avec ~g~succès !')
	else
		ESX.ShowNotification('~r~Ouvrez~s~ votre téléphone pour faire cette commande !')
	end
end)