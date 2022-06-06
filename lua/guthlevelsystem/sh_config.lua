guthlevelsystem = guthlevelsystem or {}

---  Level System Configuration
--  Maximum Level that players can reach
guthlevelsystem.MaximumLevel = 50

--  Is Prestige system enabled?
--   The prestige system is similar to Call of Duty franchise, once a player reach the maximum level, he is able to claim a new prestige
--   Doing so, the player's Level will be reset to Level 1. He can do so until he reach the maximum prestige.
guthlevelsystem.PrestigeEnabled = true
--  Maximum Prestige that players can reach
guthlevelsystem.MaximumPrestige = 12
guthlevelsystem.PrestigeAlertMessage = "Congratulations, you reach the maximum level! You have unlocked the ability to gain a new prestige and to reset your progression by typing '{command}'. This decision is permanent, there is no come back!"
guthlevelsystem.PrestigeCommand = "/prestige"

--  Base number scaled by the current level
guthlevelsystem.NXBase = 400
--  Multiplicator of the previous Level's Next XP 
guthlevelsystem.NXPMultiplicator = .25
--  Base number scaled by the current prestige
guthlevelsystem.NXPPrestigeBase = 50
--  Formula of the Next maximum XP to reach the next Level
--    By default, it's `level * guthlevelsystem.NXBase + previous_nxp * guthlevelsystem.NXPMultiplicator + prestige * guthlevelsystem.NXPPrestigeMultiplicator`
--    NOTE: use `level` instead of `ply:gls_get_level()`, it's internally required! 
guthlevelsystem.NXPFormula = function( ply, level )
	local nxp = 0

	--  compute nxp considering all previous nxp 
	for i = 1, level do
		nxp = i * guthlevelsystem.NXBase + nxp * guthlevelsystem.NXPMultiplicator
	end

	--  scale by prestige
	local prestige = ply:gls_get_prestige()
	if prestige > 0 then
		nxp = nxp + prestige * guthlevelsystem.NXPPrestigeBase
	end

	return math.Round( nxp )
end

--  XP Multipliers for specific Ranks
guthlevelsystem.RankXPMultipliers = {
	--["superadmin"] = 2.5, --  XP of "superadmin" players multiplied by x2.5
	--["vip"] = 2, --  XP of "vip" players multiplied by x2
}

--  XP Multipliers for specific Teams
--   NOTE: the multipliers scale with each other
hook.Add( "PostGamemodeLoaded", "guthlevelsystem:TeamXPMultipliers", function()
	guthlevelsystem.TeamXPMultipliers = {
		--[TEAM_CHIEF] = 2, --  XP of TEAM_CHIEF players multiplied by x2
		--[TEAM_CITIZEN] = 0.75, --  XP of TEAM_CITIZEN players multiplied by x0.75
		--[TEAM_HOBO] = 0, --  XP of TEAM_HOBO players completely disabled
	}
	
	guthlevelsystem.print( "%d Team XP Multipliers loaded", table.Count( guthlevelsystem.TeamXPMultipliers ) )
end )

--  List of weapon classes mapped by the required level for a player to be able to give the SWEP using the SpawnMenu (works for Sandbox-based gamemodes)
--   This will bypass most of the administration systems constraints (such as FAdmin & ULX), this means that 
--   anyone having the required level will be able to give the SWEP to himself despite being an admin or not 
guthlevelsystem.GiveSWEPsRequiredLevels = {
	--["weapon_rpg"] = 25, --  'weapon_rpg' can only be given by players from at least level 25
	--["weapon_pistol"] = 5, --  'weapon_pistol' can only be given by players from at least level 5
}

--  The message sent to the player who earn prestige(s)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - prestige: player's prestige
guthlevelsystem.NotificationPrestige = "Congratulations, you get to prestige {prestige}!"
--  The message sent to the player who earn level(s)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
guthlevelsystem.NotificationLevelEarn = "You get to level {level}, good job!"
--  The message sent to the player who loss level(s)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
guthlevelsystem.NotificationLevelLoss = "You fell to level {level}, watch out!"
--  The message sent to the player who earn XP by playing on the server
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXPPlaying = "You earn {xp} XP by playing on the server {multiplier}!"
--  The message sent to the player who earn XP
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXPEarn = "You earn {xp} XP, work harder {multiplier}!"
--  The message sent to the player who loss XP
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXPLoss = "You loss {xp} XP, watch out {multiplier}!"
--  (DarkRP) The message sent to the player who attempted to change teams but cannot (%d represent the required level and %s the job name)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
--    - job: job's name
guthlevelsystem.NotificationJob = "You need to be level {level} to become {job}!"

--  What sound is played when you received a notification (earn XP)
guthlevelsystem.NotificationSoundXP = "Friends/friend_join.wav"
--  What sound is played when you received a notification (earn level)
guthlevelsystem.NotificationSoundLevel = "Friends/friend_online.wav"

--  Should we earn XP when we kill a NPC?
guthlevelsystem.OnNPCKilledEarnXP = true
--  Multiplicator of XP to earn depending of the Max Health of the NPC
guthlevelsystem.NPCKilledXPMultiplicator = 1
--  Formula of the amount of XP to earn on NPC Kill 
--    By default, it's the Max Health of the NPC
--    NOTE: use `max_health` instead of `npc:GetMaxHealth()`, more reliable!
guthlevelsystem.NPCKilledXPFormula = function( npc, max_health )
	return max_health * guthlevelsystem.NPCKilledXPMultiplicator
end

--  Should we earn XP when we kill a Player?
guthlevelsystem.PlayerKillEarnXP = true
--  Multiplicator of XP to earn depending of the Max Health of the Player
guthlevelsystem.PlayerKillEarnXPMultiplicator = .5
--  Formula of the amount of XP to earn on Player Kill
--    By default, it's half of the Max Health (most case it's 50 XP)
guthlevelsystem.PlayerKillXPFormula = function( ply )
	return ply:GetMaxHealth() * guthlevelsystem.PlayerKillEarnXPMultiplicator
end

--  Should we earn XP when we play on the server?
guthlevelsystem.ByPlayingEarnXP = true
--  Interval, in seconds, to add XP to players while playing on the server (def: 60 seconds)
guthlevelsystem.ByPlayingTimer = 60
--  Formula of the amount of XP to earn while playing on the server
--    By default, it's 150 XP
guthlevelsystem.ByPlayingXPFormula = function( ply )
	return 150
end

--  Should we show the selected HUD?
guthlevelsystem.DrawHUD = true
--   Which HUD should we draw?
--   Have to be the HUD file name from 'lua/guthlevelsystem/hud/' 
--   See the HUD file to edit its config
--   defaults:
--     - default_text
--     - default_progress
guthlevelsystem.SelectedHUD = "default_progress"

--  Chat Command
guthlevelsystem.CommandChat = "/level"
--  Command Message
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
--    - xp: player's xp
--    - nxp: player's maximum xp to gain before reaching the next level
--    - percent: player's xp percentage before reaching the next level (literally equal to 'xp / nxp * 100')
guthlevelsystem.CommandFormatMessage = "You are at level {level} and to {xp}/{nxp} XP ({percent}%) from next level."
--  Arguments Highlight Color
guthlevelsystem.CommandHighlightColor = Color( 230, 110, 40 )