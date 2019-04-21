# guthlevelsystem

## Work in any gamemode (DarkRP, Sandbox...)

## Installation 

+ Download the addon and extract it in your addons folder.
+ Configure the addon in `guthlevelsystem/sh_config.lua`
+ Reboot your server

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

+ `Player:LSResetData()`, reset to zero level system data of `Player`

+ `Player:LSSendData()`, send to CLIENT the level, xp and nxp (used in HUD)