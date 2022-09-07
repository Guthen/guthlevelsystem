--  send panel data
util.AddNetworkString( "guthlevelsystem:receive_panel_data" )

local function send_panel_data_to( ply, data )
	net.Start( "guthlevelsystem:receive_panel_data" )
		net.WriteTable( data )
	net.Send( ply )
end

local function get_and_send_panel_data_to( ply )
	local query = "SELECT * FROM guthlevelsystem_players"
	guthlevelsystem.query( query, function( success, message, data )
		if not success then 
			send_panel_data_to( ply, { message = "Unable to fetch data due to error: " .. message } )
			return guthlevelsystem.error( "failed to fetch panel's data for %q: %s", ply:GetName(), message ) 
		end

		--  fetch DarkRP rpnames
		if DarkRP then
			guthlevelsystem.query( "SELECT uid, rpname FROM darkrp_player", function( success, message, rpname_data )
				--  set only on success
				if success then
					--  build a set/lookup table of <steamid, rpname> to saves iterations
					local rpnames_set = {}
					for i, v in ipairs( rpname_data ) do
						local steamid = util.SteamIDFrom64( v.uid )
						rpnames_set[steamid] = v.rpname
					end

					--  set rpname to data
					for i, v in ipairs( data ) do
						local rpname = rpnames_set[v.steamid]
						if rpname then
							v.rpname = rpname
						end
					end
				end
				
				--  send data
				send_panel_data_to( ply, data )
			end )
		else
			send_panel_data_to( ply, data )
		end
	end )
end

net.Receive( "guthlevelsystem:receive_panel_data", function( len, ply )
	if not guthlevelsystem.settings.data_panel.read_usergroups[ply:GetUserGroup()] then return end

	get_and_send_panel_data_to( ply )
end )

--  change player var
util.AddNetworkString( "guthlevelsystem:change_player_var" )

net.Receive( "guthlevelsystem:change_player_var", function( len, ply )
	if not guthlevelsystem.settings.data_panel.write_usergroups[ply:GetUserGroup()] then return end

	--  get targeted steam id
	local steamid = net.ReadString()

	--  get variable name
	local key = net.ReadString()

	--  get desired value
	local value = net.ReadUInt( guthlevelsystem.NET_CHANGE_VAR_VALUE_BITS )

	local ply = player.GetBySteamID( steamid )
	if key == "prestige" then
		if IsValid( ply ) then
			ply:gls_set_prestige( value )
		else
			guthlevelsystem.set_steamid_prestige( steamid, value )
		end
	elseif key == "lvl" then
		if IsValid( ply ) then
			ply:gls_set_level( value )
		else
			guthlevelsystem.set_steamid_level( steamid, value )
		end
	elseif key == "xp" then
		if IsValid( ply ) then
			ply:gls_set_xp( value )
		else
			guthlevelsystem.set_steamid_xp( steamid, value )
		end
	end
end )