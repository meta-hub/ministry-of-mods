local locales = {
    en = {}
}

return function(str)
    return locales.en[str] or ""
end