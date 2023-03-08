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

<<<<<<< Updated upstream
--[[

]]

local function savePlayerData(Player, Data)
    local path = _PATH .. "/data/playerdata.json"
    local existingData = {}
    if fileExists(path) then
        existingData = json.decode(readFile(path))
    end
    existingData[tostring(Player.id)] = Data
    local success = writeFile(path, json.encode(existingData))
    return success
end

local function getPlayerData(Player)
    local path = _PATH .. "/data/playerdata.json"

    if fileExists(path) then
        local existingData = json.decode(readFile(path))
        return existingData[tostring(Player.id)]
    else
        return nil
    end
end

-- Functions
local function otherLogs()
    local message = Locale.current_players_title .. string.format(Locale.current_players_message, countPlayers()) .. "\n"
        .. Locale.gender_count_title .. "\n```" .. json.encode(countGenders(), {indent = true}) .. "```\n"
        .. Locale.house_count_title .. "\n```" .. json.encode(countHouses(), {indent = true}) .. "```"

    Exports.discord.LogToDiscord("player", Locale.other_logs_title, {r = 165, g = 165, b = 165}, message, false)
end

local function Track(Player, Joined)
    local PlayerData = getPlayerData(Player)
    if not PlayerData then
        print("player doesn't exist")
        savePlayerData(Player, {gold = 100})
    else
        print(PlayerData.gold)
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

local function countGenders()
    local tempData = {}
    for i,v in pairs(PlayersTable) do
        local genderName = PlayerGenders[v.gender]
        if not tempData[genderName] then
            tempData[genderName] = 1
=======
local DATA_FILE = _PATH .. "/data/playerdata.json"

local playerData = {}

--[[
    Functions
]]

function loadPlayerData(Player)
    if fileExists(DATA_FILE) then
        local existingData = json.decode(readFile(DATA_FILE))
        local playerID = tostring(Player.id)
        if existingData then
            playerData[playerID] = existingData[playerID]
            playerData[playerID].lastPlayed = os.time()
>>>>>>> Stashed changes
        else
            playerData[tostring(Player.id)] = {
                house = Player.house,
                gender = Player.gender,
                lastPlayed = os.time()
            }
            savePlayerData(Player)
        end
    end
end

function savePlayerData(Player)
    local playerID = tostring(Player.id)
    if playerData[playerID] then
        local existingData = {}
        if fileExists(DATA_FILE) then
            existingData = json.decode(readFile(DATA_FILE))
        end
        existingData[playerID] = playerData[playerID]
        local success = writeFile(DATA_FILE, json.encode(existingData))
        return success
    end
    return false
end

function onPlayerJoin(Player)
    loadPlayerData(Player)
end

function onPlayerLeave(Player)
    local playerID = tostring(Player.id)
    savePlayerData(Player)
    playerData[playerID] = nil
end

function getPlayerData(Player)
    local playerID = tostring(Player.id)
    return playerData[playerID]
end

function onlinePlayers()
    local count = 0
    for _ in pairs(playerData) do
        count = count + 1
    end
    return count
end

<<<<<<< Updated upstream
local function countHouses()
    local tempData = {}
    for i,v in pairs(PlayersTable) do
        local houseName = PlayerHouses[v.house]
        if not tempData[houseName] then
            tempData[houseName] = 1
        else
            tempData[houseName] = tempData[houseName] + 1
=======
function countHouses()
    local houses = {}
    for _, data in pairs(playerData) do
        local house = data.house
        if house then
            houses[PlayerHouses[house]] = (houses[PlayerHouses[house]] or 0) + 1
>>>>>>> Stashed changes
        end
    end
    return houses
end

<<<<<<< Updated upstream
-- Exports
Exports("GetPlayerCount", function()
    return #PlayersTable
end)
Exports("GetPlayerGenders", countGenders)
Exports("GetPlayerHouses", countHouses)

-- ConnectToEvents
RegisterForEvent("player_joined", function(Player)
    Track(Player, true)
end)

RegisterForEvent("player_left", function(Player)
    Track(Player, false)
=======
function countGenders()
    local genders = {}
    for _, data in pairs(playerData) do
        local gender = data.gender
        genders[PlayerGenders[gender]] = (genders[PlayerGenders[gender]] or 0) + 1
    end
    return genders
end

--[[
    Exports
]]

Exports("getPlayerData", getPlayerData)
Exports("onlinePlayers", onlinePlayers)
Exports("countHouses", countHouses)
Exports("countGenders", countGenders)

--[[
    Events
]]

RegisterForEvent("player_joined", function(Player)
    onPlayerJoin(Player)
end)

RegisterForEvent("player_left", function(Player)
    onPlayerLeave(Player)
>>>>>>> Stashed changes
end)