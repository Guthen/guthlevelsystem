# guthlevelsystem

## Work in any gamemode (DarkRP, Sandbox...)

## Installation

+ Download the addon and extract it in your addons folder.
+ Configure the addon in `lua/guthlevelsystem/sh_config.lua`
+ Reboot your server

## ULX & SAM & xAdmin2 compatibility
ULX, SAM & xAdmin2 have common commands implemented for managing levels and XPs of players, such as :
+ `lsaddxp <player> <amount>`: Add `amount` XP to `player`
+ `lsaddlvl <player> <amount>`: Add `amount` LVL to `player`
+ `lssetxp <player> <amount>`: Set `player`'s XP to `amount`
+ `lssetlvl <player> <amount>`: Set `player`'s LVL to `amount`

## DarkRP job compatibility

Add this line in your chosed job and change the `x` by the required level : `LSlvl = x,`

Example, `TEAM_RANDOM` is only accessible on level 5 :
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

## SQL Drivers
If you just want a basic saving system (default: SQLite), just ignore that part.

This level system is compatible with [Gabyfle/gSQL](https://github.com/Gabyfle/gSQL/releases) library, which means that you can easily use a different SQL driver such as [MySQLOO](https://github.com/FredyH/MySQLOO) or [tMySQL4](https://github.com/bkacjios/gm_tmysql4) by downloading and installing theses systems on your server.

As said before, you have to install [Gabyfle/gSQL](https://github.com/Gabyfle/gSQL/releases) and the SQL driver of your choice. Once it's done, configure the database file (at the top) of my system located at `lua/guthlevelsystem/sv_data.lua` (it's not located at `sh_config.lua` for security reasons).

## Console Commands

+ `guthlevelsystem_set_lvl <lvl> <name>` : Set LVL `<lvl>` to `<name>` (if specified, else LVL go to the user who call command)

+ `guthlevelsystem_add_lvl <lvl> <name>` : Add LVL `<lvl>` to `<name>` (if specified, else LVL go to the user who call command)

+ `guthlevelsystem_set_xp <xp> <name>` : Set XP `<xp>` to `<name>` (if specified, else XP go to the user who call command)

+ `guthlevelsystem_add_xp <xp> <name>` : Add XP `<xp>` to `<name>` (if specified, else XP go to the user who call command)

+ `guthlevelsystem_info` : Show info of the addon

## For developpers

### Hooks

Since the version 1.3.0, customs hooks have been added ( [SIDE] `hook:name` : `vars`, if return ):
+ [SH] `guthlevelsystem:OnLoaded` : no return

+ [SV] `guthlevelsystem:OnPlayerCreateData` : `Player`, no return
+ [SV] `guthlevelsystem:OnPlayerSaveData` : `Player`, `silent`, no return
+ [SV] `guthlevelsystem:OnPlayerGetData` : `Player`, no return
+ [SV] `guthlevelsystem:OnPlayerResetData` : `Player`, no return

+ [SV] `guthlevelsystem:ShouldPlayerAddXP` : `Player`, `xp`, `silent`, `byPlaying`, return false to add give xp
+ [SV] `guthlevelsystem:OnPlayerAddXP` : `Player`, `xp`, `silent`, `byPlaying`, no return
+ [SV] `guthlevelsystem:ShouldPlayerSetXP` : `Player`, `xp`, return false to don't set xp
+ [SV] `guthlevelsystem:OnPlayerSetXP` : `Player`, `xp`, no return

+ [SV] `guthlevelsystem:ShouldPlayerAddLVL` : `Player`, `lvl`, return false to don't add lvl
+ [SV] `guthlevelsystem:OnPlayerAddLVL` : `Player`, `lvl`, no return
+ [SV] `guthlevelsystem:ShouldPlayerSetLVL` : `Player`, `lvl`, `silent`, return false to don't set lvl
+ [SV] `guthlevelsystem:OnPlayerSetLVL` : `Player`, `lvl`, `silent`, no return

+ [SV] `guthlevelsystem:ShouldPlayerSendNotif` : `Player`, `msg`, `type`, `snd`, return false to don't send notif
+ [SV] `guthlevelsystem:OnPlayerSendNotif` : `Player`, `msg`, `type`, `snd`, no return

+ [SV] `guthlevelsystem:OnPlayerAddByPlayingXP` : `Player`, `playingXP`, return a number to set the XP to receive

+ [CL] `HUDShouldDraw` : `"guthlevelsystem:HUD"`, return false to disable the HUD

### Customs Functions

If you want to get LVL/XP/NXP (specially for CLIENT), (check the `cl_hud.lua`) use :
+ `ply:GetNWInt("guthlevelsystem:LVL", 0)`
+ `ply:GetNWInt("guthlevelsystem:XP", 0)`
+ `ply:GetNWInt("guthlevelsystem:NXP", 0)`

**The following functions are SERVER side only :**

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

+ `Player:LSLoadData()`, load level system data to put in `Player` (used in `PlayerInitialSpawn` to load data and then use others function)

+ `Player:LSGetData( callback )`, get all level data and call the `callback` function( boolean success, string message, table data ) 

+ `Player:LSResetData()`, reset to zero level system data of `Player`

+ `Player:LSSendData()`, send to CLIENT the level, xp and nxp (used in HUD)

#### Other

+ `Player:LSSendNotif( msg, type, snd )`, where `msg` is the text, `type` the `NOTIFY_` (http://wiki.garrysmod.com/page/Enums/NOTIFY) and `snd` the sound file name

### Contact

Feel free to propose update, functionnalities or report bugs and exploits on my Discord or on this GitHub repository.

My Discord : https://discord.gg/eKgkpCf
