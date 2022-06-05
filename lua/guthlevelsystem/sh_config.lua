guthlevelsystem = guthlevelsystem or {}

---  Level System Configuration
--  Maximum Level that players can reach
guthlevelsystem.MaximumLevel              =   50
--  Maximum Prestige that players can reach
guthlevelsystem.MaximumPrestige 		=   12

--  How much we multiplicate the level to this to get the next needed xp of the new level
guthlevelsystem.NXBase                  =   400
--  How much we multiplicate the needed xp to get the next needed xp of the new level
guthlevelsystem.NXPMultiplicator        =   .25
--  Formula of the Next maximum XP to reach the next Level
--  NOTE: use `level` instead of `ply:gls_get_level()`, it's internally required! 
guthlevelsystem.NXPFormula = function( ply, level )
	--  recursive function!
	if level == 0 then
		return 0
	end
	return level * guthlevelsystem.NXBase + guthlevelsystem.NXPFormula( ply, level - 1 ) * guthlevelsystem.NXPMultiplicator
end

--  XP Multipliers for specific Ranks
guthlevelsystem.RankXPMultipliers = {
	--["superadmin"] = 2.5, --  XP of "superadmin" players multiplied by x2.5
	--["vip"] = 2, --  XP of "vip" players multiplied by x2
}

--  XP Multipliers for specific Teams
--   Take note that the multipliers scale with each other
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

--  The message sent to the player who earn XP by playing on the server
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXPPlaying   =   "You earn {xp} XP by playing on the server {multiplier}!"
--  The message sent to the player who earn XP
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXPEarn          =   "You earn {xp} XP, work harder {multiplier}!"
--  The message sent to the player who loss XP
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXPLoss          =   "You loss {xp} XP, watch out {multiplier}!"
--  The message sent to the player who earn level(s)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
guthlevelsystem.NotificationLevelEarn    =   "You get to LVL {level}, good job!"
--  The message sent to the player who loss level(s)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
guthlevelsystem.NotificationLevelLoss    =   "You fell to LVL {level}, watch out!"
--  (DarkRP) The message sent to the player who attempted to change teams but cannot (%d represent the required level and %s the job name)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
--    - job: job's name
guthlevelsystem.NotificationJob         =   "You need to be LVL {level} to become {job}!"

--  What sound is played when you received a notification (earn XP)
guthlevelsystem.NotificationSoundXP     =   "Friends/friend_join.wav"
--  What sound is played when you received a notification (earn LVL)
guthlevelsystem.NotificationSoundLevel    =   "Friends/friend_online.wav"

--  Should we earn XP when we kill a NPC
guthlevelsystem.OnNPCKilledEarnXP       =   true
--  How many XP we earn when we kill a NPC (if -1 then we earn XP relative to NPC Max Health)
guthlevelsystem.OnNPCKilledXP           =   -1
--  Should we earn XP when we kill a Player
guthlevelsystem.PlayerDeathEarnXP       =   true
--  How many XP we earn when we kill a Player
guthlevelsystem.PlayerDeathXP           =   50
--  Should we earn XP when we play on the server
guthlevelsystem.ByPlayingEarnXP         =   true
--  How many seconds we should wait before get XP (def: 60 seconds)
guthlevelsystem.ByPlayingTimer          =   60
--  How many XP we earn when we play on the server (def: 150 XP each 60 seconds)
guthlevelsystem.ByPlayingXP             =   150

--  Should we show the selected HUD
guthlevelsystem.DrawHUD                 =   true
--  Which HUD should we draw?
--    Have to be the HUD file name from 'lua/guthlevelsystem/hud/' 
--    See the HUD file to edit its config
--    defaults:
--    - default_text
--    - default_progress
guthlevelsystem.SelectedHUD             =   "default_progress"

--  Chat Command
guthlevelsystem.CommandChat             =   "/level"
--  Command Message
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - level: player's level
--    - xp: player's xp
--    - nxp: player's maximum xp to gain before reaching the next level
--    - percent: player's xp percentage before reaching the next level (literally equal to 'xp / nxp * 100')
guthlevelsystem.CommandFormatMessage    =   "You are at level {level} and to {xp}/{nxp} XP ({percent}%) from next level."
--  Arguments Highlight Color
guthlevelsystem.CommandHighlightColor   =   Color( 230, 110, 40 )