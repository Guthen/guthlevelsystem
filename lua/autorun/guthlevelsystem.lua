guthlevelsystem = guthlevelsystem or {}
guthlevelsystem.Author = "Guthen"
guthlevelsystem.Version = "2.3.3"
guthlevelsystem.Link = "https://github.com/Guthen/guthlevelsystem"
guthlevelsystem.Discord = "https://discord.gg/eKgkpCf"

guthlevelsystem.IsLastVersion = guthlevelsystem.IsLastVersion or nil
guthlevelsystem.GithubVersion = guthlevelsystem.GithubVersion or "N/A"

guthlevelsystem.NET_CHANGE_VAR_VALUE_BITS = 16  --  16 u-bits: allow numbers from 0 up to 65535

--  debug (https://github.com/Guthen/guthscpbase/blob/master/lua/autorun/sh_guthscpbase.lua)
local convar_debug = CreateConVar( "guthlevelsystem_debug", 0, FCVAR_NONE, "Enables debug messages", 0, 1 )

function guthlevelsystem.is_debug()
	return convar_debug:GetBool()
end

local function colored_print( color, name, message, ... )
	if ... then 
		message = message:format( ... )
	end
	MsgC( color, "[ ", name, " ] ", color_white, "guthlevelsystem: " .. message, "\n" )
end

function guthlevelsystem.error( message, ... )
	colored_print( Color( 245, 78, 66 ), "Error", message, ... )
end

function guthlevelsystem.warning( message, ... )
	colored_print( Color( 245, 167, 66), "Warning", message, ... )
end

function guthlevelsystem.print( message, ... )
	colored_print( Color( 66, 203, 245 ), "Info", message, ... )
end

function guthlevelsystem.debug_print( message, ... )
	if not guthlevelsystem.is_debug() then return end

	colored_print( Color( 66, 245, 135 ), "Debug", message, ... )
end

--  utilities
function guthlevelsystem.load_file( path, force_prefix )
	local prefix = force_prefix and force_prefix or path:GetFileFromFilename():match( "^(%w+_)" )

	if SERVER then
		if prefix == "sv_" then
			include( path )
			guthlevelsystem.print( "%q loaded", path )
		elseif prefix == "cl_" then
			AddCSLuaFile( path )
			guthlevelsystem.print( "%q sent to clients", path )
		elseif prefix == "sh_" then
			include( path )
			AddCSLuaFile( path )
			guthlevelsystem.print( "%q loaded & sent to clients", path )
		else
			guthlevelsystem.warning( "don't know what to do with file %q", path )
		end
	else
		if prefix == "cl_" or prefix == "sh_" then
			include( path )
			guthlevelsystem.print( "%q loaded", path )
		else
			guthlevelsystem.warning( "don't know what to do with file %q", path )
		end
	end
end

function guthlevelsystem.format_message( msg, args )
	local formatted_text = ""

	local function format_word( word )
		local key = word:match( "^{(.+)}$" )
		if key then
			word = tostring( args[key] or "?" )
		end
		formatted_text = formatted_text .. word
	end

	local word = ""
	for l in msg:gmatch( "." ) do
		local force_implement = false
		if l == "{" and #word > 0 then
			format_word( word )
			word = ""
		end
		
		word = word .. l
		if l == " " or l == "}" then
			format_word( word )
			word = ""
		end
	end

	if #word > 0 then
		format_word( word )
	end

	return formatted_text
end

function guthlevelsystem.colored_format_message( msg, args )
	args = args or {}

	local formatted_text, word = {}, ""

	local function format_word( word )
		local key = word:match( "^{(.+)}$" )
		if key then
			word = tostring( args[key] or "?" )
			formatted_text[#formatted_text + 1] = guthlevelsystem.settings.level_command.highlight_color
		else
			formatted_text[#formatted_text + 1] = color_white
		end
		formatted_text[#formatted_text + 1] = word
	end

	for l in msg:gmatch( "." ) do
		if l == "{" and #word > 0 then
			format_word( word )
			word = ""
		end
		
		word = word .. l
		if l == " " or l == "}" then
			format_word( word )
			word = ""
		end
	end

	if #word > 0 then
		format_word( word )
	end

	return formatted_text
end

function guthlevelsystem.format_multiplier( multiplier )
	return not ( multiplier == 1 ) and ( "(x%s)" ):format( multiplier ) or ""
end

--  compute next xp
function guthlevelsystem.compute_next_xp( prestige, level, xp, nxp )
	--  decrease
	if xp <= 0 then
		while ( xp <= 0 ) do
			level = level - 1
			nxp = guthlevelsystem.settings.nxp_formula( prestige, level )
			xp = xp + nxp
			
			--  limit
			if level <= 1 then
				level = 1  --  avoid level 0 
				xp = 0
				break
			end
		end
	--  increase
	else
		while ( xp >= nxp ) do
			level = level + 1
			xp = xp - nxp
			
			--  limit
			if level > guthlevelsystem.settings.maximum_level then
				level = guthlevelsystem.settings.maximum_level
				xp = nxp
				break
			end
			
			nxp = guthlevelsystem.settings.nxp_formula( prestige, level )
		end
	end

	return level, xp, nxp
end

--  check for updates
function guthlevelsystem.check_for_updates()
	guthlevelsystem.print( "checking for updates.." )
	http.Fetch( 
		"https://raw.githubusercontent.com/Guthen/guthlevelsystem/master/lua/autorun/guthlevelsystem.lua", 
		function( body )
			local raw_git_version = body:match( "\"(%d+%.%d+.%d+)\"" )
			if not raw_git_version then return guthlevelsystem.error( "failed to fetch Github version: `raw_git_version = nil`" ) end

			--  split each version numbers
			local git_version = raw_git_version:Split( "." )
			local local_version = guthlevelsystem.Version:Split( "." )

			--  compare versions
			guthlevelsystem.GithubVersion = raw_git_version
			guthlevelsystem.IsLastVersion = true
			for i = 1, 3 do
				local local_n, git_n = tonumber( local_version[i] ), tonumber( git_version[i] )
				if local_n < git_n then --  to update!
					guthlevelsystem.IsLastVersion = false
					guthlevelsystem.warning( "this version is out-of-date, v%s is available on Github", raw_git_version )
					break
				elseif local_n > git_n then --  dev mode
					guthlevelsystem.print( "developpment mode detected" )
					break
				end
			end

			if guthlevelsystem.IsLastVersion then
				guthlevelsystem.print( "local version is up-to-date" )
			end
		end,
		function( reason )
			guthlevelsystem.error( "HTTP request failed: %q", reason )
		end
	)
end
concommand.Add( "guthlevelsystem_check_for_updates", guthlevelsystem.check_for_updates )
hook.Add( "InitPostEntity", "guthlevelsystem:check_for_updates", function()
	timer.Simple( 5, guthlevelsystem.check_for_updates )
end )

--  loading scripts
guthlevelsystem.load_file( "guthlevelsystem/sh_config.lua" )
guthlevelsystem.load_file( "guthlevelsystem/sh_commands.lua" )
guthlevelsystem.load_file( "guthlevelsystem/sh_players.lua" )
if SERVER then
	util.AddNetworkString( "guthlevelsystem:notify" )
	util.AddNetworkString( "guthlevelsystem:tchat" )

	guthlevelsystem.load_file( "guthlevelsystem/sv_data.lua" )
	
	guthlevelsystem.load_file( "guthlevelsystem/sv_players.lua" )
	guthlevelsystem.load_file( "guthlevelsystem/sv_hooks.lua" )
	
	guthlevelsystem.load_file( "guthlevelsystem/sv_panel.lua" )

	guthlevelsystem.load_file( "guthlevelsystem/cl_hud.lua" )
	guthlevelsystem.load_file( "guthlevelsystem/cl_panel.lua" )
	
	--  sending huds files
	local path = "guthlevelsystem/hud/"
	for i, v in ipairs( file.Find( path .. "*.lua", "LUA" ) ) do
		guthlevelsystem.load_file( path .. v, "cl_" )
	end

	--  init database
	guthlevelsystem.init_data_table()
else
	guthlevelsystem.load_file( "guthlevelsystem/cl_hud.lua" )
	guthlevelsystem.load_file( "guthlevelsystem/cl_panel.lua" )
end
hook.Run( "guthlevelsystem:on_loaded" )

guthlevelsystem.print( "v%s loaded; type 'guthlevelsystem_about' for more informations on this addon.", guthlevelsystem.Version )