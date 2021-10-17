local CurrentActionData = {}
local lastTime = 0

-- Use Brolly
RegisterNetEvent('fl_useitem:brolly')
AddEventHandler('fl_useitem:brolly', function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 57005)

    RequestAnimDict('amb@code_human_wander_drinking@beer@male@base')

    while not HasAnimDictLoaded('amb@code_human_wander_drinking@beer@male@base') do
      Citizen.Wait(1)
    end

    ESX.Game.SpawnObject('p_amb_brolly_01', {
      x = coords.x,
      y = coords.y,
      z = coords.z + 2
    }, function(object)

      Citizen.CreateThread(function()

        AttachEntityToEntity(object, playerPed, boneIndex, 0.10, 0, -0.001, 80.0, 150.0, 200.0, true, true, false, true, 1, true)
        TaskPlayAnim(playerPed, "amb@code_human_wander_drinking@beer@male@base", "static", 3.5, -8, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(30000)
        DeleteObject(object)
        ClearPedSecondaryTask(playerPed)

      end)
    end)
  end)
end)

-- Use ROSE
RegisterNetEvent('fl_useitem:rose')
AddEventHandler('fl_useitem:rose', function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 57005)

    RequestAnimDict('amb@code_human_wander_drinking@beer@male@base')

    while not HasAnimDictLoaded('amb@code_human_wander_drinking@beer@male@base') do
      Citizen.Wait(1)
    end

    ESX.Game.SpawnObject('p_single_rose_s', {
      x = coords.x,
      y = coords.y,
      z = coords.z + 2
    }, function(object)

    Citizen.CreateThread(function()

      AttachEntityToEntity(object, playerPed, boneIndex, 0.10, 0, -0.001, 80.0, 150.0, 200.0, true, true, false, true, 1, true)
      TaskPlayAnim(playerPed, "amb@code_human_wander_drinking@beer@male@base", "static", 3.5, -8, -1, 49, 0, 0, 0, 0)
      Citizen.Wait(30000)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)

     end)
    end)
  end)
end)

--USE BONG
RegisterNetEvent('fl_useitem:bong')
AddEventHandler('fl_useitem:bong', function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

    RequestAnimDict('anim@safehouse@bong')
    while not HasAnimDictLoaded('anim@safehouse@bong') do
      Citizen.Wait(1)
    end

    ESX.Game.SpawnObject('hei_heist_sh_bong_01', {
      x = coords.x,
      y = coords.y,
      z = coords.z - 3
    }, function(object)

      ESX.Game.SpawnObject('p_cs_lighter_01', {
        x = coords.x,
        y = coords.y,
        z = coords.z - 3
      }, function(object2)

      Citizen.CreateThread(function()

        TaskPlayAnim(playerPed, "anim@safehouse@bong", "bong_stage1", 3.5, -8, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(1500)
        AttachEntityToEntity(object2, playerPed, boneIndex2, 0.10, 0.0, 0, 99.0, 192.0, 180.0, true, true, false, true, 1, true)
        AttachEntityToEntity(object, playerPed, boneIndex, 0.10, -0.25, 0, 95.0, 190.0, 180.0, true, true, false, true, 1, true)
        Citizen.Wait(6000)
        DeleteObject(object)
        DeleteObject(object2)
        ClearPedSecondaryTask(playerPed)
        TriggerServerEvent('fl_useitem:bong')
        end)
      end)
    end)
  end)
end)

