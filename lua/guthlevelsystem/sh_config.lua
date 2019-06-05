guthlevelsystem = guthlevelsystem or {}

--  > Config <  --

--  > The maximum LVL that player can get
guthlevelsystem.MaximumLVL              =   50

--  > Should we save data on timer (recommended) or save on every functions calls
guthlevelsystem.SaveOnTimer             =   true
--  > If 'SaveOnTimer' is on true, the time between each save (in seconds)
guthlevelsystem.SaveTimer               =   300

--  > How much we multiplicate the level to this to get the next needed xp of the new level
guthlevelsystem.NXBase                  =   400
--  > How much we multiplicate the needed xp to get the next needed xp of the new level
guthlevelsystem.NXPMultiplicator        =   1.1

--  > The message sent to the player who earn XP by playing on the server (%d represent the XP earned)
guthlevelsystem.NotificationXPPlaying   =   "You earn %d XP by playing on the server !"
--  > The message sent to the player who earn XP (%d represent the XP earned)
guthlevelsystem.NotificationXP          =   "You earn %d XP, work harder !"
--  > The message sent to the player who earn LVL (%d represent the new level of the player)
guthlevelsystem.NotificationLVL         =   "You get to LVL %d, good job !"
--  > (DarkRP) The message sent to the player who attempted to change teams but cannot (%d represent the required level and %s the job name)
guthlevelsystem.NotificationJob         =   "You need to be LVL %d to become %s !"
--  > What sound is played when you received a notification (earn XP)
guthlevelsystem.NotificationSoundXP     =   "Friends/friend_join.wav"
--  > What sound is played when you received a notification (earn LVL)
guthlevelsystem.NotificationSoundLVL    =   "Friends/friend_online.wav"

--  > Should we earn XP when we kill a NPC
guthlevelsystem.OnNPCKilledEarnXP       =   true
--  > How many XP we earn when we kill a NPC (if -1 then we earn XP relative to NPC Max Health)
guthlevelsystem.OnNPCKilledXP           =   -1

--  > Should we earn XP when we kill a Player
guthlevelsystem.PlayerDeathEarnXP       =   true
--  > How many XP we earn when we kill a Player
guthlevelsystem.PlayerDeathXP           =   50

--  > How many seconds we should wait before get XP (def: 60 seconds)
guthlevelsystem.ByPlayingTimer          =   60
--  > How many XP we earn when we kill play on the server (def: 150 XP each 60 seconds)
guthlevelsystem.ByPlayingXP             =   150

--  > Should we show the default HUD
guthlevelsystem.DrawHUD                 =   true
--  > HUD Font (can be seen here : http://wiki.garrysmod.com/page/Default_Fonts)
guthlevelsystem.HUDFont                 =   "DermaLarge"
--  > HUD X LVL
guthlevelsystem.HUDXLVL                 =   CLIENT and 30
--  > HUD Y LVL
guthlevelsystem.HUDYLVL                 =   CLIENT and ScrH()*.75
--  > HUD LVL Text
guthlevelsystem.HUDTextLVL              =   "Level : "
--  > HUD X XP
guthlevelsystem.HUDXXP                  =   CLIENT and 30
--  > HUD Y LVL
guthlevelsystem.HUDYXP                  =   CLIENT and ScrH()*.79
--  > HUD XP Text
guthlevelsystem.HUDTextXP               =   "XP : "
--  > HUD LVL Use Percentage
guthlevelsystem.HUDLVLPercentage        =   false

--  > This addon is entirely made by Guthen <  --

print( "Loaded succesfully" )
