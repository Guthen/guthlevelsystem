local PLAYER = FindMetaTable( "Player" )

-- data
function PLAYER:gls_init_data()
	local query = ( "INSERT INTO guth_ls( SteamID, XP, LVL ) VALUES ( %s, 0, 1 )" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.Query( query, function( success, message, data )
		if not success then
			return guthlevelsystem.error( "failed while creating data on %q: %s", self:GetName(), message )
		end

		self:gls_set_raw_xp( 0 )
		self:gls_set_raw_level( 1 )
		self:gls_update_nxp()

		guthlevelsystem.print( "data has been created on %q", self:GetName() )
		hook.Run( "guthlevelsystem:OnPlayerCreateData", self )
	end )
end

function PLAYER:gls_save_data()
	local xp = self:gls_get_xp()
	local level = self:gls_get_level()

	local query = ( "UPDATE guth_ls SET XP = %d, LVL = %d WHERE SteamID = %s" ):format( xp, level, SQLStr( self:SteamID() ) )
	guthlevelsystem.Query( query, function( success, message, data )
		if not success then
			return guthlevelsystem.error( "failed while saving data on %q : %s", self:GetName(), message )
		end

		guthlevelsystem.print( "data has been saved on %q", self:Name() ) 
		hook.Run( "guthlevelsystem:OnPlayerSaveData", self, silent )
	end )
end

function PLAYER:gls_load_data()
	local query = ( "SELECT XP, LVL FROM guth_ls WHERE SteamID = %s" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.Query( query, function( success, message, data )
		if not success or not data or #data <= 0 then
			return not data and guthlevelsystem.error( "failed while loading data on %q : %s", self:GetName(), message )
		end

		self:gls_set_raw_level( tonumber( data[1].LVL ), true )
		self:gls_set_raw_xp( tonumber( data[1].XP ) )
		self:gls_update_nxp()

		guthlevelsystem.print( "data has been loaded on %q", self:Name() )
	end )
end

function PLAYER:gls_get_data( callback )
	local query = ( "SELECT * FROM guth_ls WHERE SteamID = %s" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.Query( query, callback )
end

function PLAYER:gls_reset_data()
	local query = ( "DELETE FROM guth_ls WHERE SteamID='%s'" ):format( SQLStr( self:SteamID() ) )
	guthlevelsystem.Query( query, function( success, message, data )
		if not success then
			return guthlevelsystem.error( "failed while reseting data on %q : %s", self:GetName(), message )
		end

		self:gls_init_data()

		hook.Run( "guthlevelsystem:OnPlayerResetData", self )
	end )
end

--  raw setter
function PLAYER:gls_set_raw_level( level )
	self:SetNWInt( "guthlevelsystem:LVL", level )
end

function PLAYER:gls_set_raw_xp( xp )
	self:SetNWInt( "guthlevelsystem:XP", xp )
end

function PLAYER:gls_set_raw_nxp( nxp )
	self:SetNWInt( "guthlevelsystem:NXP", nxp )
end

--  XP
function PLAYER:gls_get_xp_multiplier()
	local mul = 1

	--  rank xp multiplier
	if guthlevelsystem.RankXPMultipliers[self:GetUserGroup()] then
		mul = mul * guthlevelsystem.RankXPMultipliers[self:GetUserGroup()]
	end

	--  team xp multiplier
	if guthlevelsystem.TeamXPMultipliers[self:Team()] then
		mul = mul * guthlevelsystem.TeamXPMultipliers[self:Team()]
	end
	
	return mul
end

function PLAYER:gls_update_nxp()
	self:gls_set_raw_nxp( guthlevelsystem.NXPFormula( self, self:gls_get_level() ) )
end

function PLAYER:gls_add_xp( num, is_silent )
	return self:gls_set_xp( self:gls_get_xp() + num, is_silent )
	--[[ if not isnumber( num ) then return end

	if self:gls_get_level() == -1 then self:gls_reset_data() end
	if self:gls_get_level() >= guthlevelsystem.MaximumLevel then return end

	--  apply rank xp multiplier
	local multiplier = self:gls_get_xp_multiplier()
	num = math.Round( num * multiplier )

	local should = hook.Run( "guthlevelsystem:ShouldPlayerAddXP", self, num, silent, byPlaying )
	if should == false then return end

	self.LSxp = ( self.LSxp or 0 ) + num
	if self.LSxp >= ( self.LSnxp or 0 ) then
		local dif = ( self.LSnxp or 0 ) - self.LSxp
		--print( self.LSnxp, self.LSxp, dif )

		self:gls_add_level( 1, silent )

		if dif < 0 then
			timer.Simple( .5, function()
				if not IsValid( self ) then return end
				self:gls_add_xp( -dif )
			end)
		end
		return
	end

	self:gls_save_data()

	if not silent then
		local notif = byPlaying and guthlevelsystem.NotificationXPPlaying or guthlevelsystem.NotificationXP

		self:gls_notify( 
			guthlevelsystem.format_message( notif, { 
				xp = num,
				multiplier = not ( multiplier == 1 ) and ( "(x%s)" ):format( multiplier ) or "",
			} ), 0, guthlevelsystem.NotificationSoundXP 
		)
	end

	hook.Run( "guthlevelsystem:OnPlayerAddXP", self, num, silent, byPlaying ) ]]
end



function PLAYER:gls_set_xp( num, is_silent )
	local level = self:gls_get_level()
	if level >= guthlevelsystem.MaximumLevel then return end

	--[[ local should = hook.Run( "guthlevelsystem:ShouldPlayerSetXP", self, num )
	if should == false then return end ]]

	--  apply xp multiplier
	local multiplier = self:gls_get_xp_multiplier()
	num = math.Round( num * multiplier )

	local nxp = self:gls_get_nxp()
	local xp, level = num, level

	--  decrease
	if xp <= 0 then
		while ( xp <= 0 ) do
			level = level - 1
			nxp = guthlevelsystem.NXPFormula( self, level )
			xp = xp + nxp
		end
	--  increase
	else
		while ( xp >= nxp ) do
			level = level + 1
			xp = xp - nxp
			nxp = guthlevelsystem.NXPFormula( self, level )
		end
	end

	local diff_level, diff_xp = level - self:gls_get_level(), math.Round( num - self:gls_get_xp() ) 
	self:gls_set_raw_level( level )
	self:gls_set_raw_xp( xp )
	self:gls_set_raw_nxp( nxp )

	self:gls_save_data()

	--  notify
	if not is_silent then
		self:gls_default_notify_level( diff_level )
		self:gls_default_notify_xp( diff_xp, multiplier )
	end

	--[[ self.LSxp = num
	if self.LSxp >= ( self.LSnxp or 0 ) then
		local dif = ( self.LSnxp or 0 ) - self.LSxp

		self:gls_add_level( 1, silent )

		if dif < 0 then
			timer.Simple( .5, function()
				if not IsValid( self ) then return end
				self:gls_add_xp( -dif, silent )
			end)
		end
		return
	end ]]


	--[[ hook.Run( "guthlevelsystem:OnPlayerSetXP", self, num ) ]]
	return diff_level, diff_xp, multiplier
end


---  Level
function PLAYER:gls_add_level( num )
	--[[ local should = hook.Run( "guthlevelsystem:ShouldPlayerAddLVL", self, num )
	if should == false then return end ]]

	self:gls_set_level( self:gls_get_level() + num )

	--[[ if not silent then
		self:gls_notify( guthlevelsystem.format_message( guthlevelsystem.NotificationLevel, { level = self:gls_get_level() } ), 0, guthlevelsystem.NotificationSoundLVL )
	end

	hook.Run( "guthlevelsystem:OnPlayerAddLVL", self, num ) ]]
end

function PLAYER:gls_set_level( num )
	--[[ local should = hook.Run( "guthlevelsystem:ShouldPlayerSetLVL", self, num, silent )
	if should == false then return end ]]

	self:gls_set_raw_level( math.Clamp( num, 1, guthlevelsystem.MaximumLevel ) )
	self:gls_set_raw_xp( 0 )
	self:gls_update_nxp()

	self:gls_save_data()

	--[[ if not silent then
		self:gls_notify( guthlevelsystem.format_message( guthlevelsystem.NotificationLevel, { level = self:gls_get_level() } ), 0, guthlevelsystem.NotificationSoundLVL )
	end

	hook.Run( "guthlevelsystem:OnPlayerSetLVL", self, num, silent ) ]]
end

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