RegisterNetEvent('fl_society:displayAd')
AddEventHandler('fl_society:displayAd',function(pic1, pic2, sender, subject, inputText, duration, joueur)
	webhook = "https://discord.com/api/webhooks/876933209764560926/V2T56CG5ODLRn2eRBXQU58Ak7ccyAuawIFCiQgeRb4iAJkPbkmUD_P0_hkipiXxAWREc"
	SetNotificationTextEntry('STRING');
	AddTextComponentString(inputText);
	SetNotificationMessage(pic1, pic2, true, 4, sender, subject);
	DrawNotification(false, true);
	--TriggerServerEvent("ruben:sendMessageWebhook", webhook,"**```Un joueur à utilisé le /pub twitter \nJoueur: "..target.."\nMessage: "..inputText.."```**\n")
end)