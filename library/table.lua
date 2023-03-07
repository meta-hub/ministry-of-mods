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

function table:sort(decending)
    if decending then
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
