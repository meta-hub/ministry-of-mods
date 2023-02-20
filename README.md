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

Exports Example:
```lua
-- To call the `_T` export defined in the `locales` module:
print(Exports.locales._T("player_connected"))

-- To define an export:
Exports("myExport", function(arg)
    if arg then
        return Foo
    end
    
    return Bar
end)
```
Events Example:
```lua
-- To trigger the `setWeather` event defined in the `world` module:
TriggerEvent("world:setWeather", "Rainy01")

-- To define an event:
AddEventHandler("myEvent", function(foo)
    print(bar)
end)
```

### Using a Module

- TBC

### Loading Data

- TBC

### Versioning

- TBC