local PLAYER = FindMetaTable( "Player" )

function PLAYER:gls_get_level()
    return self:GetNWInt( "guthlevelsystem:level", 0 )
end

function PLAYER:gls_get_xp()
    return self:GetNWInt( "guthlevelsystem:xp", 0 )
end

function PLAYER:gls_get_nxp()
    return self:GetNWInt( "guthlevelsystem:nxp", 0 )
end