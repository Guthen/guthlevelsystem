LEVELSYSTEM = LEVELSYSTEM or {}

local function openPanel()
    local w, h = 500, 500

    local panel = vgui.Create( "DPanel" )
          panel:SetSize( w, h )
          panel:Center()
          panel:MakePopup()
          panel.Paint = function()
              draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100 ) )
              draw.RoundedBox( 0, 0, 0, w, 25, Color( 130, 130, 130 ) )
          end

    local close = vgui.Create( "DButton", panel )
          close:SetSize( 25, 25 )
          close:SetPos( w-25, 0 )
          close:SetText( "x" )
          close:SetTextColor( Color( 255, 255, 255 ) )
          close.DoClick = function()
              panel:Remove()
          end
          close.Paint = function( self, _w, _h )
              draw.RoundedBox( 0, 0, 0, _w, _h, Color( 210, 20, 20 ) )
          end

end
concommand.Add( "guthlevelsystem_panel", openPanel )
