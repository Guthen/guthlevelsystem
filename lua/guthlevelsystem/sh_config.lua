guthlevelsystem = guthlevelsystem or {}
guthlevelsystem.settings = {}

---  Level System Configuration
--  Maximum Level that players can reach
guthlevelsystem.settings.maximum_level = 50

---  Prestige System
--   The prestige system is similar to Call of Duty franchise, once a player reach the maximum level, he is able to claim a new prestige
--   Doing so, the player's Level will be reset to Level 1. He can do so until he reach the maximum prestige.
guthlevelsystem.settings.prestige = {
	--  Is Prestige system enabled?
	enabled = true,
	--  Maximum Prestige that players can reach
	maximum_prestige = 12,
	--  Base number scaled by the current prestige
	nxp_base = 50,

	--  Command to type to get informations on the prestige and to enter the prestige mode
	command = "/prestige",
	--  Message displayed when a player is now able to enter the next prestige
	--    Arguments must be enclosed with '{}'
	--    Available arguments are:
	--    - next_prestige: next player's prestige
	--    - command: `guthlevelsystem.settings.prestige.command`
	alert_message = "Congratulations, you reach the maximum level! You have unlocked the ability to go to the prestige {next_prestige}, type '{command}' for more infos.",

	--  The message sent to the player who earn prestige(s)
	--    Arguments must be enclosed with '{}'
	--    Available arguments are:
	--    - prestige: player's prestige
	earn_notification = "Congratulations, you get to prestige {prestige}!",
}

--  Base number scaled by the current level
guthlevelsystem.settings.nx_base = 400
--  Multiplier of the previous Level's Next XP 
guthlevelsystem.settings.nx_multiplier = .25
--  Formula of the Next maximum XP to reach the next Level
--    By default, it's `level * guthlevelsystem.settings.nx_base + previous_nxp * guthlevelsystem.settings.nx_multiplier + prestige * guthlevelsystem.NXPPrestigeMultiplicator`
--    NOTE: use `level` instead of `ply:gls_get_level()`, it's internally required! 
guthlevelsystem.settings.nxp_formula = function( ply, level )
	local nxp = 0

	--  compute nxp considering all previous nxp 
	for i = 1, level do
		nxp = i * guthlevelsystem.settings.nx_base + nxp * guthlevelsystem.settings.nx_multiplier
	end

	--  scale by prestige
	local prestige = ply:gls_get_prestige()
	if guthlevelsystem.settings.prestige.enabled and prestige > 0 then
		nxp = nxp + prestige * guthlevelsystem.settings.prestige.nxp_base
	end

	return math.Round( nxp )
end

--  XP Multipliers for specific Ranks
guthlevelsystem.settings.rank_xp_multipliers = {
	--["superadmin"] = 2.5, --  XP of "superadmin" players multiplied by x2.5
	--["vip"] = 2, --  XP of "vip" players multiplied by x2
}

--  XP Multipliers for specific Teams
--   NOTE: the multipliers scale with each other
guthlevelsystem.settings.team_xp_multipliers = guthlevelsystem.settings.team_xp_multipliers or {}
hook.Add( "PostGamemodeLoaded", "guthlevelsystem:TeamXPMultipliers", function()
	guthlevelsystem.settings.team_xp_multipliers = {
		--[TEAM_CHIEF] = 2, --  XP of TEAM_CHIEF players multiplied by x2
		--[TEAM_CITIZEN] = 0.75, --  XP of TEAM_CITIZEN players multiplied by x0.75
		--[TEAM_HOBO] = 0, --  XP of TEAM_HOBO players completely disabled
	}
	
	guthlevelsystem.print( "%d Team XP Multipliers loaded", table.Count( guthlevelsystem.settings.team_xp_multipliers ) )
end )

--  List of weapon classes mapped by the required level for a player to be able to give the SWEP using the SpawnMenu (works for Sandbox-based gamemodes)
--   This will bypass most of the administration systems constraints (such as FAdmin & ULX), this means that 
--   anyone having the required level will be able to give the SWEP to himself despite being an admin or not 
guthlevelsystem.settings.give_sweps_required_levels = {
	--["weapon_rpg"] = 25, --  'weapon_rpg' can only be given by players from at least level 25
	--["weapon_pistol"] = 5, --  'weapon_pistol' can only be given by players from at least level 5
}

