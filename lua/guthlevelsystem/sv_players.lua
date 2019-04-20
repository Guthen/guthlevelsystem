local Player = FindMetaTable( "Player" )

--  >   Player:LSCreateData
--  >   args: nil
--  >   return: nil
function Player:LSCreateData()
    local sid = self:SteamID()
    local nxp = self:LSCalcNXP()

    local query = string.format( "INSERT INTO guth_ls( SteamID, XP, NXP, LVL ) VALUES ( '%s', 0, %d, 0)", sid, nxp )
    local result = sql.Query( query )

    if result == false then return LEVELSYSTEM.Notif( "SQL Error on trying to Create LS Data on " .. self:Name() ) end

    LEVELSYSTEM.Notif( "LS Data has been created on " .. self:Name() )
end

--  >   Player:LSSaveData
--  >   args: nil
--  >   return: nil
function Player:LSSaveData()
    local sid = self:SteamID()
    local xp = self:LSGetXP()
    local nxp = self:LSGetNXP()
    local lvl = self:LSGetLVL()

    local query = string.format( "UPDATE guth_ls SET XP=%d, NXP=%d, LVL=%d WHERE SteamID='%s'", xp, nxp, lvl, sid )
    local result = sql.Query( query )

    if result == false then return LEVELSYSTEM.Notif( "SQL Error on trying to Save LS Data on " .. self:Name() ) end

    LEVELSYSTEM.Notif( "LS Data has been saved on " .. self:Name() )
end

--  >   Player:LSGetData
--  >   args: nil
--  >   return: nil
function Player:LSGetData()
    local sid = self:SteamID()

    local query = string.format( "SELECT * FROM guth_ls WHERE SteamID='%s'", sid )
    local result = sql.Query( query )

    PrintTable( values )

    --self.LSxp = 0
    --self.LSnxp = 0
    --self.LSlvl = 0
end

function Player:LSHasData()
    local query = string.format( "SELECT SteamID, XP, NXP, LVL FROM guth_ls WHERE SteamID='%s'", sid )
    local result = sql.Query( query )

    return result and true or false
end

--  >   Player:LSAddXP
--  >   args: #1 number
--  >   return: nil
function Player:LSAddXP( num )
    if not num or not isnumber( num ) then return end

    self.LSxp = ( self.LSxp or 0 ) + num
    if self.LSxp >= self.LSnxp then
        self:LSAddLVL( 1 )
    end
end

--  >   Player:LSCalcNXP
--  >   args: nil
--  >   return: Player.LSnxp (number)
function Player:LSCalcNXP()
    self.LSnxp = self:LSGetLVL() * LEVELSYSTEM.NXBase * ( LEVELSYSTEM.NXPMultiplicator or 1 )
    return self.LSnxp
end

--  >   Player:LSSetXP
--  >   args: #1 number
--  >   return: nil
function Player:LSSetXP( num )
    if not num or not isnumber( num ) then return end

    self.LSxp = num
    if self.LSxp >= self.LSnxp then
        self:LSAddLVL( 1 )
    end
end

--  >   Player:LSGetXP
--  >   args: nil
--  >   return: Player.LSxp or -1 (number)
function Player:LSGetXP()
    return self.LSxp or -1
end

--  >   Player:LSGetNXP
--  >   args: nil
--  >   return: Player.LSnxp or -1 (number)
function Player:LSGetNXP()
    return self.LSnxp or -1
end

--  >   Player:LSAddLVL
--  >   args: #1 number
--  >   return: nil
function Player:LSAddLVL( num )
    if not num or not isnumber( num ) then return end

    self.LSlvl = ( self.LSlvl or 0 ) + num
    self.LSxp = 0
    self:LSCalcNXP()
end

--  >   Player:LSSetLVL
--  >   args: #1 number
--  >   return: nil
function Player:LSSetLVL( num )
    if not num or not isnumber( num ) then return end

    self.LSlvl = num
    self.LSxp = 0
    self:LSCalcNXP()
end

--  >   Player:LSGetLVL
--  >   args: nil
--  >   return: Player.LSlvl or -1 (number)
function Player:LSGetLVL()
    return self.LSlvl or -1
end

print( "Loaded succesfully" )
