function table:insert(value)
    table.insert(self, value)
end

function table:find(value)
    for i, v in ipairs(self) do
        if v == value then
            return i
        end
    end
    return nil
end

function table:remove(value)
    for i, v in ipairs(self) do
        if v == value then
            table.remove(self, i)
            return true
        end
    end
    return false
end

function table:clear()
    for k in pairs(self) do
        self[k] = nil
    end
end