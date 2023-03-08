_G._PATH = io.popen("cd"):read("*l")

--
-- Globalize JSON
--

require("dependencies/json")

--
-- LUA Extensions
--

require("dependencies/string")
require("dependencies/table")
require("dependencies/math")

--
-- File Validation
--

function fileExists(path)
    local file = io.open(path, "r")

    if file then
        file:close()
    end

    return file ~= nil
end

function readFile(path)
    local file = io.open(path, "r")

    if file == nil then
        return nil
    end

    local code = file:read("*a")

    file:close()

    return code
end

function writeFile(path, str)
    local file = io.open(path, "w+")

    if file == nil then
        return nil
    end

    file:write(str)
    file:close()

    return true
end

--
-- Global Config
--

local globalConfigFilePath = "data/config.json"

if not fileExists(globalConfigFilePath) then
    return error("No global config file found.")
end

local globalConfigString = readFile(globalConfigFilePath) or "[]"
local globalConfig = json.decode(globalConfigString)

--
-- Exports
--

local exports = {}
local exportsMt = {
    __index = function(self, resourceName)
        if type(resourceName) ~= "string" then
            return error("Exports must be indexed with a string value")
        end

        if not exports[resourceName] then
            return error(string.format("No exports defined for %s. Are you sure this resource has been started?"), resourceName)
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

        exports[self._RESOURCE] = exports[self._RESOURCE] or {}
        exports[self._RESOURCE][exportName] = fn
    end
}

--
-- Locales
--

local locales = {}

local function translate(self, labelName)
    if not locales[self._RESOURCE] then
        locales[self._RESOURCE] = LoadData(self._RESOURCE, "locales/" .. globalConfig.locale .. ".json")
    end

    return locales[self._RESOURCE][labelName]
end

local localesMt = {
    __index = translate,
    __call = translate
}

--
-- Resource Loader
--

local loadResource
local loadedResources = {}
local loadResourceMt = {
    __call = function(self, resourceName, options)
        return loadResource(self._g, resourceName, options or {})
    end
}

local function createEnvironment(resourceName, version)
    local _g = {}

    _g._RESOURCE    = resourceName
    _g._VERSION     = version
    _g.LoadResource = setmetatable({ _g = _g }, loadResourceMt)
    _g.Exports      = setmetatable({ _RESOURCE = resourceName }, exportsMt)
    _g.Locale       = setmetatable({ _RESOURCE = resourceName }, localesMt)

    local env = {}

    env._G = _G
    env._ENV = setmetatable(env, {
        __index = function(self, k)
            if _g[k] == nil then
                return _G[k]
            end

            return _g[k]
        end,

        __newindex = _g
    })

    return env
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

local function handleReturn(_g, resourceName, options, globalTable)
    if not next(globalTable) then
        return nil
    end

    if options.injectGlobal then
        _g[resourceName] = globalTable
    else
        return globalTable
    end
end

loadResource = function(_g, resourceName, options)
    local version = options.version or "root"

    if loadedResources[resourceName] and loadedResources[resourceName][version] then
        return handleReturn(_g, resourceName, options, loadedResources[resourceName][version])
    end

    options = options or {}

    local versionPath = options.version and ("/" .. options.version) or ""
    local resourcePath = _PATH .. "/modules/" .. resourceName .. versionPath
    local entryFilePath = resourcePath .. "/resource.json"

    if not fileExists(entryFilePath) then
        return error("resource does not contain resource.json entry file: " .. resourceName)
    end

    local entryFileContent = readFile(entryFilePath)

    if type(entryFileContent) ~= "string" then
        return error("resource has invalid resource.json entry file: " .. resourceName)
    end

    local resourceDef = json.decode(entryFileContent)

    if type(resourceDef) ~= "table" then
        return error("resource has invalid resource.json entry file content: " .. resourceName)
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

    loadedResources[resourceName] = loadedResources[resourceName] or {}
    loadedResources[resourceName][version] = globalTable

    return handleReturn(_g, resourceName, options, globalTable)
end

--
-- Events
--

local eventListeners = {}

function TriggerEvent(eventName, ...)
    if type(eventName) ~= "string" then
        return error("TriggerEvent requires a string [eventName] as the first argument.")
    end

    if not eventListeners[eventName] then
        return
    end

    for _,callback in ipairs(eventListeners[eventName]) do
        CreateThread(callback, ...)
    end
end

function AddEventHandler(eventName, callback)
    if type(eventName) ~= "string" then
        return error("AddEventHandler requires a string [eventName] as the first argument.")
    end

    if type(callback) ~= "function" then
        return error("AddEventHandler requires a function [callback] as the second argument.")
    end

    eventListeners[eventName] = eventListeners[eventName] or {}

    table.insert(eventListeners[eventName], callback)
end

--
-- Native Event Handlers
--

local nativeEventListeners = {}
local nativeListener = registerForEvent

registerForEvent = nil

