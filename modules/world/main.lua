local Lang = LoadResource("locales").Fetch()

local SyncTick, WeatherTick, SecondTick = 0, 0, 0
local FreezeTime, FreezeWeather = Config.Settings.FreezeTime, Config.Settings.FreezeWeather
local WorldData = {}

-- ConnectToEvents
registerForEvent("init", function()
    Initiate()
end)

registerForEvent("update", function(DeltaTime)
    Update(DeltaTime)
end)

-- Functions
function get_days_in_month(month, year)
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
    end

    return d
end

function Initiate()
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
    end

    if type(Config.Time.minute) == "number" then
        if Config.Time.minute >= 0 and Config.Time.minute <= 59 then
            WorldData["minute"] = math.floor(Config.Time.minute)
        end
    end

    if type(Config.Time.second) == "number" then
        if Config.Time.second >= 0 and Config.Time.second <= 59 then
            WorldData["second"] = math.floor(Config.Time.second)
        end
    end

    if type(Config.Time.year) == "number" then
        WorldData["year"] = math.floor(Config.Time.year)
    end

    if type(Config.Time.month) == "number" then
        if Config.Time.month >= 1 and Config.Time.month <= 12 then
            WorldData["month"] = math.floor(Config.Time.month)
        end
    end

    if type(Config.Time.day) == "number" then
        if Config.Time.day >= 1 and Config.Time.day <= 31 then
            WorldData["day"] = math.floor(Config.Time.day)
        end
    end

    if type(Config.Weather.season) == "number" then
        if Config.SeasonTypes[Config.Weather.season] then
            WorldData["season"] = math.floor(Config.Weather.season)
        end
    end

    if type(Config.Weather.weather) == "string" then
        for i,v in pairs(Config.WeatherTypes) do
            if v == Config.Weather.weather then
                WorldData["weather"] = Config.Weather.weather
            end
        end
    end

    if Config.Settings.UseOSTime then
        WorldData["hour"] = tonumber(os.date("%H"))
        WorldData["minute"] = tonumber(os.date("%M"))
        WorldData["second"] = tonumber(os.date("%S"))
        WorldData["year"] = tonumber(os.date("%Y"))
        WorldData["month"] = tonumber(os.date("%m"))
        WorldData["day"] = tonumber(os.date("%d"))

        WorldData["season"] = Config.SeasonTable[WorldData["month"]]

        NewWeather()
    end
end

function Update(Delta)
    SecondTick = SecondTick + Delta
    SyncTick = SyncTick + Delta
    WeatherTick = WeatherTick + Delta

    if not FreezeTime then
        if Config.Settings.UseOSTime then
            WorldData["hour"] = tonumber(os.date("%H"))
            WorldData["minute"] = tonumber(os.date("%M"))
            WorldData["second"] = tonumber(os.date("%S"))
            WorldData["year"] = tonumber(os.date("%Y"))
            WorldData["month"] = tonumber(os.date("%m"))
            WorldData["day"] = tonumber(os.date("%d"))
        else
            if SecondTick > 1 then
                SecondTick = SecondTick - 1
                WorldData["second"] = WorldData["second"] + 1
                WorldData["minute"] = WorldData["minute"] + Config.Settings.MinutesPerSecond
            end

            if WorldData["second"] > 59 then
                WorldData["second"] = WorldData["second"] - 59
                WorldData["minute"] = WorldData["minute"] + 1
            end

            if WorldData["minute"] > 59 then
                WorldData["minute"] = WorldData["minute"] - 59
                WorldData["hour"] = WorldData["hour"] + 1
            end

            if WorldData["hour"] > 23 then
                WorldData["hour"] = 0
                WorldData["day"] = WorldData["day"] + 1
            end

            if WorldData["day"] > get_days_in_month(WorldData["month"], WorldData["year"]) then
                WorldData["day"] = 1
                WorldData["month"] = WorldData["month"] + 1
            end

            if WorldData["month"] > 12 then
                WorldData["month"] = 1
                WorldData["year"] = WorldData["year"] + 1
            end
        end
    end

    if not FreezeWeather then
        WorldData["season"] = Config.SeasonTable[WorldData["month"]]
        if WeatherTick > Config.Settings.RandomWeatherTimer then
            WeatherTick = WeatherTick - Config.Settings.RandomWeatherTimer

            NewWeather()
        end
    end

    if SyncTick > Config.Settings.SyncTimer then
        SyncTick = SyncTick - Config.Settings.SyncTimer

        WorldSync()
    end
end

function NewWeather()
    local getSeason = Config.SeasonTypes[Config.SeasonTable[WorldData["month"]]]
    local getWeather = Config.WeatherTypes[math.random(1,#Config.Seasons[getSeason])]

    WorldData["weather"] = Config.WeatherTypes[genWeather]

    WorldSync()
end

function WorldSync()
    for i,v in pairs(WorldData) do
        world[i] = v
    end

    world:RpcSet()
<<<<<<< HEAD

    if Config.Settings.PrintWorldSync then
        local xh,xmi,xs,xd,xmo,xy = WorldData["hour"], WorldData["minute"], WorldData["second"], WorldData["day"], WorldData["month"], WorldData["year"]
        local TimeFormat = xh .. ":" .. xmi .. ":" .. xs
        local DateFormat = xd .. "/" .. xmo .. "/" .. xy

        print(Lang.world_sync .. TimeFormat .. " - " .. DateFormat )
=======
    if Config.DiscordLogs then
        Exports.discord.LogToDiscord("world", Lang.world_sync_title, {r = 165, g = 165, b = 165}, Lang.world_sync_message, false)
>>>>>>> 5c925f94767b5c2661309da2d40bf19b15723092
    end
end

-- Exports

Exports("SetWorldData", function(DataTable)
    if type(DataTable) == "table" then
        for i,v in pairs(Data) do
            if Config.Time[i] or Config.Weather[i] then
                WorldData[i] = v
            end
        end
    end
end)

Exports("SyncWorldData", WorldSync)

Exports("FreezeTime", function(state)
    if type(state) == "boolean" then
        FreezeTime = state
    else
        if FreezeTime then
            FreezeTime = false
        else
            FreezeTime = true
        end
    end
end)

Exports("FreezeWeather", function(state)
    if type(state) == "boolean" then
        FreezeWeather = state
    else
        if FreezeWeather then
            FreezeWeather = false
        else
            FreezeWeather = true
        end
    end
end)