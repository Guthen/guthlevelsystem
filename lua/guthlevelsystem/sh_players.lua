local PLAYER = FindMetaTable( "Player" )

function PLAYER:gls_get_prestige()
    return self:GetNWInt( "guthlevelsystem:prestige", 0 )
end

function PLAYER:gls_get_level()
    return self:GetNWInt( "guthlevelsystem:level", 0 )
end

function PLAYER:gls_get_xp()
    return self:GetNWInt( "guthlevelsystem:xp", 0 )
end

function PLAYER:gls_get_xp_for_maximum_level()
    local prestige, xp = self:gls_get_prestige(), -self:gls_get_xp()
    
    for i = self:gls_get_level(), guthlevelsystem.settings.maximum_level do
        xp = xp + guthlevelsystem.settings.nxp_formula( prestige, i )
    end

    return xp
end

function PLAYER:gls_get_nxp()
    return self:GetNWInt( "guthlevelsystem:nxp", 0 )
end