local json = require("json")

local eventHandlers = {}
local exports = {}

function AddEventHandler(eventName, callback)
    if type(eventName) ~= "string" then
        return error("AddEventHandler requires string for first arg")
    end

    if type(callback) ~= "function" then
        return error("AddEventHandler requires a function for the second arg")
    end

    eventHandlers[eventName] = eventHandlers[eventName] or {}
    eventHandlers[eventName][#eventHandlers[eventName]+1] = callback
end

function TriggerEvent(eventName, ...)
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
        return exports[resourceName]
    end,

    __call = function(self, fnName, fn)
        local resourceName = getfenv(2)._RESOURCE

        exports[resourceName] = exports[resourceName] or {}
        exports[resourceName][fnName] = fn
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

function LoadResource(resourceName, options)
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

    local alias = options.injectionAlias or resourceName
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

    if not next(globalTable) then
        return nil
    end

    if options.injectGlobal then
        _G[alias] = globalTable
    else
        return globalTable
    end
end

function LoadData(resourceName, filePath)
    local path = "modules/" .. resourceName .. "/" .. filePath

    if not fileExists(path) then
        return error("invalid file: " .. path)
    end

    local content = readFile(path)
    
    return json.decode(content)
end

local initResources = json.decode(readFile(("resources.json")))

if type(initResources) ~= "table" then
    return
end

for _,resourceDef in ipairs(initResources) do
    LoadResource(resourceDef.name, resourceDef.options)
end