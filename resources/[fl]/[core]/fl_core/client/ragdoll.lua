local isInRagdoll = false

RegisterCommand('+ragdoll', function()
  isInRagdoll = not isInRagdoll
  GoRagdoll()
end, false)

RegisterCommand('-ragdoll', function()
end, false)

function GoRagdoll()
  while isInRagdoll do
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
      Citizen.Wait(100)
  end
end