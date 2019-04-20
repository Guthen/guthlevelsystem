LEVELSYSTEM = LEVELSYSTEM or {}

local ply = LocalPlayer()

local lvl = 0
local xp = 0
local nxp = 0

hook.Add( "HUDPaintBackground", "LEVELSYSTEM:HUD", function()
    if not ply:IsValid() then ply = LocalPlayer() return end

    local _lvl = string.format( "Level : %d", lvl )
    local _xp = string.format( "XP : %d/%d", xp, nxp )

    draw.SimpleText( _lvl, "DermaLarge", 15, ScrH()*.76, Color( 255, 255, 255 ) )
    draw.SimpleText( _xp, "DermaLarge", 15, ScrH()*.8, Color( 255, 255, 255 ) )
end )

local function getData()
    lvl = net.ReadInt( 32 ) or 0
    xp = net.ReadInt( 32 ) or 0
    nxp = net.ReadInt( 32 ) or 0
end
net.Receive( "LEVELSYSTEM:SendData", getData )

print( "Loaded succesfully" )
