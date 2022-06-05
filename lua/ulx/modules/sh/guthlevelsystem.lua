--  ULX <  --

--	> ulx.gls_add_xp
--	> args: caller, target, xp
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

--	> ulx.gls_set_xp
--	> args: caller, target, xp
function ulx.gls_set_xp( ply, target, xp )
	if not xp then return ULib.tsayError( "XP amount is not specified!" ) end
	target:gls_set_xp( xp )
	ulx.fancyLogAdmin( ply, "#A set XP to #i to #T !", xp, target )
end

local gls_add_xp = ulx.command( "guthlevelsystem", "ulx gls_add_xp", ulx.gls_add_xp, "!gls_add_xp" )
gls_add_xp:addParam( { type = ULib.cmds.PlayerArg } )
gls_add_xp:addParam( { type = ULib.cmds.NumArg, hint = "xp" } )
gls_add_xp:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_add_xp:help( "Add XP to a specified player." )

--  > ulx.gls_set_level
--  > args: caller, target, level
function ulx.gls_set_level( ply, target, level )
	if not level then return ULib.tsayError( "Level amount is not specified!" ) end
	target:gls_set_level( level )
	ulx.fancyLogAdmin( ply, "#A set LVL #i to #T !", level, target )
end

local gls_set_level = ulx.command( "guthlevelsystem", "ulx gls_set_level", ulx.gls_set_level, "!gls_set_level" )
gls_set_level:addParam( { type=ULib.cmds.PlayerArg } )
gls_set_level:addParam( { type=ULib.cmds.NumArg, hint="level" } )
gls_set_level:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_set_level:help( "Set LVL to a specified player." )

--  > ulx.gls_add_level
--  > args: caller, target, level
function ulx.gls_add_level( ply, target, level )
	if not level then return ULib.tsayError( "Level amount is not specified!" ) end
	target:gls_add_level( level )
	ulx.fancyLogAdmin( ply, "#A add #i LVL to #T !", level, target )
end

local gls_add_level = ulx.command( "guthlevelsystem", "ulx gls_add_level", ulx.gls_add_level, "!gls_add_level" )
gls_add_level:addParam( { type = ULib.cmds.PlayerArg } )
gls_add_level:addParam( { type = ULib.cmds.NumArg, hint = "level" } )
gls_add_level:defaultAccess( ULib.ACCESS_SUPERADMIN )
gls_add_level:help( "Add LVL to a specified player." )

guthlevelsystem.print( "ulx module loaded!" )
