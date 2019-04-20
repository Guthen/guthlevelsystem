local Player = FindMetaTable( "Player" )

function Player:LSAddXP( num )
    return self.LSxp = self.LSxp + num
end

function Player:LSGetXP()
    return self.LSxp
end
