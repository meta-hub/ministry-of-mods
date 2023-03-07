-- string:byte(i [, j])
-- string:find(pattern [, init [, plain]])
-- string:format(formatstring, ...)
-- string:gmatch(pattern)
-- string:gsub(pattern, replace [, n])
-- string:lower()
-- string:match(pattern [, init])
-- string:rep(n [, sep])
-- string:reverse()
-- string:sub(i [, j])
-- string:upper()

-- string:len() [[DEPRICATED - USE #]]

-- string.char(...)
-- string.dump(function)

function string:split(separator, useIter)
    if useIter then
        local pattern = separator:format("([^%s]+)")
        return self:gmatch(pattern)
    else
        local result = {}
        local pattern = separator:format("([^%s]+)")
        for token in self:gmatch(pattern) do
            table.insert(result, token)
        end
        return result
    end
end
