guthlevelsystem = guthlevelsystem or {}

--  Config

--  The maximum LVL that player can get
guthlevelsystem.MaximumLVL              =   50

--  Should we save data on timer (recommended) or save on every functions calls
guthlevelsystem.SaveOnTimer             =   true
--  If 'SaveOnTimer' is on true, the time between each save (in seconds)
guthlevelsystem.SaveTimer               =   300

--  How much we multiplicate the level to this to get the next needed xp of the new level
guthlevelsystem.NXBase                  =   400
--  How much we multiplicate the needed xp to get the next needed xp of the new level
guthlevelsystem.NXPMultiplicator        =   1.1

--  XP Multiplicators for specific Ranks
guthlevelsystem.RankXPMultipliers = {
    --["superadmin"] = 2.5, --  XP of "superadmin" players multiplied by x2.5
    --["vip"] = 2, --  XP of "vip" players multiplied by x2
}

--  The message sent to the player who earn XP by playing on the server (%d represent the XP earned)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXPPlaying   =   "You earn {xp} XP by playing on the server {multiplier}!"
--  The message sent to the player who earn XP (%d represent the XP earned)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - xp: earned xp
--    - multiplier: applied rank multiplier (if has any or nothing otherwise)  
guthlevelsystem.NotificationXP          =   "You earn {xp} XP, work harder {multiplier}!"
--  The message sent to the player who earn LVL
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - lvl: player's level
guthlevelsystem.NotificationLVL         =   "You get to LVL {lvl}, good job!"
--  (DarkRP) The message sent to the player who attempted to change teams but cannot (%d represent the required level and %s the job name)
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - lvl: player's level
--    - job: job's name
guthlevelsystem.NotificationJob         =   "You need to be LVL {lvl} to become {job}!"

--  What sound is played when you received a notification (earn XP)
guthlevelsystem.NotificationSoundXP     =   "Friends/friend_join.wav"
--  What sound is played when you received a notification (earn LVL)
guthlevelsystem.NotificationSoundLVL    =   "Friends/friend_online.wav"

--  Should we earn XP when we kill a NPC
guthlevelsystem.OnNPCKilledEarnXP       =   true
--  How many XP we earn when we kill a NPC (if -1 then we earn XP relative to NPC Max Health)
guthlevelsystem.OnNPCKilledXP           =   -1
--  Should we earn XP when we kill a Player
guthlevelsystem.PlayerDeathEarnXP       =   true
--  How many XP we earn when we kill a Player
guthlevelsystem.PlayerDeathXP           =   50
--  Should we earn XP when we play on the server
guthlevelsystem.ByPlayingEarnXP       =   true
--  How many seconds we should wait before get XP (def: 60 seconds)
guthlevelsystem.ByPlayingTimer          =   60
--  How many XP we earn when we play on the server (def: 150 XP each 60 seconds)
guthlevelsystem.ByPlayingXP             =   150

--  Should we show the default HUD
guthlevelsystem.DrawHUD                 =   true
--  HUD Font (can be seen here : http://wiki.garrysmod.com/page/Default_Fonts)
guthlevelsystem.HUDFont                 =   "DermaLarge"
--  HUD X LVL
guthlevelsystem.HUDXLVL                 =   CLIENT and 30
--  HUD Y LVL
guthlevelsystem.HUDYLVL                 =   CLIENT and ScrH() * .75
--  HUD LVL Text
guthlevelsystem.HUDTextLVL              =   "Level : "
--  HUD X XP
guthlevelsystem.HUDXXP                  =   CLIENT and 30
--  HUD Y LVL
guthlevelsystem.HUDYXP                  =   CLIENT and ScrH() * .79
--  HUD XP Text
guthlevelsystem.HUDTextXP               =   "XP : "
--  HUD LVL Use Percentage
guthlevelsystem.HUDLVLPercentage        =   false

--  Chat Command
guthlevelsystem.CommandChat             =   "/level"
--  Command Message
--    Arguments must be enclosed with '{}'
--    Available arguments are:
--    - lvl: player's level
--    - xp: player's xp
--    - nxp: player's maximum xp to gain before reaching the next level
--    - percent: player's xp percentage before reaching the next level (literally equal to 'xp / nxp * 100')
guthlevelsystem.CommandFormatMessage    =   "You are at level {lvl} and to {xp}/{nxp} XP ({percent}%) from next level."
--  Arguments Highlight Color
guthlevelsystem.CommandHighlightColor   =   Color( 230, 110, 40 )

print( "Loaded succesfully" )
