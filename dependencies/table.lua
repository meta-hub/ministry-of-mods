local function riter(t, i)
    i = i - 1
    
    if i > 0 then
        return i, t[i]
    end
end

function irpairs(t)
    return riter, t, #t + 1
end

function table:find(element)
    for k,v in pairs(self) do
        if v == element then
            return k
        end
    end
end

function table:contains(element)
    for k,v in pairs(self) do
        if v == element then
            return true
        end
    end

    return false
end

function table:search(cb)
    for k,v in pairs(self) do
        if cb(k,v) then
            return k,v
        end
    end
end

function table:clone()
    local ret = {}

    for k,v in pairs(self) do
        ret[k] = v
    end

    return ret
end

function table:cloneDeep()
    local ret = {}

    for k,v in pairs(self) do
        if type(v) == "table" then
            ret[k] = table.cloneDeep(v)
        else
            ret[k] = v
        end
    end

    return ret
end

function table:len()
    local n = 0
    
    for k,v in pairs(self) do
        n = n + 1
    end

    return n
end

function table:clear()
    for k,v in pairs(self) do
        self[k] = nil
    end
end