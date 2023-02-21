local resourceLocales = {}

return {
    Fetch = function()
        local invokingResource = getfenv(2)._RESOURCE

        if not resourceLocales[invokingResource] then
            resourceLocales[invokingResource] = LoadData(invokingResource, "locales/" .. Config.Locale .. ".json") or {}
        end

        return resourceLocales[invokingResource]
    end
}