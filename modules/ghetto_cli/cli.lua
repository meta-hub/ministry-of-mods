print("> CMD")

while true do
    local res = io.read()
    local file = io.open("D:/SteamLibrary/steamapps/common/Hogwarts Legacy/Server/plugins/mom/modules/ghetto_cli/output.txt", "w")

    if file then
        file:write(res)
        file:close()
    end
end