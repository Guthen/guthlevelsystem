--  > ULX <  --

function ulx.LSAddXP( ply, trg, xp )
	if not xp then ULib.tsayError( "XP amount is not specified!" ) return end
	trg:LSAddXP( xp )
	ulx.fancyLogAdmin( ply:Name() .. " gave " .. xp .. " XP to " .. trg:Name() )
end

local LSAddXP = ulx.command( "guthlevelsystem", "ulx lsaddxp", ulx.LSAddXP, "!lsaddxp" )
LSAddXP:addParam( { type=ULib.cmds.PlayerArg } )
LSAddXP:addParam( { type=ULib.cmds.NumArg, hint="xp" } )
LSAddXP:defaultAccess( ULib.ACCESS_SUPERADMIN )
LSAddXP:help("Add XP to a specified player.")

function ulx.LSSetLVL( ply, trg, lvl )
	if not lvl then ULib.tsayError( "Level amount is not specified!" ) return end
	trg:LSSetLVL( lvl )
	ulx.fancyLogAdmin( ply:Name() .. " set LVL " .. lvl .. " to " .. trg:Name() )
end

local LSSetLVL = ulx.command( "guthlevelsystem", "ulx lssetlvl", ulx.LSSetLVL, "!lssetlvl" )
LSSetLVL:addParam( { type=ULib.cmds.PlayerArg } )
LSSetLVL:addParam( { type=ULib.cmds.NumArg, hint="lvl" } )
LSSetLVL:defaultAccess( ULib.ACCESS_SUPERADMIN )
LSSetLVL:help( "Set LVL to a specified player." ) 

function ulx.LSAddLVL( ply, trg, lvl )
	if not lvl then ULib.tsayError( "Level amount is not specified!" ) return end
	trg:LSAddLVL( lvl )
	ulx.fancyLogAdmin( ply:Name() .. " add " .. lvl .. "LVL to " .. trg:Name() )
end

local LSAddLVL = ulx.command( "guthlevelsystem", "ulx lsaddlvl", ulx.LSAddLVL, "!lsaddlvl" )
LSAddLVL:addParam( { type=ULib.cmds.PlayerArg } )
LSAddLVL:addParam( { type=ULib.cmds.NumArg, hint="lvl" } )
LSAddLVL:defaultAccess( ULib.ACCESS_SUPERADMIN )
LSAddLVL:help( "Add LVL to a specified player." ) 