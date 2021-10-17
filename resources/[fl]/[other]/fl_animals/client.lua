local ped = nil
local model, object, animation = {}, {}, {}
local status = 100
local objCoords
local come = 0
local isAnimalAttached, getball, inanimation, balle = false ,false, false, false

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	ESX.Streaming.RequestModel('a_c_rottweiler') -- chien
	ESX.Streaming.RequestModel('a_c_cat_01') -- chat
	ESX.Streaming.RequestModel('a_c_coyote') -- loup
	ESX.Streaming.RequestModel('a_c_rabbit_01') -- lapin
	ESX.Streaming.RequestModel('a_c_husky') -- husky
	ESX.Streaming.RequestModel('a_c_pig') -- cochon
	ESX.Streaming.RequestModel('a_c_poodle') -- caniche
	ESX.Streaming.RequestModel('a_c_pug') -- carlin
	ESX.Streaming.RequestModel('a_c_retriever') -- labrador
	ESX.Streaming.RequestModel('a_c_shepherd') -- berger
	ESX.Streaming.RequestModel('a_c_panther') -- panther
	ESX.Streaming.RequestModel('a_c_westy') -- westie
	ESX.Streaming.RequestModel('a_c_mtlion') -- cougar
end)

AddEventHandler('fl_animals:openPetMenu', function()
	local elements = {}
	if come == 1 then
		table.insert(elements, {label = _U('hunger', status), value = nil})
		table.insert(elements, {label = _U('givefood'), value = 'graille'})
		table.insert(elements, {label = _U('attachpet'), value = 'AttachAnimal_animal'})

		if isInVehicle then
			table.insert(elements, {label = _U('getpeddown'), value = 'vehicle'})
		else
			table.insert(elements, {label = _U('getpedinside'), value = 'vehicle'})
		end

		table.insert(elements, {label = _U('giveorders'), value = 'give_orders'})

	else
		table.insert(elements, {label = _U('callpet'), value = 'come_animal'})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'pet_menu', {
		title = 'Interaction',
		description = _U('pet_management'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'come_animal' and come == 0 then
			ESX.TriggerServerCallback('fl_animals:getPet', function(pet)
				if pet == '' then
					ESX.ShowNotification('~r~Vous n\'avez pas d\'animal !')
				elseif pet == 'chien' then
					model = `a_c_rottweiler`
					come = 1
					CallAnimal()
				elseif pet == 'chat' then
					model = `a_c_cat_01`
					come = 1
					CallAnimal()
				elseif pet == 'loup' then
					model = `a_c_coyote`
					come = 1
					CallAnimal()
				elseif pet == 'lapin' then
					model = `a_c_rabbit_01`
					come = 1
					CallAnimal()
				elseif pet == 'husky' then
					model = `a_c_husky`
					come = 1
					CallAnimal()
				elseif pet == 'caniche' then
					model = `a_c_poodle`
					come = 1
					CallAnimal()
				elseif pet == 'carlin' then
					model = `a_c_pug`
					come = 1
					CallAnimal()
				elseif pet == 'labrador' then
					model = `a_c_retriever`
					come = 1
					CallAnimal()
				elseif pet == 'berger' then
					model = `a_c_shepherd`
					come = 1
					CallAnimal()
				elseif pet == 'westie' then
					model = `a_c_westy`
					come = 1
					CallAnimal()
				elseif pet == 'panther' then
					model = `a_c_panther`
					come = 1
					CallAnimal()
				elseif pet == 'cougar' then
					model = `a_c_mtlion`
					come = 1
					CallAnimal()
				else
					ESX.ShowNotification('~r~Animal inconnu ...')
					print('fl_animals: unknown pet ' .. pet)
				end
			end)
			menu.close()
		elseif data.current.value == 'AttachAnimal_animal' then
			if not IsPedSittingInAnyVehicle(ped) then
				if isAnimalAttached == false then
					AttachAnimal()
					isAnimalAttached = true
				else
					DetachAnimal()
					isAnimalAttached = false
				end
				else
				ESX.ShowNotification(_U('dontattachhiminacar'))
			end
		elseif data.current.value == 'give_orders' then
			GivePetOrders()
		elseif data.current.value == 'graille' then
			local inventory = ESX.GetPlayerData().inventory
			local coords1 = GetEntityCoords(PlayerPedId())
			local coords2 = GetEntityCoords(ped)
			local distance = #(coords1 - coords2)

			local count = 0
			for i=1, #inventory, 1 do
				if inventory[i].name == 'croquettes' then
					count = inventory[i].count
				end
			end
			if distance < 5 then
				if count >= 1 then
					if status < 100 then
						status = status + math.random(2, 15)
						ESX.ShowNotification(_U('gavepetfood'))
						TriggerServerEvent('fl_animals:consumePetFood')
						if status > 100 then
							status = 100
						end
						menu.close()
					else
						ESX.ShowNotification(_U('nomorehunger'))
					end
				else
					ESX.ShowNotification(_U('donthavefood'))
				end
			else
				ESX.ShowNotification(_U('hestoofar'))
			end
		elseif data.current.value == 'vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(playerPed)
			local coords = GetEntityCoords(playerPed)
			local distance = #(coords - GetEntityCoords(ped))

			if not isInVehicle then
				if IsPedSittingInAnyVehicle(playerPed) then
					if distance < 8 then
						AttachAnimal()
						Citizen.Wait(200)
						if IsVehicleSeatFree(vehicle, 1) then
							SetPedIntoVehicle(ped, vehicle, 1)
							isInVehicle = true
						elseif IsVehicleSeatFree(vehicle, 2) then
							isInVehicle = true
							SetPedIntoVehicle(ped, vehicle, 2)
						elseif IsVehicleSeatFree(vehicle, 0) then
							isInVehicle = true
							SetPedIntoVehicle(ped, vehicle, 0)
						end

						menu.close()
					else
						ESX.ShowNotification(_U('toofarfromcar'))
					end

				else
					ESX.ShowNotification(_U('youneedtobeincar'))
				end
			else
				if not IsPedSittingInAnyVehicle(playerPed) then
					SetEntityCoords(ped, coords,1,0,0,1)
					Citizen.Wait(100)
					DetachAnimal()
					isInVehicle = false
					menu.close()
				else
					ESX.ShowNotification(_U('yourstillinacar'))
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

function GivePetOrders()
	ESX.TriggerServerCallback('fl_animals:getPet', function(pet)
		local elements = {}

		if not inanimation then
			if pet ~= 'chat' then
				table.insert(elements, {label = _U('balle'), value = 'balle'})
			end

			table.insert(elements, {label = 'Suis moi', value = 'follow'})
			table.insert(elements, {label = _U('pied'), value = 'pied'})
			table.insert(elements, {label = _U('doghouse'), value = 'return_doghouse'})

			if pet == 'chien' then
				table.insert(elements, {label = _U('sitdown'), value = 'assis'})
				table.insert(elements, {label = _U('getdown'), value = 'coucher'})
			elseif pet == 'chat' then
				table.insert(elements, {label = _U('getdown'), value = 'coucher2'})
			elseif pet == 'loup' then
				table.insert(elements, {label = _U('getdown'), value = 'coucher3'})
			elseif pet == 'carlin' then
				table.insert(elements, {label = _U('sitdown'), value = 'assis2'})
			elseif pet == 'labrador' then
				table.insert(elements, {label = _U('sitdown'), value = 'assis3'})
			end
		else
			table.insert(elements, {label = _U('getup'), value = 'debout'})
		end

		ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'give_orders', {
			title = _U('pet_orders'),
			elements = elements
		}, function(data, menu)
			if data.current.value == 'return_doghouse' then
				local GroupHandle = GetPlayerGroup(PlayerId())
				local coords = GetEntityCoords(PlayerPedId())

				ESX.ShowNotification(_U('doghouse_returning'))

				SetGroupSeparationRange(GroupHandle, 1.9)
				SetPedNeverLeavesGroup(ped, false)
				TaskGoToCoordAnyMeans(ped, coords.x + 40, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)

				Citizen.Wait(5000)
				DeleteEntity(ped)
				come = 0

				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'follow' then
				TaskFollowToOffsetOfEntity(ped, PlayerPedId(), 0.0, 0.0, 1.0, 1.0, 10.0, 1000.0, true)
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('Votre animal vous suis')
			elseif data.current.value == 'pied' then
				TaskGoToCoordAnyMeans(ped, GetEntityCoords(PlayerPedId()), 5.0, 0, 0, 786603, 0xbf800000)
				ESX.UI.Menu.CloseAll()
				ESX.ShowNotification('Votre animal va au pied')
			elseif data.current.value == 'balle' then
				local pedCoords = GetEntityCoords(ped)
				object = GetClosestObjectOfType(pedCoords, 190.0, `w_am_baseball`)

				if DoesEntityExist(object) then
					balle = true
					objCoords = GetEntityCoords(object)
					TaskGoToCoordAnyMeans(ped, objCoords, 5.0, 0, 0, 786603, 0xbf800000)
					local GroupHandle = GetPlayerGroup(PlayerId())
					SetGroupSeparationRange(GroupHandle, 1.9)
					SetPedNeverLeavesGroup(ped, false)
					ESX.ShowNotification('Votre animal va chercher la balle')
					ESX.UI.Menu.CloseAll()
				else
					ESX.ShowNotification(_U('noball'))
				end
			elseif data.current.value == 'assis' then -- chien
				ESX.Streaming.RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
				TaskPlayAnim(ped, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				menu.close()
			elseif data.current.value == 'coucher' then -- chien
				ESX.Streaming.RequestAnimDict('creatures@rottweiler@amb@sleep_in_kennel@')
				TaskPlayAnim(ped, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				ESX.ShowNotification('Votre animal va coucher !')
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'coucher2' then -- chat
				ESX.Streaming.RequestAnimDict('creatures@cat@amb@world_cat_sleeping_ground@idle_a')
				TaskPlayAnim(ped, 'creatures@cat@amb@world_cat_sleeping_ground@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				ESX.ShowNotification('Votre animal va coucher !')
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'coucher3' then -- loup
				ESX.Streaming.RequestAnimDict('creatures@coyote@amb@world_coyote_rest@idle_a')
				TaskPlayAnim(ped, 'creatures@coyote@amb@world_coyote_rest@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'assis2' then -- carlin
				ESX.Streaming.RequestAnimDict('creatures@carlin@amb@world_dog_sitting@idle_a')
				TaskPlayAnim(ped, 'creatures@carlin@amb@world_dog_sitting@idle_a', 'idle_b' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'assis3' then -- labrador
				ESX.Streaming.RequestAnimDict('creatures@retriever@amb@world_dog_sitting@idle_a')
				TaskPlayAnim(ped, 'creatures@retriever@amb@world_dog_sitting@idle_a', 'idle_c' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'assis4' then -- chien
				ESX.Streaming.RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@idle_a')
				TaskPlayAnim(ped, 'creatures@rottweiler@amb@world_dog_sitting@idle_a', 'idle_c' ,8.0, -8, -1, 1, 0, false, false, false)
				inanimation = true
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'debout' then
				ClearPedTasks(ped)
				inanimation = false
				ESX.ShowNotification('Votre animal se lève')
				ESX.UI.Menu.CloseAll()
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30)

		if balle then
			local coords1 = GetEntityCoords(PlayerPedId())
			local coords2 = GetEntityCoords(ped)
			local distance = #(objCoords - coords2)
			local distance2 = #(coords1 - coords2)

			if distance < 0.5 then
				local boneIndex = GetPedBoneIndex(ped, 17188)
				AttachEntityToEntity(object, ped, boneIndex, 0.120, 0.010, 0.010, 5.0, 150.0, 0.0, true, true, false, true, 1, true)
				TaskGoToCoordAnyMeans(ped, coords1, 5.0, 0, 0, 786603, 0xbf800000)
				balle = false
				getball = true
			end
		elseif getball then
			local coords1 = GetEntityCoords(PlayerPedId())
			local coords2 = GetEntityCoords(ped)
			local distance2 = #(coords1 - coords2)

			if distance2 < 1.5 then
				DetachEntity(object,false,false)
				Citizen.Wait(50)
				SetEntityAsMissionEntity(object)
				DeleteEntity(object)
				GiveWeaponToPed(PlayerPedId(), `WEAPON_BALL`, 1, false, true)
				local GroupHandle = GetPlayerGroup(PlayerId())
				SetGroupSeparationRange(GroupHandle, 999999.9)
				SetPedNeverLeavesGroup(ped, true)
				SetPedAsGroupMember(ped, GroupHandle)
				getball = false
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

function AttachAnimal()
	SetGroupSeparationRange(GetPlayerGroup(PlayerId()), 1.9)
	SetPedNeverLeavesGroup(ped, false)
	FreezeEntityPosition(ped, true)
end

function DetachAnimal()
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 999999.9)
	SetPedNeverLeavesGroup(ped, true)
	SetPedAsGroupMember(ped, GroupHandle)
	FreezeEntityPosition(ped, false)
end

function CallAnimal()
	local playerPed = PlayerPedId()
	local LastPosition = GetEntityCoords(playerPed)
	local GroupHandle = GetPlayerGroup(PlayerId())

	ESX.Streaming.RequestAnimDict('rcmnigel1c')

	TaskPlayAnim(playerPed, 'rcmnigel1c', 'hailing_whistle_waive_a' ,8.0, -8, -1, 120, 0, false, false, false)

	Citizen.SetTimeout(2000, function()
		ped = CreatePed(28, model, LastPosition.x +1, LastPosition.y +1, LastPosition.z -1, 1, 1)

		SetPedAsGroupLeader(playerPed, GroupHandle)
		SetPedAsGroupMember(ped, GroupHandle)
		SetPedNeverLeavesGroup(ped, true)
		SetPedCanBeTargetted(ped, false)
		SetEntityAsMissionEntity(ped, true,true)

		status = math.random(40, 90)
		Citizen.Wait(5)
		AttachAnimal()
		Citizen.Wait(5)
		DetachAnimal()

		if not DoesEntityExist(ped) then
			ESX.ShowNotification('~r~Votre animal semble ne pas vouloir sortir (bug...)')
			ped = nil
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random(60000, 120000))

		if come == 1 then
			status = status - 1
		end

		if status == 0 then
			TriggerServerEvent('fl_animals:petDied')
			DeleteEntity(ped)
			ESX.ShowNotification(_U('pet_dead'))
			come = 3
			status = "die"
		end
	end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.PetShop.Pos.x, Config.Zones.PetShop.Pos.y, Config.Zones.PetShop.Pos.z)

	SetBlipSprite(blip, Config.Zones.PetShop.Sprite)
	SetBlipDisplay(blip, Config.Zones.PetShop.Display)
	SetBlipScale(blip, Config.Zones.PetShop.Scale)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('pet_shop'))
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coord = GetEntityCoords(PlayerPedId())

		if #(coord - Config.Zones.PetShop.Pos) < 2 then
			ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour acceder a l\'animalerie.')

			if IsControlJustReleased(0, 38) then
				OpenPetShop()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenPetShop()
	local elements = {}

	for i=1, #Config.PetShop, 1 do
		table.insert(elements, {
			label = Config.PetShop[i].label,
			rightLabel = _U('shop_item', ESX.Math.GroupDigits(Config.PetShop[i].price)),
			rightLabelColor = {R = 0, G = 0, B = 200},
			pet = Config.PetShop[i].pet,
			price = Config.PetShop[i].price
		})
	end

	ESX.UI.Menu.Open('native', GetCurrentResourceName(), 'pet_shop', {
		title = _U('pet_shop'),
		elements = elements
	}, function(data, menu)
		ESX.TriggerServerCallback('fl_animals:buyPet', function(boughtPed)
			if boughtPed then
				menu.close()
			end
		end, data.current.pet)
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('onResourceStop', function (resourceName)
	if resourceName ~= GetCurrentResourceName() then return end
	if ped ~= nil then
		DeleteEntity(ped)
	end
end)