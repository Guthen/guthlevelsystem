LEVELSYSTEM = LEVELSYSTEM or {}

--  > Config <  --

--  > How much we multiplicate the level to this to get the next needed xp of the new level
LEVELSYSTEM.NXBase              =   400
--  > How much we multiplicate the needed xp to get the next needed xp of the new level
LEVELSYSTEM.NXPMultiplicator    =   1.1

--  > What sound is played when you received a notification
LEVELSYSTEM.NotificationSound   =   "Friends/friend_join.wav"

--  > Should we earn XP when we kill NPC
LEVELSYSTEM.OnNPCKilledEarnXP   =   true
--  > How many XP we earn when we kill a NPC (if -1 then we earn XP relative to NPC Max Health)
LEVELSYSTEM.OnNPCKilledXP       =   -1

--  > How many XP we earn when we kill a Player
LEVELSYSTEM.PlayerDeathXP       =   50

--  > How many seconds we should wait before get XP
LEVELSYSTEM.ByPlayingTimer      =   60
--  > How many XP we earn when we kill play on the server
LEVELSYSTEM.ByPlayingXP         =   150

print( "Loaded succesfully" )
