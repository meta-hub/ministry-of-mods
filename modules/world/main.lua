AddEventHandler("world:setWeather", function(weatherType)
    world.weather = weatherType
end)

print( Exports.locales._T("player_connected") )