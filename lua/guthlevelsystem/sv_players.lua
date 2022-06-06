local PLAYER = FindMetaTable( "Player" )

-- data
function PLAYER:gls_init_data()
	local query = ( "INSERT INTO guthlevelsystem_players( steamid, xp, lvl, prestige ) VALUES ( %s, 0, 1, 0 )" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.query( query, function( success, message, data )
		if not success then
			return guthlevelsystem.error( "failed while creating data on %q: %s", self:GetName(), message )
		end

		self:gls_set_raw_xp( 0 )
		self:gls_set_raw_level( 1 )
		self:gls_update_nxp()

		guthlevelsystem.print( "data has been created on %q (%s)", self:GetName(), self:SteamID() )
		hook.Run( "guthlevelsystem:OnPlayerCreateData", self )
	end )
end

function PLAYER:gls_save_data()
	timer.Create( "guthlevelsystem:save_data:" .. ( self:SteamID64() or "N/A" ), 1, 1, function()  --  prevent multiple saving at once
		local xp = self:gls_get_xp()
		local level = self:gls_get_level()
		local prestige = 0 --  TODO
	
		local query = ( "UPDATE guthlevelsystem_players SET xp = %d, lvl = %d, prestige = %d WHERE steamid = %s" ):format( xp, level, prestige, SQLStr( self:SteamID() ) )
		guthlevelsystem.query( query, function( success, message, data )
			if not success then
				return guthlevelsystem.error( "failed while saving data on %q : %s", self:GetName(), message )
			end
	
			guthlevelsystem.debug_print( "data has been saved on %q (%s)", self:GetName(), self:SteamID() ) 
			hook.Run( "guthlevelsystem:on_player_save_data", self )
		end )
	end )
end

function PLAYER:gls_load_data()
	local query = ( "SELECT xp, lvl, prestige FROM guthlevelsystem_players WHERE steamid = %s" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.query( query, function( success, message, data )
		if not success or not data or #data <= 0 then
			return not data and guthlevelsystem.error( "failed while loading data on %q : %s", self:GetName(), message )
		end

		self:gls_set_raw_level( tonumber( data[1].lvl ), true )
		self:gls_set_raw_xp( tonumber( data[1].xp ) )
		--self:gls_set_raw_prestige( tonumber( data[1].prestige )) --  TODO
		self:gls_update_nxp()

		guthlevelsystem.print( "data has been loaded on %q", self:GetName() )
	end )
end

function PLAYER:gls_get_data( callback )
	local query = ( "SELECT * FROM guthlevelsystem_players WHERE steamid = %s" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.query( query, callback )
end

function PLAYER:gls_reset_data()
	local query = ( "DELETE FROM guthlevelsystem_players WHERE steamid='%s'" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.query( query, function( success, message, data )
		if not success then
			return guthlevelsystem.error( "failed while reseting data on %q : %s", self:GetName(), message )
		end

		self:gls_init_data()
		hook.Run( "guthlevelsystem:on_player_reset_data", self )
	end )
end

--  raw setter
function PLAYER:gls_set_raw_level( level )
	self:SetNWInt( "guthlevelsystem:level", math.Round( level ) )
end

function PLAYER:gls_set_raw_xp( xp )
	self:SetNWInt( "guthlevelsystem:xp", math.Round( xp ) )
end

function PLAYER:gls_set_raw_nxp( nxp )
	self:SetNWInt( "guthlevelsystem:nxp", math.Round( nxp ) )
end

--  XP
function PLAYER:gls_get_xp_multiplier()
	local multiplier = 1

	--  rank xp multiplier
	if guthlevelsystem.RankXPMultipliers[self:GetUserGroup()] then
		multiplier = multiplier * guthlevelsystem.RankXPMultipliers[self:GetUserGroup()]
	end

	--  team xp multiplier
	if guthlevelsystem.TeamXPMultipliers[self:Team()] then
		multiplier = multiplier * guthlevelsystem.TeamXPMultipliers[self:Team()]
	end

	--  custom multiplier (not cumulable!)
	multiplier = multiplier * ( hook.Run( "guthlevelsystem:custom_xp_multiplier", self, mul ) or 1 )
	
	return multiplier
end

function PLAYER:gls_update_nxp()
	self:gls_set_raw_nxp( guthlevelsystem.NXPFormula( self, self:gls_get_level() ) )
end

function PLAYER:gls_set_xp( num, is_silent )
	local level = self:gls_get_level()
	if num >= 0 and level >= guthlevelsystem.MaximumLevel then return end

	local nxp = self:gls_get_nxp()
	local xp, level = num, level
	
	--  decrease
	if xp <= 0 then
		while ( xp <= 0 ) do
			level = level - 1
			nxp = guthlevelsystem.NXPFormula( self, level )
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
			nxp = guthlevelsystem.NXPFormula( self, level )
			
			--  limit
			if level >= guthlevelsystem.MaximumLevel then
				xp = 0
				break
			end
		end
	end
	
	local diff_level, diff_xp = level - self:gls_get_level(), math.Round( num - self:gls_get_xp() ) 

	local should = hook.Run( "guthlevelsystem:can_player_earn", self, diff_level, diff_xp )
	if should == false then return end

	self:gls_set_raw_level( level )
	self:gls_set_raw_xp( xp )
	self:gls_set_raw_nxp( nxp )
	
	guthlevelsystem.debug_print( "%q (%s) earned %d level(s) and %d XP", self:GetName(), self:SteamID(), diff_level, diff_xp )
	self:gls_save_data()
	
	--  notify
	if not is_silent then
		self:gls_default_notify_level( diff_level )
		self:gls_default_notify_xp( diff_xp, 1 )
	end

	hook.Run( "guthlevelsystem:on_player_earn", self, diff_level, diff_xp )
	return diff_level, diff_xp
end

function PLAYER:gls_add_xp( num, is_silent )
	--  apply xp multiplier
	local multiplier = self:gls_get_xp_multiplier()
	num = math.Round( num * multiplier )

	local diff_level, diff_xp = self:gls_set_xp( self:gls_get_xp() + num, true )

	--  notify w/ multiplier
	if not is_silent and diff_level and diff_xp then
		self:gls_default_notify_level( diff_level )
		self:gls_default_notify_xp( diff_xp, multiplier )
	end

	return diff_level, diff_xp, multiplier
end

--  Level
function PLAYER:gls_set_level( num, is_silent )
	local diff_level = num - self:gls_get_level()

	local should = hook.Run( "guthlevelsystem:can_player_earn", self, diff_level, 0 )
	if should == false then return end

	self:gls_set_raw_level( math.Clamp( num, 1, guthlevelsystem.MaximumLevel ) )
	self:gls_set_raw_xp( 0 )
	self:gls_update_nxp()
	
	guthlevelsystem.debug_print( "%q (%s) earned %d level(s)", self:GetName(), self:SteamID(), diff_level )
	self:gls_save_data()
	
	if not is_silent then
		self:gls_default_notify_level( diff_level )
	end
	
	hook.Run( "guthlevelsystem:on_player_earn", self, diff_level, 0 )
end

function PLAYER:gls_add_level( num, is_silent )
	return self:gls_set_level( self:gls_get_level() + num, is_silent )
end

--  notifications
function PLAYER:gls_notify( msg, type, snd )
	net.Start( "guthlevelsystem:notify" )
		net.WriteString( msg or "" )
		net.WriteUInt( type or 0, 3 )
		net.WriteString( snd or "Resource/warning.wav" )
	net.Send( self )
end

function PLAYER:gls_default_notify_level( diff_level )
	local level = self:gls_get_level()
	if diff_level > 0 then
		self:gls_notify( 
			guthlevelsystem.format_message( guthlevelsystem.NotificationLevelEarn, {
					level = level,
			} ),
			0,
			guthlevelsystem.NotificationSoundLevel
		)
	elseif diff_level < 0 then
		self:gls_notify( 
			guthlevelsystem.format_message( guthlevelsystem.NotificationLevelLoss, {
				level = level,
			} ),
			1,
			guthlevelsystem.NotificationSoundLevel
		)
	end
end

function PLAYER:gls_default_notify_xp( diff_xp, multiplier )
	if diff_xp > 0 then
		self:gls_notify( 
			guthlevelsystem.format_message( guthlevelsystem.NotificationXPEarn, {
				xp = diff_xp,
				multiplier = guthlevelsystem.format_multiplier( multiplier ),
			} ),
			0,
			guthlevelsystem.NotificationSoundXP
		)
	elseif diff_xp < 0 then
		self:gls_notify( 
			guthlevelsystem.format_message( guthlevelsystem.NotificationXPLoss, {
				xp = diff_xp,
				multiplier = guthlevelsystem.format_multiplier( multiplier ),
			} ),
			1,
			guthlevelsystem.NotificationSoundXP
		)
	end
end