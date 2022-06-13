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

local migrations = {}
local migrations_path = "guthlevelsystem/migrations/"

local db
function guthlevelsystem.query( query, callback )
    if Gsql then
        if not db then return false, "Database not initialized" end

        db:query( query, {}, callback )
    else
        local result = sql.Query( query )
        local success = not ( result == false )
        callback( success, success and "success" or sql.LastError(), result ) 
    end
end

function guthlevelsystem.init_data_table()
    --  gSQL
    if Gsql then
        db = Gsql:new( 
            guthlevelsystem.DatabaseDriver, guthlevelsystem.DatabaseHost, guthlevelsystem.DatabaseName,
            guthlevelsystem.DatabaseUser, guthlevelsystem.DatabasePassword, guthlevelsystem.DatabasePort, 
            function( success, message )
                if not success then
                    return guthlevelsystem.error( "failed while connecting to database: %s (gSQL)", message )
                end

                guthlevelsystem.print( "database connection successfully established (gSQL)" )
                guthlevelsystem.migrate()
            end
        )
    --  sqlite
    else
        guthlevelsystem.print( "database connection successfully established" )
        guthlevelsystem.migrate()
    end
end

function guthlevelsystem.run_migration( id, callback )
    local query = migrations[id]
    if not query then return guthlevelsystem.error( "migration %d not found, aborting..", id ) end

    guthlevelsystem.query( query, callback )
end

function guthlevelsystem.migrate()
    --  retrieve all migrations
    migrations = {}
    for i, v in ipairs( file.Find( migrations_path .. "/*.sql", "LUA" ) ) do
        migrations[i] = file.Read( migrations_path .. v, "LUA" )
    end

    --  create migration table 
    --   (thankx to https://github.com/Erlite/Advisor/blob/master/lua/advisor-modules/sql/sv_migrations.lua)
    local query = [[
        CREATE TABLE IF NOT EXISTS guthlevelsystem_version(
            version INTEGER NOT NULL
        );
        INSERT INTO guthlevelsystem_version SELECT 0 WHERE NOT EXISTS ( SELECT * FROM guthlevelsystem_version );

        SELECT version FROM guthlevelsystem_version LIMIT 1;
    ]]

    guthlevelsystem.query( query, function( success, message, data )
        if not success then return guthlevelsystem.error( "failed to migrate: %s", message ) end
        
        local current_version = data[1].version
        local diff_version = #migrations - current_version
        if diff_version == 0 then
            guthlevelsystem.print( "database is up-to-date, no migrations to run" )
            return
        elseif diff_version < 0 then 
            return 
        end

        --  migrating..
        guthlevelsystem.print( "%d version(s) of difference, migrating..", diff_version )

        local i = current_version + 1
        local function run_next_migration()
            if i > #migrations then 
                guthlevelsystem.query( "UPDATE guthlevelsystem_version SET version = " .. #migrations, function( success, message )
                    if not success then return guthlevelsystem.error( "failed to set migration version: %s", message ) end
                    
                    guthlevelsystem.print( "migration successfully finished!" )
                end )
                return 
            end

            guthlevelsystem.query( migrations[i], function( success, message )
                if not success then return guthlevelsystem.error( "failed to run migration %d: %s", i, message ) end

                guthlevelsystem.print( "migration %d successfull!", i )
                i = i + 1

                run_next_migration()
            end )
        end
        run_next_migration()
    end )
end