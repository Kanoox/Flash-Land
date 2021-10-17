Citizen.CreateThread(function()
	RequestIpl("gabz_import_milo_")
	interiorID = GetInteriorAtCoords(941.0, -972.6, 39.1)
	if IsValidInterior(interiorID) then
		--EnableInteriorProp(interiorID, "basic_style_set")
		--EnableInteriorProp(interiorID, "urban_style_set")
		EnableInteriorProp(interiorID, "branded_style_set")
		EnableInteriorProp(interiorID, "car_floor_hatch")
		RefreshInterior(interiorID)
	end
end)
