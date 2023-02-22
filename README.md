# Ministry of Mods

This is a resource to handle containerization and cross-resource communication for LUA mods in HogWarp. This will be an ongoing project, and compatibility may break alongside HogWarp updates at any given time (beta, woo-hoo).

# Usage

## For Users

- Clone this repository into your `HogwartsLegacy/Server/mods/` directory.
- Check the `resources.json` file to disable any modules you might not want active on your server.
- Start your server, and observer the console. If no errors are present, the resource should now be running.

## For Developers

### Creating a Module

- Add a new folder to the `modules/` directory.
- Ensure the folder name is somewhat descriptive of what your resource intends to do.
- At the root of your modules directory, add a `resource.json` file.
- Inside the `resource.json` file, create an array of file paths to load (excluding `.lua`).
- The load order will be the same as listed in your `resource.json` file.

### Exports and Events

A simple events and exports system has been provided to allow cross-resource communication without the use of `require`.
Exports support return values, events would require a callback function- though both are synchronous.

Exports Example:
```lua
-- To call the `FreezeWeather` export defined in the `world` module:
Exports.world.FreezeWeather(true)

-- To define an export:
Exports("foo", function()
    return "bar"
end)
```
Events Example:
```lua

-- To define an event:
AddEventHandler("myModule:myEvent", function(foo)
    print("myModule:myEvent triggered", foo)
end)

-- To trigger the event:
TriggerEvent("myModule:myEvent", "bar")
```

### Using a Module

To load another module into your resource, two primary methods have been provided.
Both of these methods use the `LoadResource` function, which is able to be referenced in all modules.
The first method retrieves a local reference to the module:

```lua
local myModule = LoadResource("myModule")
```

The second method injects a global (to your resources environment) reference of the resource.
This method will use the resource name as the definition.

```lua
LoadResource("myModule", { injectGlobal = true })
```

We can now access this resources functions as defined within the resource:

```lua
myModule.foo()
```

NOTE: LoadResource **must** be called from the root stack, i.e, not inside a function.

### Loading Data

The `LoadData` function has been provided to load json data files.
You can load data files from any resource.

```lua
-- This example will load the file `modules/myModule/data/myData.json` into a table.
local myData = LoadData("myModule", "data/myData.json")
```

### Versioning

Backward and forward compatibility can be maintained through the use of versioning within modules.
To update your module to a newer release (in this example, version "1.0.0"), follow the example directory layout:

```
myModule /
    resource.json
    main.lua

    1.0.0 /
        main.lua
```

Given the above example structure (all files in root directory, main.lua is the only script), developers can load the new version of your resource like so:

```lua
local myModule = LoadResource("myModule", { version = "1.0.0" })
```

The file structure and version names are arbitrary. The following example would also work:

```
myModule /
    resource.json
    
    bar / 
        main.lua

    foo /
        bar /
            main.lua
```

Given the above example structure (all files in root directory, main.lua is the only script), developers can load the new version of your resource like so:

```lua
local myModule = LoadResource("myModule", { version = "foo" })
```