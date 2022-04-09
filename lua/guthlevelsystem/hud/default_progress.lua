local config = {
    SmoothSpeed = 5, --  animation speed for progress box & color changes

    --  box
    BoxY = ScrH() * .025, --  box's Y coordinate; by default set to 2.5% of the screen height  
    BoxW = ScrW() * .2, --  box's width; by default set to 20% of the screen width
    BoxH = ScrH() * .025, --  box's height; by default set to 2.5% of the screen height

    --  progress box
    BoxProgressPadding = 3, --  gap at top, bottom, left & right of progress box
    BoxProgressCornerRadius = 6, --  radius of box's corners; 0: no corner
    BoxProgressColor = Color( 12, 234, 75, 150 ), --  color used in the progression box
    IsBoxProgressColorByTeam = false, --  do we set the progress color to the current player's team color?
                                     --  please note that setting this to true will not take in account BoxProgressColor value 

    --  background box
    BoxBackgroundCornerRadius = 6, --  radius of box's corners; 0: no corner
    BoxBackgroundColor = Color( 130, 130, 130, 150 ), -- box background color

    --  texts
    TextPadding = 8, --  gap at left and right of both texts; default: 8px
    TextLevel = "Level %d", --  level text format; "%d" will be replaced with the level
    TextProgress = "%d%%", --  progress text format; "%d" will be replaced with the xp percent & "%%" will become automatically a "%"
    TextFont = "Trebuchet22", --  font of both texts, see https://wiki.facepunch.com/gmod/Default_Fonts for default fonts
    TextColor = Color( 255, 255, 255, 150 ), --  color of both texts
}

if config.TextFont == "Trebuchet22" then
    surface.CreateFont( "Trebuchet22", {
        font = "Trebuchet MS",
        size = 22,
    } )
end

local function lerp_color( t, a, b )
    return Color( Lerp( t, a.r, b.r ), Lerp( t, a.g, b.g ), Lerp( t, a.b, b.b ), Lerp( t, a.a, b.a ) )
end

local ratio, progress_color = 0, config.BoxProgressColor
return function( ply )
    --  variables
    local x = ScrW() / 2 - config.BoxW / 2
    ratio = Lerp( FrameTime() * config.SmoothSpeed, ratio, ply:GetNWInt( "guthlevelsystem:XP", 0 ) / ply:GetNWInt( "guthlevelsystem:NXP", 0 ) )

    if config.IsBoxProgressColorByTeam then
        progress_color = lerp_color( FrameTime() * config.SmoothSpeed, progress_color, ColorAlpha( team.GetColor( ply:Team() ), progress_color.a ) )
    end

    --  background
    draw.RoundedBox( config.BoxBackgroundCornerRadius, x, config.BoxY, config.BoxW, config.BoxH, config.BoxBackgroundColor )

    --  progress
    draw.RoundedBox( config.BoxProgressCornerRadius, x + config.BoxProgressPadding, config.BoxY + config.BoxProgressPadding, math.max( 0, config.BoxW * ratio - config.BoxProgressPadding * 2 ), config.BoxH - config.BoxProgressPadding * 2, progress_color )

    --  text
    draw.SimpleText( config.TextLevel:format( ply:GetNWInt( "guthlevelsystem:LVL", 0 ) ), config.TextFont, x + config.TextPadding, config.BoxY + config.BoxH / 2, config.TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( config.TextProgress:format( ratio * 100 ), config.TextFont, x + config.BoxW - config.TextPadding, config.BoxY + config.BoxH / 2, config.TextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
end