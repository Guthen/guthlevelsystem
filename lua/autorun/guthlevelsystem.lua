guthlevelsystem = guthlevelsystem or {}
guthlevelsystem.Author      =   "Guthen"
guthlevelsystem.Version     =   "1.6.0"
guthlevelsystem.Link        =   "https://github.com/Guthen/guthlevelsystem"
guthlevelsystem.Discord     =   "https://discord.gg/eKgkpCf"

if SERVER then
    include( "guthlevelsystem/sv_base.lua" )
else
    include( "guthlevelsystem/cl_base.lua" )
end

print( "[guthlevelsystem] - Made by " .. guthlevelsystem.Author .. " in version " .. guthlevelsystem.Version .. ", type 'guthlevelsystem_info' for more info." )