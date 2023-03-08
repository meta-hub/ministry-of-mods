<<<<<<< Updated upstream
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

function string:split(sep, iter)
    if iter then
        local pattern = sep:format("([^%s]+)")
        return self:gmatch(pattern)
    else
        local result = {}
        local pattern = sep:format("([^%s]+)")
        for token in self:gmatch(pattern) do
            table.insert(result, token)
        end
        return result
    end
end
=======
function string:split(sep)
    return self:gmatch(sep or "%S+")
end

function string:splitT(sep)
    sep = sep or "%S+"

    local ret = {}

    for str in self:gmatch(sep) do
        ret[#ret+1] = str
    end

    return ret
end

function string:toHex()
    return self:gsub('.', function(c)
        return string.format('%02X', c:byte())
    end)
end

function string:fromHex()
    return self:gsub('..', function(cc)
        return string.char(tonumber(cc, 16))
    end)
end
>>>>>>> Stashed changes
