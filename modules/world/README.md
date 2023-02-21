# World Module

This module at the moment regulates the world
- Optional Print for when the World Syncs,
- Optional Use your local time in-game
- Freeze Time and or Weather ( So it never changes )
- Set how often the world syncs between players,
- Set how often the world changes the weather,
- Make time move faster per second
- Fully config starting Time and Weather

## For Developers

For those who need to control weather outside of this resource, use
```LUA
    local ExampleTable = {
        hour = 12,
        minute = 43,
        --second = 12,
        day = 24,
        --month = 4,
        year = 1000
    }
    TriggerEvent('mom:world:SetWorldData', ExampleTable)

    TriggerEvent('mom:world:SyncWorldData') -- Forces the world to sync between players

    -- EXAMPLE: If FreezeTime is on and you execute the trigger below, it will turn it off and vice versa. Same applies to Freeze Weather. Can include a BOOL to force a state.
    TriggerEvent('mom:world:FreezeTime', false) -- Forces the time to unfreeze
    TriggerEvent('mom:world:FreezeWeather') -- Forces the weather to freeze
```