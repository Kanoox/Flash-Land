Citizen.CreateThread(function()
	for _,Bank in pairs(Config.Banks) do
		Bank.Peds = {}
		for _,PedInfo in pairs(Bank.npc) do

			ESX.Streaming.RequestModel(GetHashKey(PedInfo.model))

			local ped = CreatePed(4, GetHashKey(PedInfo.model), PedInfo.pos.x, PedInfo.pos.y, PedInfo.pos.z, PedInfo.pos.w, false, false)
			SetPedRandomComponentVariation(ped)
			SetPedRandomProps(ped)
			SetBlockingOfNonTemporaryEvents(ped, false)
			FreezeEntityPosition(ped, true)
			DisablePedPainAudio(ped, true)
			SetPedSeeingRange(ped, 0)
			SetPedFleeAttributes(ped, 0, 0)
			SetPedArmour(ped, 200)
			SetPedSuffersCriticalHits(ped, false)
			SetPedMaxHealth(ped, 200)
			SetPedDiesWhenInjured(ped, true)
			SetEntityInvincible(ped, true)
			SetAmbientVoiceName(ped, 'GENERIC_HI')

			if PedInfo.dict and PedInfo.anim then
				RequestAnimDict(PedInfo.anim)
				repeat
					Citizen.Wait(0)
				until HasAnimDictLoaded(PedInfo.anim)
				TaskPlayAnim(ped, PedInfo.anim, PedInfo.dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
			elseif PedInfo.scenario then
				TaskStartScenarioInPlace(ped, PedInfo.scenario, 0, 0)
			else
				TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT', 0, 0)
			end

			table.insert(Bank.Peds, ped)

			SetModelAsNoLongerNeeded(GetHashKey(PedInfo.model))
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local FreeAiming, FreeAimingEntity = GetEntityPlayerIsFreeAimingAt(PlayerId())

		if FreeAiming then
			if not IsPedDeadOrDying(FreeAimingEntity, true) and IsPedArmed(PlayerPedId(), 4) then
				for _,Bank in pairs(Config.Banks) do
					for _,Ped in pairs(Bank.Peds) do
						if Ped == FreeAimingEntity then
							Bank.PedHoldUp = true
							FreezeEntityPosition(Ped, false)
							ClearPedTasksImmediately(Ped)

							RequestAnimDict("missminuteman_1ig_2")
							repeat
								Citizen.Wait(0)
							until HasAnimDictLoaded("missminuteman_1ig_2")
							TaskPlayAnim(Ped, "missminuteman_1ig_2", "handsup_base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)

							Citizen.CreateThread(function()
								Citizen.Wait(3 * 60 * 1000)

								if Bank.PedHoldUp then
									Bank.PedHoldUp = false
									for _,Ped in pairs(Bank.Peds) do
										ClearPedTasksImmediately(Ped)
									end
								end

								ClearPedTasksImmediately(Ped)
							end)
							break
						end
					end
				end
			end
		end

		Citizen.Wait(2000)
	end
end)