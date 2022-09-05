guthlevelsystem = guthlevelsystem or {}

--  init data
hook.Add( "PlayerInitialSpawn", "guthlevelsystem:set_data", function( ply )
	if ply:IsBot() then return end

	ply:gls_get_data( function( data )
		if not data or #data <= 0 then
			ply:gls_init_data()
		else
			ply:gls_load_data()
		end
	end ) 
end )

--  earn xp on npc kill
if guthlevelsystem.settings.event_npc_kill.enabled then
	hook.Add( "PostEntityTakeDamage", "guthlevelsystem:add_xp", function( ent, dmg, take )
		if ( not ent:IsNPC() and not ent:IsNextBot() ) then return end

		--  setup xp to earn
		if not ent.guthlevelsystem_max_health then
			ent.guthlevelsystem_max_health = ent:GetMaxHealth() >= ent:Health() and ent:GetMaxHealth() or ent:Health() + dmg:GetDamage()
		end
		if ent:Health() > 0 or ent.guthlevelsystem_took then return end

		local ply = dmg:GetAttacker()
		if not IsValid( ply ) or not ply:IsPlayer() then return end

		ply:gls_add_xp( guthlevelsystem.settings.event_npc_kill.formula( npc, ent.guthlevelsystem_max_health ) )
		ent.guthlevelsystem_took = true
	end )
else
	hook.Remove( "PostEntityTakeDamage", "guthlevelsystem:add_xp" ) 
end

--  earn xp on player kill
if guthlevelsystem.settings.event_player_kill.enabled then 
	hook.Add( "PlayerDeath", "guthlevelsystem:add_xp", function( ply, _, atk )
		if not IsValid( atk ) or not atk:IsPlayer() then return end
		if ply == atk then return end

		atk:gls_add_xp( guthlevelsystem.settings.event_player_kill.formula( ply ) )
	end )
else
	hook.Remove( "PlayerDeath", "guthlevelsystem:add_xp" ) 
end

--  earn xp while playing
if guthlevelsystem.settings.event_time_playing.enabled then
	timer.Create( "guthlevelsystem:by_playing_xp", guthlevelsystem.settings.event_time_playing.interval, 0, function()
		for _, v in pairs( player.GetHumans() ) do
			local diff_level, diff_xp, multiplier = v:gls_add_xp( guthlevelsystem.settings.event_time_playing.formula( v ), true )
			if diff_level and diff_xp and multiplier then
				v:gls_default_notify_level( diff_level ) 
				v:gls_notify( 
					guthlevelsystem.format_message( guthlevelsystem.settings.event_time_playing.earn_notification, {
						xp = diff_xp,
						multiplier = guthlevelsystem.format_multiplier( multiplier ),
					} ),
					0,
					guthlevelsystem.settings.sound_notification_xp
				)
			end
		end
	end )
else
	timer.Remove( "guthlevelsystem:by_playing_xp" )
end

--  give sweps
hook.Add( "PlayerGiveSWEP", "!!!guthlevelsystem:give_swep_required_levels", function( ply, class, swep )
	local required_level = guthlevelsystem.settings.give_sweps_required_levels[class]
	if required_level and ply:gls_get_level() >= required_level then
		return true
	end
end )

--  prestige
hook.Add( "PlayerSay", "guthlevelsystem:prestige", function( ply, text, is_team_chat )
	if text:StartWith( guthlevelsystem.settings.prestige.command ) then
		local arg = text:Split( " " )[2]
		
		if arg == "y" or arg == "yes" then
			if ply:gls_is_eligible_to_prestige() then
				ply:gls_add_prestige( 1 )
			else
				if ply:gls_get_prestige() < guthlevelsystem.settings.prestige.maximum_prestige then
					ply:gls_colored_message( guthlevelsystem.settings.prestige.not_eligible_message, { 
						total_xp = string.Comma( ply:gls_get_xp_for_maximum_level() ),
					} )
				else
					ply:gls_colored_message( guthlevelsystem.settings.prestige.not_eligible_maximum_prestige_message, {} )
				end
			end
		elseif arg == "reset" then
			if ply:gls_get_level() == guthlevelsystem.settings.maximum_level and ply:gls_get_prestige() == guthlevelsystem.settings.prestige.maximum_prestige and ply:gls_get_xp() == ply:gls_get_nxp() then
				ply:gls_set_prestige( 0 )
				ply:gls_colored_message( guthlevelsystem.settings.prestige.reset_message, {} )
			else
				ply:gls_colored_message( guthlevelsystem.settings.prestige.reset_fail_message, {} )
			end
		else
			ply:gls_colored_message( guthlevelsystem.settings.prestige.status_message, {
				total_xp = string.Comma( ply:gls_get_xp_for_maximum_level() ),
				command_accept = guthlevelsystem.settings.prestige.command .. " yes",
				command_reset = guthlevelsystem.settings.prestige.command .. " reset",
			} )
		end
		
		return ""
	end
end )

--  DarkRP job
hook.Add( "playerCanChangeTeam", "guthlevelsystem:can_change_team", function( ply, job )
	if not IsValid( ply ) then return end

	local data = RPExtraTeams[job]
	local job_level, job_prestige, has_level_priority = data.LSlvl or data.level or 0, data.prestige or 0, data.has_level_priority
	if job_level <= 0 and job_prestige <= 0 then return end

	local level, prestige = ply:gls_get_level(), ply:gls_get_prestige()

	if has_level_priority then
		if not ( level >= job_level and prestige >= job_prestige ) then 
			return false, guthlevelsystem.format_message( guthlevelsystem.settings.notification_fail_level_priority_job, {
				level = job_level, 
				prestige = job_prestige,
				job = team.GetName( job ),
			} )
		end 
	else
		if not ( level >= job_level and prestige >= job_prestige or prestige > job_prestige ) then
			return false, guthlevelsystem.format_message( guthlevelsystem.settings.notification_fail_job, {
				level = job_level, 
				prestige = job_prestige,
				job = team.GetName( job ),
			} )
		end
	end
end )
