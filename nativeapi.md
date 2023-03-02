
##
**Server.**
- world
- - :RpcSet()
- - .hour
- - .minute
- - .second
- - .year
- - .month
- - .day
- - .season
- - .weather

- player_manager
- - :GetByConnectionId()
- - :GetById()
- - .count

- npc_manager
- - :GetById()
- - :Create()
- - :Remove()
- - :Spawn()
- - .count

**Events**
- "init"

- "update"
- - DeltaTime

- "shutdown"

- "player_joined"
- - Player

- "player_left"
- - Player

**Player**
- .connection (identifier)
- *inherits variables and functions from Character*

**Npc**
- :RpcApplyMovement()
- *inherits variables and functions from Character*

**Character**
- .id

- .gear
- - :add(GearItem.new())
- - - .id
- - - .variation
- - - .equipped
- - - .slot

- .gender

- .house

- .time_point
- - .tick
- - .movement
- - - .position
- - - - .x, .y, .z
- - - .speed

- .presets
- - :add(AvatarPreset.new())
- - - .name