-- OUTFIT SWIM
RegisterNetEvent('fl_useitem:swim')
AddEventHandler('fl_useitem:swim', function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 12844)
    local boneIndex2 = GetPedBoneIndex(playerPed, 24818)

    if GetEntityModel(PlayerPedId()) == 16852336050 then
      SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 4, 94, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 5, 67, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 11, 243, 0, 0)
    elseif GetEntityModel(PlayerPedId()) == 1667301415 then
      SetPedComponentVariation(PlayerPedId(), 3, 7, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 4, 102, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 6, 70, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 0)
      SetPedComponentVariation(PlayerPedId(), 11, 262, 0, 0)
    end

    ESX.Game.SpawnObject('p_s_scuba_mask_s', {
      x = coords.x,
      y = coords.y,
      z = coords.z - 3
    }, function(object)

      ESX.Game.SpawnObject('p_s_scuba_tank_s', {
        x = coords.x,
        y = coords.y,
        z = coords.z - 3
      }, function(object2)

        Citizen.CreateThread(function()
          AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
          AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
          SetPedDiesInWater(playerPed, false)
          ESX.ShowNotification('~g~Bouteille ~s~: 100%')
          ESX.ShowNotification('~g~Allez vous baigner')
          Citizen.Wait(45000)
          ESX.ShowNotification('~y~Bouteille ~s~: 50%')
          Citizen.Wait(45000)
          ESX.ShowNotification('~o~Bouteille ~s~: 10%')
          Citizen.Wait(30000)
          ESX.ShowNotification('~r~Bouteille ~s~: 0%')
          SetPedDiesInWater(playerPed, true)
          DeleteObject(object)
          DeleteObject(object2)
          ClearPedSecondaryTask(playerPed)
        end)
      end)
    end)
  end)
end)

-- Use Tatgun
RegisterNetEvent('fl_useitem:tatgun')
AddEventHandler('fl_useitem:tatgun', function()

local playerPed = PlayerPedId()
local coords = GetEntityCoords(playerPed)

Citizen.CreateThread(function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)
  local boneIndex = GetPedBoneIndex(playerPed, 11816)
  local boneIndex2 = GetPedBoneIndex(playerPed, 6286)

  RequestAnimDict('random@shop_tattoo')
  while not HasAnimDictLoaded('random@shop_tattoo') do
    Citizen.Wait(1)
  end

    ESX.Game.SpawnObject('v_ilev_ta_tatgun', {
      x = coords.x,
      y = coords.y,
      z = coords.z + 2
    }, function(object2)

      Citizen.CreateThread(function()

        AttachEntityToEntity(object2, playerPed, boneIndex2, 0.09, 0.11, 0.01, -75.0, -90.0, -140.0, true, true, false, true, 1, true)
        TaskPlayAnim(PlayerPedId(), "random@shop_tattoo", "artist_artist_finishes_up_his_tattoo" ,3.5, -8, -1, 49, 0,false, false, false)
        Citizen.Wait(13000)
        DeleteObject(object)
        DeleteObject(object2)
        ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

-- Use notepad
RegisterNetEvent('fl_useitem:notepad')
AddEventHandler('fl_useitem:notepad', function()

local playerPed = PlayerPedId()
local coords = GetEntityCoords(playerPed)

Citizen.CreateThread(function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)
  local boneIndex = GetPedBoneIndex(playerPed, 36029)

  RequestAnimDict('amb@world_human_clipboard@male@idle_b')
  while not HasAnimDictLoaded('amb@world_human_clipboard@male@idle_b') do
    Citizen.Wait(1)
  end

    ESX.Game.SpawnObject('prop_notepad_01', {
      x = coords.x,
      y = coords.y,
      z = coords.z + 2
    }, function(object)

      Citizen.CreateThread(function()

        AttachEntityToEntity(object, playerPed, boneIndex, 0.10, 0.08, 0.07, 155.0, 120.0, -180.0, true, true, false, true, 1, true)
        TaskPlayAnim(PlayerPedId(), "amb@world_human_clipboard@male@idle_b", "idle_d" ,3.5, -8, -1, 49, 0,false, false, false )
        Citizen.Wait(25000)
        DeleteObject(object)
        ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

-- KIT PIC
RegisterNetEvent('fl_useitem:kitpic')
AddEventHandler('fl_useitem:kitpic', function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

  ESX.Game.SpawnObject('prop_yoga_mat_02',  {
    x = coords.x,
    y = coords.y,
    z = coords.z -1
  }, function(object)
  end)

  ESX.Game.SpawnObject('prop_yoga_mat_02',  {
    x = coords.x ,
    y = coords.y -0.9,
    z = coords.z -1
  }, function(object)
  end)

  ESX.Game.SpawnObject('prop_yoga_mat_02',  {
    x = coords.x ,
    y = coords.y +0.9,
    z = coords.z -1
  }, function(object)
  end)

  ESX.Game.SpawnObject('prop_champset',  {
    x = coords.x ,
    y = coords.y ,
    z = coords.z -1
  }, function(object)
  end)

  ESX.Game.SpawnObject('prop_beach_fire',  {
    x = coords.x +1.3,
    y = coords.y ,
    z = coords.z -1.6
  }, function(object)
  end)
end)

-----------------------------------------------------------------------------------------------
----------------------------------------- Bulletproof -----------------------------------------
-----------------------------------------------------------------------------------------------
RegisterCommand('pedcomponent', function(argN, args)
  SetPedComponentVariation(PlayerPedId(), 9, tonumber(args[1]), 1, 2) --Gilet
end)

--- Bullet1
RegisterNetEvent('fl_useitem:bullet1')
  AddEventHandler('fl_useitem:bullet1', function()
    local playerPed = PlayerPedId()
      SetPedArmour(playerPed, 50)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)

    ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function()
      SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 2) --Gilet
    end)
end)

--- Bullet2
RegisterNetEvent('fl_useitem:bullet2')
  AddEventHandler('fl_useitem:bullet2', function()

    local playerPed = PlayerPedId()
      SetPedArmour(playerPed, 75)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)

    ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function()
      SetPedComponentVariation(PlayerPedId(), 9, 4, 9, 2) --Gilet
    end)
end)

--- Bullet3
RegisterNetEvent('fl_useitem:bullet3')
  AddEventHandler('fl_useitem:bullet3', function()

    local playerPed = PlayerPedId()
      SetPedArmour(playerPed, 100)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)

    ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function()
      SetPedComponentVariation(PlayerPedId(), 9, 9, 1, 2) --Gilet
    end)
