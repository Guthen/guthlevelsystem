--  TODO:
--[[ 
local function find_player_by_name( name )
	if not name then return end

	for i, v in ipairs( player.GetAll() ) do
		if v:GetName():StartWith( name ) then 
			return v
		end
	end
end

--  level
concommand.Add( "guthlevelsystem_set_level", function( ply, _, args )
	if IsValid( ply ) and not ply:IsSuperAdmin() then return end

	local level = tonumber( args[1] )
	if not level then return end

	local target = find_player_by_name( args[2] )
	if not IsValid( target ) then
		target = ply
	end

	if IsValid( target ) then
		if SERVER then 
			target:gls_set_level( level ) 
		end
		print( "GU-LS: " .. target:Name() .. " has been set to LVL " .. level )
	end
end )

concommand.Add( "guthlevelsystem_add_level", function( ply, _, args )
	if IsValid( ply ) and not ply:IsSuperAdmin() then return end

	local level = tonumber( args[1] )
	if not level then return end

	local target = ply
	local name = args[2]
	if name then
		for _, v in pairs( player.GetHumans() ) do
			if string.StartWith( v:Name(), name ) then target = v end
		end
	end

	if IsValid( target ) then
		if SERVER then target:gls_add_level( level ) end
		guthlevelsystem.print( "%d level(s) added to %q by %q", level, target:GetName(), IsValid( ply ) and ply:GetName() or "(CONSOLE)" )
	end
end )

--  XP
concommand.Add( "guthlevelsystem_set_xp", function( ply, _, args )
	if IsValid( ply ) and not ply:IsSuperAdmin() then return end

	local xp = tonumber( args[1] )
	if not xp then return end

	local target = ply
	local name = args[2]
	if name then
		for _, v in pairs( player.GetHumans() ) do
			if string.StartWith( v:Name(), name ) then target = v end
		end
	end

	if IsValid( target ) then
		if SERVER then target:gls_set_xp( xp ) end
		print( "GU-LS: " .. target:Name() .. " has been set to XP " .. xp )
	end
end )

concommand.Add( "guthlevelsystem_add_xp", function( ply, _, args )
	if IsValid( ply ) and not ply:IsSuperAdmin() then return end

	local xp = tonumber( args[1] )
	if not xp then return end

	local target = ply
	local name = args[2]
	if name then
		for _, v in pairs( player.GetHumans() ) do
			if string.StartWith( v:Name(), name ) then target = v end
		end
	end

	if IsValid( target ) then
		if SERVER then target:gls_add_xp( xp ) end
		print( "GU-LS: " .. target:Name() .. " has been set to XP " .. xp )
	end
end ) ]]

--  informations
concommand.Add( "guthlevelsystem_about", function( ply, _, args )
	guthlevelsystem.print( "is an open-source level-system addon made by %s which can be found on Github (%s).", guthlevelsystem.Author, guthlevelsystem.Link )
	if guthlevelsystem.IsLastVersion then
		guthlevelsystem.print( "current version is v%s, the addon is up-to-date.", guthlevelsystem.Version )
	else
		guthlevelsystem.warning( "this version of guthlevelsystem (v%s) is out-of-date, consider downloading the v%s on the Github", guthlevelsystem.Version, guthlevelsystem.GithubVersion )
	end
	guthlevelsystem.print( "if you encounter any issues or errors with this script, you can either open an issue on the Github repository or join my Discord (%s).", guthlevelsystem.Discord )
end )