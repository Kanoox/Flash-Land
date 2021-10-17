local TeleportFromTo = {
	["HDellPero"] = {
		positionFrom = vector3(-1268.05, -811.96, 17.15), nomFrom = "monter",
		positionTo = vector3(-1226.41, -838.46, 29.43), nomTo = "descendre",
	},

	["Mont Chiliad - Telecabine"] = {
		positionFrom = vector3(-741.738, 5595.22, 41.6546), nomFrom = "entrer - Cabine",
		positionTo = vector3(446.051, 5572.32, 781.189), nomTo = "sortir - Cabine",
	},

	["Gouvernement"] = {
		positionFrom = vector3(2476.1, -384.0, 94.4), nomFrom = "entrer",
		positionTo = vector3(136.2, -761.7, 242.200), nomTo = "sortir",
	},

	["Weed"] = {
		hide = true,
		positionFrom = vector3(465.83, -735.37, 27.36), nomFrom = "entrer",
		positionTo = vector3(1066.14, -3183.49, -39.16), nomTo = "sortir",
	},

	["Coke"] = {
		hide = true,
		positionFrom = vector3(94.23, -2694.27, 6.0), nomFrom = "entrer",
		positionTo = vector3(1088.56, -3187.46, -38.99), nomTo = "sortir",
	},

	["Meth"] = {
		hide = true,
		positionFrom = vector3(448.77, -2761.31, 7.10), nomFrom = "entrer",
		positionTo = vector3(996.98, -3200.69, -36.39), nomTo = "sortir",
	},

	["Hopital"] = {
		positionFrom = vector3(339.32, -584.20, 74.16), nomFrom = "descendre",
		positionTo = vector3(331.62, -595.38, 43.28), nomTo = "monter sur le toit",
	},

--	["Bahamas"] = {
--		positionFrom = vector3(-1391.03, -597.91, 30.34), nomFrom = "passer derrière le bar",
--		positionTo = vector3(-1390.56, -600.32, 30.34), nomTo = "retourner devant le bar",
--	},

	["MappingWeazelNewsTpHelico"] = {
		positionFrom = vector3(-590.92, -921.21, 23.93), nomFrom = "montrer sur le toit",
		positionTo = vector3(-569.47, -927.66, 36.93), nomTo = "descendre",
	},

	["GalaxyTp"] = {
		positionFrom = vector3(345.32, 289.26, 95.8), nomFrom = "passer derrière",
		positionTo = vector3(347.07, 285.79, 95.8), nomTo = "retourner devant",
		size = 0.4,
	},

	["HopitalEntrerMorgue"] = {
		positionFrom = vector3(294.7, -1448.1, 30.0), nomFrom = "sortir",
		positionTo = vector3(275.3, -1361, 24.6), nomTo = "entrer",
	},

	["HopitalAscenseurMorgue"] = {
		positionFrom = vector3(247.3, -1371.5, 24.7), nomFrom = "sortir",
		positionTo = vector3(335.5, -1432.0, 46.7), nomTo = "monter",
	},

	["Hopital3"] = {
		positionFrom = vector3(329.90, -601.09, 43.28), nomFrom = "descendre au garage",
		positionTo = vector3(339.69, -584.41, 28.80), nomTo = "monter",
	},

--	["AgenceImmo"] = {
--		positionFrom = vector3(-140.99, -615.24, 168.82), nomFrom = "descendre",
--		positionTo = vector3(-1382.57, -500.55, 33.16), nomTo = "monter",
--	},

 --CASINO

 --["CasinoEntrance"] = {
--	positionFrom = vector3(935.46, 46.69, 81.12), nomFrom = "entrer",
--	positionTo = vector3(2468.93, -287.17, -58.27), nomTo = "sortir",
--	size = 3,
--},

["PentHouseTerrasseFromCasino"] = {
	positionFrom = vector3(964.6, 58.82, 112.57), nomFrom = "descendre dans le casino",
	positionTo = vector3(922.93, 52.25, 72.07), nomTo = "monter à la terrasse",
},

["CasinoPoubelle"] = {
	positionFrom = vector3(993.17, 76.39, 81.1), nomFrom = "entrer dans le local poubelle",
	positionTo = vector3(2540.96, -208.25, -58.72), nomTo = "sortir",
},

["CasinoClub"] = {
	positionFrom = vector3(987.44, 79.58, 81.1), nomFrom = "entrer dans le club",
	positionTo = vector3(1578.39, 253.41, -45.8), nomTo = "sortir",
},

["CasinoLoadingBay"] = {
	positionFrom = vector4(1000.01, -56.27, 74.96, 112.71), nomFrom = "entrer dans le tunnel",
	positionTo = vector4(2650.07, -339.27, -64.72, 45.69), nomTo = "sortir",
	size = 3.0,
},

["CasinoTunnelBraco"] = {
	positionFrom = vector3(891.02, -174.97, 22.95), nomFrom = "rentrer dans le tunnel",
	positionTo = vector4(2517.28, -326.99, -70.65, 73.4), nomTo = "sortir du tunnel",
	hide = true,
},

["CasinoTunnelDestroyedWall"] = {
	positionFrom = vector3(2479.89, -291.89, -70.17), nomFrom = "passer par le trou",
	positionTo = vector3(2479.66, -290.14, -70.43), nomTo = "passer par le trou",
	size = 0.5,
},

["CasinoSecu"] = {
	positionFrom = vector3(978.06, 18.9, 80.99), nomFrom = "entrer",
	positionTo = vector4(2551.49, -269.46, -58.72, 97.24), nomTo = "sortir",
},


}

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(PlayerPedId(), true)

		for _, j in pairs(TeleportFromTo) do
			j.distanceFrom = #(pos - vector3(j.positionFrom.x, j.positionFrom.y, j.positionFrom.z))
			j.distanceTo = #(pos - vector3(j.positionTo.x, j.positionTo.y, j.positionTo.z))
			if j.size == nil then
				j.size = 1.0
			end
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local sleep = true

		for _, j in pairs(TeleportFromTo) do
			if j.distanceFrom and j.distanceFrom < 20.0 then
				sleep = false
				if not j.hide then
					DrawMarker(23, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1.0, 0, 0, 0, 0, 0, 0, j.size*0.8, j.size*0.8, 1.0, 255, 255, 255, 255, 0, 0, 0, 0)
				end
				if j.distanceFrom < j.size then
					ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour '.. j.nomFrom)
					if IsControlJustPressed(1, 38) then
						local x,y,z,w = table.unpack(j.positionTo)
						local entityToTeleport = PlayerPedId()
						if j.size > 2.5 and IsPedInAnyVehicle(PlayerPedId(), 1) then
							entityToTeleport = GetVehiclePedIsIn(PlayerPedId(), 0)
						end
						ESX.Game.Teleport(entityToTeleport, vector3(x, y, z - 1))
						if w then
							SetEntityHeading(entityToTeleport, w)
						end
					end
				end
			end

			if j.distanceTo and j.distanceTo < 20.0 then
				sleep = false
				DrawMarker(23, j.positionTo.x, j.positionTo.y, j.positionTo.z - 1.0, 0, 0, 0, 0, 0, 0, j.size*0.8, j.size*0.8, 1.0, 255, 255, 255, 255, 0, 0, 0, 0)

				if j.distanceTo < j.size then
					ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour '.. j.nomTo)
					if IsControlJustPressed(1, 38) then
						local x,y,z,w = table.unpack(j.positionFrom)
						local entityToTeleport = PlayerPedId()
						if j.size > 2.5 and IsPedInAnyVehicle(PlayerPedId(), 1) then
							entityToTeleport = GetVehiclePedIsIn(PlayerPedId(), 0)
						end
						ESX.Game.Teleport(entityToTeleport, vector3(x, y, z - 1))
						if w then
							SetEntityHeading(entityToTeleport, w)
						end
					end
				end
			end
		end

		if sleep then
			Citizen.Wait(500)
		end
	end
end)