guthlevelsystem = guthlevelsystem or {}

--  LVL
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

    if trg:IsValid() then
        if SERVER then trg:LSSetLVL( lvl ) end
        print( "GU-LS: " .. trg:Name() .. " has been set to LVL " .. lvl )
    end
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

    if trg:IsValid() then
        if SERVER then trg:LSAddLVL( lvl ) end
        print( "GU-LS: " .. trg:Name() .. "'s LVL has been added " .. lvl )
    end
end )

--  XP
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

    if trg:IsValid() then
        if SERVER then trg:LSSetXP( xp ) end
        print( "GU-LS: " .. trg:Name() .. " has been set to XP " .. xp )
    end
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

    if trg:IsValid() then
        if SERVER then trg:LSAddXP( xp ) end
        print( "GU-LS: " .. trg:Name() .. " has been set to XP " .. xp )
    end
end )

--  INFO
concommand.Add( "guthlevelsystem_info", function( ply, _, args )
    local msg = string.format(
        "GU-LS: 'guthlevelsystem' is made by %s.\nThe installed version is %s.\nDownload the addon here : %s.\nJoin freely my Discord : %s.",
        guthlevelsystem.Author, guthlevelsystem.Version, guthlevelsystem.Link, guthlevelsystem.Discord)

    if ply:IsValid() then
        ply:PrintMessage( HUD_PRINTCONSOLE, msg )
    else
        print( msg )
    end
end )

print( "Loaded succesfully" )
