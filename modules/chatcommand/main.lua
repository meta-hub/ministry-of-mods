local registeredCommands = {}

<<<<<<< Updated upstream
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
=======
--[[
    Functions
]]

function checkPerm(Player, ReqPerms)
    local pData = Exports.player.getPlayerData(Player)
    local pPermissions = pData.permissions
    if type(ReqPerms) == "string" then
        ReqPerms = {ReqPerms}
    end
    for _,pPerms in pairs(pPermissions) do
        for _,rPerms in pairs(ReqPerms) do
            if pPerms == rPerms then
>>>>>>> Stashed changes
                return true
            end
        end
    end
    return false
end

<<<<<<< Updated upstream
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
=======
function onCommand(Player, cmdName, args)
    local cmd = registeredCommands[cmdName]
    if not cmd then return end
    if not checkPerm(Player, cmd.permissions) then return end
    cmd.callback(Player, args)
end

function registerCommand(cmdNames, callback, permissions)
    if type(cmdNames) == "string" then
        cmdNames = {cmdNames}
    end
    for _, cmdName in ipairs(cmdNames) do
        if cmdName ~= "" then
            registeredCommands[cmdName] = {
                callback = callback,
                permissions = permissions
            }
        end
    end
end

--[[
    Exports
]]

Exports("RegisterCommand", registerCommand)

--[[
    Events
]]

RegisterForEvent("chatmessage", function(Player, message)
    local isCommand = message:sub(0,1) == Config.Prefix
    if not isCommand then return end
    local args = message:split()
    local cmdName = args[1]
    table.remove(args, 1)
    onCommand(Player, cmdName, args)
>>>>>>> Stashed changes
end)
