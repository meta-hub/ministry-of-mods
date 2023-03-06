-- string:byte (s [, i [, j]])
-- string:char (···)
-- string:dump (function)
-- string:find (s, pattern [, init [, plain]])
-- string:format (formatstring, ···)
-- string:gmatch (s, pattern)
-- string:gsub (s, pattern, repl [, n])
-- string:len (s)
-- string:lower (s)
-- string:match (s, pattern [, init])
-- string:rep (s, n)
-- string:reverse (s)
-- string:sub (s, i [, j])
-- string:upper (s)

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
