Config = {}

Config.AllLogs = true											-- Enable/Disable All Logs Channel
Config.postal = false  											-- set to false if you want to disable nerest postal (https://forum.cfx.re/t/release-postal-code-map-minimap-new-improved-v1-2/147458)
Config.username = "FreeLife Logger" 							-- Bot Username
Config.avatar = ""				-- Bot Avatar
Config.communtiyName = "FreeLife"					-- Icon top of the embed
Config.communtiyLogo = ""		-- Icon top of the embed
Config.FooterText = "FreeLife"						-- Footer text for the embed
Config.FooterIcon = ""			-- Footer icon for the embed


Config.weaponLog = true  			-- set to false to disable the shooting weapon logs
Config.InlineFields = true			-- set to false if you don't want the player details next to each other

Config.playerID = true				-- set to false to disable Player ID in the logs
Config.steamID = true				-- set to false to disable Steam ID in the logs
Config.steamURL = true				-- set to false to disable Steam URL in the logs
Config.discordID = true				-- set to false to disable Discord ID in the logs
Config.license = true				-- set to false to disable license in the logs
Config.IP = true					-- set to false to disable IP in the logs

-- Change color of the default embeds here
-- It used Decimal or Hex color codes. They will both work.
Config.BaseColors ={		-- For more info have a look at the docs: https://docs.prefech.com
	chat = "#A1A1A1",				-- Chat Message
	joins = "#3AF241",				-- Player Connecting
	leaving = "#F23A3A",			-- Player Disconnected
	deaths = "#000000",				-- Shooting a weapon
	shooting = "#2E66F2",			-- Player Died
	resources = "#EBEE3F",			-- Resource Stopped/Started	
}


Config.webhooks = {		-- For more info have a look at the docs: https://docs.prefech.com
	all = "https://discord.com/api/webhooks/876931840538202152/hfkKYZuDbmr9TktZ8Oo2Lvstoz2cZxw8fDuQ1u28u6jg86C72lsbZYBiw4s8E3B1Cq4_",		-- All logs will be send to this channel
	chat = "https://discord.com/api/webhooks/876931941889364049/DnvPbdBDGnl4xiSg2nHlbPn7U0DoT27OlIDidxq0O6jfxrfsqgksmlQ2c_OF-7RogJlQ",		-- Chat Message
	joins = "https://discord.com/api/webhooks/876871243859656734/BxeiUNcXmf_1bE_e6CQ0j6FGz2qmWFUmt2E9pX3f4BZswfy4sAeo4qsfbjbsbTbhNXgG",		-- Player Connecting
	leaving = "https://discord.com/api/webhooks/876871347773505616/aMI-p9KSnTM4vJ7wyIc2WOa80alKT6pG4pC2-WXhK7cKoQznFLzB51XtAxk0edRwPBCD",	-- Player Disconnected
	deaths = "https://discord.com/api/webhooks/876932031274176512/pEHehDU8GlBNFGKhcZ68kigoWHfJ6ltUfYXFWqVH7s1f9S_BDJSZQdSwaNqxJCKpm5Kj",		-- Shooting a weapon
	shooting = "https://discord.com/api/webhooks/876871547200106497/bVuK5vsssqV6aZG6oCMFha5k6ZKEPLkiK-JA4JZF-H5-rBbX2tYggByhEAww0bD0P4O9",	-- Player Died
	resources = "DISCORD_WEBHOOK",	-- Resource Stopped/Started	
}

Config.TitleIcon = {		-- For more info have a look at the docs: https://docs.prefech.com
	chat = "💬",				-- Chat Message
	joins = "📥",				-- Player Connecting
	leaving = "📤",			-- Player Disconnected
	deaths = "💀",				-- Shooting a weapon
	shooting = "🔫",			-- Player Died
	resources = "🔧",			-- Resource Stopped/Started	
}

Config.Plugins = {
	--["PluginName"] = {color = "#FFFFFF", icon = "🔗", webhook = "DISCORD_WEBHOOK"},
	["NameChange"] = {color = "#03fc98", icon = "🔗", webhook = "DISCORD_WEBHOOK"},
}


 --Debug shizzels :D
Config.debug = false
Config.versionCheck = "1.3.0"
