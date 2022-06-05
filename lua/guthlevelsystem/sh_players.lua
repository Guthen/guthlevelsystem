local PLAYER = FindMetaTable( "Player" )

function PLAYER:gls_get_level()
    return self:GetNWInt( "guthlevelsystem:LVL", 0 )
end

function PLAYER:gls_get_xp()
    return self:GetNWInt( "guthlevelsystem:XP", 0 )
end

function PLAYER:gls_get_nxp()
    return self:GetNWInt( "guthlevelsystem:NXP", 0 )
end