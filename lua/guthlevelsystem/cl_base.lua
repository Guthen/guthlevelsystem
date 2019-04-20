LEVELSYSTEM = LEVELSYSTEM or {}

local function load()
    print( "--->GU-LEVELSYSTEM<---" )

    print( "Loading : Configuration" )
    include( "guthlevelsystem/sh_config.lua" )

    print( "Loading : HUD" )
    include( "guthlevelsystem/cl_hud.lua" )

    print( "------->LOADED<-------" )
end

local function notifPlayer()
    local msg = net.ReadString()
    local type = net.ReadInt( 32 )

    surface.PlaySound( LEVELSYSTEM.NotificationSound )
    notification.AddLegacy( msg, type, 3 )
end
net.Receive( "LEVELSYSTEM:SendNotif", notifPlayer )

load()
