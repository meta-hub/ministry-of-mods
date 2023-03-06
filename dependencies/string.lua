function string:split(sep)
    return self:gmatch(sep or "%s")
end

function string:splitT(sep)
    sep = sep or "%s"

    local ret = {}

    for str in self:gmatch(sep) do
        ret[#ret+1] = str
    end

    return ret
end