end)

--- Bullet4
RegisterNetEvent('fl_useitem:bullet4')
  AddEventHandler('fl_useitem:bullet4', function()

    local playerPed = PlayerPedId()
      SetPedArmour(playerPed, 200)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)

    ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function()
      SetPedComponentVariation(PlayerPedId(), 9, 16, 9, 2) --Gilet
    end)
end)

-- BALL XXL
RegisterNetEvent('fl_useitem:ball')
AddEventHandler('fl_useitem:ball', function()

  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

  ESX.Game.SpawnObject('prop_beach_volball01',  {
    x = coords.x +1.5,
    y = coords.y +1.5,
    z = coords.z -1
  }, function(object)
  end)
end)

local nightvision = false
-- NightVision
RegisterNetEvent('fl_useitem:nightvision')
AddEventHandler('fl_useitem:nightvision', function()
  if not nightvision then
    SetPedComponentVariation(PlayerPedId(), 1, 132, 21, 2)
    SetNightvision(true)
    nightvision = true
  else
    SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
    SetNightvision(false)
    nightvision = false
  end
end)

-- Tenus Hasmat
-- Noir
RegisterNetEvent('fl_objects:settenuehaz1')
AddEventHandler('fl_objects:settenuehaz1', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

      if skin.sex == 0 then
       local clothesSkin = {
        ['tshirt_1'] = 62, ['tshirt_2'] = 1,
        ['torso_1'] = 67, ['torso_2'] = 1,
        ['decals_1'] = 0,  ['decals_2'] = 0,
        ['mask_1'] = 46, ['mask_2'] = 0,
        ['arms'] = 38,
        ['pants_1'] = 40, ['pants_2'] = 1,
        ['shoes_1'] = 25, ['shoes_2'] = 0,
        ['helmet_1'] = -1, ['helmet_2'] = 0,
        ['bags_1'] = 44, ['bags_2'] = 0,
        ['bproof_1'] = 0,  ['bproof_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      else
        local clothesSkin = {
        ['tshirt_1'] = 43, ['tshirt_2'] = 1,
        ['torso_1'] = 61, ['torso_2'] = 1,
        ['decals_1'] = 0,  ['decals_2'] = 0,
        ['mask_1'] = 46, ['mask_2'] = 0,
        ['arms'] = 101,
        ['pants_1'] = 40, ['pants_2'] = 1,
        ['shoes_1'] = 25, ['shoes_2'] = 0,
        ['helmet_1'] = -1, ['helmet_2'] = 0,
        ['bags_1'] = 44, ['bags_2'] = 0,
        ['bproof_1'] = 0,  ['bproof_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
      end
      local playerPed = PlayerPedId()
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

--Tenue Hazmat Bleu
RegisterNetEvent('fl_objects:settenuehaz2')
AddEventHandler('fl_objects:settenuehaz2', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1'] = 62, ['tshirt_2'] = 3,
                ['torso_1'] = 67, ['torso_2'] = 3,
                ['decals_1'] = 0,  ['decals_2'] = 0,
                ['mask_1'] = 46, ['mask_2'] = 0,
                ['arms'] = 38,
                ['pants_1'] = 40, ['pants_2'] = 3,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 44, ['bags_2'] = 0,
                ['bproof_1'] = 0,  ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['tshirt_1'] = 43, ['tshirt_2'] = 3,
                ['torso_1'] = 61, ['torso_2'] = 3,
                ['decals_1'] = 0,  ['decals_2'] = 0,
                ['mask_1'] = 46, ['mask_2'] = 0,
                ['arms'] = 101,
                ['pants_1'] = 40, ['pants_2'] = 3,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 44, ['bags_2'] = 0,
                ['bproof_1'] = 0,  ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

-- Jaune
RegisterNetEvent('fl_objects:settenuehaz3')
AddEventHandler('fl_objects:settenuehaz3', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1'] = 62, ['tshirt_2'] = 2,
                ['torso_1'] = 67, ['torso_2'] = 2,
                ['decals_1'] = 0,  ['decals_2'] = 0,
                ['mask_1'] = 46, ['mask_2'] = 0,
                ['arms'] = 38,
                ['pants_1'] = 40, ['pants_2'] = 2,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 44, ['bags_2'] = 0,
                ['bproof_1'] = 0,  ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['tshirt_1'] = 43, ['tshirt_2'] = 2,
                ['torso_1'] = 61, ['torso_2'] = 2,
                ['decals_1'] = 0,  ['decals_2'] = 0,
                ['mask_1'] = 46, ['mask_2'] = 0,
                ['arms'] = 101,
                ['pants_1'] = 40, ['pants_2'] = 2,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 44, ['bags_2'] = 0,
                ['bproof_1'] = 0,  ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu  = not UseTenu
end)

-- Blanche
RegisterNetEvent('fl_objects:settenuehaz4')
AddEventHandler('fl_objects:settenuehaz4', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1'] = 62, ['tshirt_2'] = 0,
                ['torso_1'] = 67, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 46, ['mask_2'] = 0,
                ['arms'] = 38,
                ['pants_1'] = 40, ['pants_2'] = 0,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 44, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['tshirt_1'] = 43, ['tshirt_2'] = 0,
                ['torso_1'] = 61, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 46, ['mask_2'] = 0,
                ['arms'] = 101,
                ['pants_1'] = 40, ['pants_2'] = 0,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 44, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

-- Casa Papel
RegisterNetEvent('fl_objects:settenuecasa')
AddEventHandler('fl_objects:settenuecasa', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1']  = 130, ['tshirt_2'] = 0,
                ['torso_1'] = 221, ['torso_2'] = 3,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['arms'] = 96,
                ['pants_1'] = 87, ['pants_2'] = 3,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['tshirt_1'] = 160, ['tshirt_2'] = 0,
                ['torso_1'] = 231, ['torso_2'] = 3,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['arms'] = 111,
                ['pants_1'] = 90, ['pants_2'] = 3,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        SetPedArmour(playerPed, 100)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

--Tenue Karting
RegisterNetEvent('fl_objects:settenuekarting1')
AddEventHandler('fl_objects:settenuekarting1', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1'] = 130, ['tshirt_2'] = 0,
                ['torso_1'] = 221,['torso_2'] = 3,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['arms'] = 96,
                ['pants_1'] = 87, ['pants_2'] = 3,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2']  = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['tshirt_1'] = 34, ['tshirt_2'] = 0,
                ['torso_1'] = 144,['torso_2'] = 9,
                ['decals_1'] = 0,  ['decals_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['arms'] = 36,
                ['pants_1'] = 68, ['pants_2'] = 9,
                ['shoes_1'] = 47, ['shoes_2'] = 9,
                ['helmet_1'] = 71, ['helmet_2'] = 3,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2']  = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        --SetPedArmour(playerPed, 100)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

--Tenue Militaire
RegisterNetEvent('fl_objects:settenuemilitaire')
AddEventHandler('fl_objects:settenuemilitaire', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 221,['torso_2'] = 3,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['arms'] = 1,
                ['pants_1'] = 87, ['pants_2'] = 3,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                ['torso_1'] = 231,['torso_2'] = 3,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['arms'] = 1,
                ['pants_1'] = 90, ['pants_2'] = 3,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        --SetPedArmour(playerPed, 100)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

--Tenue Parachute
RegisterNetEvent('fl_objects:settenueskydivingcl')
AddEventHandler('fl_objects:settenueskydivingcl', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1'] = 15, ['tshirt_2'] = 1,
                ['torso_1'] = 148,['torso_2'] = 1,
                ['decals_1'] = 0, ['decals_2']  = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['arms'] = 17,
                ['pants_1'] = 67, ['pants_2'] = 3,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['glasses_1'] = 25, ['glasses_2']  = 0,
                ['bags_1'] = 31, ['bags_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                ['torso_1'] = 145,['torso_2'] = 1,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['mask_1'] = 0,  ['mask_2'] = 0,
                ['arms'] = 42,
                ['pants_1'] = 69, ['pants_2'] = 1,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['helmet_1'] = 19, ['helmet_2'] = 0,
                ['glasses_1'] = 27, ['glasses_2'] = 0,
                ['bags_1'] = 52, ['bags_2'] = 9,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        --SetPedArmour(playerPed, 100)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

--Tenue Jailer
RegisterNetEvent('fl_objects:settenuejailer')
AddEventHandler('fl_objects:settenuejailer', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

				if skin.sex == 0 then

					local clothesSkin = {
						['tshirt_1'] = 15, ['tshirt_2'] = 0,
						['torso_1'] = 146, ['torso_2'] = 0,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 0,
						['pants_1'] = 3, ['pants_2'] = 7,
						['shoes_1'] = 12, ['shoes_2'] = 12,
						['chain_1'] = 0, ['chain_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

				else

					local clothesSkin = {
						['tshirt_1'] = 3, ['tshirt_2'] = 0,
						['torso_1'] = 38, ['torso_2'] = 3,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 2,
						['pants_1'] = 3, ['pants_2'] = 15,
						['shoes_1'] = 66, ['shoes_2'] = 5,
						['chain_1'] = 0, ['chain_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

				end

				local playerPed = PlayerPedId()
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
				ResetPedMovementClipset(playerPed, 0)
			end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)


-- Badge LSPD
RegisterNetEvent('fl_objects:setbadgefbi')
AddEventHandler('fl_objects:setbadgefbi', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['chain_1'] = 125, ['chain_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['chain_1'] = 95, ['chain_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)

-- Masque Covid
RegisterNetEvent('fl_objects:setcovid')
AddEventHandler('fl_objects:setcovid', function()
  if UseTenu then

    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            local clothesSkin = {
                ['chain_1'] = 5, ['chain_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
                ['chain_1'] = 5, ['chain_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end
          local playerPed = PlayerPedId()
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
  else

    TriggerEvent('skinchanger:getSkin', function(skin)

      ESX.TriggerServerCallback('fl_skin:getPlayerSkin', function(skin, hasSkin)

        if hasSkin then

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end
      end)
    end)
  end
  UseTenu = not UseTenu
end)