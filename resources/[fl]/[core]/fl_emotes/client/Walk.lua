function WalkMenuStart(name)
  RequestWalking(name)
  SetPedMovementClipset(PlayerPedId(), name, 0.2)
  RemoveAnimSet(name)
  SetResourceKvp('dpemotes:lastWalk', name)
end

function RequestWalking(set)
  if set == 'Reset' or set == 'reset' then return end
  ESX.Streaming.RequestAnimSet(set)
end

function WalksOnCommand(source, args, raw)
  local WalksCommand = ""
  for a in pairsByKeys(DP.Walks) do
    WalksCommand = WalksCommand .. ""..string.lower(a)..", "
  end
  EmoteChatMessage(WalksCommand)
  EmoteChatMessage("To reset do /walk reset")
end

function WalkCommandStart(source, args, raw)
  local name = firstToUpper(args[1])

  if name == "Reset" then
      DeleteResourceKvp('dpemotes:lastWalk')
      ResetPedMovementClipset(PlayerPedId()) return
  end

  local name2 = table.unpack(DP.Walks[name])
  if name2 ~= nil then
    WalkMenuStart(name2)
  else
    EmoteChatMessage("'"..name.."' is not a valid walk")
  end
end

Citizen.CreateThread(function()
  while not NetworkIsSessionStarted() do Citizen.Wait(0) print('aa') end
  local lastWalk = GetResourceKvpString('dpemotes:lastWalk')

  if not lastWalk or lastWalk == nil then lastWalk = 'Reset' end
  WalkMenuStart(lastWalk)

  local lastMood = GetResourceKvpString('dpemotes:lastMood')
  if lastMood ~= nil then
    EmoteMenuStart(lastMood, "expression")
  end
end)