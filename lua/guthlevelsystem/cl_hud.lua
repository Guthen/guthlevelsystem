guthlevelsystem = guthlevelsystem or {}

--  load HUDs
local path, huds = "guthlevelsystem/hud/", {}
function guthlevelsystem.add_hud( id, callback )
	huds[id] = callback
end

for i, v in ipairs( file.Find( path .. "*.lua", "LUA" ) ) do
	guthlevelsystem.load_file( path .. v, "cl_" )
end 
guthlevelsystem.print( "loaded %d HUDs", table.Count( huds ) )

local toggle_convar = CreateClientConVar(  "guthlevelsystem_hud_enabled", "1", true, false, "Toggle visibility of guthlevelsystem's HUD", 0, 1 )
hook.Add( "HUDPaintBackground", "guthlevelsystem:HUD", function()
	if not toggle_convar:GetBool() then return end

	local should = hook.Run( "HUDShouldDraw", "guthlevelsystem:HUD" )
	if should == false then return end

	local ply = LocalPlayer()
	if not IsValid( ply ) then return end

	if huds[guthlevelsystem.settings.hud.selected] then 
		huds[guthlevelsystem.settings.hud.selected]( ply )
	end
end )
if not guthlevelsystem.settings.hud.enabled then 
	hook.Remove( "HUDPaintBackground", "guthlevelsystem:HUD" ) 
end

local function tchat_message( args )
	chat.AddText( guthlevelsystem.settings.level_command.highlight_color, "[LEVEL] ", unpack( args ) )
end
 
hook.Add( "OnPlayerChat", "guthlevelsystem:level", function( ply, text )
	if not ( ply == LocalPlayer() ) then return end
	if not text:StartWith( guthlevelsystem.settings.level_command.command ) then return end

	local args = {
		level = ply:gls_get_level(),
		xp = ply:gls_get_xp(), 
		nxp = ply:gls_get_nxp(),
	}
	args.percent = math.floor( args.xp / args.nxp * 100 )

	tchat_message( guthlevelsystem.colored_format_message( guthlevelsystem.settings.level_command.message, args ) )
	return true
end )

--  notifications
net.Receive( "guthlevelsystem:notify", function()
	if guthlevelsystem.settings.notification_is_hud_printcenter then
		surface.PlaySound( net.ReadString() )
	else
		local msg = net.ReadString()
		local type = net.ReadUInt( 3 )
		local snd = net.ReadString()
	
		surface.PlaySound( snd )
		notification.AddLegacy( msg, type, 3 )
	end
end )

net.Receive( "guthlevelsystem:tchat", function()
	local msg = net.ReadString()
	local args = net.ReadTable()

	--  print
	tchat_message( guthlevelsystem.colored_format_message( msg, args ) )
end )