local registeredCommands = {}

local function getPlayerPermissions(playerId)
    for uid,player in pairs(--[[PlayersData]]) do
        if player.id == playerId then
            return player
        end
    end
end

local function hasPermissions(playerPerms, requiredPerms)
    for _,playerPerm in ipairs(playerPerms) do
        for _,requiredPerm in ipairs(requiredPerms) do
            if playerPerm == requiredPerm then
                return true
            end
        end
    end
    return false
end

local function onCommand(playerId, cmdName, args)
    if not registeredCommands[cmdName] then return end

    local playerPerms = getPlayerPermissions(playerId)
    local requiredPerms = registeredCommands[cmdName].permissions
    if not hasPermissions(playerPerms, requiredPerms) then return end

    registeredCommands[cmdName].callback(playerId, args)
end

local function registerCommand(cmdName, callback, permissions)
    if type(cmdName) == "table" and cmdName ~= {} then
        for _,identity in pairs(cmdName) do
            if identity ~= "" then
                registeredCommands[identity] = {
                    callback = callback,
                    permissions = permissions
                }
            end
        end
    elseif type(cmdName) == "string" and cmdName ~= "" then
        registeredCommands[cmdName] = {
            callback = callback,
            permissions = permissions
        }
    end
end

Exports("RegisterCommand", registerCommand)

RegisterForEvent("chatmessage", function(player, message)
    local isCommand = message:sub(0,1) == Config.Prefix
    if not isCommand then return end

    local args = string.split(message)
    local cmdName = args[1]
    table.remove(args, 1)

    onCommand(player.id, cmdName, args)
end)
