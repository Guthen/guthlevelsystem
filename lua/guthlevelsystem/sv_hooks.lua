guthlevelsystem = guthlevelsystem or {}

--  init data
hook.Add( "PlayerInitialSpawn", "guthlevelsystem:set_data", function( ply )
	if ply:IsBot() then return end

	ply:gls_get_data( function( success, message, data )
		if not data or #data <= 0 then
			ply:gls_init_data()
		else
			ply:gls_load_data()
		end
	end ) 
end )

--  earn xp on npc kill
if guthlevelsystem.OnNPCKilledEarnXP then
	hook.Add( "PostEntityTakeDamage", "guthlevelsystem:add_xp", function( ent, dmg, take )
		if ( not ent:IsNPC() and not ent:IsNextBot() ) then return end

		--  setup xp to earn
		if not ent.guthlevelsystem_max_health then
			ent.guthlevelsystem_max_health = ent:GetMaxHealth() >= ent:Health() and ent:GetMaxHealth() or ent:Health() + dmg:GetDamage()
		end
		if ent:Health() > 0 or ent.guthlevelsystem_took then return end

		local ply = dmg:GetAttacker()
		if not IsValid( ply ) or not ply:IsPlayer() then return end

		ply:gls_add_xp( guthlevelsystem.NPCKilledXPFormula( npc, ent.guthlevelsystem_max_health ) )
		ent.guthlevelsystem_took = true
	end )
else
	hook.Remove( "PostEntityTakeDamage", "guthlevelsystem:add_xp" ) 
end

--  earn xp on player kill
if guthlevelsystem.PlayerKillEarnXP then 
	hook.Add( "PlayerDeath", "guthlevelsystem:add_xp", function( ply, _, atk )
		if not IsValid( atk ) or not atk:IsPlayer() then return end
		if ply == atk then return end

		atk:gls_add_xp( guthlevelsystem.PlayerKillXPFormula( ply ) )
	end )
else
	hook.Remove( "PlayerDeath", "guthlevelsystem:add_xp" ) 
end

--  earn xp while playing
if guthlevelsystem.ByPlayingEarnXP then
	timer.Create( "guthlevelsystem:by_playing_xp", guthlevelsystem.ByPlayingTimer, 0, function()
		for _, v in pairs( player.GetHumans() ) do
			local diff_level, diff_xp, multiplier = v:gls_add_xp( guthlevelsystem.ByPlayingXPFormula( v ), true )
			if diff_level and diff_xp and multiplier then
				v:gls_default_notify_level( diff_level ) 
				v:gls_notify( 
					guthlevelsystem.format_message( guthlevelsystem.NotificationXPPlaying, {
						xp = diff_xp,
						multiplier = guthlevelsystem.format_multiplier( multiplier ),
					} ),
					0,
					guthlevelsystem.NotificationSoundXP
				)
			end
		end
	end )
else
	timer.Remove( "guthlevelsystem:by_playing_xp" )
end

--  give sweps
hook.Add( "PlayerGiveSWEP", "!!!guthlevelsystem:give_swep_required_levels", function( ply, class, swep )
	local required_level = guthlevelsystem.GiveSWEPsRequiredLevels[class]
	if required_level and ply:gls_get_level() >= required_level then
		return true
	end
end )

--  prestige
hook.Add( "PlayerSay", "guthlevelsystem:prestige", function( ply, text, is_team_chat )
	if text:StartWith( guthlevelsystem.PrestigeCommand ) then
		local arg = text:Split( " " )[2]
		
		if arg == "y" or arg == "yes" then
			if ply:gls_is_eligible_to_prestige() then
				ply:gls_add_prestige( 1 )
			else
				ply:PrintMessage( HUD_PRINTTALK, "You are not eligible to earn a new prestige!" )
			end
		elseif arg == "reset" then
			if ply:gls_get_level() == guthlevelsystem.MaximumLevel and ply:gls_get_prestige() == guthlevelsystem.MaximumPrestige then
				ply:gls_set_prestige( 0 )
				ply:PrintMessage( HUD_PRINTTALK, "Your progress have been resetted, have fun!" )
			else
				ply:PrintMessage( HUD_PRINTTALK, "You can only reset your progress when you are at maximum level and prestige!" )
			end
		else
			ply:PrintMessage( HUD_PRINTTALK, ( "Earning a new prestige reset your Level & XP to zero but might gives you more opportunity on this server. Your are currently %s to enter to the next prestige." ):format( ply:gls_is_eligible_to_prestige() and "able (/prestige y)" or "unable" ) )
		end
		
		return ""
	end
end )

--  DarkRP job
hook.Add( "playerCanChangeTeam", "guthlevelsystem:can_change_job", function( ply, job )
	 if IsValid( ply ) then
		local level = RPExtraTeams[job].LSlvl or RPExtraTeams[job].level
		if level then
			if ply:gls_get_level() < level then
				return false, 
					guthlevelsystem.format_message( guthlevelsystem.NotificationJob, {
						level = level, 
						job = team.GetName( job )
					} )
			end
		end
	 end
end )
