local CATEGORY_NAME = "guthlevelsystem"

xAdmin.RegisterCommand( "lsaddxp", "Add XP", "Add XP to a specified player", "%s add %d XP to %s", CATEGORY_NAME, function( admin, args )
    local targets = xAdmin.GetTargetsFromArg( admin, "lsaddxp", args[1] )
    local amount = tonumber( args[2] )

    for i, v in ipairs( targets ) do
        local ply = player.GetBySteamID( v )
        if IsValid( ply ) then
            ply:LSAddXP( amount )
        end
    end

    xAdmin.NotifyCommandUse( admin, "lsaddxp", {
        xAdmin.GetLanguageString( "You" ), 
        amount, 
        xAdmin.GetTargetString( targets ),
    } )
    xAdmin.LogCommandUse( admin, "lsaddxp", {
        ( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
        amount,
        xAdmin.GetTargetString( targets ),
    } )
end, {
    { xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
    { xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

xAdmin.RegisterCommand( "lsaddlvl", "Add LVL", "Add LVL to a specified player", "%s add %d LVL to %s", CATEGORY_NAME, function( admin, args )
    local targets = xAdmin.GetTargetsFromArg( admin, "lsaddlvl", args[1] )
    local amount = tonumber( args[2] )

    for i, v in ipairs( targets ) do
        local ply = player.GetBySteamID( v )
        if IsValid( ply ) then
            ply:LSAddLVL( amount )
        end
    end

    xAdmin.NotifyCommandUse( admin, "lsaddlvl", {
        xAdmin.GetLanguageString( "You" ), 
        amount, 
        xAdmin.GetTargetString( targets ),
    } )
    xAdmin.LogCommandUse( admin, "lsaddlvl", {
        ( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
        amount,
        xAdmin.GetTargetString( targets ),
    } )
end, {
    { xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
    { xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

xAdmin.RegisterCommand( "lssetxp", "Set XP", "Set XP to a specified player", "%s set %s to %d XP", CATEGORY_NAME, function( admin, args )
    local targets = xAdmin.GetTargetsFromArg( admin, "lssetxp", args[1] )
    local amount = tonumber( args[2] )

    for i, v in ipairs( targets ) do
        local ply = player.GetBySteamID( v )
        if IsValid( ply ) then
            ply:LSSetXP( amount )
        end
    end

    xAdmin.NotifyCommandUse( admin, "lssetxp", {
        xAdmin.GetLanguageString( "You" ), 
        xAdmin.GetTargetString( targets ),
        amount, 
    } )
    xAdmin.LogCommandUse( admin, "lssetxp", {
        ( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
        xAdmin.GetTargetString( targets ),
        amount,
    } )
end, {
    { xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
    { xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )

xAdmin.RegisterCommand( "lssetlvl", "Set LVL", "Set LVL to a specified player", "%s set %s to LVL %d", CATEGORY_NAME, function( admin, args )
    local targets = xAdmin.GetTargetsFromArg( admin, "lssetlvl", args[1] )
    local amount = tonumber( args[2] )

    for i, v in ipairs( targets ) do
        local ply = player.GetBySteamID( v )
        if IsValid( ply ) then
            ply:LSSetLVL( amount )
        end
    end

    xAdmin.NotifyCommandUse( admin, "lssetlvl", {
        xAdmin.GetLanguageString( "You" ), 
        xAdmin.GetTargetString( targets ),
        amount, 
    } )
    xAdmin.LogCommandUse( admin, "lssetlvl", {
        ( admin:EntIndex() == 0 ) and "CONSOLE" or admin:Nick(),
        xAdmin.GetTargetString( targets ),
        amount,
    } )
end, {
    { xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( "target" ) },
    { xAdmin.ARG_NUM, xAdmin.GetLanguageString( "amount" ) },
} )