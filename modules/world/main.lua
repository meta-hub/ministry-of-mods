local world = server.world
local WorldData = {
    hour = world.hour,
    minute = world.minute,
    second = world.second,
    year = world.year,
    month = world.month,
    day = world.day,
    season = world.season,
    weather = world.weather,
}
local SyncTick, WeatherTick, SecondTick = 0, 0, 0
local FreezeTime, FreezeWeather = Config.Time.FreezeTime, Config.Weather.FreezeWeather

<<<<<<< Updated upstream
-- Functions
local function get_days_in_month(month, year)
    local days_in_month = {31,28,31,30,31,30,31,31,30,31,30,31}
    local d = days_in_month[month]

    if (month == 2) then
        if (year % 4 == 0) then
            if (year % 100 == 0)then
                if (year % 400 == 0) then
                    d = 29
                end
            else
                d = 29
            end
        end
=======
--[[
    Functions
]]

function syncWorld()
    print("World Syncing")
    for i,v in pairs(WorldData) do
        world[i] = v
>>>>>>> Stashed changes
    end
    world:RpcSet()
end

function newWeather()
    local getSeason = Config.SeasonTypes[Config.SeasonTable[WorldData.month]]
    WorldData.weather = Config.WeatherTypes[math.random(1,#Config.WeatherSystems[getSeason])]
    syncWorld()
end

function daysInMonth(month, year)
    local days_in_month = {31,28,31,30,31,30,31,31,30,31,30,31}
    if month == 2 then
        return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) and 29 or 28
    else
        return days_in_month[month]
    end
end

<<<<<<< Updated upstream
local function WorldSync()
    for i,v in pairs(WorldData) do
        world[i] = v
    end

    world:RpcSet()

    if Config.DiscordLogs then
        Exports.discord.LogToDiscord("world", Locale.world_sync_title, {r = 165, g = 165, b = 165}, Locale.world_sync_message, false)
    end
end

local function NewWeather()
    local getSeason = Config.SeasonTypes[Config.SeasonTable[WorldData["month"]]]
    local getWeather = Config.WeatherTypes[math.random(1,#Config.Seasons[getSeason])]

    WorldData["weather"] = Config.WeatherTypes[getWeather]

    WorldSync()
end

local function Initiate()
    -- Set primary information to WorldData table
    WorldData["hour"]       = world.hour
    WorldData["minute"]     = world.minute
    WorldData["second"]     = world.second
    WorldData["year"]       = world.year
    WorldData["month"]      = world.month
    WorldData["day"]        = world.day
    WorldData["season"]     = world.season
    WorldData["weather"]    = world.weather

    if type(Config.Time.hour) == "number" then
        if Config.Time.hour >= 0 and Config.Time.hour <= 23 then
            WorldData["hour"] = math.floor(Config.Time.hour)
        end
=======
function Initiate()
    local time = Config.Time
    local weather = Config.Weather
    if type(time.hour) == "number" and time.hour >= 0 and time.hour <= 23 then
        WorldData.hour = math.floor(time.hour)
>>>>>>> Stashed changes
    end
    if type(time.minute) == "number" and time.minute >= 0 and time.minute <= 59 then
        WorldData.minute = math.floor(time.minute)
    end
    if type(time.second) == "number" and time.second >= 0 and time.second <= 59 then
        WorldData.second = math.floor(time.second)
    end
    if type(time.year) == "number" then
        WorldData.year = math.floor(time.year)
    end
    if type(time.month) == "number" and time.month >= 1 and time.month <= 12 then
        WorldData.month = math.floor(time.month)
    end
    if type(time.day) == "number" and time.day >= 1 and time.day <= 31 then
        WorldData.day = math.floor(time.day)
    end
    if type(weather.season) == "number" and Config.SeasonTypes[weather.season] then
        WorldData.season = math.floor(weather.season)
    end
    if type(weather.weather) == "string" and Config.WeatherTypes[weather.weather] then
        WorldData.weather = weather.weather
    end
end

<<<<<<< Updated upstream
local function Update(Delta)
    SecondTick = SecondTick + Delta
=======
function Update(Delta)
>>>>>>> Stashed changes
    SyncTick = SyncTick + Delta
    SecondTick = SecondTick + Delta
    WeatherTick = WeatherTick + Delta

    if not FreezeTime then
        if Config.Time.UseOSTime then
            local date = os.date("*t")
            WorldData.hour = tonumber(date.hour)
            WorldData.minute = tonumber(date.min)
            WorldData.second = tonumber(date.sec)
            WorldData.year = tonumber(date.year)
            WorldData.month = tonumber(date.month)
            WorldData.day = tonumber(date.day)
        else
            if SecondTick > 1 then
                SecondTick = SecondTick - 1
                WorldData.minute = WorldData.minute + Config.Settings.MinutesPerSecond
                WorldData.second = WorldData.second + 1
            end
            if WorldData.second > 59 then
                WorldData.second = WorldData.second - 60
                WorldData.minute = WorldData.minute + 1
            end
            if WorldData.minute > 59 then
                WorldData.minute = WorldData.minute - 60
                WorldData.hour = WorldData.hour + 1
            end
            if WorldData.hour > 23 then
                WorldData.hour = 0
                WorldData.day = WorldData.day + 1
            end
            if WorldData.day > daysInMonth(WorldData.month, WorldData.year) then
                WorldData.day = 1
                WorldData.month = WorldData.month + 1
            end
            if WorldData.month > 12 then
                WorldData.month = 1
                WorldData.year = WorldData.year + 1
            end
        end
    end
    if not FreezeWeather then
        WorldData.season = Config.SeasonTable[WorldData.month]
        if WeatherTick > Config.Settings.RandomWeatherTimer then
            WeatherTick = WeatherTick - Config.Settings.RandomWeatherTimer
            newWeather()
        end
    end
    if SyncTick > Config.Settings.SyncTimer then
        SyncTick = SyncTick - Config.Settings.SyncTimer
        syncWorld()
    end
end

<<<<<<< Updated upstream
-- Exports

Exports("SetWorldData", function(DataTable)
=======

--[[
    Exports Functions
]]
function getWorldData()
    return WorldData
end

function setWorldData(DataTable)
>>>>>>> Stashed changes
    if type(DataTable) == "table" then
        for i,v in pairs(Data) do
            if Config.Time[i] or Config.Weather[i] then
                WorldData[i] = v
            end
        end
    end
end

function freezeTime(state)
    if type(state) == "boolean" then
        FreezeTime = state
    else
        if FreezeTime then
            FreezeTime = false
        else
            FreezeTime = true
        end
    end
end

function freezeWeather(state)
    if type(state) == "boolean" then
        FreezeWeather = state
    else
        if FreezeWeather then
            FreezeWeather = false
        else
            FreezeWeather = true
        end
    end
<<<<<<< Updated upstream
end)

Exports("GetWorldData", function()
    return WorldData
end)

-- ConnectToEvents
=======
end

--[[
    Exports
]]

Exports("syncWorld", syncWorld)
Exports("getWorldData", getWorldData)
Exports("setWorldData", setWorldData)
Exports("freezeTime", freezeTime)
Exports("freezeWeather", freezeWeather)

--[[
    Events
]]

>>>>>>> Stashed changes
RegisterForEvent("init", function()
    Initiate()
end)

<<<<<<< Updated upstream
CreateThread(function(DeltaTime)
    Update(DeltaTime)
=======
CreateThread(function()
    local prevTime = GetGameTimer()
    while true do
        Wait(0)
        local timeNow = GetGameTimer()
        local deltaTime = (timeNow - prevTime) / 1000
        prevTime = timeNow
        Update(deltaTime)
    end
>>>>>>> Stashed changes
end)