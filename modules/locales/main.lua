local resourceLocales = {}
-- LoadData("locales", "locales/" .. Config.Locale .. ".json") or {}

local locales = setmetatable({}, {
    __index = function(self, k)
        local invokingResource = getfenv(3)._RESOURCE

        if not resourceLocales[invokingResource] then
            resourceLocales[invokingResource] = LoadData(invokingResource, "locales/" .. Config.Locale .. ".json") or {}
        end

        return resourceLocales[invokingResource][k]
    end
})

Exports("_T", function(str)
    return locales[str] or ""
end)

_ENV.Locales = locales