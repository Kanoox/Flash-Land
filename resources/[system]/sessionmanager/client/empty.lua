--This empty file causes the scheduler.lua to load clientside
--scheduler.lua when loaded inside the sessionmanager resource currently manages remote callbacks.
--Without this, callbacks will only work server->client and not client->server.

AddEventHandler("esx:onPlayerSpawn", function(spawn)
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)
end)