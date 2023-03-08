local registeredCommands = {}

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
                return true
            end
        end
    end
    return false
end

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
end)
