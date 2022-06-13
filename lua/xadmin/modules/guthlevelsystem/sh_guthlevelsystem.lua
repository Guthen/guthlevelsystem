local CATEGORY_NAME = "guthlevelsystem"

--  prestige
xAdmin.RegisterCommand( "gls_set_prestige", "Set prestige", "Set prestige to a specified player", "%s set %s to prestige %d", CATEGORY_NAME, function( admin, args )
	local targets = xAdmin.GetTargetsFromArg( admin, "gls_set_prestige", args[1] )
	local amount = tonumber( args[2] )

	for i, v in ipairs( targets ) do
		local ply = player.GetBySteamID( v )
		if IsValid( ply ) then
			ply:gls_set_prestige( amount )
		end
	end

	xAdmin.NotifyCommandUse( admin, "gls_set_prestige", {
		xAdmin.GetLanguageString( "You" ), 
		xAdmin.GetTargetString( targets ),
		amount, 
	} )
	xAdmin.LogCommandUse( admin, "gls_set_prestige", {
		( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
		xAdmin.GetTargetString( targets ),
		amount,
	} )
end, {
	{ xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
	{ xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

xAdmin.RegisterCommand( "gls_add_prestige", "Add prestige", "Add prestige to a specified player", "%s add %d prestige to %s", CATEGORY_NAME, function( admin, args )
	local targets = xAdmin.GetTargetsFromArg( admin, "gls_add_level", args[1] )
	local amount = tonumber( args[2] )

	for i, v in ipairs( targets ) do
		local ply = player.GetBySteamID( v )
		if IsValid( ply ) then
			ply:gls_add_prestige( amount )
		end
	end

	xAdmin.NotifyCommandUse( admin, "gls_add_prestige", {
		xAdmin.GetLanguageString( "You" ), 
		amount, 
		xAdmin.GetTargetString( targets ),
	} )
	xAdmin.LogCommandUse( admin, "gls_add_prestige", {
		( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
		amount,
		xAdmin.GetTargetString( targets ),
	} )
end, {
	{ xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
	{ xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

--  level
xAdmin.RegisterCommand( "gls_set_level", "Set level", "Set level to a specified player", "%s set %s to level %d", CATEGORY_NAME, function( admin, args )
	local targets = xAdmin.GetTargetsFromArg( admin, "gls_set_level", args[1] )
	local amount = tonumber( args[2] )

	for i, v in ipairs( targets ) do
		local ply = player.GetBySteamID( v )
		if IsValid( ply ) then
			ply:gls_set_level( amount )
		end
	end

	xAdmin.NotifyCommandUse( admin, "gls_set_level", {
		xAdmin.GetLanguageString( "You" ), 
		xAdmin.GetTargetString( targets ),
		amount, 
	} )
	xAdmin.LogCommandUse( admin, "gls_set_level", {
		( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
		xAdmin.GetTargetString( targets ),
		amount,
	} )
end, {
	{ xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
	{ xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

xAdmin.RegisterCommand( "gls_add_level", "Add level", "Add level to a specified player", "%s add %d level to %s", CATEGORY_NAME, function( admin, args )
	local targets = xAdmin.GetTargetsFromArg( admin, "gls_add_level", args[1] )
	local amount = tonumber( args[2] )

	for i, v in ipairs( targets ) do
		local ply = player.GetBySteamID( v )
		if IsValid( ply ) then
			ply:gls_add_level( amount )
		end
	end

	xAdmin.NotifyCommandUse( admin, "gls_add_level", {
		xAdmin.GetLanguageString( "You" ), 
		amount, 
		xAdmin.GetTargetString( targets ),
	} )
	xAdmin.LogCommandUse( admin, "gls_add_level", {
		( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
		amount,
		xAdmin.GetTargetString( targets ),
	} )
end, {
	{ xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
	{ xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

--  XP
xAdmin.RegisterCommand( "gls_set_xp", "Set XP", "Set XP to a specified player", "%s set %s to %d XP", CATEGORY_NAME, function( admin, args )
	local targets = xAdmin.GetTargetsFromArg( admin, "gls_set_xp", args[1] )
	local amount = tonumber( args[2] )

	for i, v in ipairs( targets ) do
		local ply = player.GetBySteamID( v )
		if IsValid( ply ) then
			ply:gls_set_xp( amount )
		end
	end

	xAdmin.NotifyCommandUse( admin, "gls_set_xp", {
		xAdmin.GetLanguageString( "You" ), 
		xAdmin.GetTargetString( targets ),
		amount, 
	} )
	xAdmin.LogCommandUse( admin, "gls_set_xp", {
		( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
		xAdmin.GetTargetString( targets ),
		amount,
	} )
end, {
	{ xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
	{ xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

xAdmin.RegisterCommand( "gls_add_xp", "Add XP", "Add XP to a specified player", "%s add %d XP to %s", CATEGORY_NAME, function( admin, args )
	local targets = xAdmin.GetTargetsFromArg( admin, "gls_add_xp", args[1] )
	local amount = tonumber( args[2] )

	for i, v in ipairs( targets ) do
		local ply = player.GetBySteamID( v )
		if IsValid( ply ) then
			ply:gls_add_xp( amount )
		end
	end

	xAdmin.NotifyCommandUse( admin, "gls_add_xp", {
		xAdmin.GetLanguageString( "You" ), 
		amount, 
		xAdmin.GetTargetString( targets ),
	} )
	xAdmin.LogCommandUse( admin, "gls_add_xp", {
		( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
		amount,
		xAdmin.GetTargetString( targets ),
	} )
end, {
	{ xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
	{ xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

guthlevelsystem.print( "xAdmin2 module loaded!" )