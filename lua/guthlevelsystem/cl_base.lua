LEVELSYSTEM = LEVELSYSTEM or {}

local function load()
    print( "--> [guthlevelsystem] <--" )

    print( "Loading : Configuration" )
    include( "guthlevelsystem/sh_config.lua" )

    print( "Loading : HUD" )
    include( "guthlevelsystem/cl_hud.lua" )

    print( "Loading : PANEL" )
    include( "guthlevelsystem/cl_panel.lua" )

    print( "Loading : Commands" )
    include( "guthlevelsystem/sh_commands.lua" )

    print( "-------> LOADED <-------" )
end

local function notifPlayer()
    local msg = net.ReadString()
    local type = net.ReadInt( 32 )
    local snd = net.ReadString()

    surface.PlaySound( snd )
    notification.AddLegacy( msg, type, 3 )
end
net.Receive( "LEVELSYSTEM:SendNotif", notifPlayer )

load()
