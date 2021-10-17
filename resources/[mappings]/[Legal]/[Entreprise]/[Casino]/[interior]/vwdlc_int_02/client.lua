Citizen.CreateThread(function()


RequestIpl("vw_casino_penthouse")
RequestIpl("vw_casino_main")
	interiorID = GetInteriorAtCoords(1100.00000000,220.00000000,-50.00000000)
	if IsValidInterior(interiorID) then
	EnableInteriorProp(interiorID, "0x30240D11")
	EnableInteriorProp(interiorID, "0xA3C89BB2")
	
		RefreshInterior(interiorID)
	end
	interiorID = GetInteriorAtCoords(976.63640000,70.294760000,115.16410000)
	if IsValidInterior(interiorID) then
	EnableInteriorProp(interiorID, "teste1")
	EnableInteriorProp(interiorID, "teste2")
	EnableInteriorProp(interiorID, "teste3")
	EnableInteriorProp(interiorID, "teste4")
	--EnableInteriorProp(interiorID, "teste5") --''portas fechadas""
	
	-- EnableInteriorProp(interiorID, "teste6") --''portas fechadas""
	
	-- EnableInteriorProp(interiorID, "teste7")--''portas fechadas""
	
	
-- PATTERN 1 até o 9

	EnableInteriorProp(interiorID, "teste11")  --"pattern_07"
-- ARCADES - PROPS - BALOONS

	EnableInteriorProp(interiorID, "teste17") --"arcade"
	EnableInteriorProp(interiorID, "teste18") --"arcade"
	EnableInteriorProp(interiorID, "teste19") --"bagunça"
	EnableInteriorProp(interiorID, "teste20") --"bagunça"
	EnableInteriorProp(interiorID, "teste21") --"bagunça"
--BLOCKERS

	-- EnableInteriorProp(interiorID, "teste22")"pent_lounge_blocker"
	-- EnableInteriorProp(interiorID, "teste23")"pent_guest_blocker"
	-- EnableInteriorProp(interiorID, "teste24")"pent_office_blocker"
	-- EnableInteriorProp(interiorID, "teste25")"pent_cine_blocker"
	-- EnableInteriorProp(interiorID, "teste26")"pent_spa_blocker"
	-- EnableInteriorProp(interiorID, "teste27")"pent_bar_blocker"
	
	--EnableInteriorProp(interiorID, "teste28") --"prop_beer_bottle ---- lixo????w"
	EnableInteriorProp(interiorID, "teste29") --"bebidas no bar"
	--EnableInteriorProp(interiorID, "teste30") --"pent_baloons" azul e branco
	--EnableInteriorProp(interiorID, "teste31") --"leds bar"
	EnableInteriorProp(interiorID, "teste32") --"pent_baloons_col"
	EnableInteriorProp(interiorID, "teste33") --"baloons_col001"
	EnableInteriorProp(interiorID, "teste34") --"baloons" vermelho e preto
	--EnableInteriorProp(interiorID, "teste35") --"baloons" preto e amarelo
	

	SetInteriorPropColor(interiorID, "teste1", 3)
	SetInteriorPropColor(interiorID, "teste2", 3)
	SetInteriorPropColor(interiorID, "teste4", 3)
	SetInteriorPropColor(interiorID, "teste11", 3)
	
	
	RefreshInterior(interiorID)
	end

end)