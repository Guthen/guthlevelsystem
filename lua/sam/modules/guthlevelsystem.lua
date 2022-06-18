--if SAM_LOADED then return end

sam.command.set_category( "guthlevelsystem" )

--  prestige
sam.command.new( "gls_set_prestige" )
	:SetPermission( "gls_set_prestige", "superadmin" )

	:AddArg( "player", {
		single_player = true,
	} )
	:AddArg( "number", {
		hint = "prestige",
		default = 1,
	} )

	:Help( "Set prestige to a specified player." )

	:OnExecute( function( ply, targets, prestige )
		targets[1]:gls_set_prestige( prestige )

		if sam.is_command_silent then return end
		sam.player.send_message( nil, "{A} set {T} to prestige {V}!", {
			A = ply,
			V = prestige,
			T = targets,
		} )
	end )

	:End()

sam.command.new( "gls_add_prestige" )
	:SetPermission( "gls_add_prestige", "superadmin" )

	:AddArg( "player", {
		single_player = true,
	} )
	:AddArg( "number", {
		hint = "prestige",
		default = 1,
	} )

	:Help( "Add prestige to a specified player." )

	:OnExecute( function( ply, targets, prestige )
		targets[1]:gls_add_prestige( prestige )

		if sam.is_command_silent then return end
		sam.player.send_message( nil, "{A} set prestige {V} to {T}!", {
			A = ply,
			V = prestige,
			T = targets,
		} )
	end )

	:End()

--  level
sam.command.new( "gls_set_level" )
	:SetPermission( "gls_set_level", "superadmin" )

	:AddArg( "player", {
		single_player = true,
	} )
	:AddArg( "number", {
		hint = "level",
		default = 1,
	} )

	:Help( "Set level to a specified player." )

	:OnExecute( function( ply, targets, level )
		targets[1]:gls_set_level( level )

		if sam.is_command_silent then return end
		sam.player.send_message( nil, "{A} set {T} to level {V}!", {
			A = ply,
			V = level,
			T = targets,
		} )
	end )

	:End()

sam.command.new( "gls_add_level" )
	:SetPermission( "gls_add_level", "superadmin" )

	:AddArg( "player", {
		single_player = true,
	} )
	:AddArg( "number", {
		hint = "level",
		default = 1,
	} )

	:Help( "Add level to a specified player." )

	:OnExecute( function( ply, targets, level )
		targets[1]:gls_add_level( level )

		if sam.is_command_silent then return end
		sam.player.send_message( nil, "{A} set Level {V} to {T}!", {
			A = ply,
			V = level,
			T = targets,
		} )
	end )

	:End()

--  xp
sam.command.new( "gls_add_xp" )
	:SetPermission( "gls_add_xp", "superadmin" )

	:AddArg( "player", {
		single_player = true,
	} )
	:AddArg( "number", {
		hint = "xp",
		default = 1,
	} )

	:Help( "Add XP to a specified player." )

	:OnExecute( function( ply, targets, xp )
		targets[1]:gls_add_xp( xp )

		if sam.is_command_silent then return end
		sam.player.send_message( nil, "{A} add {V} XP to {T}!", {
			A = ply,
			V = xp,
			T = targets,
		} )
	end )

	:End()

sam.command.new( "gls_set_xp" )
	:SetPermission( "gls_set_xp", "superadmin" )

	:AddArg( "player", {
		single_player = true,
	} )
	:AddArg( "number", {
		hint = "xp",
		default = 1,
	} )

	:Help( "Set XP to a specified player." )

	:OnExecute( function( ply, targets, xp )
		targets[1]:gls_set_xp( xp )

		if sam.is_command_silent then return end
		sam.player.send_message( nil, "{A} set {T} to {V} XP!", {
			A = ply,
			V = xp,
			T = targets,
		} )
	end )

	:End()

guthlevelsystem.print( "sam module loaded!" )