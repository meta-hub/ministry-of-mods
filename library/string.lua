--[[
    string:byte
    string:char
    string:dump
    string:find
    string:format
    string:gmatch
    string:gsub
    string:len
    string:lower
    string:match
    string:rep
    string:reverse
    string:sub
    string:upper
]]

function string:split(separator)
    local result = {}
    pattern = separator:format("([^%s]+)")
    for token in self:gmatch(pattern) do
        table.insert(result, token)
    end
    return result
end