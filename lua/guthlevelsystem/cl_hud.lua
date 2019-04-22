LEVELSYSTEM = LEVELSYSTEM or {}

local ply = LocalPlayer()

local _xp = 0

hook.Add( "HUDPaintBackground", "LEVELSYSTEM:HUD", function()
    ply = LocalPlayer()

    if not ply:IsValid() then ply = LocalPlayer() return end

    _xp = Lerp( FrameTime()*5, _xp or 0, ply:GetNWInt( "LEVELSYSTEM:XP", 0 ) )

    local lvl = string.format( "Level : %d", ply:GetNWInt( "LEVELSYSTEM:LVL", 0 ) )
    local xp = string.format( "XP : %d/%d", _xp, ply:GetNWInt( "LEVELSYSTEM:NXP", 0 ) )

    draw.SimpleText( lvl, LEVELSYSTEM.HUDFont, LEVELSYSTEM.HUDXLVL, LEVELSYSTEM.HUDYLVL, Color( 255, 255, 255 ) )
    draw.SimpleText( xp, LEVELSYSTEM.HUDFont, LEVELSYSTEM.HUDXXP, LEVELSYSTEM.HUDYXP, Color( 255, 255, 255 ) )
end )

print( "Loaded succesfully" )
