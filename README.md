# guthlevelsystem

## Work in any gamemode (DarkRP, Sandbox...)

## Installation 

+ Download the addon and extract it in your addons folder.
+ Configure the addon in `guthlevelsystem/sh_config.lua`
+ Reboot your server

## DarkRP job compatibility

Add this line in your chosed job and change the `x` by the required level : `LSlvl = x,`

Exemple, `TEAM_RANDOM` is only accessible on level 5 :
```
TEAM_RANDOM = DarkRP.createJob("Random", {
    color = Color(226, 47, 255, 255),
    model = {"models/player/eli.mdl"},
    description = [[waw]],
    weapons = {},
    command = "random",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    LSlvl = 5, -- here is my required lvl to be able to choose the job
})
```

## Console Commands

+ `guthlevelsystem_set_lvl <lvl> <name>` : Set LVL to `<lvl>` to `<name>` (if specified, else LVL go to the user who call command) 

+ `guthlevelsystem_add_lvl <lvl> <name>` : Add LVL to `<lvl>` to `<name>` (if specified, else LVL go to the user who call command) 

+ `guthlevelsystem_set_xp <xp> <name>` : Set XP to `<xp>` to `<name>` (if specified, else XP go to the user who call command) 

+ `guthlevelsystem_add_xp <xp> <name>` : Add XP to `<xp>` to `<name>` (if specified, else XP go to the user who call command)

+ `guthlevelsystem_info` : Show info of the addon

## For developpers

This addon offers for developpers some functions.

#### XP

+ `Player:LSAddXP( n, silent, byPlaying )` where `n` is a number, and (OPTIONAL) `silent` (show or hide the notification) and `byPlaying` (if `true`, the notification will be the notification for play to the server) are a boolean 

+ `Player:LSSetXP( n )` where `n` is a number

+ `Player:LSGetXP()`, returns XP of `Player`

+ `Player:LSCalcNXP()`, calculates and returns Needed XP of `Player`

+ `Player:LSGetNXP()`, returns Needed XP

#### LVL

+ `Player:LSAddLVL( n, silent )` where `n` is a number and (OPTIONAL) `silent` (show or hide the notification) is a boolean

+ `Player:LSSetLVL( n, silent )` where `n` is a number and (OPTIONAL) `silent` (show or hide the notification) is a boolean

+ `Player:LSGetLVL()`, returns LVL of `Player`

#### Data

+ `Player:LSCreateData()`, create level system data

+ `Player:LSSaveData()`, save level system data

+ `Player:LSGetData()`, load level system data to put in `Player` (used in `PlayerInitialSpawn` to load data and then use others function)

+ `Player:LSHasData()`, returns true if `Player` has level system data

+ `Player:LSResetData()`, reset to zero level system data of `Player`

+ `Player:LSSendData()`, send to CLIENT the level, xp and nxp (used in HUD)

#### Other

+ `Player:LSSendNotif( msg, type, snd )`, where `msg` is the text, `type` the `NOTIFY_` (http://wiki.garrysmod.com/page/Enums/NOTIFY) and `snd` the sound file name