function RegisterForEvent(eventName, callback)
    if type(eventName) ~= "string" then
        return error("RegisterForEvent requires a string [eventName] as the first argument.")
    end

    if type(callback) ~= "function" then
        return error("RegisterForEvent requires a function [callback] as the second argument.")
    end

    if eventName == "update" then
        return error("The native update event must be listened for with the CreateThread function.")
    end

    if not nativeEventListeners[eventName] then
        local listeners = {}

        nativeListener(eventName, function(...)
            for _,callback in ipairs(listeners) do
                callback(...)
            end
        end)

        nativeEventListeners[eventName] = listeners
    end

    table.insert(nativeEventListeners[eventName], callback)
end

--
-- File Loader
--

function LoadResourceFile(resourceName, filePath)
    if type(resourceName) ~= "string" then
        return error("LoadResourceFile requires a string [resourceName] as the first argument.")
    end

    if type(filePath) ~= "string" then
        return error("LoadResourceFile requires a string [filePath] as the second argument.")
    end

    local path = _PATH .. "/modules/" .. resourceName .. "/" .. filePath

    if not fileExists(path) then
        return error("invalid data file: " .. path)
    end

    local content = readFile(path)

    if type(content) ~= "string" then
        return error("invalid data file content: " .. path)
    end

    return content
end

function SaveResourceFile(resourceName, filePath, content)
    if type(resourceName) ~= "string" then
        return error("SaveResourceFile requires a string [resourceName] as the first argument.")
    end

    if type(filePath) ~= "string" then
        return error("SaveResourceFile requires a string [filePath] as the second argument.")
    end

    if type(content) ~= "string" then
        return error("SaveResourceFile requires a string [content] as the third argument.")
    end

    local path = _PATH .. "/modules/" .. resourceName .. "/" .. filePath

    local result = writeFile(path, content)

    if not result then
        return error("failed writing data to file: " .. path)
    end
end

--
-- Data File Loader
--

function LoadData(resourceName, filePath)
    if type(resourceName) ~= "string" then
        return error("LoadData requires a string [resourceName] as the first argument.")
    end

    if type(filePath) ~= "string" then
        return error("LoadData requires a string [filePath] as the second argument.")
    end

    local content = LoadResourceFile(resourceName, filePath)

    if not content then
        return {}
    end

    return json.decode(content)
end

function SaveData(resourceName, filePath, data)
    if type(resourceName) ~= "string" then
        return error("SaveData requires a string [resourceName] as the first argument.")
    end

    if type(filePath) ~= "string" then
        return error("SaveData requires a string [filePath] as the second argument.")
    end

    if type(data) ~= "table" then
        return error("SaveResourceFile requires a table [data] as the third argument.")
    end

    local content = json.encode(data, { indent = true })

    SaveResourceFile(resourceName, filePath, content)
end

--
-- Thread Tracker
--

local threads = {}

function CreateThread(callback, ...)
    if type(callback) ~= "function" then
        return error("CreateThread requires a function [callback] as the first argument.")
    end

    local thread = {
        coroutine = coroutine.create(callback),
        waitTime = -1,
        prevTime = GetGameTimer(),
        args = {...}
    }

    local function Wait(waitTime)
        thread.waitTime = waitTime
        coroutine.yield(thread.coroutine)
    end

    local env = getfenv(callback)

    local threadMt = setmetatable({}, {
        __index = function(self, k)
            if k == "Wait" then
                return Wait
            else
                return env[k]
            end
        end,

        __newindex = env
    })

    setfenv(callback, threadMt)

    table.insert(threads, thread)
end

function SetTimeout(callback, delay)
    if type(callback) ~= "function" then
        return error("SetTimeout requires a function [callback] as the first argument.")
    end

    if type(delay) ~= "number" then
        return error("SetTimeout requires a number [delay] as the second argument.")
    end

    local thread = {
        coroutine = coroutine.create(callback),
        waitTime = delay,
        prevTime = GetGameTimer(),
        kill = true
    }

    table.insert(threads, thread)
end

local gameTime = 0

function GetGameTimer()
    return math.floor(gameTime * 1000)
end

nativeListener("update", function(deltaTime)
    gameTime = gameTime + deltaTime

    if #threads == 0 then
        return
    end

    local timeNow = GetGameTimer()

    for i=#threads,1,-1 do
        local thread = threads[i]

        if thread.waitTime <= 0 or timeNow - thread.prevTime >= thread.waitTime then
            coroutine.resume(thread.coroutine, table.unpack(thread.args))

            if thread.kill then
                table.remove(threads, i)
            else
                thread.prevTime = timeNow
            end
        end
    end
end)

--
-- Resource Initialization
--

local initResourceFilePath = "data/resources.json"

if not fileExists(initResourceFilePath) then
    return error("resources.json is not present in root directory")
end

local initResources = json.decode(readFile(initResourceFilePath) or "")

if type(initResources) ~= "table" then
    return error("failed to parse resources.json file")
end

for _,resourceDef in ipairs(initResources) do
    loadResource(_G, resourceDef.name, resourceDef.options or {})
end