local function load()
    print( "--->GU-LEVELSYSTEM<---" )

    print( "Loading : Configuration" )
    include( "guthlevelsystem/sh_config.lua" )

    print( "Loading : Players" )
    include( "guthlevelsystem/sv_players.lua" )

    print( "Loading : Hooks" )
    include( "guthlevelsystem/sv_hooks.lua" )

    AddCSLuaFile( "guthlevelsystem/sh_config.lua" )
    AddCSLuaFile( "guthlevelsystem/cl_base.lua" )

    print( "------->LOADED<-------" )
end

load()
