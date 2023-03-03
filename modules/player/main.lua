local PlayersTable = {}

local PlayerGenders = {
    [0] = Locale.gen_m,
    [1] = Locale.gen_f,
    [2] = Locale.gen_u,
}

local PlayerHouses = {
    [0] = Locale.house_g,
    [1] = Locale.house_h,
    [2] = Locale.house_r,
    [3] = Locale.house_s,
    [4] = Locale.house_u,
}


local defaultPlayerTable = {gold = 100}
-- ConnectToEvents
RegisterForEvent("player_joined", function(Player)
    Track(Player, true)
end)

RegisterForEvent("player_left", function(Player)
    Track(Player, false)
end)

-- Functions
function Track(Player, Joined)
    local getPlayerData = readPlayerData()
    local stringId = tostring(Player.id)
    if not getPlayerData[stringId] then
        print("player doesn't exist")
        local tempTable = {[stringId] = defaultPlayerTable}
        writePlayerData(tempTable)
    else
        print(getPlayerData[stringId]["gold"])
    end

    if Joined then
        table.insert(PlayersTable, Player)
        if Config.DiscordLogs then
            Exports.discord.LogToDiscord("player", Locale.player_join_title, {r = 165, g = 165, b = 165}, string.format(Locale.player_join_message, Player.id), false)
        end
    else
        for i,v in pairs(PlayersTable) do
            if v.id == Player.id then
                table.remove(PlayersTable, i)
                if Config.DiscordLogs then
                    Exports.discord.LogToDiscord("player", Locale.player_left_title, {r = 165, g = 165, b = 165}, string.format(Locale.player_left_message, Player.id), false)
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
    local message = Locale.current_players_title .. string.format(Locale.current_players_message, countPlayers()) .. "\n"
        .. Locale.gender_count_title .. "\n```" .. json.encode(countGenders(), {indent = true}) .. "```\n"
        .. Locale.house_count_title .. "\n```" .. json.encode(countHouses(), {indent = true}) .. "```"

    Exports.discord.LogToDiscord("player", Locale.other_logs_title, {r = 165, g = 165, b = 165}, message, false)
end

-- Exports
Exports("GetPlayerCount", countPlayers)
Exports("GetPlayerGenders", countGenders)
Exports("GetPlayerHouses", countHouses)