local config = {}

--  position
config.prestige_x = 30 --  X coordinate
config.prestige_y = ScrH() * .71 --  Y coordinate
config.level_x = 30 --  X coordinate
config.level_y = ScrH() * .75 -- Y coordinate
config.xp_x = 30 --  X coordinate
config.xp_y = ScrH() * .79 --  Y coordinate

--  texts
config.text_prestige = "Prestige: %d" --  prestige text format, if `guthlevelsystem.settings.prestige.enabled` is `true`; "%d" will be replaced with the prestige
config.text_level = "Level: %d" --  level text format; "%d" will be replaced with the level
config.text_xp = "XP: %s" --  text format
config.xp_is_percent = false  --  do we show a percent or a text on the format of "XP/NXP"
					   --  e.g.: xp_is_percent = true => "XP : 50%"
					   --        xp_is_percent = false => "XP : 100/200"
config.text_font = "DermaLarge" --  font of both texts, see https://wiki.facepunch.com/gmod/Default_Fonts for default fonts
config.text_color = Color( 255, 255, 255, 150 ) --  color of both texts

--
--  end of config
--

local _xp = 0
guthlevelsystem.add_hud( "default_text", function( ply )
	_xp = Lerp( FrameTime() * 5, _xp or 0, ply:gls_get_xp() )

	local level, nxp = ply:gls_get_level(), ply:gls_get_nxp()
	local xp_text = config.xp_is_percent and config.text_xp:format( math.Round( _xp / nxp * 100 ) .. "%" ) or config.text_xp:format( math.Round( _xp ) .. "/" .. nxp )

	--  text
	draw.SimpleText( config.text_level:format( level ), config.text_font, config.level_x, config.level_y, config.text_color )
	draw.SimpleText( xp_text, config.text_font, config.xp_x, config.xp_y, config.text_color )
	
	if guthlevelsystem.settings.prestige.enabled then
		draw.SimpleText( config.text_prestige:format( ply:gls_get_prestige() ), config.text_font, config.prestige_x, config.prestige_y, config.text_color )
	end
end )