# Discord Module

This module at the moment **IS NOT FUNCTIONAL**
- This *will* manage the discord webhook

## For Developers

### Exports
```LUA
    Exports.discord.LogToDiscord(name, title, color, message, tagEveryone)
```

### Example
```LUA
    local name = "player" -- This is the name of the Webhook found in Config
    local title = "" -- This is if you wish to include a title
    local color = {r = 255, g = 0, b = 0} -- This sets the color of the embed

    -- These are examples of message body setups and how you set up the message is purely up to you!
    local Player = {id = 1234, gender = 0, house = 3}
    local Action = "Ban"
    local Reason = "Exploiting"

    local message = Player.id .. " has Joined"

    local message = [[**Player Name:** ]] .. Player.id .. "\n"
        .. [[**Action:** ]] .. Action .. "\n"
        .. [[**Reason:** ]] .. Reason,

    local tagEveryone = true -- Set to true or false
    Exports.discord.LogToDiscord(name, title, color, message, tagEveryone)
```