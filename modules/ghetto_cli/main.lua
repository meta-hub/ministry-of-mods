local commands = {
    test = function(a, b, c)
        print(a, b, c)
    end
}

local function awaitCommand()
    local path = "plugins/mom/modules/ghetto_cli/output.txt"
    local file = io.open(path, "r")

    if file == nil then
        return
    end

    local content = file:read("*a")

    file:close()
    
    local args = {}

    for token in string.gmatch(content, "[^%s]+") do
        table.insert(args, token)
    end

    local cmd = args[1]
    
    if not cmd or not commands[cmd] then
        return
    end

    file = io.open(path, "w+")

    if file == nil then
        return
    end

    file:write("")
    file:close()

    table.remove(args, 1)

    print("Executing command: " .. cmd)

    commands[cmd](table.unpack(args))
end

CreateThread(function()
    local str = 'start %s "plugins/mom/modules/ghetto_cli/cli.lua" "%s"'
    local cmd = str:format(Config.lua_path, _PATH)

    os.execute(cmd)

    while true do
        awaitCommand()
        Wait(2000)
    end
end)