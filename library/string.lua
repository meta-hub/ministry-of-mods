function string:upper()
    return string.upper(self)
end

function string:lower()
    return string.lower(self)
end

function string:len()
    return #self
end

function string:format(...)
    return string.format(self, ...)
end

function string:match(pattern)
    return string.match(self, pattern)
end

function string:gmatch(pattern)
    local iterator = self:gmatch(pattern)
    return function()
        return iterator()
    end
end

function string:sub(startPos, endPos)
    return string.sub(self, startPos, endPos)
end

function string:gsub(pattern, replace)
    local new_str = self
    new_str = new_str:gsub(pattern, replace)
    return new_str
end

function string:find(pattern, init, plain)
    local start_pos, end_pos = string.find(self, pattern, init, plain)
    if start_pos ~= nil and end_pos ~= nil then
        return start_pos, end_pos
    else
        return nil
    end
end

-- Depends on pre-existing functions

function string:reverse()
    local reversed = ""
    for i = #self, 1, -1 do
        reversed = reversed .. self:sub(i, i)
    end
    return reversed
end

function string:split(separator)
    local result = {}
    pattern = string.format("([^%s]+)", separator)
    for token in self:gmatch(pattern) do
        table.insert(result, token)
    end
    return result
end