local Config = require("config")
local Locales = LoadResource("locales")

local PlayersTable = {}

local PlayerGender = {
    [1] = {"Agender", 0},
    [2] = {"Female", 0},
    [3] = {"Male", 0},
}

local PlayerHouse = {
    [1] = {"Gryffindor", 0},
    [2] = {"Hufflepuff", 0},
    [3] = {"Ravenclaw", 0},
    [4] = {"Slytherin", 0},
    [5] = {"Unaffiliated", 0},
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
        table.insert(PlayersTable, Player.id)
        PlayerHouse[Player.gender][2] = PlayerHouse[Player.gender][2] + 1
        PlayerHouse[Player.house][2] = PlayerHouse[Player.house][2] + 1
        if Config.Settings.PrintJoin then
            Print(Player.id .. " | has joined")
        end
    else
        for i,v in pairs(PlayerIdTable) do
            if v == Player.id then
                table.remove(PlayerIdTable, i)
                PlayerHouse[Player.gender][2] = PlayerHouse[Player.gender][2] - 1
                PlayerHouse[Player.house][2] = PlayerHouse[Player.house][2] - 1
                if Config.Settings.PrintLeave then
                    Print(Player.id .. " | has left")
                end
            end
        end
    end

    if Config.Settings.PrintPlayerCount then
        print("There are " .. #PlayersTable .. " players connected")
    end
    if Config.Settings.PrintGenderCount then
        print("Gender Count:")
        print(json.encode(PlayerGender))
    end
    if Config.Settings.PrintHouseCount then
        print("House Count:")
        print(json.encode(PlayerGender))
    end
end