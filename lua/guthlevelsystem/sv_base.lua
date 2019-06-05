guthlevelsystem = guthlevelsystem or {}

local function load()
    print( "--> [guthlevelsystem] <--" )

    guthlevelsystem.CreateDataTable( false )

    print( "Loading : Configuration" )
    include( "guthlevelsystem/sh_config.lua" )

    print( "Loading : Players" )
    include( "guthlevelsystem/sv_players.lua" )

    print( "Loading : Hooks" )
    include( "guthlevelsystem/sv_hooks.lua" )

    print( "Loading : Commands" )
    include( "guthlevelsystem/sh_commands.lua" )

    AddCSLuaFile( "guthlevelsystem/sh_config.lua" )
    AddCSLuaFile( "guthlevelsystem/sh_commands.lua" )

    AddCSLuaFile( "guthlevelsystem/cl_base.lua" )
    AddCSLuaFile( "guthlevelsystem/cl_hud.lua" )

    util.AddNetworkString( "guthlevelsystem:SendNotif" )

    print( "-------> LOADED <-------" )

    hook.Run( "guthlevelsystem:OnLoaded" )
end

function guthlevelsystem.Notif( txt )
    print( "[guthlevelsystem] - " .. txt )
end

function guthlevelsystem.CreateDataTable( advert )
    if sql.TableExists( "guth_ls" ) then
        if advert or advert == nil then return guthlevelsystem.Notif( "SQL Data Table is already created !" ) end
        return
    end

    local query = "CREATE TABLE guth_ls( SteamID TEXT, XP INTEGER, LVL INTEGER )"
    local result = sql.Query( query )

    if result == false then return guthlevelsystem.Notif( "SQL Error on trying to Create LS Data Table : " .. sql.LastError() ) end

    guthlevelsystem.Notif( "LS Data Table has been created" )
end

function guthlevelsystem.DeleteDataTable()
    if not sql.TableExists( "guth_ls" ) then return guthlevelsystem.Notif( "SQL Data Table doesn't exists !" ) end

    local query = "DROP TABLE guth_ls"
    local result = sql.Query( query )

    if result == false then return guthlevelsystem.Notif( "SQL Error on trying to Delete LS Data Table : " .. sql.LastError() ) end

    if not sql.TableExists( "guth_ls" ) then
        guthlevelsystem.Notif( "LS Data Table has been erased" )
    else
        guthlevelsystem.Notif( "LS Data Table hasn't been erased" )
    end
end

hook.Add( "Initialize", "guthlevelsystem:Load", load() )
