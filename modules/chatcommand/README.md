# Chat Command Module

This module at the moment **IS NOT FUNCTIONAL**
- This *will* manage Chat Commands

## For Developers

### Exports
```LUA
    Exports.chatcommand.RegisterCommand(cmdName, callback, permissions)
```

### Examples
```LUA
    Exports.chatcommand.RegisterCommand({"tp", "teleport"}, function(Player, args)
        print(Player)
    end, {"admin", "teacher"})

    Exports.chatcommand.RegisterCommand("example", function(Player, args)
        print(Player)
    end, "mod")
```
