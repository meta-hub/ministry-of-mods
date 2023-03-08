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

local DATA_FILE = _PATH .. "/modules/player/data/playerdata.json"

local playerData = {}

--[[
    Functions
]]

function loadPlayerData(Player)
    if fileExists(DATA_FILE) then
        local existingData = json.decode(readFile(DATA_FILE))
        local playerID = tostring(Player.id)
        if existingData[playerID] then
            playerData[playerID] = existingData[playerID]
            playerData[playerID].lastPlayed = os.time()
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

function countHouses()
    local houses = {}
    for _, data in pairs(playerData) do
        local house = data.house
        if house then
            houses[PlayerHouses[house]] = (houses[PlayerHouses[house]] or 0) + 1
        end
    end
    return houses
end

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
end)