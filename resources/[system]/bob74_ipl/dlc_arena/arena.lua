local map = 3
local scene = "wasteland"

local maps = {
	["dystopian"] = {
		"Set_Dystopian_01",
		"Set_Dystopian_02",
		"Set_Dystopian_03",
		"Set_Dystopian_04",
		"Set_Dystopian_05",
		"Set_Dystopian_06",
		"Set_Dystopian_07",
		"Set_Dystopian_08",
		"Set_Dystopian_09",
		"Set_Dystopian_10",
		"Set_Dystopian_11",
		"Set_Dystopian_12",
		"Set_Dystopian_13",
		"Set_Dystopian_14",
		"Set_Dystopian_15",
		"Set_Dystopian_16",
		"Set_Dystopian_17"
	},

	["scifi"] = {
		"Set_Scifi_01",
		"Set_Scifi_02",
		"Set_Scifi_03",
		"Set_Scifi_04",
		"Set_Scifi_05",
		"Set_Scifi_06",
		"Set_Scifi_07",
		"Set_Scifi_08",
		"Set_Scifi_09",
		"Set_Scifi_10"
	},

	["wasteland"] = {
		"Set_Wasteland_01",
		"Set_Wasteland_02",
		"Set_Wasteland_03",
		"Set_Wasteland_04",
		"Set_Wasteland_05",
		"Set_Wasteland_06",
		"Set_Wasteland_07",
		"Set_Wasteland_08",
		"Set_Wasteland_09",
		"Set_Wasteland_10"
	}
}


Citizen.CreateThread(function()
	-- New Arena : 2800.00, -3800.00, 100.00
	--RequestIpl("xs_arena_interior")

	-- The below are additional interiors / maps relating to this DLC play around with them at your own risk and want.
	--RequestIpl("xs_arena_interior_mod")
	--RequestIpl("xs_arena_interior_mod_2")
	--RequestIpl("xs_arena_interior_vip") -- This is the interior bar for VIP's
	--RequestIpl("xs_int_placement_xs")
	--RequestIpl("xs_arena_banners_ipl")
	--RequestIpl("xs_mpchristmasbanners")
	--RequestIpl("xs_mpchristmasbanners_strm_0")

	-- Lets get and save our interior ID for use later
	local interiorID = GetInteriorAtCoords(2800.000, -3800.000, 100.000)

	-- now lets check the interior is ready if not lets just wait a moment
	if not IsInteriorReady(interiorID) then
		Wait(1)
	end
	-- We need to add the crowds as who does stuff on their own for nobody?
	EnableInteriorProp(interiorID, "Set_Crowd_A")
	EnableInteriorProp(interiorID, "Set_Crowd_B")
	EnableInteriorProp(interiorID, "Set_Crowd_C")
    EnableInteriorProp(interiorID, "Set_Crowd_D")

    for mapName,mapTable in pairs(maps) do
        for _,prop in pairs(mapTable) do
		    DisableInteriorProp(interiorID, prop)
        end
    end

	-- now lets set our map type and scene.
	if (scene == "dystopian") then
		DisableInteriorProp(interiorID, "Set_Scifi_Scene")
		DisableInteriorProp(interiorID, "Set_Wasteland_Scene")
		EnableInteriorProp(interiorID, "Set_Dystopian_Scene")
		EnableInteriorProp(interiorID, maps[scene][map])
	end
	if (scene == "scifi") then
		DisableInteriorProp(interiorID, "Set_Dystopian_Scene")
		DisableInteriorProp(interiorID, "Set_Wasteland_Scene")
		EnableInteriorProp(interiorID, "Set_Scifi_Scene")
		EnableInteriorProp(interiorID, maps[scene][map])
	end
	if (scene == "wasteland") then
		DisableInteriorProp(interiorID, "Set_Dystopian_Scene")
		DisableInteriorProp(interiorID, "Set_Scifi_Scene")
		EnableInteriorProp(interiorID, "Set_Wasteland_Scene")
		EnableInteriorProp(interiorID, maps[scene][map])
    end

    RefreshInterior(interiorID)
end)

