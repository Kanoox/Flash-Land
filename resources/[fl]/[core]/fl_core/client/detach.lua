RegisterCommand('detach', function()
	for _,AnyEntity in pairs(ESX.Game.GetObjects()) do
		if not IsEntityAPed(AnyEntity) and IsEntityAttachedToEntity(AnyEntity, PlayerPedId()) then
			DetachEntity(AnyEntity, 0, 1)
		end
	end
end, false)
