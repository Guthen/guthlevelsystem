# Patch Notes
## v1.7.0 ─ Add XP Rank Multiplier (#8)
### 04/04/2022
+ **ADD** : XP Rank Multiplier (see [#8](https://github.com/Guthen/guthlevelsystem/issues/8))
+ **UPDATE** : Changed Format of Notifications Texts in Configuration File 
+ **UPDATE** : Changed default Chat Command from `!level` to `/level`
+ **CODE FIX** : Cleaned-Up some parts of the Code 

## v1.7.1 ─ Fix NPC Kill XP Earning (again)
### 05/04/2022
+ **FIX** : XP Earning by Killing NPCs not working on some NPCs addons (see [#7](https://github.com/Guthen/guthlevelsystem/issues/7))

## v1.8.0 ─ Custom HUDs
### 05/04/2022
+ **ADD** : Custom HUD System
+ **ADD** : Added a Box Progress HUD and set as the default HUD

## v1.8.6 ─ Remove `SaveOnTimer` option
### 04/06/2022
+  **ADD** : Player Data is now saved as soon as it's modified 
+ **REMOVE** : `SaveOnTimer` config option & timer (see [#6](https://github.com/Guthen/guthlevelsystem/issues/6))

## v1.8.7 ─ Toggle HUD visibility through Client ConVar
### 04/06/2022
+  **ADD** : Client ConVar `guthlevelsystem_hud_enabled <1 or 0>` to toggle HUD visibility (see [#5](https://github.com/Guthen/guthlevelsystem/issues/5))

## v2.0.0 ─ Code Refactoring & Prestige System
### 04/06/2022
+  **ADD** : Github Version Checker
+  **ADD** : Add `guthlevelsystem_debug` convar to enable debug messages
+  **UPDATE** : prints are now colored depending of the type of information (error, warning, debug & info)
+  **UPDATE** : `guthlevelsystem_info` command has been renamed to `guthlevelsystem_about`
+  **CODE REFACTOR** : all functions names are now under **snake_case** naming convention
+  **CODE REFACTOR** : XP & Level setters functions are no longer recursive 
### 05/06/2022
+  **ADD** : DarkRP Job support for variable `level` 
+  **UPDATE** : XP 'Earn by Events' Configuration are now editable functions instead of numbers
### 06/06/2022
+  **ADD** : SQL Database Migrations for Prestige system
+  **ADD** : Prestige System
+  **CODE REFACTOR** : configuration variables are now under **snake_case** naming convention and organized in their relative tables 
### 09/06/2022
+  **ADD** : Configuration for HUD_PRINTCENTER notifications
+  **ADD** : Add Prestige commands to ULX
### 13/06/2022
+  **ADD** : Add Prestige commands to guthlevelsystem, SAM & xAdmin2