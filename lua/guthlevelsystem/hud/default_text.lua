local config = {
	--  position
	PrestigeX = 30, --  X coordinate
	PrestigeY = ScrH() * .71, --  Y coordinate
	LevelX = 30, --  X coordinate
	LevelY = ScrH() * .75, -- Y coordinate
	XPX = 30, --  X coordinate
	XPY = ScrH() * .79, --  Y coordinate

	--  texts
	TextPrestige = "Prestige: %d", --  prestige text format, if `guthlevelsystem.PrestigeEnabled` is `true`; "%d" will be replaced with the prestige
    TextLevel = "Level: %d", --  level text format; "%d" will be replaced with the level
	TextXP = "XP: %s", --  text format
	XPIsPercent = false,--  do we show a percent or a text on the format of "XP/NXP"
						--  e.g.: XPIsPercent = true => "XP : 50%"
						--        XPIsPercent = false => "XP : 100/200"
	TextFont =   "DermaLarge", --  font of both texts, see https://wiki.facepunch.com/gmod/Default_Fonts for default fonts
	TextColor = Color( 255, 255, 255, 150 ), --  color of both texts
}


local _xp = 0
return function( ply )
	_xp = Lerp( FrameTime() * 5, _xp or 0, ply:gls_get_xp() )

	local level, nxp = ply:gls_get_level(), ply:gls_get_nxp()
	local xp_text = config.XPIsPercent and config.TextXP:format( math.Round( _xp / nxp * 100 ) .. "%" ) or config.TextXP:format( math.Round( _xp ) .. "/" .. nxp )

	--  text
	draw.SimpleText( config.TextLevel:format( level ), config.TextFont, config.LevelX, config.LevelY, config.TextColor )
	draw.SimpleText( xp_text, config.TextFont, config.XPX, config.XPY, config.TextColor )
	
	if guthlevelsystem.PrestigeEnabled then
		draw.SimpleText( config.TextPrestige:format( ply:gls_get_prestige() ), config.TextFont, config.PrestigeX, config.PrestigeY, config.TextColor )
	end
end