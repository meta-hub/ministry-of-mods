<<<<<<< Updated upstream
function table:concat(sep, i, j)
    return table.concat(self, sep, i, j)
end

function table:insert(pos, value)
    table.insert(self, pos, value)
end

function table:maxn()
    return table.maxn(self)
end

function table:remove(pos)
    return table.remove(self, pos)
end

function table:sort(decen)
    if decen then
        return table.sort(self, function(a, b) return a > b end)
    else
        return table.sort(self)
    end
end

function table:clear()
    for k in pairs(self) do
        self[k] = nil
    end
end

function table:find(value, path)
    path = path or {}
    for i, v in ipairs(self) do
        if type(v) == "table" then
            local subpath = v:find(value, path)
            if subpath then
                table.insert(subpath, 1, i)
                return subpath
            end
        elseif v == value then
            table.insert(path, i)
            return path
        end
    end
    return nil
end
=======
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
>>>>>>> Stashed changes
