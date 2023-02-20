local locales = LoadData("locales", "locales/" .. Config.Locale .. ".json") or {}

Exports("_T", function(str)
    return locales[str] or ""
end)

_ENV.Locales = locales