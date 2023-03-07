local path = ...

print("Command Prompt")

while true do
    local res = io.read()
    local file = io.open(path .. "/modules/ghetto_cli/output.txt", "w")

    if file then
        file:write(res)
        file:close()
    end
end