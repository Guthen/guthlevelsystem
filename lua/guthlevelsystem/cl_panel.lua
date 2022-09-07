
--  lerping color (why isn't already built-in?)
local function lerp_color( t, a, b )
	return Color( 
		Lerp( t, a.r, b.r ),
		Lerp( t, a.g, b.g ),
		Lerp( t, a.b, b.b ),
		Lerp( t, a.a, b.a )
	)
end

--  variable & input stuff
local function change_player_var( steamid, key, value )
	net.Start( "guthlevelsystem:change_player_var" )
		net.WriteString( steamid )
		net.WriteString( key )
		net.WriteUInt( value, guthlevelsystem.NET_CHANGE_VAR_VALUE_BITS )
	net.SendToServer()
end 

local function ask_number_input( title, subtitle, default, confirm_callback )
	Derma_StringRequest( title, subtitle, default, function( text )
		local number = tonumber( text )
		if not number then
			ask_number_input( title, subtitle, default, confirm_callback )
			return
		end

		confirm_callback( number )
	end )
end

--  panel code
local co
local function show_panel()
	local w, h = ScrW() * .4, ScrH() * .4
	
	--  create frame
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( w, h )
	frame:SetTitle( "guthlevelsystem" )
	frame:Center()
	frame:MakePopup()

	--  create listview
	local listview = frame:Add( "DListView" )
	listview:Dock( FILL )
	listview:SetMultiSelect( false )

	--  init listview to N/A
	listview:AddColumn( "Requesting" )
	listview:AddLine( "Waiting for request response.." )

	local target_alpha_multiplier, alpha_multiplier = 0, 0
	
	--  wait and populate the data w/ coroutine (yeah wanted to try fancy stuff) 
	local function wait_and_refresh_data()
		--  request data from server
		net.Start( "guthlevelsystem:receive_panel_data" )
		net.SendToServer()

		--  waiting for data
		local data = coroutine.yield()

		--  clear lines 
		listview:Clear()

		--  clear columns
		for i, v in ipairs( listview.Columns ) do
			v:Remove()
		end
		listview.Columns = {}

		--  reset listview behaviour
		function listview:OnRowRightClick() end

		--  checking data
		if not data or #data == 0 then 
			--  no data? oh my..
			listview:AddColumn( "No Data" )
			listview:AddLine( "No data has been received!" )
			
			--  populate error message
			if data.message then
				listview:AddLine( data.message )
			end
			
			return 
		end

		--  init listview columns
		listview:AddColumn( "SteamID" )
		if DarkRP then
			listview:AddColumn( "RP Name" )
		end
		listview:AddColumn( "Prestige" )
		listview:AddColumn( "Level" )
		listview:AddColumn( "XP" )

		--  populate our data to listview
		for i, v in ipairs( data ) do
			if DarkRP then
				listview:AddLine( v.steamid, v.rpname, v.prestige, v.lvl, v.xp )
			else
				listview:AddLine( v.steamid, v.prestige, v.lvl, v.xp )
			end
		end

		--  right click menu
		function listview:OnRowRightClick( line_id, line )
			local menu = DermaMenu( false, line )

			local steamid = line:GetColumnText( 1 )

			--  edit menu
			if guthlevelsystem.settings.data_panel.write_usergroups[LocalPlayer():GetUserGroup()] then 
				local edit_menu, edit_option = menu:AddSubMenu( "Edit" )
				edit_option:SetMaterial( "icon16/pencil.png" )
				
				edit_menu:AddOption( "Set Prestige", function()
					ask_number_input( "Set Prestige", "Which prestige do you want to set the player to?", line:GetColumnText( 2 ), function( value )
						change_player_var( steamid, "prestige", value )
						target_alpha_multiplier = 1
					end )
				end ):SetMaterial( "icon16/award_star_gold_1.png" )
				edit_menu:AddOption( "Set Level", function()
					ask_number_input( "Set Level", "Which level do you want to set the player to?", line:GetColumnText( 3 ), function( value )
						change_player_var( steamid, "lvl", value )
						target_alpha_multiplier = 1
					end )
				end ):SetMaterial( "icon16/award_star_silver_1.png" )
				edit_menu:AddOption( "Set XP", function()
					ask_number_input( "Set XP", "How much XP do you want to set the player to?", line:GetColumnText( 4 ), function( value )
						change_player_var( steamid, "xp", value )
						target_alpha_multiplier = 1
					end )
				end ):SetMaterial( "icon16/award_star_bronze_1.png" )
			end
			
			--  copy menu
			local copy_menu, copy_option = menu:AddSubMenu( "Copy" )
			copy_option:SetMaterial( "icon16/page_copy.png" )
			
			copy_menu:AddOption( "SteamID", function()
				SetClipboardText( steamid )
			end ):SetMaterial( "icon16/user_gray.png" )
			copy_menu:AddOption( "Entry as JSON", function()
				local json = util.TableToJSON( data[line_id] )
				if not json then
					return guthlevelsystem.error( "failed to serialize entry as json" )	
				end

				SetClipboardText( json )
			end ):SetMaterial( "icon16/script_code_red.png" )

			menu:Open()
		end
	end

	--  create buttons
	local top_container = frame:Add( "Panel" )
	top_container:Dock( TOP )
	top_container:DockMargin( 4, 4, 4, 4 )
	top_container:SetTall( 16 )
	
	--  create refresh button
	local refresh_button = top_container:Add( "DImageButton" )
	refresh_button:Dock( RIGHT )
	refresh_button:SetSize( 16, 16 )
	refresh_button:SetImage( "icon16/arrow_refresh.png" )
	refresh_button:SetTooltip( "Request a data refresh from the server, useful to see changes" )
	function refresh_button:DoClick()
		co = coroutine.create( wait_and_refresh_data )
		coroutine.resume( co )

		target_alpha_multiplier = 0
	end

	local warning_color = Color( 255, 128, 0 )
	local old_paint = refresh_button.Paint
	function refresh_button:Think()
		--  animate alpha multiplier
		alpha_multiplier = Lerp( FrameTime() * 3, alpha_multiplier, target_alpha_multiplier )

		--  change color
		self:SetColor( lerp_color( alpha_multiplier * math.abs( math.sin( CurTime() * 3 ) ), color_white, warning_color ) )
	end

	local title_label = top_container:Add( "DLabel" )
	title_label:Dock( LEFT )
	title_label:SetFont( "DermaDefaultBold" )
	title_label:SetText( "Players Data" )
	title_label:SizeToContentsX()

	wait_and_refresh_data()
end

net.Receive( "guthlevelsystem:receive_panel_data", function()
	if co and coroutine.status( co ) == "dead" then return end

	local data = net.ReadTable()
	coroutine.resume( co, data )  --  pass received data to coroutine
end )

function guthlevelsystem.open_panel()
	if not guthlevelsystem.settings.data_panel.read_usergroups[LocalPlayer():GetUserGroup()] then 
		return guthlevelsystem.error( "you do not have the permission to access this panel" )
	end

	--  init panel
	co = coroutine.create( show_panel )
	coroutine.resume( co )
end
concommand.Add( "guthlevelsystem_panel", guthlevelsystem.open_panel )