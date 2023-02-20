local locales = {
    en = {}
}

Exports("_T", function(str)
    return locales.en[str] or ""
end)