local Lang = LoadResource("locales").Fetch()

local PlayersTable = {}

-- ConnectToEvents
registerForEvent("player_joined", function(Player)
    Track(Player, true)
end)
registerForEvent("player_left", function(Player)
    Track(Player, false)
end)

-- Functions
function Track(Player, Joined)
    if Joined then
        table.insert(PlayersTable, {
            id = Player.id,
            gender = Player.gender,
            house = Player.house,
            gear = Player.gear,
            movement = Player.movement
        })
        if Config.Settings.PrintJoin then
            print(string.format(Lang.player_joining, Player.id))
        end
    else
        for i,v in pairs(PlayersTable) do
            if v.id == Player.id then
                table.remove(PlayersTable, i)
                if Config.Settings.PrintLeave then
                    print(string.format(Lang.player_leaveing, Player.id))
                end
            end
        end
    end
    if Config.Settings.PrintGenderCount then
        print(Lang.gender_count)
        print(json.encode(countGenders(), { indent = true }))
    end
    if Config.Settings.PrintHouseCount then
        print(Lang.house_count)
        print(json.encode(countHouses(), { indent = true }))
    end
    if Config.Settings.PrintPlayerCount then
        print(string.format(Lang.current_players, countPlayers()))
    end
end

function countPlayers()
    return #PlayersTable
end

function countGenders()
    local tempData = {}
    for i,v in pairs(PlayersTable) do
        local genderName = Config.PlayerGenders[v.gender]
        if not tempData[genderName] then
            tempData[genderName] = 1
        else
            tempData[genderName] = tempData[genderName] + 1
        end
    end
    return tempData
end

function countHouses()
    local tempData = {}
    for i,v in pairs(PlayersTable) do
        local houseName = Config.PlayerHouses[v.house]
        if not tempData[houseName] then
            tempData[houseName] = 1
        else
            tempData[houseName] = tempData[houseName] + 1
        end
    end
    return tempData
end

-- Exports

Exports("GetPlayerCount", function(str)
    return countPlayers()
end)

Exports("GetPlayerGenders", function(str)
    return countGenders()
end)

Exports("GetPlayerHouses", function(str)
    return countHouses()
end)