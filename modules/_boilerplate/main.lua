local players = {}

RegisterForEvent("player_joined", function(player)
    print("Player connected", player.id)
end)

RegisterForEvent("player_left", function(player)
    print("Player disconnected", player.id)
end)