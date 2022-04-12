util.AddNetworkString( "guthlevelsystem:SendNotif" )

guthlevelsystem = guthlevelsystem or {}

local function load()
    guthlevelsystem.Print( "Loading sh_config.lua" )
    include( "guthlevelsystem/sh_config.lua" )

    guthlevelsystem.Print( "Loading sv_data.lua" )
    include( "guthlevelsystem/sv_data.lua" )
    guthlevelsystem.CreateDataTable()

    guthlevelsystem.Print( "Loading sv_players.lua" )
    include( "guthlevelsystem/sv_players.lua" )

    guthlevelsystem.Print( "Loading sv_hooks.lua" )
    include( "guthlevelsystem/sv_hooks.lua" )

    guthlevelsystem.Print( "Loading sh_commands.lua" )
    include( "guthlevelsystem/sh_commands.lua" )

    guthlevelsystem.Print( "Sending files" )
    AddCSLuaFile( "guthlevelsystem/sh_config.lua" )
    AddCSLuaFile( "guthlevelsystem/sh_commands.lua" )

    AddCSLuaFile( "guthlevelsystem/cl_base.lua" )
    AddCSLuaFile( "guthlevelsystem/cl_hud.lua" )

    local path = "guthlevelsystem/hud/"
    for i, v in ipairs( file.Find( path .. "*.lua", "LUA" ) ) do
        guthlevelsystem.Print( "Sending hud/%s", v )
        AddCSLuaFile( path .. v )
    end

    hook.Run( "guthlevelsystem:OnLoaded" )
end

function guthlevelsystem.Notif( txt )
    print( "[guthlevelsystem] - " .. txt )
end

load()
