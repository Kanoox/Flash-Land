local myPedId = nil

local phoneProp = 0
local phoneModel = -1038739674

local currentStatus = 'out'
local lastDict = nil
local lastAnim = nil
local lastIsFreeze = false

local ANIMS = {
	['cellphone@'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_listen_base',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_call_out',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	},
	['anim@cellphone@in_car@ps'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_in',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_horizontal_exit',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	}
}

function NewPhoneProp()
	DeletePhone()
	ESX.Streaming.RequestModel(phoneModel)
	phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(phoneProp, myPedId, GetPedBoneIndex(myPedId, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

function DeletePhone()
	if phoneProp ~= 0 then
		DeleteEntity(phoneProp)
		phoneProp = 0
	end
end

function PhonePlayAnim(status, freeze, force)
	if currentStatus == status and not force then
		return
	end

	myPedId = PlayerPedId()

	local dict = "cellphone@"
	if IsPedInAnyVehicle(myPedId, false) then
		dict = "anim@cellphone@in_car@ps"
	end
	ESX.Streaming.RequestAnimDict(dict)

	local anim = ANIMS[dict][currentStatus][status]
	if currentStatus ~= 'out' then
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end
	local flag = 50
	if freeze then
		flag = 14
	end
	TaskPlayAnim(myPedId, dict, anim, 3.0, -1, -1, flag, 0, false, false, false)

	if status ~= 'out' and currentStatus == 'out' then
		Citizen.Wait(380)
		NewPhoneProp()
	end

	lastDict = dict
	lastAnim = anim
	lastIsFreeze = freeze
	currentStatus = status

	if status == 'out' then
		Citizen.Wait(180)
		DeletePhone()
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end

end

function PhonePlayOut()
	PhonePlayAnim('out')
end

function PhonePlayText()
	if not hasAPhone then return end
	PhonePlayAnim('text')
end

function PhonePlayCall(freeze)
	if not hasAPhone then return end
	PhonePlayAnim('call', freeze)
end

function PhonePlayIn()
	if not hasAPhone then return end
	if currentStatus == 'out' then
		PhonePlayText()
	end
end

DeletePhone()
StopAnimTask(myPedId, lastDict, lastAnim, 1.0)