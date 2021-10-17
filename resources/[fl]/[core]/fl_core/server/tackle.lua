RegisterNetEvent('nwx:tryTackle')
AddEventHandler('nwx:tryTackle', function(target)
	TriggerClientEvent('nwx:getTackled', target, source)
	TriggerClientEvent('nwx:playTackle', source)
end)

RegisterNetEvent('nwx:carry')
AddEventHandler('nwx:carry', function(targetSrc, animationLib, animation, animation2, distans, distans2, height, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget)
	TriggerClientEvent('nwx:carryTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget)
	TriggerClientEvent('nwx:carrySync', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
end)

RegisterNetEvent('nwx:carryStop')
AddEventHandler('nwx:carryStop', function(targetSrc)
	if targetSrc ~= nil and targetSrc > 0 then
		TriggerClientEvent('nwx:carryStopTarget', targetSrc, source)
	else
		print('[nwx_utils] Called cmg2_animations:stop without proper target (' .. tostring(source) .. ')')
	end
end)
