 Citizen.CreateThread(function()
    while true do
        SetRichPresence(GetPlayerName(PlayerId()) .. " - ".. nbPlayerTotal .. "/999")
        SetDiscordAppId(869640268532572201)
        SetDiscordRichPresenceAsset('69dsign')
        SetDiscordRichPresenceAsset("69dsign") 
        SetDiscordRichPresenceAssetText("Rejoins nous !") 
        SetDiscordRichPresenceAssetSmall("69dsign") 
        SetDiscordRichPresenceAssetSmallText("Clique sur le boutton en dessous !")
        SetDiscordRichPresenceAction(0, "Rejoindre", "fivem://connect/sixnueve.life")
        Citizen.Wait(4000)
    end
end)