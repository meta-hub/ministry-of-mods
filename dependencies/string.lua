function string:split(sep)
    sep = sep or " "

    local pattern = string.format("([^%s]+)", sep)

    return self:gmatch(pattern)
end

function string:splitT(sep)
    sep = sep or " "

    local pattern = string.format("([^%s]+)", sep)

    local ret = {}

    for str in self:gmatch(pattern) do
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