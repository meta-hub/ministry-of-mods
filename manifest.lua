
language 'en'

author 'Brayden#2812 (Ministry of Mods)'
contributors {
    "BrianTU#0001 (world, player, npc, discord)",
}
description 'Ministry of Mods is a ...'
version '1.0.0'

modules {
    {name = "discord", options = {version = nil, env = nil}},
    {name = "world"},
    {name = "player"},
    {name = "npc"},
}

--[[
    This is an example of the options a manifest can provide.
    language 'en'

    author 'Bob' or authors {'Eric', 'Kyle', 'Stan', 'Kenny'}

    contributor 'Bob' or contributors {'Eric', 'Kyle', 'Stan', 'Kenny'}

    description 'this is an example'

    version '1.0.0'

    modules {'world', 'player', 'npc'}
]]