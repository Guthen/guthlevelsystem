local Player = FindMetaTable( "Player" )

--  > DATA <  --

--  >   Player:LSCreateData
--  >   args: nil
--  >   return: nil
function Player:LSCreateData()
    local sid = self:SteamID()

    local query = string.format( "INSERT INTO guth_ls( SteamID, XP, LVL ) VALUES ( '%s', 0, 0)", sid )
    local result = sql.Query( query )

    if result == false then return LEVELSYSTEM.Notif( "SQL Error on trying to Create LS Data on " .. self:Name() ) end

    LEVELSYSTEM.Notif( "LS Data has been created on " .. self:Name() )
end

--  >   Player:LSSaveData
--  >   args: nil
--  >   return: nil
function Player:LSSaveData()
    local xp = self:LSGetXP()
    local lvl = self:LSGetLVL()
    local sid = self:SteamID()

    local query = string.format( "UPDATE guth_ls SET XP=%d, LVL=%d WHERE SteamID='%s'", xp, lvl, sid )
    local result = sql.Query( query )

    if result == false then return LEVELSYSTEM.Notif( "SQL Error on trying to Save LS Data on " .. self:Name() ) end

    LEVELSYSTEM.Notif( "LS Data has been saved on " .. self:Name() )
end

--  >   Player:LSGetData
--  >   args: nil
--  >   return: nil
function Player:LSGetData()
    local sid = self:SteamID()

    local query = string.format( "SELECT SteamID, XP, LVL FROM guth_ls WHERE SteamID='%s'", sid )
    local result = sql.Query( query )

    if not istable( result ) then return end

    if #result > 1 then
        query = string.format( "DELETE FROM guth_ls WHERE SteamID='%s'", sid )
        sql.Query( query )
        LEVELSYSTEM.Notif( "LS Data has been erased on " .. self:Name() )
        return self:LSCreateData()
    end

    self:LSSetXP( result[1].XP )
    self:LSCalcNXP()
    self:LSSetLVL( result[1].LVL )

    timer.Simple( .1, function()
        self:LSSendData()
    end )

    LEVELSYSTEM.Notif( "LS Data has been loaded on " .. self:Name() )
end

function Player:LSHasData()
    local query = string.format( "SELECT SteamID FROM guth_ls WHERE SteamID='%s'", sid )
    local result = sql.Query( query )

    return result == nil and true or false
end

--  > XP <  --

--  >   Player:LSAddXP
--  >   args: #1 number
--  >   return: nil
function Player:LSAddXP( num )
    if not num or not isnumber( num ) then return end

    self.LSxp = ( self.LSxp or 0 ) + num
    if self.LSxp >= ( self.LSnxp or math.huge ) then
        local dif = self.LSnxp - self.LSxp
        --print( self.LSnxp, self.LSxp, dif )

        self:LSAddLVL( 1 )

        if dif < 0 then
            timer.Simple( .5, function()
                if not self:IsValid() then return end
                self:LSAddXP( -dif )
            end)
        end
        return
    end

    self:LSSaveData()
    self:LSSendData()

    self:LSSendNotif( string.format( "You get %d XP, work harder !", num ) )
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
        local dif = self.LSnxp - self.LSxp
        --print( self.LSnxp, self.LSxp, dif )

        self:LSAddLVL( 1 )

        if dif < 0 then
            timer.Simple( .5, function()
                if not self:IsValid() then return end
                self:LSAddXP( -dif )
            end)
        end
        return
    end

    self:LSSaveData()
    self:LSSendData()
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

--  > LVL <  --

--  >   Player:LSAddLVL
--  >   args: #1 number
--  >   return: nil
function Player:LSAddLVL( num )
    if not num or not isnumber( num ) then return end

    self.LSlvl = ( self.LSlvl or 0 ) + num
    self.LSxp = 0
    self:LSCalcNXP()

    self:LSSaveData()
    self:LSSendData()

    self:LSSendNotif( string.format( "You get LVL %d, good job !", self:LSGetLVL() ) )
end

--  >   Player:LSSetLVL
--  >   args: #1 number
--  >   return: nil
function Player:LSSetLVL( num )
    if not num or not isnumber( num ) then return end

    self.LSlvl = num
    self.LSxp = 0
    self:LSCalcNXP()

    self:LSSaveData()
    self:LSSendData()

    self:LSSendNotif( string.format( "You get LVL %d, good job !", self:LSGetLVL() ) )
end

--  >   Player:LSGetLVL
--  >   args: nil
--  >   return: Player.LSlvl or -1 (number)
function Player:LSGetLVL()
    return self.LSlvl or -1
end

--  > OTHERS <  --

function Player:LSSendData()
    net.Start( "LEVELSYSTEM:SendData" )
        net.WriteInt( self:LSGetLVL(), 32 )
        net.WriteInt( self:LSGetXP(), 32 )
        net.WriteInt( self:LSGetNXP(), 32 )
    net.Send( self )
end

function Player:LSSendNotif( msg, type )
    net.Start( "LEVELSYSTEM:SendNotif" )
        net.WriteString( msg or "" )
        net.WriteInt( type or 0, 32 )
    net.Send( self )
end

print( "Loaded succesfully" )
