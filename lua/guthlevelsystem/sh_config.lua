LEVELSYSTEM = LEVELSYSTEM or {}

--  > Config <  --

LEVELSYSTEM.MaximumLVL              =   50

--  > Should we save data on timer (recommended) or save on every functions calls
LEVELSYSTEM.SaveOnTimer             =   true
--  > If 'SaveOnTimer' is on true, the time between each save (in seconds)
LEVELSYSTEM.SaveTimer               =   300

--  > How much we multiplicate the level to this to get the next needed xp of the new level
LEVELSYSTEM.NXBase                  =   400
--  > How much we multiplicate the needed xp to get the next needed xp of the new level
LEVELSYSTEM.NXPMultiplicator        =   1.1

--  > The message sent to the player who earn XP by playing on the server (%d represent the XP earned)
LEVELSYSTEM.NotificationXPPlaying   =   "You earn %d XP by playing on the server !"
--  > The message sent to the player who earn XP (%d represent the XP earned)
LEVELSYSTEM.NotificationXP          =   "You earn %d XP, work harder !"
--  > The message sent to the player who earn LVL (%d represent the new level of the player)
LEVELSYSTEM.NotificationLVL         =   "You get to LVL %d, good job !"
--  > (DarkRP) The message sent to the player who attempted to change teams but cannot (%d represent the required level and %s the job name)
LEVELSYSTEM.NotificationJob         =   "You need to be LVL %d to become %s !"
--  > What sound is played when you received a notification (earn XP)
LEVELSYSTEM.NotificationSoundXP     =   "Friends/friend_join.wav"
--  > What sound is played when you received a notification (earn LVL)
LEVELSYSTEM.NotificationSoundLVL    =   "Friends/friend_online.wav"

--  > Should we earn XP when we kill a NPC
LEVELSYSTEM.OnNPCKilledEarnXP       =   true
--  > How many XP we earn when we kill a NPC (if -1 then we earn XP relative to NPC Max Health)
LEVELSYSTEM.OnNPCKilledXP           =   -1

--  > Should we earn XP when we kill a Player
LEVELSYSTEM.PlayerDeathEarnXP       =   true
--  > How many XP we earn when we kill a Player
LEVELSYSTEM.PlayerDeathXP           =   50

--  > How many seconds we should wait before get XP (def: 60 seconds)
LEVELSYSTEM.ByPlayingTimer          =   60
--  > How many XP we earn when we kill play on the server (def: 150 XP each 60 seconds)
LEVELSYSTEM.ByPlayingXP             =   150

--  > HUD Font (can be seen here : http://wiki.garrysmod.com/page/Default_Fonts)
LEVELSYSTEM.HUDFont                 =   "DermaLarge"
--  > HUD X LVL
LEVELSYSTEM.HUDXLVL                 =   CLIENT and 30
--  > HUD Y LVL
LEVELSYSTEM.HUDYLVL                 =   CLIENT and ScrH()*.75
--  > HUD LVL Text
LEVELSYSTEM.HUDTextLVL              =   "Level : "
--  > HUD X XP
LEVELSYSTEM.HUDXXP                  =   CLIENT and 30
--  > HUD Y LVL
LEVELSYSTEM.HUDYXP                  =   CLIENT and ScrH()*.79
--  > HUD XP Text
LEVELSYSTEM.HUDTextXP               =   "XP : "
--  > HUD LVL Use Percentage
LEVELSYSTEM.HUDLVLPercentage        =   true

--  > This addon is entirely made by Guthen <  --

print( "Loaded succesfully" )
