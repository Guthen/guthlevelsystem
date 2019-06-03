LEVELSYSTEM = LEVELSYSTEM or {}
LEVELSYSTEM.Author      =   "Guthen"
LEVELSYSTEM.Version     =   "1.2.4"
LEVELSYSTEM.Link        =   "https://github.com/Guthen/guthlevelsystem"
LEVELSYSTEM.Discord     =   "https://discord.gg/eKgkpCf"

if SERVER then
    include( "guthlevelsystem/sv_base.lua" )
else
    include( "guthlevelsystem/cl_base.lua" )
end

print( "[guthlevelsystem] - Made by " .. LEVELSYSTEM.Author .. " in version " .. LEVELSYSTEM.Version .. ", type 'guthlevelsystem_info' for more info." )
