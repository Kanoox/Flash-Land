Citizen.CreateThread(function()
	Citizen.Wait(1)
	for _,particle in pairs(config.particles) do

		RequestNamedPtfxAsset(particle.dict)
		while not HasNamedPtfxAssetLoaded(particle.dict) do
			Citizen.Wait(1)
		end

		UseParticleFxAssetNextCall(particle.dict)
		StartParticleFxLoopedAtCoord(particle.name, particle.coords.x, particle.coords.y, particle.coords.z, 0.0, 0.0, 0.0, particle.scale, false, false, false, 0)

	end
end)