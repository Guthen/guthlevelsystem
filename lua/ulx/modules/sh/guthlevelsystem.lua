--  > ULX <  --

function ulx.LSAddXP( ply, trg, xp )
	if not xp then ULib.tsayError( "XP amount is not specified!" ) return end
	trg:LSAddXP( xp )
	ulx.fancyLogAdmin( ply:Name() .. " gave " .. xp .. " XP to " .. trg:Name() )
end

local LSAddXP = ulx.command( "guthlevelsystem", "ulx lsaddxp", ulx.LSaddXP, "!lsaddxp" )
addXPx:addParam( { type=ULib.cmds.PlayerArg } )
addXPx:addParam( { type=ULib.cmds.NumArg, hint="xp" } )
addXPx:defaultAccess( ULib.ACCESS_SUPERADMIN )
addXPx:help("Add XP to a specified player.")

function ulx.LSSetLVL( ply, trg, lvl )
	if not lvl then ULib.tsayError( "Level amount is not specified!" ) return end
	trg:LSSetLVL( lvl )
	ulx.fancyLogAdmin( ply:Name() .. " set LVL " .. lvl .. " to " .. trg:Name() )
end
local LSSetLVL = ulx.command( "guthlevelsystem", "ulx lssetlvl", ulx.setLevel, "!lssetlvl" )
setLevelx:addParam( { type=ULib.cmds.PlayerArg } )
setLevelx:addParam( { type=ULib.cmds.NumArg, hint="lvl" } )
setLevelx:defaultAccess( ULib.ACCESS_SUPERADMIN )
setLevelx:help( "Set LVL to a specified player." ) 


function ulx.LSAddLVL( ply, trg, lvl )
	if not lvl then ULib.tsayError( "Level amount is not specified!" ) return end
	trg:LSAddLVL( lvl )
	ulx.fancyLogAdmin( ply:Name() .. " add " .. lvl .. "LVL to " .. trg:Name() )
end
local LSAddLVL = ulx.command( "guthlevelsystem", "ulx lsaddlvl", ulx.setLevel, "!lsaddlvl" )
setLevelx:addParam( { type=ULib.cmds.PlayerArg } )
setLevelx:addParam( { type=ULib.cmds.NumArg, hint="lvl" } )
setLevelx:defaultAccess( ULib.ACCESS_SUPERADMIN )
setLevelx:help( "Add LVL to a specified player." ) 