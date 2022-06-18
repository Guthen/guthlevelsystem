# guthlevelsystem

## Features
+ Works in every **gamemode** : **DarkRP**, **Sandbox**, etc..
+ **XP**, **Level** & **Prestige** system
+ **DarkRP job** compatibility
+ Customizable **XP Multipliers** for **Ranks** & **Teams** (=jobs)
+ Customizable **XP Earning Events** : NPC/Player kill & Playing on the server
+ Customizable **HUDs**
+ Commands for **Level & Prestige**

## Installation
+ Download the addon and extract it in your addons folder.
+ Configure the addon in `lua/guthlevelsystem/sh_config.lua`
+ Reboot your server
+ Most importantlty, have fun! :)

## Custom HUDs
For now, there are **2 default HUDs** that you can choose to use (or not) :

`default_progress`
![default_progress](https://media.discordapp.net/attachments/579628254814666762/961019202653790278/default_progress.jpg?width=1246&height=701)
`default_text`
![default_text](https://media.discordapp.net/attachments/579628254814666762/961019202939015208/default_text.jpg?width=1246&height=701)

Custom HUDs are located in `lua/guthlevelsystem/hud` and **you can choose one** by specifying the configuration variable `guthlevelsystem.settings.hud.selected` in `sh_config.lua`

## ULX & SAM & xAdmin2 compatibility
ULX, SAM & xAdmin2 have common commands implemented for managing levels and XPs of players, such as :
+ `gls_add_xp <player> <amount>`: Add `amount` XP to `player`
+ `gls_add_level <player> <amount>`: Add `amount` level to `player`
+ `gls_set_xp <player> <amount>`: Set `player`'s XP to `amount`
+ `gls_set_level <player> <amount>`: Set `player`'s level to `amount`

## DarkRP job compatibility
### Level
Adding a level constraint to a DarkRP job is quite simple, you have to add a variable `level = X,` (or `LSlvl = x`; default to `0`) to it and to replace `X` by the level wanted. See example below

Example, `TEAM_RANDOM` is accessible at least at level `5` :
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
    LSlvl = 5, --  here is my required level to be able to choose the job
    level = 5, --  or, I can write it like that!
})
```

### Prestige
Adding a prestige condition is similar to the level, you have to add an other variable `prestige = Y,` (default to `0`) to the job, again, replace `Y` by the prestige wanted. See example below

Example, `TEAM_VIP` is accessible at least at level `5` of the `2`nd prestige :
```
TEAM_VIP = DarkRP.createJob("VIP", {
    color = Color(226, 47, 255, 255),
    model = {"models/player/gman.mdl"},
    description = [[wuw]],
    weapons = {},
    command = "vip",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    LSlvl = 5, --  here is my required level to be able to choose the job
    level = 5, --  or, I can write it like that!
    prestige = 2, --  and here's my prestige minimum!
})
```

### Level Priority over Prestige
If you don't want to make a job only available from a level `X` from any prestige `Y`, add the variable `has_level_priority = true,` (default to `false`) to your job.

For instance, a job set to level `20` and prestige `2`:
+ `has_level_priority == false` : you can enter the job when you reach the level `20` of the `2`nd prestige (& the `1`st level of the `3`rd prestige works too) 
+ `has_level_priority == true` : you must be at least level `20` of the `2`nd prestige too (but `1`st level of the `3`rd prestige doesn't work because you have to be level `20`) 


## SQL Drivers
If you just want a basic saving system (default: SQLite), just ignore that part.

This level system is compatible with [Gabyfle/gSQL](https://github.com/Gabyfle/gSQL/releases) library, which means that you can easily use a different SQL driver such as [MySQLOO](https://github.com/FredyH/MySQLOO) or [tMySQL4](https://github.com/bkacjios/gm_tmysql4) by downloading and installing theses systems on your server.

As said before, you have to install [Gabyfle/gSQL](https://github.com/Gabyfle/gSQL/releases) and the SQL driver of your choice. Once it's done, configure the database file (at the top) of my system located at `lua/guthlevelsystem/sv_data.lua` (it's not located at `sh_config.lua` for security reasons).

## Console Commands
+ `guthlevelsystem_set_lvl <level> <name>` : Set level `<level>` to `<name>` (if specified, else level go to the user who call command)
+ `guthlevelsystem_add_lvl <level> <name>` : Add level `<level>` to `<name>` (if specified, else level go to the user who call command)
+ `guthlevelsystem_set_xp <xp> <name>` : Set XP `<xp>` to `<name>` (if specified, else XP go to the user who call command)
+ `guthlevelsystem_add_xp <xp> <name>` : Add XP `<xp>` to `<name>` (if specified, else XP go to the user who call command)
+ `guthlevelsystem_info` : Show info of the addon

## For developpers
**/!\ The API changed in the version 2.0.0, if you use my addon somehow, please check for incompatibilities & errors in your mod**

### Hooks
Since the version 1.3.0, customs hooks have been added:

#### Server
+ **void** `guthlevelsystem:on_player_init_data`
    + **Player** `ply`
+ **void** `guthlevelsystem:on_player_save_data`
    + **Player** `ply`
+ **void** `guthlevelsystem:on_player_reset_data` 
    + **Player** `ply`
    + *NOTE: a call to `guthlevelsystem:on_player_init_data` is made before*
+ **bool** `guthlevelsystem:can_player_earn_prestige`
    + **Player** `ply`
    + **int** `diff_prestige` 
    + *NOTE: runned when calling `Player/gls_add_prestige` or `Player/gls_set_prestige`*
+ **void** `guthlevelsystem:on_player_earn_prestige`
    + **Player** `ply`
    + **int** `diff_prestige`
+ **bool** `guthlevelsystem:can_player_earn`
    + **Player** `ply`
    + **int** `diff_level`
    + **int** `diff_xp`
    + *NOTE: runned when calling `Player/gls_add_level`, `Player/gls_set_level`, `Player/gls_add_xp` & `Player/gls_set_xp`*
+ **void** `guthlevelsystem:on_player_earn`
    + **Player** `ply`
    + **int** `diff_level`
    + **int** `diff_xp`
+ **float** `guthlevelsystem:custom_xp_multiplier`
    + **Player** `ply`
    + **float** `current_multiplier`
    + *NOTE:*
        + *this hook doesn't allow cumulable multipliers, consider overriding `Player/gls_get_xp_multiplier` for that*
        + *runned when calling `Player/gls_add_xp`*
#### Client
+ **bool** `HUDShouldDraw`
    + **string** `name="guthlevelsystem:HUD"`
    + return `false` to disable the HUD

#### Shared
+ **void** `guthlevelsystem:on_loaded`
    + called when the addon is fully loaded

## Contact
Feel free to propose update, functionnalities or report bugs and exploits on the [issues](https://github.com/Guthen/guthlevelsystem/issues) page my [Discord](https://discord.gg/eKgkpCf).
