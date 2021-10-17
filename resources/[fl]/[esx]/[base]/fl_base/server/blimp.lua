local BlacklistedModels = {
    [`blimp`] = true
  }

AddEventHandler('entityCreating', function(entity)
    local model = GetEntityModel(entity)
    if not BlacklistedModels[model] then return end
    CancelEvent()
end)