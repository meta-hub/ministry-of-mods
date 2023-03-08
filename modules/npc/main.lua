local Peds = {}

--[[
    Functions
]]

function CreatePed(gender, gear, features, house, spawnPos)
    local Ped = server.npc_manager:Create()
    Ped.gender = gender
    Ped.house = house

    local time_point = Ped.time_point
    local movement = time_point.movement
    movement.position.x = spawnPos.x
    movement.position.y = spawnPos.y
    movement.position.z = spawnPos.z
    movement.speed = 0
    time_point.movement = movement
    Ped.time_point = time_point

    local item = GearItem.new()
    local setGear = Ped.gear
    for i,v in pairs(gear) do
        item.id = v
        setGear:add(item)
    end
    Ped.gear = setGear

    local preset = AvatarPreset.new()
    local presets = Ped.presets
    for i,v in pairs(features) do
        preset.name = v
        presets:add(preset)
    end
    Ped.presets = presets

    server.npc_manager:Spawn(Ped)
    table.insert(Peds, Ped)
    return Ped
end

local function RemovePed(Ped)
    for i,v in pairs(Peds) do
        if v == Ped then
            server.npc_manager:Remove(Ped)
            table.remove(Peds, i)
            return false
        end
    end
end

--[[
    Exports
]]

Exports("CreatePed", CreatePed)

Exports("RemovePed", RemovePed)

Exports("GetSpawnedPeds", function()
    return Peds
end)