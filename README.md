# guthlevelsystem
## Work in any gamemode (DarkRP, Sandbox...)

## Installation
+ Download the addon and extract it in your addons folder.
+ Configure the addon in `lua/guthlevelsystem/sh_config.lua`
+ Reboot your server

## Custom HUDs
For now, there are **2 default HUDs** that you can choose to use (or not) :
### default_progress
![default_progress](https://media.discordapp.net/attachments/579628254814666762/961019202653790278/default_progress.jpg?width=1246&height=701)
### default_text
![default_text](https://media.discordapp.net/attachments/579628254814666762/961019202939015208/default_text.jpg?width=1246&height=701)

Custom HUDs are located in `lua/guthlevelsystem/hud` and **you can choose one** by specifying the configuration variable `guthlevelsystem.SelectedHUD` in `sh_config.lua`

## ULX & SAM & xAdmin2 compatibility
ULX, SAM & xAdmin2 have common commands implemented for managing levels and XPs of players, such as :
+ `gls_add_xp <player> <amount>`: Add `amount` XP to `player`
+ `gls_add_level <player> <amount>`: Add `amount` level to `player`
+ `gls_set_xp <player> <amount>`: Set `player`'s XP to `amount`
+ `gls_set_level <player> <amount>`: Set `player`'s level to `amount`

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
    LSlvl = 5, -- here is my required level to be able to choose the job
})
```

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
### Hooks
Since the version 1.3.0, customs hooks have been added:
+ [SH] `guthlevelsystem:OnLoaded` : no return

+ [SV] `guthlevelsystem:OnPlayerCreateData` : `Player`, no return
+ [SV] `guthlevelsystem:on_player_save_data` : `Player`, `silent`, no return
+ [SV] `guthlevelsystem:OnPlayerGetData` : `Player`, no return
+ [SV] `guthlevelsystem:on_player_reset_data` : `Player`, no return

+ [SV] `guthlevelsystem:ShouldPlayerAddXP` : `Player`, `xp`, `silent`, `byPlaying`, return false to add give xp
+ [SV] `guthlevelsystem:OnPlayerAddXP` : `Player`, `xp`, `silent`, `byPlaying`, no return
+ [SV] `guthlevelsystem:ShouldPlayerSetXP` : `Player`, `xp`, return false to don't set xp
+ [SV] `guthlevelsystem:OnPlayerSetXP` : `Player`, `xp`, no return

+ [SV] `guthlevelsystem:ShouldPlayerAddlevel` : `Player`, `level`, return false to don't add level
+ [SV] `guthlevelsystem:OnPlayerAddlevel` : `Player`, `level`, no return
+ [SV] `guthlevelsystem:ShouldPlayerSetlevel` : `Player`, `level`, `silent`, return false to don't set level
+ [SV] `guthlevelsystem:OnPlayerSetlevel` : `Player`, `level`, `silent`, no return

+ [SV] `guthlevelsystem:ShouldPlayerSendNotif` : `Player`, `msg`, `type`, `snd`, return false to don't send notif
+ [SV] `guthlevelsystem:OnPlayerSendNotif` : `Player`, `msg`, `type`, `snd`, no return

+ [SV] `guthlevelsystem:OnPlayerAddByPlayingXP` : `Player`, `playingXP`, return a number to set the XP to receive

+ [CL] `HUDShouldDraw` : `"guthlevelsystem:HUD"`, return false to disable the HUD

### Contact

Feel free to propose update, functionnalities or report bugs and exploits on my Discord or on this GitHub repository.

My Discord : https://discord.gg/eKgkpCf
