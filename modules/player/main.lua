local Lang = LoadResource("locales").Fetch()

local PlayersTable = {}

local PlayerGender = {
    [1] = {Lang.sex_a, 0},
    [2] = {Lang.sex_f, 0},
    [3] = {Lang.sex_m, 0},
}

local PlayerHouse = {
    [1] = {Lang.house_g, 0},
    [2] = {Lang.house_h, 0},
    [3] = {Lang.house_r, 0},
    [4] = {Lang.house_s, 0},
    [5] = {Lang.house_u, 0},
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
            print(string.format(Lang.player_joining, Player.id))
        end
    else
        for i,v in pairs(PlayerIdTable) do
            if v == Player.id then
                table.remove(PlayerIdTable, i)
                PlayerHouse[Player.gender][2] = PlayerHouse[Player.gender][2] - 1
                PlayerHouse[Player.house][2] = PlayerHouse[Player.house][2] - 1
                if Config.Settings.PrintLeave then
                    print(string.format(Lang.player_leaveing, Player.id))
                end
            end
        end
    end

    if Config.Settings.PrintPlayerCount then
        print(string.format(Lang.current_players, #PlayersTable))
    end
    if Config.Settings.PrintGenderCount then
        print(Lang.gender_count)
        print(json.encode(PlayerGender))
    end
    if Config.Settings.PrintHouseCount then
        print(Lang.house_count)
        print(json.encode(PlayerGender))
    end
end