util.AddNetworkString( "guthlevelsystem:SendNotif" )

guthlevelsystem = guthlevelsystem or {}

local function load()
    print( "--> [guthlevelsystem] <--" )

    print( "Loading : Configuration" )
    include( "guthlevelsystem/sh_config.lua" )

    print( "Loading : Data" )
    include( "guthlevelsystem/sv_data.lua" )
    guthlevelsystem.CreateDataTable()

    print( "Loading : Players" )
    include( "guthlevelsystem/sv_players.lua" )

    print( "Loading : Hooks" )
    include( "guthlevelsystem/sv_hooks.lua" )

    print( "Loading : Commands" )
    include( "guthlevelsystem/sh_commands.lua" )

    AddCSLuaFile( "guthlevelsystem/sh_config.lua" )
    AddCSLuaFile( "guthlevelsystem/sh_commands.lua" )

    AddCSLuaFile( "guthlevelsystem/cl_base.lua" )
    AddCSLuaFile( "guthlevelsystem/cl_hud.lua" )

    print( "-------> LOADED <-------" )

    hook.Run( "guthlevelsystem:OnLoaded" )
end

function guthlevelsystem.Notif( txt )
    print( "[guthlevelsystem] - " .. txt )
end

hook.Add( "Initialize", "guthlevelsystem:Load", load )
