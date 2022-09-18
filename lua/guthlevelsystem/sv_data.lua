---   Database Configuration
--  The following configuration will only be used if you have installed gSQL (https://github.com/Gabyfle/gSQL/releases).
--  Otherwise, SQLite is used (so gSQL is not a necessary dependency).
guthlevelsystem.settings.database = {
    --  either "sqlite", "mysqloo" or "tmysql"
    --  WARNING: you also have to install MySQLOO (https://github.com/FredyH/MySQLOO)
    --  or tMySQL4 (https://github.com/bkacjios/gm_tmysql4) if you want to use them
    driver = "sqlite",
    --  If you use SQLite's driver, the following configuration are useless.
    host = "localhost",
    port = 3306,
    name = "?",
    user = "root",
    pass = "",
}

----
----

local migrations = {}
local migrations_path = "guthlevelsystem/migrations/"

function guthlevelsystem.query( query, callback )
    if Gsql then
        if not guthlevelsystem.database then 
            callback( false, "database not initialized!" )
            return
        end

        guthlevelsystem.database:query( query, {}, callback )
    else
        local result = sql.Query( query )
        local success = not ( result == false )
        callback( success, success and "success" or sql.LastError(), result ) 
    end
end

function guthlevelsystem.init_data_table()
    --  gSQL
    if Gsql then
        guthlevelsystem.database = Gsql:new( 
            guthlevelsystem.settings.database.driver, guthlevelsystem.settings.database,
            function( success, message )
                if not success then
                    return guthlevelsystem.error( "failed while connecting to database: %s (gSQL)", message )
                end

                timer.Simple( 0, function()  --  avoid aborting cause `guthlevelsystem.database` wouldn't be initialized
                    guthlevelsystem.print( "database connection successfully established (gSQL)" )
                    guthlevelsystem.migrate()
                end )
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
    ]]

    guthlevelsystem.query( query, function( success, message, data )
        if not success then return guthlevelsystem.error( "failed to migrate: %s", message ) end
        
        --  NOTE: I had to split the SELECT query from the previous query cause of MySQLOO
        --        not being able to determine which data to return
        guthlevelsystem.query( "SELECT version FROM guthlevelsystem_version LIMIT 1;", function( success, message, data )
            if not success then return guthlevelsystem.error( "failed to retrieve version while migrating: %s", message ) end

            local current_version = data[1] and data[1].version or 0
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
    end )
end

function guthlevelsystem.get_steamid_data( steamid, callback )
	local query = ( "SELECT * FROM guthlevelsystem_players WHERE steamid = %s" ):format( SQLStr( steamid ) )
	guthlevelsystem.query( query, function( success, message, data )
		if not success then
			callback( nil )
            return guthlevelsystem.error( "failed to get data of %q : %s", steamid, message )
		end

        if not data or #data == 0 then
            callback( nil )
        else
            callback( data )
        end
    end )
end

--  raw setters
function guthlevelsystem.set_steamid_raw_prestige( steamid, prestige )
    local query = ( "UPDATE guthlevelsystem_players SET prestige = %d WHERE steamid = %s" ):format( prestige, SQLStr( steamid ) )
    guthlevelsystem.query( query, function( success, message, data ) end )
end 

function guthlevelsystem.set_steamid_raw_level( steamid, level )
    local query = ( "UPDATE guthlevelsystem_players SET lvl = %d WHERE steamid = %s" ):format( level, SQLStr( steamid ) )
    guthlevelsystem.query( query, function( success, message, data ) end )
end 

function guthlevelsystem.set_steamid_raw_xp( steamid, xp )
    local query = ( "UPDATE guthlevelsystem_players SET xp = %d WHERE steamid = %s" ):format( xp, SQLStr( steamid ) )
    guthlevelsystem.query( query, function( success, message, data ) end )
end 

--  normal setters
function guthlevelsystem.set_steamid_prestige( steamid, prestige )
    prestige = math.min( prestige, guthlevelsystem.settings.prestige.maximum_prestige )

    local query = ( "UPDATE guthlevelsystem_players SET prestige = %d, lvl = %d, xp = %d WHERE steamid = %s" ):format( prestige, 1, 0, SQLStr( steamid ) )
    guthlevelsystem.query( query, function( success, message, data ) end )
end

function guthlevelsystem.set_steamid_level( steamid, level )
    level = math.min( level, guthlevelsystem.settings.maximum_level )

    local query = ( "UPDATE guthlevelsystem_players SET lvl = %d, xp = %d WHERE steamid = %s" ):format( level, 0, SQLStr( steamid ) )
    guthlevelsystem.query( query, function( success, message, data ) end )
end

function guthlevelsystem.set_steamid_xp( steamid, xp )
    guthlevelsystem.get_steamid_data( steamid, function( data )
        if not data then return end

        --  get first row
        data = data[1]

        --  convert values to number
        local prestige, level = tonumber( data.prestige ), tonumber( data.lvl )
        
        --  compute next values
        local nxp = guthlevelsystem.settings.nxp_formula( prestige, level )
        local level, xp, nxp = guthlevelsystem.compute_next_xp( prestige, level, xp, nxp )
        
        --  query changes
        local query = ( "UPDATE guthlevelsystem_players SET lvl = %d, xp = %d WHERE steamid = %s" ):format( level, xp, SQLStr( steamid ) )
        guthlevelsystem.query( query, function( success, message, data ) end )
    end )
end