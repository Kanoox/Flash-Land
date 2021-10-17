ShowHelpNotification = function(msg)
	AddTextEntry('rPropsHelpNotif', msg)
	DisplayHelpTextThisFrame('rPropsHelpNotif', false)
end

ShowNotification = function(msg)
	AddTextEntry('rPropsNotif', msg)
	BeginTextCommandThefeedPost('rPropsNotif')
	EndTextCommandThefeedPostTicker(false, false)
end