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