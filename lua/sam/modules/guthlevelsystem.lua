if SAM_LOADED then return end

sam.command.set_category( "guthlevelsystem" )

sam.command.new( "lsaddxp" )
    :SetPermission( "lsaddxp", "superadmin" )

    :AddArg( "player", {
        single_player = true,
    } )
    :AddArg( "number", {
        hint = "xp",
        default = 1,
    } )

    :Help( "Add XP to a specified player." )

    :OnExecute( function( ply, targets, xp )
        targets[1]:LSAddXP( xp )

        if sam.is_command_silent then return end
	    sam.player.send_message( nil, "{A} add {V} XP to {T}!", {
            A = ply,
            V = xp,
            T = targets,
        } )
    end )

    :End()

sam.command.new( "lssetxp" )
    :SetPermission( "lssetxp", "superadmin" )

    :AddArg( "player", {
        single_player = true,
    } )
    :AddArg( "number", {
        hint = "xp",
        default = 1,
    } )

    :Help( "Set XP to a specified player." )

    :OnExecute( function( ply, targets, xp )
        targets[1]:LSSetXP( xp )

        if sam.is_command_silent then return end
	    sam.player.send_message( nil, "{A} set {T} to {V} XP!", {
            A = ply,
            V = xp,
            T = targets,
        } )
    end )

    :End()

sam.command.new( "lsaddlvl" )
    :SetPermission( "lsaddlvl", "superadmin" )

    :AddArg( "player", {
        single_player = true,
    } )
    :AddArg( "number", {
        hint = "lvl",
        default = 1,
    } )

    :Help( "Add LVL to a specified player." )

    :OnExecute( function( ply, targets, lvl )
        targets[1]:LSAddLVL( lvl )

        if sam.is_command_silent then return end
	    sam.player.send_message( nil, "{A} set Level {V} to {T}!", {
            A = ply,
            V = lvl,
            T = targets,
        } )
    end )

    :End()

sam.command.new( "lssetlvl" )
    :SetPermission( "lssetlvl", "superadmin" )

    :AddArg( "player", {
        single_player = true,
    } )
    :AddArg( "number", {
        hint = "lvl",
        default = 1,
    } )

    :Help( "Set LVL to a specified player." )

    :OnExecute( function( ply, targets, lvl )
        targets[1]:LSSetLVL( lvl )

        if sam.is_command_silent then return end
        sam.player.send_message( nil, "{A} set {T} to LVL {V}!", {
            A = ply,
            V = lvl,
            T = targets,
        } )
    end )

    :End()

print( "[guthlevelsystem] - SAM Module loaded succesfully" )