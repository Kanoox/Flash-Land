RMenu.Add('fl_civilprops', 'main', RageUI.CreateMenu("Menu d'objet", " "))
RMenu:Get('fl_civilprops', 'main'):SetSubtitle("Catégories :")
RMenu:Get('fl_civilprops', 'main').EnableMouse = false
RMenu:Get('fl_civilprops', 'main').Closed = function()
	-- TODO Perform action
end;


deleteMode = false
hashList = {}
local propsList = {
	{
		nom = "LSPD",
		props = {
			{nom = "Cone", prop = "prop_roadcone02a"},
			{nom = "Barrière Police", prop = "prop_barrier_work05"},
			{nom = "Barrière Travaux", prop = "prop_barrier_work06a"},
			{nom = "Barrière", prop = -565489442},
			{nom = "Gros carton", prop = "prop_boxpile_07d"},
			{nom = "Gazebo", prop = "prop_gazebo_02"},
			{nom = "Herse", prop = "p_ld_stinger_s"},
			{nom = "Poteau routier", prop = "prop_roadpole_01b"},
			{nom = "Baril d'eau routier", prop = "prop_barrier_wat_04b", canMove = true},
			{nom = "Baril orange routier", prop = "prop_barrier_wat_03b"},
		}
	},

	{
		nom = "#DEV",
		props = {},
	}
}

local categorie = {}

RegisterNetEvent('fl_civilprops:addPropDev')
AddEventHandler('fl_civilprops:addPropDev', function(args)
	table.insert(hashList, GetHashKey(args[1]))
	for _, propData in pairs(propsList) do
		if propData.nom == '#DEV' then
			if #propData.props == 0 then
				RMenu.Add('fl_civilprops', propData.nom, RageUI.CreateSubMenu(RMenu:Get('fl_civilprops', 'main'), "Props", "~b~Pose d'objets"))
				table.insert(categorie, propData.nom)
			end
			table.insert(propData.props, {nom = '' .. args[1], prop = args[1]})
		end
	end
	print('added ' .. tostring(args[1]))
end)

Citizen.CreateThread(function()
	for k,v in pairs(propsList) do
		for _,Prop in pairs(v.props) do
			if tonumber(Prop.prop) ~= nil then
				table.insert(hashList, Prop.prop)
			else
				table.insert(hashList, GetHashKey(Prop.prop))
			end
		end

		if #v.props > 0 then
			RMenu.Add('fl_civilprops', v.nom, RageUI.CreateSubMenu(RMenu:Get('fl_civilprops', 'main'), "Props", "~b~Pose d'objets"))
			table.insert(categorie, v.nom)
		end
	end
end)

RageUI.CreateWhile(1.0, true, function()
	local sleep = true
	if RageUI.Visible(RMenu:Get('fl_civilprops', 'main')) then
		sleep = false
		RageUI.DrawContent({ header = true, glare = true, instructionalButton = true }, function()
			for k,v in pairs(categorie) do
				RageUI.Button(v, nil, { RightLabel = "→→→"  }, true, function(Hovered, Active, Selected)
				end, RMenu:Get('fl_civilprops', v))
			end

			RageUI.Button("Mode Suppression", nil, { RightLabel = "XXX"  }, true, function(Hovered, Active, Selected)
				if Selected then
					deleteMode = not deleteMode


					if deleteMode then
						RageUI.Visible(RMenu:Get('fl_civilprops', 'main'), false)
						ESX.ShowNotification('~g~Mode suppression actif')
					else
						ESX.ShowNotification('~r~Mode suppression désactivé')
					end
				end
			end)
		end, function()
			---Panels
		end)
	end

	for k,v in pairs(categorie) do
		if RageUI.Visible(RMenu:Get('fl_civilprops', v)) then
			sleep = false
			for _,i in pairs(propsList) do
				if i.nom == v then
					RageUI.DrawContent({ header = true, glare = true, instructionalButton = true }, function()
						for _,j in pairs(i.props) do
							RageUI.Button(j.nom, nil, {}, true, function(Hovered, Active, Selected)
								if (Selected) then
									SpawnObj(j)
									Citizen.Wait(10)
								end
							end)
						end
					end, function()
					end)
				end
			end
		end
	end

	if sleep then
		Wait(1000)
	end
end, 1)

RegisterNetEvent("fl_civilprops:OpenMenu")
AddEventHandler("fl_civilprops:OpenMenu", function()
	RageUI.Visible(RMenu:Get('fl_civilprops', 'main'), true)
end)

RegisterNetEvent("fl_police:OuvPropsM")
AddEventHandler("fl_police:OuvPropsM", function()
	RageUI.Visible(RMenu:Get('fl_civilprops', 'LSPD'), true)
end)


RegisterCommand('props', function()
	RageUI.Visible(RMenu:Get('fl_civilprops', 'main'), true)
end, false)