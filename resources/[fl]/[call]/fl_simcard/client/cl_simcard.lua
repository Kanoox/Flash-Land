RegisterNetEvent('fl_simcard:startNumChange')
AddEventHandler('fl_simcard:startNumChange', function(newNum)
	exports.fl_emotes:OnEmotePlay({"cellphone@", "cellphone_text_read_base", "Phone", AnimationOptions =
	{
		Prop = "prop_npc_phone_02",
		PropBone = 28422,
		PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		EmoteLoop = true,
		EmoteMoving = true,
	}})

	Citizen.Wait(Config.TimeToChange)
	TriggerServerEvent('fl_simcard:changeNumber', newNum)
	exports.fl_emotes:EmoteCancel()
	ESX.ShowNotification('~b~~h~Numéro de téléphone : ~g~' .. newNum)
end)

RegisterNetEvent('fl_simcard:ejectMySim')
AddEventHandler('fl_simcard:ejectMySim', function()
	TriggerServerEvent('fl_simcard:changeNumber', 0)
end)

RegisterNetEvent('fl_simcard:success')
AddEventHandler('fl_simcard:success', function()
	TriggerServerEvent('fl_phone:allUpdate')
end)