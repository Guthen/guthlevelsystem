local function find_player_by_name( name )
	if not name then return end

	for i, v in ipairs( player.GetAll() ) do
		if v:GetName():StartWith( name ) then 
			return v
		end
	end
end

local function command_wrapper( callback )
	return function( ply, _, args )
		if not SERVER then return end
		if IsValid( ply ) and not ply:IsSuperAdmin() then return end

		local amount = tonumber( args[1] )
		if not amount then return end
	
		local target
		if args[2] then
			target = find_player_by_name( args[2] )
		else
			target = ply
		end
	
		if IsValid( target ) then
			callback( ply, target, amount )
		else
			guthlevelsystem.error( "Player not found!" )
		end
	end
end

--  prestige
concommand.Add( "guthlevelsystem_set_prestige", command_wrapper( 
	function( ply, target, amount )
		local diff_prestige = target:gls_set_prestige( amount )
		if not ( diff_prestige == 0 ) then 
			guthlevelsystem.print( guthlevelsystem.format_message( "You set prestige of {target_name} to {prestige}!", {
				target_name = target:GetName(),
				prestige = amount,
			} ) )
		end
	end )
)

concommand.Add( "guthlevelsystem_add_prestige", command_wrapper( 
	function( ply, target, amount )
		local diff_prestige = target:gls_add_prestige( amount )
		if not ( diff_level == 0 ) then 
			guthlevelsystem.print( guthlevelsystem.format_message( "You add {amount} prestige(s) to {target_name}!", {
				target_name = target:GetName(),
				amount = amount,
			} ) )
		end
	end )
)

--  level
concommand.Add( "guthlevelsystem_set_level", command_wrapper( 
	function( ply, target, amount )
		local diff_level = target:gls_set_level( amount )
		if not ( diff_level == 0 ) then 
			guthlevelsystem.print( guthlevelsystem.format_message( "You set level of {target_name} to {level}!", {
				target_name = target:GetName(),
				level = amount,
			} ) )
		end
	end )
)

concommand.Add( "guthlevelsystem_add_level", command_wrapper( 
	function( ply, target, amount )
		local diff_level = target:gls_add_level( amount )
		if not ( diff_level == 0 ) then 
			guthlevelsystem.print( guthlevelsystem.format_message( "You add {amount} level(s) to {target_name}!", {
				target_name = target:GetName(),
				amount = amount,
			} ) )
		end
	end )
)

--  XP
concommand.Add( "guthlevelsystem_set_xp", command_wrapper( 
	function( ply, target, amount )
		local diff_level, diff_xp = target:gls_set_xp( amount )
		if not ( diff_xp == 0 and diff_level == 0 ) then 
			guthlevelsystem.print( guthlevelsystem.format_message( "You set XP of {target_name} to {xp}!", {
				target_name = target:GetName(),
				xp = string.Comma( amount ),
			} ) )
		end
	end )
)

concommand.Add( "guthlevelsystem_add_xp", command_wrapper( 
	function( ply, target, amount )
		local diff_level, diff_xp = target:gls_add_xp( amount )
		if not ( diff_xp == 0 and diff_level == 0 ) then 
			guthlevelsystem.print( guthlevelsystem.format_message( "You add {amount} XP(s) to {target_name}!", {
				target_name = target:GetName(),
				amount = string.Comma( amount ),
			} ) )
		end
	end )
)

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