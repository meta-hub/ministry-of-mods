local json = require("json")

local eventHandlers = {}
local exports = {}

function AddEventHandler(eventName, callback)
    if type(eventName) ~= "string" then
        return error("AddEventHandler requires string for first arg")
    elseif type(callback) ~= "function" then
        return error("AddEventHandler requires a function for the second arg")
    end

    eventHandlers[eventName] = eventHandlers[eventName] or {}
    eventHandlers[eventName][#eventHandlers[eventName]+1] = callback
end

function TriggerEvent(eventName, ...)
    if type(eventName) ~= "string" then
        return error("TriggerEvent requires string for first arg")
    end

    if not eventHandlers[eventName] then
        return
    end

    for _,fn in pairs(eventHandlers[eventName]) do
        fn(...)
    end
end

Exports = {}

setmetatable(Exports, {
    __index = function(self, resourceName)
        if type(resourceName) ~= "string" then
            return error("Exports must be indexed with a string value")
        end

        if not exports[resourceName] then
            return {}
        end
        
        return setmetatable({}, {
            __index = function(self, exportName)
                if type(exportName) ~= "string" then
                    return error("Exports methods must be indexed with a string value")
                end

                return exports[resourceName][exportName]
            end
        })
    end,

    __call = function(self, exportName, fn)
        if type(exportName) ~= "string" then
            return error("Export definition requires string as the first argument")
        elseif type(fn) ~= "function" then
            return error("Export definition requires function as the second argument")
        end

        local resourceName = getfenv(2)._RESOURCE

        exports[resourceName] = exports[resourceName] or {}
        exports[resourceName][exportName] = fn
    end
})

local function createEnvironment(resourceName, version)
    local env = {}

    local gProt = {
        _RESOURCE = resourceName,
        _VERSION = version
    }
    
    env._G = _G
    env._ENV = setmetatable(env, {
        __index = function(self, k)
            if gProt[k] == nil then
                return _G[k]
            end

            return gProt[k]
        end,

        __newindex = gProt
    })

    return env
end

local function fileExists(path)
    local file = io.open(path, "r")

    if file then
        file:close()
    end

    return file ~= nil
end

local function readFile(path)
    local file = io.open(path, "r")

    if file == nil then
        return nil
    end

    local code = file:read("*a")

    file:close()
    
    return code
end

local function loadScript(code, filePath, environment, ...)    
    local _,fn,err = pcall(load, code, filePath, 'bt', environment)

    if err then
        return false,err
    end

    if type(fn) ~= "function" then
        return false
    end

    local res,ret = pcall(fn, ...)

    if not res then
        return false,ret
    end

    return ret
end

local loadedResources = {}

local function handleReturn(resourceName, options, globalTable)
    if not next(globalTable) then
        return nil
    end

    if options.injectGlobal then
        getfenv(2)[resourceName] = globalTable
    else
        return globalTable
    end
end

function LoadResource(resourceName, options)
    options = options or {}

    if loadedResources[resourceName] then
        return handleReturn(resourceName, options, loadedResources[resourceName])
    end

    options = options or {}

    local versionPath = options.version and ("/" .. options.version) or ""
    local resourcePath = "modules/" .. resourceName .. versionPath
    local entryFilePath = resourcePath .. "/resource.json"

    if not fileExists(entryFilePath) then
        return error("resource does not contain resource.json entry file: " .. resourceName)
    end

    local entryFileContent = readFile(entryFilePath)
    local resourceDef = json.decode(entryFileContent)
    
    if not resourceDef then
        return error("resource has invalid resource.json entry file: " .. resourceName)
    end

    local env = options.env or createEnvironment(resourceName, options.version or "default")

    local globalTable = {}

    for _,fileName in ipairs(resourceDef) do
        local filePath = resourcePath .. "/" .. fileName .. ".lua"

        if not fileExists(filePath) then
            return error("defined file does not exist: " .. filePath)
        end

        local code = readFile(filePath)

        if not code then
            return error("invalid file content for: " .. filePath)
        end

        local res,err = loadScript(code, filePath, env)

        if err then
            return error(err)
        end

        if type(res) == "table" then
            for k,v in pairs(res) do
                globalTable[k] = v
            end
        elseif type(res) == "function" then
            globalTable[fileName] = res
        end
    end

    loadedResources[resourceName] = globalTable

    handleReturn(resourceName, options, globalTable)
end

function LoadData(resourceName, filePath)
    local path = "modules/" .. resourceName .. "/" .. filePath

    if not fileExists(path) then
        return error("invalid file: " .. path)
    end

    local content = readFile(path)
    
    return json.decode(content)
end

local initResourceFilePath = "resources.json"

if not fileExists(initResourceFilePath) then
    return error("resources.json is not present in root directory")
end

local initResources = json.decode(readFile(initResourceFilePath))

if type(initResources) ~= "table" then
    return error("failed to parse resources.json file")
end

for _,resourceDef in ipairs(initResources) do
    LoadResource(resourceDef.name, resourceDef.options)
end