guthlevelsystem = guthlevelsystem or {}

local _xp = 0
hook.Add( "HUDPaintBackground", "guthlevelsystem:HUD", function()
    local should = hook.Run( "HUDShouldDraw", "guthlevelsystem:HUD" )
    if should == false then return end

    local ply = LocalPlayer()
    if not IsValid( ply ) then return end

    _xp = Lerp( FrameTime() * 5, _xp or 0, ply:GetNWInt( "guthlevelsystem:XP", 0 ) )

    local lvl = guthlevelsystem.HUDTextLVL .. string.format( "%d", ply:GetNWInt( "guthlevelsystem:LVL", 0 ) )
    local xp = guthlevelsystem.HUDLVLPercentage and guthlevelsystem.HUDTextXP .. string.format( "%d", _xp / ply:GetNWInt( "guthlevelsystem:NXP", 0 ) * 100 ) .. "%"
               or guthlevelsystem.HUDTextXP .. string.format( "%d/%d", _xp, ply:GetNWInt( "guthlevelsystem:NXP", 0 ) )

    draw.SimpleText( lvl, guthlevelsystem.HUDFont, guthlevelsystem.HUDXLVL, guthlevelsystem.HUDYLVL, Color( 255, 255, 255 ) )
    draw.SimpleText( xp, guthlevelsystem.HUDFont, guthlevelsystem.HUDXXP, guthlevelsystem.HUDYXP, Color( 255, 255, 255 ) )
end )
if not guthlevelsystem.DrawHUD then hook.Remove( "HUDPaintBackground", "guthlevelsystem:HUD" ) end
 
hook.Add( "OnPlayerChat", "guthlevelsystem:level", function( ply, text )
    if not ( ply == LocalPlayer() ) then return end
    if not text:StartWith( guthlevelsystem.CommandChat ) then return end

    local args = {
        lvl = ply:GetNWInt( "guthlevelsystem:LVL", 0 ),
        xp = ply:GetNWInt( "guthlevelsystem:XP", 0 ), 
        nxp = ply:GetNWInt( "guthlevelsystem:NXP", 0 ),
    }
    args.percent = math.floor( args.xp / args.nxp * 100 )

    --  format text with colors
    local formatted_text, word = {}, ""

    local function format_word( word )
        local key = word:match( "^{(.+)}$" )
        if key then
            word = tostring( args[key] or "?" )
            formatted_text[#formatted_text + 1] = guthlevelsystem.CommandHighlightColor
        else
            formatted_text[#formatted_text + 1] = color_white
        end
        formatted_text[#formatted_text + 1] = word
    end

    for l in guthlevelsystem.CommandFormatMessage:gmatch( "." ) do
        local force_implement = false
        if l == "{" and #word > 0 then
            format_word( word )
            word = ""
        end
        
        word = word .. l
        if l == " " or l == "}" then
            format_word( word )
            word = ""
        end
    end

    if #word > 0 then
        format_word( word )
    end

    chat.AddText( guthlevelsystem.CommandHighlightColor, "[LEVEL] ", unpack( formatted_text ) )
    return true
end )

print( "Loaded succesfully" )