Citizen.CreateThread(function()
	--RequestIpl("xs_arena_interior")

	--RequestIpl("xs_arena_interior_vip")
    local interiorVip = GetInteriorAtCoords(2804.1, -3930.0, 185.0)
    EnableInteriorProp(interiorVip, 'VIP_XMAS_DECS')
    RefreshInterior(interiorVip)

	RequestIpl("xs_arena_interior_mod_2")
    local interiorMod2 = GetInteriorAtCoords(170.0, 5190.0, 10.0)
    DisableInteriorProp(interiorMod2, 'Set_Int_MOD2_B1')
    EnableInteriorProp(interiorMod2, 'Set_Int_MOD2_B2')
    EnableInteriorProp(interiorMod2, 'Set_Int_MOD2_B_TINT')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_01')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_02')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_03')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_04')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_05')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_06')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_07')
    DisableInteriorProp(interiorMod2, 'Set_Mod2_Style_08')
    EnableInteriorProp(interiorMod2, 'Set_Mod2_Style_09')
    RefreshInterior(interiorMod2)


	RequestIpl("xs_arena_interior_mod")
    local interiorMod = GetInteriorAtCoords(205.0, 5180.0, -90.0)

    EnableInteriorProp(interiorMod, 'Set_Int_MOD_SHELL_DEF')

    DisableInteriorProp(interiorMod, 'Set_Int_MOD_BOOTH_DEF')
    DisableInteriorProp(interiorMod, 'Set_Int_MOD_BOOTH_BEN')
    DisableInteriorProp(interiorMod, 'Set_Int_MOD_BOOTH_WP')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_BOOTH_COMBO')

    EnableInteriorProp(interiorMod, 'Set_Int_MOD_BEDROOM_BLOCKER')

    DisableInteriorProp(interiorMod, 'Set_Int_MOD_CONSTRUCTION_01')
    DisableInteriorProp(interiorMod, 'Set_Int_MOD_CONSTRUCTION_02')
    DisableInteriorProp(interiorMod, 'Set_Int_MOD_CONSTRUCTION_03')

    DisableInteriorProp(interiorMod, 'SET_OFFICE_STANDARD')
    DisableInteriorProp(interiorMod, 'SET_OFFICE_INDUSTRIAL')
    DisableInteriorProp(interiorMod, 'SET_OFFICE_HITECH')

    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_01')
    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_02')
    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_03')
    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_04')
    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_05')
    EnableInteriorProp(interiorMod, 'Set_Mod1_Style_06')
    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_07')
    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_08')
    DisableInteriorProp(interiorMod, 'Set_Mod1_Style_09')

    EnableInteriorProp(interiorMod, 'set_arena_peds')
    --EnableInteriorProp(interiorMod, 'set_arena_no_peds')
    EnableInteriorProp(interiorMod, 'SET_XMAS_DECORATIONS')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_CAREER')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_SCORE')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_WAGEWORKER')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_TIME_SERVED')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_GOT_ONE')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_OUTTA_HERE')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_SHUNT')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_BOBBY')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_KILLED')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_CROWD')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_DUCK')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_BANDITO')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_SPINNER')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_LENS')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_WAR')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_UNSTOPPABLE')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_CONTACT')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_TOWER')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_STEP')
    EnableInteriorProp(interiorMod, 'Set_Int_MOD_TROPHY_PEGASUS')
    EnableInteriorProp(interiorMod, 'SET_BANDITO_RC')

    EnableInteriorProp(interiorMod, 'SET_OFFICE_TRINKET_07')
    EnableInteriorProp(interiorMod, 'SET_OFFICE_TRINKET_06')
    EnableInteriorProp(interiorMod, 'SET_OFFICE_TRINKET_03')
    EnableInteriorProp(interiorMod, 'SET_OFFICE_TRINKET_04')
    EnableInteriorProp(interiorMod, 'SET_OFFICE_TRINKET_02')
    EnableInteriorProp(interiorMod, 'SET_OFFICE_TRINKET_01')

    RefreshInterior(interiorMod)
end)