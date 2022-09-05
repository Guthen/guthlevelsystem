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
	--  Message displayed when a player try the '/prestige yes' command but is not eligible 
	--    Arguments must be enclosed with '{}'
	--    Available arguments are:
	--    - total_xp: amount of XP needed to pass the next prestige
	--    - has_next_prestige: boolean value checking if the player can earn a new prestige (prestige < guthlevelsystem.settings.prestige.maximum_prestige)
	not_eligible_message = "You are not eligible to earn a new prestige! You still need {total_xp} XP to be able to enter the next prestige.",
	--  Message displayed when a player try the '/prestige yes' command but is not eligible because of he already reach the maximum prestige
	not_eligible_maximum_prestige_message = "You can't go further, you are already at the maximum prestige.",
	--  Message displayed when a player enter the '/prestige' command
	--    Arguments must be enclosed with '{}'
	--    Available arguments are:
	--    - total_xp: amount of XP needed to pass the next prestige
	--    - command_accept: `guthlevelsystem.settings.prestige.command yes`
	--    - command_reset: `guthlevelsystem.settings.prestige.command reset`
	status_message = [[
Earning a new prestige reset your Level & XP to zero but might gives you more opportunity on this server. You need {total_xp} XP to be able to pass the next prestige.
The available commands are:
- {command_accept} : to pass the next prestige,
- {command_reset} : to reset your progress once you are at maximum level
]],
	--  Message displayed when a player enter the '/prestige reset' command & succeed
	reset_message = "Your progress have been reset, have fun!",
	--  Message displayed when a player enter the '/prestige reset' command & failed
	reset_fail_message = "You can only reset your progress when you are at maximum level and prestige!",

	--  The message sent to the player who earn prestige(s)
	--    Arguments must be enclosed with '{}'
	--    Available arguments are:
	--    - prestige: player's prestige
	earn_notification = "Congratulations, you get to prestige {prestige}!",
	
	--  Sound to play when you receive a prestige notification
	sound_notification = "Friends/message.wav",
}

--  Base number scaled by the current level
guthlevelsystem.settings.nxp_base = 100
--  Multiplier of the previous Level's Next XP 
guthlevelsystem.settings.nxp_multiplier = .25
--  Formula of the Next maximum XP to reach the next Level
--    By default, it's `level * guthlevelsystem.settings.nxp_base + previous_nxp * guthlevelsystem.settings.nxp_multiplier + prestige * guthlevelsystem.settings.prestige.nxp_base`
guthlevelsystem.settings.nxp_formula = function( prestige, level )
	local nxp = 0

	--  compute nxp considering all previous nxp 
	for i = 1, level do
		nxp = i * guthlevelsystem.settings.nxp_base + nxp * guthlevelsystem.settings.nxp_multiplier
	end

	--  scale by prestige
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
--  (DarkRP) The message sent to the player who attempted to change team but cannot
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: job's level
--    - prestige: job's prestige
--    - job: job's name
guthlevelsystem.settings.notification_fail_job = "You need to be level {level} of prestige {prestige} to become {job}!"
--  (DarkRP) The message sent to the player who attempted to change team but cannot with 'has_level_required' enabled on the job
--   Same arguments as above
guthlevelsystem.settings.notification_fail_level_priority_job = "You need to be prestige {prestige} & must be at least at the level {level} to become {job}!"

--  Sound to play when you receive a XP notification
guthlevelsystem.settings.sound_notification_xp = "Friends/friend_join.wav"
--  Sound to play when you receive a level notification
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

---  Data Panel
guthlevelsystem.settings.data_panel = {
	--  Set of user groups able to open the panel and see all player's level data
	read_usergroups = {
		["superadmin"] = true,
		["admin"] = true,
		["operator"] = true,
	},
	--  Set of user groups able to edit player's level data (through the panel or any other 3rd party-way)
	write_usergroups = {
		["superadmin"] = true,
	},
}