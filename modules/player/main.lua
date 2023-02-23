local PlayersTable = {}

local PlayerGenders = {
    [0] = Lang.gen_m,
    [1] = Lang.gen_f,
    [2] = Lang.gen_u,
}

local PlayerHouses = {
    [0] = Lang.house_g,
    [1] = Lang.house_h,
    [2] = Lang.house_r,
    [3] = Lang.house_s,
    [4] = Lang.house_u,
}

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
        if Config.DiscordLogs then
            Exports.discord.LogToDiscord("player", Lang.player_join_title, {r = 165, g = 165, b = 165}, string.format(Lang.player_join_message, Player.id), false)
        end
    else
        for i,v in pairs(PlayersTable) do
            if v.id == Player.id then
                table.remove(PlayersTable, i)
                if Config.DiscordLogs then
                    Exports.discord.LogToDiscord("player", Lang.player_left_title, {r = 165, g = 165, b = 165}, string.format(Lang.player_left_message, Player.id), false)
                end
            end
        end
    end
    if Config.DiscordLogs then
        otherLogs()
    end
end

function countPlayers()
    return #PlayersTable
end

function countGenders()
    local tempData = {}
    for i,v in pairs(PlayersTable) do
        local genderName = PlayerGenders[v.gender]
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
        local houseName = PlayerHouses[v.house]
        if not tempData[houseName] then
            tempData[houseName] = 1
        else
            tempData[houseName] = tempData[houseName] + 1
        end
    end
    return tempData
end

function otherLogs()
    local message = Lang.current_players_title .. string.format(Lang.current_players_message, countPlayers()) .. "\n"
        .. Lang.gender_count_title .. "\n```" .. json.encode(countGenders(), {indent = true}) .. "```\n"
        .. Lang.house_count_title .. "\n```" .. json.encode(countHouses(), {indent = true}) .. "```"

    Exports.discord.LogToDiscord("player", Lang.other_logs_title, {r = 165, g = 165, b = 165}, message, false)
end

-- Exports
Exports("GetPlayerCount", countPlayers)
Exports("GetPlayerGenders", countGenders)
Exports("GetPlayerHouses", countHouses)