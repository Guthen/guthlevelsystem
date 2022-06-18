---  ULX Module
--  prestige
function ulx.gls_set_prestige( ply, target, prestige )
	if not prestige then return ULib.tsayError( "Prestige amount is not specified!" ) end
	target:gls_set_prestige( prestige )
	ulx.fancyLogAdmin( ply, "#A set prestige #i to #T !", prestige, target )
end

local gls_set_prestige = ulx.command( "guthlevelsystem", "ulx gls_set_prestige", ulx.gls_set_prestige, "!gls_set_prestige" )
gls_set_prestige:addParam( { type=ULib.cmds.PlayerArg } )
gls_set_prestige:addParam( { type=ULib.cmds.NumArg, hint="prestige" } )
gls_set_prestige:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_set_prestige:help( "Set prestige to a specified player." )

function ulx.gls_add_prestige( ply, target, prestige )
	if not prestige then return ULib.tsayError( "Prestige amount is not specified!" ) end
	target:gls_add_prestige( prestige )
	ulx.fancyLogAdmin( ply, "#A add #i prestige to #T !", prestige, target )
end

local gls_add_prestige = ulx.command( "guthlevelsystem", "ulx gls_add_prestige", ulx.gls_add_prestige, "!gls_add_prestige" )
gls_add_prestige:addParam( { type = ULib.cmds.PlayerArg } )
gls_add_prestige:addParam( { type = ULib.cmds.NumArg, hint = "prestige" } )
gls_add_prestige:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_add_prestige:help( "Add prestige to a specified player." )


--  level
function ulx.gls_set_level( ply, target, level )
	if not level then return ULib.tsayError( "Level amount is not specified!" ) end
	target:gls_set_level( level )
	ulx.fancyLogAdmin( ply, "#A set level #i to #T !", level, target )
end

local gls_set_level = ulx.command( "guthlevelsystem", "ulx gls_set_level", ulx.gls_set_level, "!gls_set_level" )
gls_set_level:addParam( { type=ULib.cmds.PlayerArg } )
gls_set_level:addParam( { type=ULib.cmds.NumArg, hint="level" } )
gls_set_level:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_set_level:help( "Set level to a specified player." )

function ulx.gls_add_level( ply, target, level )
	if not level then return ULib.tsayError( "Level amount is not specified!" ) end
	target:gls_add_level( level )
	ulx.fancyLogAdmin( ply, "#A add #i level to #T !", level, target )
end

local gls_add_level = ulx.command( "guthlevelsystem", "ulx gls_add_level", ulx.gls_add_level, "!gls_add_level" )
gls_add_level:addParam( { type = ULib.cmds.PlayerArg } )
gls_add_level:addParam( { type = ULib.cmds.NumArg, hint = "level" } )
gls_add_level:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_add_level:help( "Add level to a specified player." )


--  XP
function ulx.gls_add_xp( ply, target, xp )
	if not xp then return ULib.tsayError( "XP amount is not specified!" ) end
	target:gls_add_xp( xp )
	ulx.fancyLogAdmin( ply, "#A add #i XP to #T !", xp, target )
end

local gls_add_xp = ulx.command( "guthlevelsystem", "ulx gls_add_xp", ulx.gls_add_xp, "!gls_add_xp" )
gls_add_xp:addParam( { type = ULib.cmds.PlayerArg } )
gls_add_xp:addParam( { type = ULib.cmds.NumArg, hint = "xp" } )
gls_add_xp:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_add_xp:help( "Add XP to a specified player." )

function ulx.gls_set_xp( ply, target, xp )
	if not xp then return ULib.tsayError( "XP amount is not specified!" ) end
	target:gls_set_xp( xp )
	ulx.fancyLogAdmin( ply, "#A set XP to #i to #T !", xp, target )
end

local gls_set_xp = ulx.command( "guthlevelsystem", "ulx gls_set_xp", ulx.gls_set_xp, "!gls_set_xp" )
gls_set_xp:addParam( { type = ULib.cmds.PlayerArg } )
gls_set_xp:addParam( { type = ULib.cmds.NumArg, hint = "xp" } )
gls_set_xp:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_set_xp:help( "Set XP to a specified player." )


guthlevelsystem.print( "ULX module loaded!" )