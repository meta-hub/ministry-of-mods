function string:split(separator)
    local result = {}
    pattern = string.format("([^%s]+)", separator)
    for token in self:gmatch(pattern) do
        table.insert(result, token)
    end
    return result
end