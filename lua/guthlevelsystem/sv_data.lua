---   Database Configuration
--  The following configuration will only be used if you have installed gSQL (https://github.com/Gabyfle/gSQL/releases).
--  Otherwise, SQLite is used (so gSQL is not a necessary dependency).
guthlevelsystem.DatabaseDriver = "sqlite"  --  either "sqlite", "mysqloo" or "tmysql"
                                           --  WARNING: you also have to install MySQLOO (https://github.com/FredyH/MySQLOO)
                                           --  or tMySQL4 (https://github.com/bkacjios/gm_tmysql4) if you want to use them

--  If you use SQLite's driver, the following configuration are useless.
guthlevelsystem.DatabaseHost = "localhost"
guthlevelsystem.DatabasePort = 3306
guthlevelsystem.DatabaseName = "?"
guthlevelsystem.DatabaseUser = "root"
guthlevelsystem.DatabasePassword = ""

----
----

local db
function guthlevelsystem.Query( query, callback )
    if Gsql then
        if not db then return false, "Database not initialized" end

        db:query( query, {}, callback )
    else
        local result = sql.Query( query )
        local success = not ( result == false )
        callback( success, success and "success" or sql.LastError(), result ) 
    end
end

function guthlevelsystem.CreateDataTable()
    local query = "CREATE TABLE IF NOT EXISTS guth_ls( SteamID TEXT, XP INTEGER, LVL INTEGER )"

    --  gSQL
    if Gsql then
        db = Gsql:new( 
            guthlevelsystem.DatabaseDriver, guthlevelsystem.DatabaseHost, guthlevelsystem.DatabaseName,
            guthlevelsystem.DatabaseUser, guthlevelsystem.DatabasePassword, guthlevelsystem.DatabasePort, 
            function( success, message )
                if not success then
                    return guthlevelsystem.Notif( ( "Failed while connecting to database : %s (gSQL)" ):format( message ) )
                end

                --  create database
                timer.Simple( 0, function()  --  avoid indexing errors
                    db:query( query, {}, function( success, message, data )
                        if not success then
                            return guthlevelsystem.Notif( ( "Failed while creating database : %s (gSQL)" ):format( message ) )
                        end
                        guthlevelsystem.Notif( "Database connection successfully established (gSQL)" )
                    end )
                end )
            end
        )
    --  sqlite
    else
        local result = sql.Query( query )
        if result == false then return guthlevelsystem.Notif( "Failed while creating database : " .. sql.LastError() ) end
        
        guthlevelsystem.Notif( "Database connection successfully established" )
    end
end

function guthlevelsystem.DeleteDataTable()
    guthlevelsystem.Query( "DROP TABLE guth_ls", function( success, message, data )
        if not success then
            return guthlevelsystem.Notif( ( "Failed while dropping database : %s" ):format( self:GetName(), message ) )
        end

        guthlevelsystem.Notif( "Database has been dropped" )
    end )
end