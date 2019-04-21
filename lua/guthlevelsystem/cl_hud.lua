LEVELSYSTEM = LEVELSYSTEM or {}

local ply = LocalPlayer()

local lvl = lvl or nil
local xp = xp or nil
local nxp = nxp or nil

hook.Add( "HUDPaintBackground", "LEVELSYSTEM:HUD", function()
    if not ply:IsValid() then ply = LocalPlayer() return end

    local _lvl = string.format( "Level : %d", lvl or 0 )
    local _xp = string.format( "XP : %d/%d", xp or 0, nxp or 0 )

    draw.SimpleText( _lvl, "DermaLarge", 15+LEVELSYSTEM.HUDOffSetX, ScrH()*.76+LEVELSYSTEM.HUDOffSetY, Color( 255, 255, 255 ) )
    draw.SimpleText( _xp, "DermaLarge", 15+LEVELSYSTEM.HUDOffSetX, ScrH()*.8+LEVELSYSTEM.HUDOffSetY, Color( 255, 255, 255 ) )
end )

local function getData()
    lvl = net.ReadInt( 32 ) or 0
    xp = net.ReadInt( 32 ) or 0
    nxp = net.ReadInt( 32 ) or 0

    --print( "Receive data" )
end
net.Receive( "LEVELSYSTEM:SendData", getData )

print( "Loaded succesfully" )
