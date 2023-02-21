local Lang = LoadResource("locales").Fetch()
local worldSyncLabel = Lang.world_sync

local SyncTick = 0
local WeatherTick = 0
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
    if type(Config.Time.hour) == "number" then
        if Config.Time.hour >= 0 and Config.Time.hour <= 23 then
            WorldData["hour"] = Config.Time.hour
        end
    end
    if type(Config.Time.minute) == "number" then
        if Config.Time.minute >= 0 and Config.Time.minute <= 59 then
            WorldData["minute"] = Config.Time.minute
        end
    end
    if type(Config.Time.second) == "number" then
        if Config.Time.second >= 0 and Config.Time.second <= 59 then
            WorldData["second"] = Config.Time.second
        end
    end
    if type(Config.Time.year) == "number" then
        WorldData["year"] = Config.Time.year
    end
    if type(Config.Time.month) == "number" then
        if Config.Time.month >= 1 and Config.Time.month <= 12 then
            WorldData["month"] = Config.Time.month
        end
    end
    if type(Config.Time.day) == "number" then
        if Config.Time.day >= 1 and Config.Time.day <= 31 then
            WorldData["day"] = Config.Time.day
        end
    end
    if type(Config.Weather.season) == "number" then
        if Config.SeasonTypes[Config.Weather.season] then
            WorldData["season"] = Config.Weather.season
        end
    end
    if type(Config.Weather.weather) == "string" then
        for i,v in pairs(Config.WeatherTypes) do
            if v == Config.Weather.weather then
                WorldData["weather"] = Config.Weather.weather
            end
        end
    end
    if #WorldData == 0 then
        WorldData["hour"] = world.hour
        WorldData["minute"] = world.minute
        WorldData["second"] = world.second
        WorldData["year"] = world.year
        WorldData["month"] = world.month
        WorldData["day"] = world.day
        WorldData["season"] = world.season
        WorldData["weather"] = world.weather
    end
    WorldSync()
end

function Update(Delta)
    SyncTick = SyncTick + Delta
    WeatherTick = WeatherTick + Delta

    if not Config.Settings.FreezeTime then
        WorldData["minute"] = WorldData["minute"] + Config.Settings.MinutesPerSecond

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

    if not Config.Settings.FreezeWeather then
        if WorldData["month"] == 12 or WorldData["month"] == 1 or WorldData["month"] == 2 then
            WorldData["season"] = 2
        elseif WorldData["month"] == 3 or WorldData["month"] == 4 or WorldData["month"] == 5 then
            WorldData["season"] = 4
        elseif WorldData["month"] == 6 or WorldData["month"] == 7 or WorldData["month"] == 8 then
            WorldData["season"] = 1
        elseif WorldData["month"] == 9 or WorldData["month"] == 10 or WorldData["month"] == 11 then
            WorldData["season"] = 3
        end

        if WeatherTick >= Config.Settings.RandomWeatherTimer then
            WeatherTick = 0
            NewWeather()
        end
    end

    if SyncTick >= Config.Settings.SyncTimer then
        SyncTick = 0
        WorldSync()
    end
end

function NewWeather()
    local genWeather = 0
    if WorldData["month"] == 12 or WorldData["month"] == 1 or WorldData["month"] == 2 then
        genWeather = Config.Seasons["Winter"][math.random(1,#Config.Seasons["Winter"])]
    elseif WorldData["month"] == 3 or WorldData["month"] == 4 or WorldData["month"] == 5 then
        genWeather = Config.Seasons["Spring"][math.random(1,#Config.Seasons["Spring"])]
    elseif WorldData["month"] == 6 or WorldData["month"] == 7 or WorldData["month"] == 8 then
        genWeather = Config.Seasons["Summer"][math.random(1,#Config.Seasons["Summer"])]
    elseif WorldData["month"] == 9 or WorldData["month"] == 10 or WorldData["month"] == 11 then
        genWeather = Config.Seasons["Fall"][math.random(1,#Config.Seasons["Fall"])]
    end
    WorldData["weather"] = Config.WeatherTypes[genWeather]
    WorldSync()
end

function WorldSync()
    for i,v in pairs(WorldData) do
        world[i] = v
    end
    world:RpcSet()
    if Config.Settings.PrintWorldSync then
        local xh,xmi,xs,xd,xmo,xy = WorldData["hour"], WorldData["minute"], WorldData["second"], WorldData["day"], WorldData["month"], WorldData["year"]
        local TimeFormat = xh .. ":" .. xmi .. ":" .. xs
        local DateFormat = xd .. "/" .. xmo .. "/" .. xy
        print(worldSyncLabel .. TimeFormat .. " - " .. DateFormat )
    end
end