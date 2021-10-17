mhackingCallback = {}
showHelp = false
helpTimer = 0
helpCycle = 4000

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showHelp then
			if helpTimer > GetGameTimer() then
				showHelpText("Naviguez avec ~b~Z,Q,S,D~w~ puis confirmez ~INPUT_DIVE~ pour le bloc gauche.")
			elseif helpTimer > GetGameTimer() - helpCycle then
				showHelpText("Utilisez ~b~les flèches~w~ puis ~INPUT_FRONTEND_RDOWN~ pour le bloc droite.")
			else
				helpTimer = GetGameTimer() + helpCycle
			end

			if IsEntityDead(PlayerPedId()) then
				nuiMsg = {}
				nuiMsg.fail = true
				SendNUIMessage(nuiMsg)
			end
		else
			Citizen.Wait(300)
		end
	end
end)

function showHelpText(s)
	SetTextComponentFormat("STRING")
	AddTextComponentString(s)
	EndTextCommandDisplayHelp(0, 0, 0, -1)
end

AddEventHandler('fl_bank:showHack', function()
    nuiMsg = {}
	nuiMsg.show = true
	SendNUIMessage(nuiMsg)
	SetNuiFocus(true, false)
end)

AddEventHandler('fl_bank:hideHack', function()
    nuiMsg = {}
	nuiMsg.show = false
	SendNUIMessage(nuiMsg)
	SetNuiFocus(false, false)
	showHelp = false
end)

AddEventHandler('fl_bank:startHack', function(solutionLength, duration, callback)
    mhackingCallback = callback
	nuiMsg = {}
	nuiMsg.s = solutionLength
	nuiMsg.d = duration
	nuiMsg.start = true
	SendNUIMessage(nuiMsg)
	showHelp = true
end)

AddEventHandler('fl_bank:setMessage', function(msg)
    nuiMsg = {}
	nuiMsg.displayMsg = msg
	SendNUIMessage(nuiMsg)
end)

RegisterNUICallback('callback', function(data, cb)
	mhackingCallback(data.success, data.remainingTime)
    cb('ok')
end)

-- SEQ

seqSwitch = nil
seqRemaingingTime = 0

AddEventHandler('fl_bank:seqStartHack', function(solutionLength, duration, callback)
	print('fl_bank:seqStartHack')
	if type(solutionLength) ~= 'table' and type(duration) ~= 'table' then
		TriggerEvent('fl_bank:showHack')
		TriggerEvent('fl_bank:startHack', solutionLength, duration, mhackingSeqCallback)
		while seqSwitch == nil do
			Citizen.Wait(5)
		end
		TriggerEvent('fl_bank:hideHack')
		callback(seqSwitch, seqRemaingingTime, true)
		seqRemaingingTime = 0
		seqSwitch = nil

	elseif type(solutionLength) == 'table' and type(duration) ~= 'table' then
		TriggerEvent('fl_bank:showHack')
		seqRemaingingTime = duration
		for _, sollen in pairs(solutionLength) do
			TriggerEvent('fl_bank:startHack', sollen, seqRemaingingTime, mhackingSeqCallback)
			while seqSwitch == nil do
				Citizen.Wait(5)
			end

			if next(solutionLength,_) == nil or seqRemaingingTime == 0 then
				callback(seqSwitch, seqRemaingingTime, true)
			else
				callback(seqSwitch, seqRemaingingTime, false)
			end
			seqSwitch = nil
		end

		seqRemaingingTime = 0
		TriggerEvent('fl_bank:hideHack')
	elseif type(solutionLength) ~= 'table' and type(duration) == 'table' then
		TriggerEvent('fl_bank:showHack')
		for _, dur in pairs(duration) do
			TriggerEvent('fl_bank:startHack', solutionLength, dur, mhackingSeqCallback)
			while seqSwitch == nil do
				Citizen.Wait(5)
			end
			if next(duration,_) == nil then
				callback(seqSwitch, seqRemaingingTime, true)
			else
				callback(seqSwitch, seqRemaingingTime, false)
			end
			seqSwitch = nil
		end

		seqRemaingingTime = 0
		TriggerEvent('fl_bank:hideHack')
	elseif type(solutionLength) == 'table' and type(duration) == 'table' then
		local itrTbl = {}
		local solTblLen = 0
		local durTblLen = 0

		for _ in ipairs(solutionLength) do solTblLen = solTblLen + 1 end
		for _ in ipairs(duration) do durTblLen = durTblLen + 1 end
		itrTbl = duration
		if solTblLen > durTblLen then itrTbl = solutionLength end

		TriggerEvent('fl_bank:showHack')
		for idx in ipairs(itrTbl) do
			TriggerEvent('fl_bank:startHack', solutionLength[idx], duration[idx], mhackingSeqCallback)
			while seqSwitch == nil do
				Citizen.Wait(5)
			end
			if next(itrTbl,idx) == nil then
				callback(seqSwitch, seqRemaingingTime, true)
			else
				callback(seqSwitch, seqRemaingingTime, false)
			end
			seqSwitch = nil
		end

		seqRemaingingTime = 0
		TriggerEvent('fl_bank:hideHack')
	end
end)

function mhackingSeqCallback(success, remainingTime)
	seqSwitch = success
	seqRemaingingTime = math.floor(remainingTime/1000.0 + 0.5)
end