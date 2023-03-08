Config = {}

Config.Settings = {
    SyncTimer = 30, -- How long before before the server forces a sync (Seconds)
    RandomWeatherTimer = 300, -- How long before the server changes the weather (Secon1ds)
    MinutesPerSecond = 5, -- Every second adds the given number to minutes
}

Config.Time = { -- False values ignore the variable/setting (meaning it doesn't set anything)
    FreezeTime = false, -- Forces the Time & Date to freeze
    UseOSTime = false, -- if you want to use OS time (ignores all time settings below)
    hour = false, -- Must be between 1 & 23
    minute = false, -- Must be between 1 & 59
    second = false, -- Must be between 1 & 59
    year = false, -- Anything 4 digits long(?)
    month = false, -- Must be between 1 & 12
    day = false, -- Must be between 1 & 31 (Even if feburary has 28 days, it will be corrected automatically)
}

Config.Weather = { -- False values ignore the variable/setting (meaning it doesn't set anything)
    FreezeWeather = false, -- Forces the Weather to freeze
    season = false, -- Must be a number in the SeasonTypes below (EXAMPLE: season = 2)
    weather = false, -- Must be text, reference the WeatherTypes below (EXAMPLE: weather = "Overcast_Heavy_Winter_01",)
}

--[[
    Do not touch anything below unless you know what you are doing!
]]

Config.SeasonTable = {2,2,4,4,4,1,1,1,3,3,3,2}

Config.SeasonTypes = {
    [1] = "Summer",
    [2] = "Winter",
    [3] = "Fall",
    [4] = "Spring",
}

Config.WeatherSystems = {
    Spring = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22,27,28,29,30},
    Summer = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22,27,28,29,30,34},
    Fall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22,27,28,29,30},
    Winter = {3,16,23,24,25,26,31,32,33},
}

Config.WeatherTypes = {
    [1] = "Announce",
    [2] = "Astronomy",
    [3] = "Clear",
    [4] = "Default_PHY",
    [5] = "FIG_07_Storm",
    [6] = "ForbiddenForest_01",
    [7] = "HighAltitudeOnly",
    [8] = "Intro_01",
    [9] = "LightClouds_01",
    [10] = "LightRain_01",
    [11] = "Misty_01",
    [12] = "MistyOvercast_01",
    [13] = "MKT_Nov11",
    [14] = "Overcast_01",
    [15] = "Overcast_Heavy_01",
    [16] = "Overcast_Heavy_Winter_01",
    [17] = "Overcast_Windy_01",
    [18] = "Rainy",
    [19] = "Sanctuary_Bog",
    [20] = "Sanctuary_Coastal",
    [21] = "Sanctuary_Forest",
    [22] = "Sanctuary_Grasslands",
    [23] = "Snow_01",
    [24] = "Snow_Const",
    [25] = "SnowLight_01",
    [26] = "SnowShort",
    [27] = "Stormy_01",
    [28] = "StormyLarge_01",
    [29] = "TestStormShort",
    [30] = "TestWind",
    [31] = "Winter_Misty_01",
    [32] = "Winter_Overcast_01",
    [33] = "Winter_Overcast_Windy_01",
    [34] = "Summer_Overcast_Heavy_01",
}