--  Are notifications displayed on screen center or by using default gmod notification system?
guthlevelsystem.settings.notification_is_hud_printcenter = false
--  The message sent to the player who earn level(s)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
guthlevelsystem.settings.notification_earn_level = "You get to level {level}, good job!"
--  The message sent to the player who loss level(s)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
guthlevelsystem.settings.notification_loss_level = "You fell to level {level}, watch out!"
--  The message sent to the player who earn XP
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.settings.notification_earn_xp = "You earn {xp} XP, work harder {multiplier}!"
--  The message sent to the player who loss XP
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.settings.notification_loss_xp = "You loss {xp} XP, watch out {multiplier}!"
--  (DarkRP) The message sent to the player who attempted to change teams but cannot (%d represent the required level and %s the job name)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
--    - job: job's name
guthlevelsystem.settings.notification_fail_job = "You need to be level {level} to become {job}!"

--  What sound is played when you received a notification (earn XP)
guthlevelsystem.settings.sound_notification_xp = "Friends/friend_join.wav"
--  What sound is played when you received a notification (earn level)
guthlevelsystem.settings.sound_notification_level = "Friends/friend_online.wav"

---  Events
--  NPC Kill
guthlevelsystem.settings.event_npc_kill = {
	--  Should we earn XP when we kill a NPC?
	enabled = true,
	--  Multiplicator of XP to earn depending of the Max Health of the NPC
	multiplicator = 2,
	--  Formula of the amount of XP to earn on NPC Kill 
	--    By default, it's the Max Health scaled by 2 of the NPC
	--    NOTE: use `max_health` instead of `npc:GetMaxHealth()`, more reliable!
	formula = function( npc, max_health )
		return max_health * guthlevelsystem.settings.event_npc_kill.multiplicator
	end,
}

--  Player Kill
guthlevelsystem.settings.event_player_kill = {
	--  Should we earn XP when we kill a Player?
	enabled = true,
	--  Multiplicator of XP to earn depending of the Max Health of the Player
	multiplicator = .5,
	--  Formula of the amount of XP to earn on Player Kill
	--    By default, it's half of the Max Health (most case it's 50 XP)
	formula = function( ply )
		return ply:GetMaxHealth() * guthlevelsystem.settings.event_player_kill.multiplicator
	end,
}

--  Time Playing
guthlevelsystem.settings.event_time_playing = {
	--  Should we earn XP when we play on the server?
	enabled = true,
	--  Interval, in seconds, to add XP to players while playing on the server (def: 300 seconds = 5 minutes)
	interval = 300,
	--  Formula of the amount of XP to earn while playing on the server
	--    By default, it's 150 XP
	formula = function( ply )
		return 150
	end,
	--  The message sent to the player who earn XP by playing on the server
	--    Arguments must be enclosed with '{}'
	--    Available arguments are:
	--    - xp: earned xp
	--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
	earn_notification = "You earn {xp} XP by playing on the server {multiplier}!",
}

---  HUD
guthlevelsystem.settings.hud = {
	--  Should we show the selected HUD?
	enabled = true,
	--   Which HUD should we draw?
	--   Have to be the HUD file name from 'lua/guthlevelsystem/hud/' 
	--   See the HUD file to edit its config
	--   defaults:
	--     - default_text
	--     - default_progress
	selected = "default_progress",
}

---  Chat Command
guthlevelsystem.settings.level_command = {
	--  Command to type to display the message
	command = "/level",
	--  Command Message
	--    Arguments must be enclosed with '{}'
	--    Available arguments are:
	--    - level: player's level
	--    - xp: player's xp
	--    - nxp: player's maximum xp to gain before reaching the next level
	--    - percent: player's xp percentage before reaching the next level (literally equal to 'xp / nxp * 100')
	message = "You are at level {level} and to {xp}/{nxp} XP ({percent}%) from next level.",
	--  Arguments Highlight Color
	highlight_color = Color( 230, 110, 40 ),
}