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
    _xp = Lerp( FrameTime() * 5, _xp or 0, ply:GetNWInt( "guthlevelsystem:XP", 0 ) )

    local lvl = config.LevelText:format( ply:GetNWInt( "guthlevelsystem:LVL", 0 ) )
    local xp = config.XPIsPercent and config.XPText:format( math.Round( _xp / ply:GetNWInt( "guthlevelsystem:NXP", 0 ) * 100 ) .. "%" ) 
               or config.XPText:format( math.Round( _xp ) .. "/" .. ply:GetNWInt( "guthlevelsystem:NXP", 0 ) )

    draw.SimpleText( lvl, config.TextFont, config.LevelX, config.LevelY, color_white )
    draw.SimpleText( xp, config.TextFont, config.XPX, config.XPY, color_white )
end