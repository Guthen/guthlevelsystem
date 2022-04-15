guthlevelsystem = guthlevelsystem or {}
guthlevelsystem.Author      =   "Guthen"
guthlevelsystem.Version     =   "1.8.4"
guthlevelsystem.Link        =   "https://github.com/Guthen/guthlevelsystem"
guthlevelsystem.Discord     =   "https://discord.gg/eKgkpCf"

function guthlevelsystem.Print( msg, ... ) 
    if ... then
        msg = msg:format( ... )
    end

    print( "[guthlevelsystem] ─ " .. msg )
end

function guthlevelsystem.FormatMessage( msg, args )
    local formatted_text = ""

    local function format_word( word )
        local key = word:match( "^{(.+)}$" )
        if key then
            word = tostring( args[key] or "?" )
        end
        formatted_text = formatted_text .. word
    end

    local word = ""
    for l in msg:gmatch( "." ) do
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

    return formatted_text
end

if SERVER then
    include( "guthlevelsystem/sv_base.lua" )
else
    include( "guthlevelsystem/cl_base.lua" )
end

guthlevelsystem.Print( "Made by %s in version %s, type 'guthlevelsystem_info' for more info.", guthlevelsystem.Author, guthlevelsystem.Version )