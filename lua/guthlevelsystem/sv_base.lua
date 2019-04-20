LEVELSYSTEM = {}

local function load()
    print( "--->GU-LEVELSYSTEM<---" )

    LEVELSYSTEM.CreateDataTable( false )

    print( "Loading : Configuration" )
    include( "guthlevelsystem/sh_config.lua" )

    print( "Loading : Players" )
    include( "guthlevelsystem/sv_players.lua" )

    print( "Loading : Hooks" )
    include( "guthlevelsystem/sv_hooks.lua" )

    AddCSLuaFile( "guthlevelsystem/sh_config.lua" )
    
    AddCSLuaFile( "guthlevelsystem/cl_base.lua" )
    AddCSLuaFile( "guthlevelsystem/cl_hud.lua" )

    util.AddNetworkString( "LEVELSYSTEM:SendNotif" )
    util.AddNetworkString( "LEVELSYSTEM:SendData" )

    print( "------->LOADED<-------" )
end

function LEVELSYSTEM.Notif( txt )
    print( "GU-LS: " .. txt )
end

function LEVELSYSTEM.CreateDataTable( advert )
    if sql.TableExists( "guth_ls" ) then
        if advert or advert == nil then return LEVELSYSTEM.Notif( "SQL Data Table is already created !" ) end
        return
    end

    local query = "CREATE TABLE guth_ls( SteamID TEXT, XP INTEGER, NXP INTEGER, LVL INTEGER )"
    local _query = sql.Query( query )

    if _query == false then return LEVELSYSTEM.Notif( "SQL Error on trying to Create LS Data Table" ) end

    LEVELSYSTEM.Notif( "LS Data Table has been created" )
end

load()
