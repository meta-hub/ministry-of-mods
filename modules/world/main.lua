local Locales = LoadResource("locales")

AddEventHandler("world:setWeather", function(weatherType)
    world.weather = weatherType
end)

print( Exports.locales._T("player_connected") )
print( Locales.Translate("player_connected") )