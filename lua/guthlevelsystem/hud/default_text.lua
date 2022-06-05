local config = {
    TextFont             =   "DermaLarge", --  font of both texts, see https://wiki.facepunch.com/gmod/Default_Fonts for default fonts

    --  level text
    LevelX               =   30, --  X coordinate
    LevelY               =   ScrH() * .75, -- Y coordinate
    LevelText            =   "Level : %s", --  text format
    
    --  xp text
    XPX                  =   30, --  X coordinate
    XPY                  =   ScrH() * .79, --  Y coordinate
    XPText               =   "XP : %s", --  text format
    XPIsPercent          =   false, --  do we show a percent or a text on the format of "XP/NXP"
                                    --  e.g.: XPIsPercent = true => "XP : 50%"
                                    --        XPIsPercent = false => "XP : 100/200"
}


local _xp = 0
return function( ply )
    _xp = Lerp( FrameTime() * 5, _xp or 0, ply:gls_get_xp() )

    local level, nxp = ply:gls_get_level(), ply:gls_get_nxp()
    local xp_text = config.XPIsPercent and config.XPText:format( math.Round( _xp / nxp * 100 ) .. "%" ) 
               or config.XPText:format( math.Round( _xp ) .. "/" .. nxp )

    draw.SimpleText( config.LevelText:format( level ), config.TextFont, config.LevelX, config.LevelY, color_white )
    draw.SimpleText( xp_text, config.TextFont, config.XPX, config.XPY, color_white )
end