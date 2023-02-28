# NPCs Module

This module at the moment regulates creating Peds.

## For Developers

This module has 2 exports
```LUA
    Exports.npcs.CreatePed(gender, gear, features, house, spawnPos)
    Exports.npcs.RemovePed(Ped)
```

This is an example of how to create a ped, perhaps use a ped and remove a ped..
```LUA
-- Create a ped
local gear = {
    "Back_112_Legendary",
    "Hand_035_Legendary",
    "Outfit_021_Legendary"
}
local features = {
    "EyebrowColorMale014",
    "EyebrowMale012",
    "EyeColorMale009",
    "MarkingMale000a",
    "MarkingMale001a",
    "MarkingMale002b",
    "MarkingMale003a",
    "HairColorMale001",
    "HairMale011",
    "FaceMale005",
    "SkinColorMale011"
}
local spawnPos = {
    x = 353903,
    y = -466938,
    z = -85208
}

local entity = Exports.npcs.CreatePed(0, gear, features, 2, spawnPos)
local entity2 = Exports.npcs.CreatePed(0, gear, features, 2, spawnPos)

-- Use a ped
local done = false
local distanceFromPoint = 200
CreateThread(function()
    while true do
        if not done then
            done = true
            for i = 1, 200, 1 do
                if not entity2 then return end
                Wait(100)
                local time_point = entity2.time_point
                local movement = time_point.movement
                movement.position.x = spawnPos.x + i
                movement.position.y = spawnPos.y
                movement.position.z = spawnPos.z
                movement.speed = 10
                --movement.direction = math.deg(math.rad(i)) + 90
                time_point.movement = movement
                entity2.time_point = time_point
                entity2:RpcApplyMovement()
            end

            --[[
                Remove a Ped
                Using this export does 2 things.
                    - Move the Ped to a far far away spot.
                    - returns false
                In this example, when you connect to the server you will automatically have this NPC move (untill it gets to 200). IF for example, you called the RemovePed event, while it was in the process of moving the ped, lets say at i = 100,

                it first moves the ped far far away, then clears it from the Peds table, and returns false.
                by setting entity2 = Events.npcs.RemovePed() - the return (which is false) now makes entity 2 = false. By doing so, if the for loop is still firing, the if not statment would prevent the code from executing further code - preventing it from snapping back to where it wants to finish and errors.

                disconnecting will always remove the ped from your world
                upon reconnecting, the ped would still be loaded however, it would maintain its location in far far away - Since everything is serverside.
            ]]
            entity2 = Exports.npcs.RemovePed(entity2)
        end
        for i = 6, 360, 6 do
            if not entity then return end
            Wait(100)
            local xDifference = math.cos(math.rad(i)) * distanceFromPoint
            local yDifference = math.sin(math.rad(i)) * distanceFromPoint
            local time_point = entity.time_point
            local movement = time_point.movement
            movement.position.x = spawnPos.x + xDifference
            movement.position.y = spawnPos.y + yDifference
            movement.position.z = spawnPos.z
            --movement.speed = 0
            movement.direction = math.deg(math.rad(i)) + 90
            time_point.movement = movement
            entity.time_point = time_point
            entity:RpcApplyMovement()
        end
    end
end)
```