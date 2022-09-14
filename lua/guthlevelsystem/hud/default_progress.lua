local config = {}
config.smooth_speed = 5 --  animation speed for progress box & color changes

--  box
config.box_w = ScrW() * .2 --  box's width; by default set to 20% of the screen width
config.box_h = ScrH() * .025 --  box's height; by default set to 2.5% of the screen height
config.box_x = ScrW() / 2 - config.box_w / 2  --  box's X coordinate; by default it's centered
config.box_y = ScrH() * .025 --  box's Y coordinate; by default set to 2.5% of the screen height  

--  progress box
config.box_progress_padding = 3 --  gap at top, bottom, left & right of progress box
config.box_progress_corner_radius = 6 --  radius of box's corners; 0: no corner
config.box_progress_color = Color( 12, 234, 75, 150 ) --  color used in the progression box
config.is_box_progress_color_by_team = false --  do we set the progress color to the current player's team color?
                                      --  please note that setting this to true will not take in account box_progress_color value 

--  background box
config.box_background_corner_radius = 6 --  radius of box's corners; 0: no corner
config.box_background_color = Color( 130, 130, 130, 150 ) -- box background color

--  texts
config.text_padding = 8 --  gap at left and right of both texts; default: 8px
config.text_prestige = "Prestige %d" --  prestige text format, if `guthlevelsystem.settings.prestige.enabled` is `true`; "%d" will be replaced with the prestige
config.text_level = "Level %d" --  level text format; "%d" will be replaced with the level
config.text_progress = "%d%%" --  progress text format; "%d" will be replaced with the xp percent & "%%" will become automatically a "%"
config.text_is_progress = false 
config.text_font = "Trebuchet22" --  font of both texts, see https://wiki.facepunch.com/gmod/Default_Fonts for default fonts
config.text_color = Color( 255, 255, 255, 150 ) --  color of both texts

--
--  end of config
--

--  create the default font
if config.text_font == "Trebuchet22" then
    surface.CreateFont( "Trebuchet22", {
        font = "Trebuchet MS",
        size = 22,
    } )
end

--  HUD code
local function lerp_color( t, a, b )
    return Color( Lerp( t, a.r, b.r ), Lerp( t, a.g, b.g ), Lerp( t, a.b, b.b ), Lerp( t, a.a, b.a ) )
end

local progress_color = config.box_progress_color
local xp = 0
guthlevelsystem.add_hud( "default_progress", function( ply )
    --  variables
    xp = Lerp( FrameTime() * config.smooth_speed, xp, ply:gls_get_xp() )

    local nxp = ply:gls_get_nxp()
    local ratio = math.Clamp( xp / nxp, 0, 1 )
    
    if config.is_box_progress_color_by_team then
        progress_color = lerp_color( FrameTime() * config.smooth_speed, progress_color, ColorAlpha( team.GetColor( ply:Team() ), progress_color.a ) )
    end

    --  background
    draw.RoundedBox( config.box_background_corner_radius, config.box_x, config.box_y, config.box_w, config.box_h, config.box_background_color )

    --  progress
    draw.RoundedBox( config.box_progress_corner_radius, config.box_x + config.box_progress_padding, config.box_y + config.box_progress_padding, math.max( 0, config.box_w * ratio - config.box_progress_padding * 2 ), config.box_h - config.box_progress_padding * 2, progress_color )

    --  text
    local right_text = config.text_is_progress and config.text_progress:format( ratio * 100 ) or ( "%d/%d XP" ):format( xp, nxp )
    draw.SimpleText( config.text_level:format( ply:gls_get_level() ), config.text_font, config.box_x + config.text_padding, config.box_y + config.box_h / 2, config.text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( right_text, config.text_font, config.box_x + config.box_w - config.text_padding, config.box_y + config.box_h / 2, config.text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

    --  prestige
    if guthlevelsystem.settings.prestige.enabled then
        draw.SimpleText( config.text_prestige:format( ply:gls_get_prestige() ), config.text_font, config.box_x + config.box_w / 2, config.box_y + config.box_h / 2, config.text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end )