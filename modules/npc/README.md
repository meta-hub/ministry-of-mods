# NPCs Module

This module regulates creating NPCs

## For Developers

### Exports
```LUA
    Exports.npc.CreatePed(gender, gear, features, house, spawnPos)
    Exports.npc.RemovePed(Ped)
    Exports.npc.GetSpawnedPeds()
```

### Example
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

local entity = Exports.npc.CreatePed(0, gear, features, 2, spawnPos)
local entity2 = Exports.npc.CreatePed(0, gear, features, 2, spawnPos)

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
            -- Remove a ped
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