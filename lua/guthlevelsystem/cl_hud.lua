guthlevelsystem = guthlevelsystem or {}

local ply = LocalPlayer()

local _xp = 0

hook.Add( "HUDPaintBackground", "guthlevelsystem:HUD", function()
    local should = hook.Run( "HUDShouldDraw", "guthlevelsystem:HUD" )
    if should == false then return end

    ply = LocalPlayer()

    if not ply:IsValid() then ply = LocalPlayer() return end

    _xp = Lerp( FrameTime()*5, _xp or 0, ply:GetNWInt( "guthlevelsystem:XP", 0 ) )

    local lvl = guthlevelsystem.HUDTextLVL .. string.format( "%d", ply:GetNWInt( "guthlevelsystem:LVL", 0 ) )
    local xp = guthlevelsystem.HUDLVLPercentage and guthlevelsystem.HUDTextXP .. string.format( "%d", _xp/ply:GetNWInt( "guthlevelsystem:NXP", 0 )*100 ) .. "%"
               or guthlevelsystem.HUDTextXP .. string.format( "%d/%d", _xp, ply:GetNWInt( "guthlevelsystem:NXP", 0 ) )

    draw.SimpleText( lvl, guthlevelsystem.HUDFont, guthlevelsystem.HUDXLVL, guthlevelsystem.HUDYLVL, Color( 255, 255, 255 ) )
    draw.SimpleText( xp, guthlevelsystem.HUDFont, guthlevelsystem.HUDXXP, guthlevelsystem.HUDYXP, Color( 255, 255, 255 ) )
end )
if not guthlevelsystem.DrawHUD then hook.Remove( "HUDPaintBackground", "guthlevelsystem:HUD" ) end

print( "Loaded succesfully" )
