guthlevelsystem = guthlevelsystem or {}

--  load HUDs
local path, huds = "guthlevelsystem/hud/", {}
for i, v in ipairs( file.Find( path .. "*.lua", "LUA" ) ) do
    local file_name = v:gsub( "%.lua$", "" )

    local func = include( path .. v )
    if not func then
        ErrorNoHalt( ( "guthlevelsystem ─ HUD '%s' can't be load, an error has occured!" ):format( file_name ) )
        continue
    elseif not isfunction( func ) then
        ErrorNoHalt( ( "guthlevelsystem ─ HUD '%s' can't be load, the returned value is not a function!" ):format( file_name ) )
        continue
    end

    huds[file_name] = func
end
guthlevelsystem.Print( "Loaded %d HUDs", table.Count( huds ) )

local toggle_convar = CreateClientConVar(  "guthlevelsystem_hud_enabled", "1", true, false, "Toggle visibility of guthlevelsystem's HUD", 0, 1 )
hook.Add( "HUDPaintBackground", "guthlevelsystem:HUD", function()
    if not toggle_convar:GetBool() then return end

    local should = hook.Run( "HUDShouldDraw", "guthlevelsystem:HUD" )
    if should == false then return end

    local ply = LocalPlayer()
    if not IsValid( ply ) then return end

    if huds[guthlevelsystem.SelectedHUD] then 
        huds[guthlevelsystem.SelectedHUD]( ply )
    end
end )
if not guthlevelsystem.DrawHUD then 
    hook.Remove( "HUDPaintBackground", "guthlevelsystem:HUD" ) 
end
 
hook.Add( "OnPlayerChat", "guthlevelsystem:level", function( ply, text )
    if not ( ply == LocalPlayer() ) then return end
    if not text:StartWith( guthlevelsystem.CommandChat ) then return end

    local args = {
        lvl = ply:GetNWInt( "guthlevelsystem:LVL", 0 ),
        xp = ply:GetNWInt( "guthlevelsystem:XP", 0 ), 
        nxp = ply:GetNWInt( "guthlevelsystem:NXP", 0 ),
    }
    args.percent = math.floor( args.xp / args.nxp * 100 )

    --  format text with colors
    local formatted_text, word = {}, ""

    local function format_word( word )
        local key = word:match( "^{(.+)}$" )
        if key then
            word = tostring( args[key] or "?" )
            formatted_text[#formatted_text + 1] = guthlevelsystem.CommandHighlightColor
        else
            formatted_text[#formatted_text + 1] = color_white
        end
        formatted_text[#formatted_text + 1] = word
    end

    for l in guthlevelsystem.CommandFormatMessage:gmatch( "." ) do
        local force_implement = false
        if l == "{" and #word > 0 then
            format_word( word )
            word = ""
        end
        
        word = word .. l
        if l == " " or l == "}" then
            format_word( word )
            word = ""
        end
    end

    if #word > 0 then
        format_word( word )
    end

    chat.AddText( guthlevelsystem.CommandHighlightColor, "[LEVEL] ", unpack( formatted_text ) )
    return true
end )