ESX.Streaming = {}

local loadingTimeout = {}
local timeout = 600

function ESX.Streaming.RequestModel(modelHash, cb)
	local reduceModelHash = modelHash
	local modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		loadingTimeout[modelHash] = 0

		while not HasModelLoaded(modelHash) do
			loadingTimeout[modelHash] = loadingTimeout[modelHash] + 1
			Citizen.Wait(1)

			if loadingTimeout[modelHash] > timeout then
				print('[es_extended/streaming] Failed to RequestModel ' .. tostring(reduceModelHash) .. ' from ' .. tostring(GetCurrentResourceName()))
				return
			end
		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestStreamedTextureDict(textureDict, cb)
	if not HasStreamedTextureDictLoaded(textureDict) then
		RequestStreamedTextureDict(textureDict)
		loadingTimeout[textureDict] = 0

		while not HasStreamedTextureDictLoaded(textureDict) do
			loadingTimeout[textureDict] = loadingTimeout[textureDict] + 1
			Citizen.Wait(1)

			if loadingTimeout[textureDict] > timeout then
				print('[es_extended/streaming] Failed to RequestStreamedTextureDict ' .. tostring(textureDict) .. ' from ' .. tostring(GetCurrentResourceName()))
				return
			end
		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestNamedPtfxAsset(assetName, cb)
	if not HasNamedPtfxAssetLoaded(assetName) then
		RequestNamedPtfxAsset(assetName)
		loadingTimeout[assetName] = 0

		while not HasNamedPtfxAssetLoaded(assetName) do
			loadingTimeout[assetName] = loadingTimeout[assetName] + 1
			Citizen.Wait(1)

			if loadingTimeout[assetName] > timeout then
				print('[es_extended/streaming] Failed to RequestNamedPtfxAsset ' .. tostring(assetName) .. ' from ' .. tostring(GetCurrentResourceName()))
				return
			end
		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestAnimSet(animSet, cb)
	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)
		loadingTimeout[animSet] = 0

		while not HasAnimSetLoaded(animSet) do
			loadingTimeout[animSet] = loadingTimeout[animSet] + 1
			Citizen.Wait(1)

			if loadingTimeout[animSet] > timeout then
				print('[es_extended/streaming] Failed to RequestAnimSet ' .. tostring(animSet) .. ' from ' .. tostring(GetCurrentResourceName()))
				return
			end
		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		loadingTimeout[animDict] = 0

		while not HasAnimDictLoaded(animDict) do
			loadingTimeout[animDict] = loadingTimeout[animDict] + 1
			Citizen.Wait(1)

			if loadingTimeout[animDict] > timeout then
				print('[es_extended/streaming] Failed to RequestAnimDict ' .. tostring(animDict) .. ' from ' .. tostring(GetCurrentResourceName()))
				return
			end
		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestWeaponAsset(weaponHash, cb)
	if not HasWeaponAssetLoaded(weaponHash) then
		RequestWeaponAsset(weaponHash)
		loadingTimeout[weaponHash] = 0

		while not HasWeaponAssetLoaded(weaponHash) do
			loadingTimeout[weaponHash] = loadingTimeout[weaponHash] + 1
			Citizen.Wait(1)

			if loadingTimeout[weaponHash] > timeout then
				print('[es_extended/streaming] Failed to RequestWeaponAsset ' .. tostring(weaponHash) .. ' from ' .. tostring(GetCurrentResourceName()))
				return
			end
		end
	end

	if cb ~= nil then
		cb()
	end
end
