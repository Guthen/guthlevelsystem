guthlevelsystem = guthlevelsystem or {}

local function load()
    guthlevelsystem.Print( "Loading sh_config.lua" )
    include( "guthlevelsystem/sh_config.lua" )

    guthlevelsystem.Print( "Loading cl_hud.lua" )
    include( "guthlevelsystem/cl_hud.lua" )

    guthlevelsystem.Print( "Loading sh_commands.lua" )
    include( "guthlevelsystem/sh_commands.lua" )

    hook.Run( "guthlevelsystem:OnLoaded" )
end

local function notifPlayer()
    local msg = net.ReadString()
    local type = net.ReadInt( 32 )
    local snd = net.ReadString()

    surface.PlaySound( snd )
    notification.AddLegacy( msg, type, 3 )
end
net.Receive( "guthlevelsystem:SendNotif", notifPlayer )

load()