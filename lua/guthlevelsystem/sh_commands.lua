LEVELSYSTEM = LEVELSYSTEM or {}

concommand.Add( "guthlevelsystem_set_lvl", function( ply, _, args )
    if ply:IsValid() and not ply:IsSuperAdmin() then return end

    local lvl = tonumber( args[1] )
    local name = args[2]

    if not lvl then return end

    local trg = ply
    if name then
        for _, v in pairs( player.GetHumans() ) do
            if string.StartWith( v:Name(), name ) then trg = v end
        end
    end

    if SERVER then trg:LSSetLVL( lvl ) end
    print( "GU-LS: " .. trg:Name() .. " has been set to LVL " .. lvl )
end )

concommand.Add( "guthlevelsystem_add_lvl", function( ply, _, args )
    if ply:IsValid() and not ply:IsSuperAdmin() then return end

    local lvl = tonumber( args[1] )
    local name = args[2]

    if not lvl then return end

    local trg = ply
    if name then
        for _, v in pairs( player.GetHumans() ) do
            if string.StartWith( v:Name(), name ) then trg = v end
        end
    end

    if SERVER then trg:LSAddLVL( lvl ) end
    print( "GU-LS: " .. trg:Name() .. "'s LVL has been added " .. lvl )
end )

concommand.Add( "guthlevelsystem_set_xp", function( ply, _, args )
    if ply:IsValid() and not ply:IsSuperAdmin() then return end

    local xp = tonumber( args[1] )
    local name = args[2]

    if not xp then return end

    local trg = ply
    if name then
        for _, v in pairs( player.GetHumans() ) do
            if string.StartWith( v:Name(), name ) then trg = v end
        end
    end

    if SERVER then trg:LSSetXP( xp ) end
    print( "GU-LS: " .. trg:Name() .. " has been set to XP " .. xp )
end )

concommand.Add( "guthlevelsystem_add_xp", function( ply, _, args )
    if ply:IsValid() and not ply:IsSuperAdmin() then return end

    local xp = tonumber( args[1] )
    local name = args[2]

    if not xp then return end

    local trg = ply
    if name then
        for _, v in pairs( player.GetHumans() ) do
            if string.StartWith( v:Name(), name ) then trg = v end
        end
    end

    if SERVER then trg:LSAddXP( xp ) end
    print( "GU-LS: " .. trg:Name() .. " has been set to XP " .. xp )
end )

print( "Loaded succesfully" )
