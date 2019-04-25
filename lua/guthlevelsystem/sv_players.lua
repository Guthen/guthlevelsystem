local Player = FindMetaTable( "Player" )

--  > DATA <  --

--  >   Player:LSCreateData
--  >   args: nil
--  >   return: nil
function Player:LSCreateData()
    --if self:LSHasData() then return LEVELSYSTEM.Notif( self:Name() .. " has already data !" ) end
    local sid = self:SteamID()

    local query = string.format( "INSERT INTO guth_ls( SteamID, XP, LVL ) VALUES ( '%s', 0, 1 )", sid )
    local result = sql.Query( query )

    if result == false then return LEVELSYSTEM.Notif( "SQL Error on trying to Create LS Data on " .. self:Name() ) end

    self:LSSetLVL( 1, true )
    self:LSSetXP( 0, true )
    self:LSCalcNXP()

    self:LSSendData()

    LEVELSYSTEM.Notif( "LS Data has been created on " .. self:Name() )
end

--  >   Player:LSSaveData
--  >   args: #1 boolean (OPTIONAL)
--  >   return: nil
function Player:LSSaveData( silent )
    local xp = self:LSGetXP()
    local lvl = self:LSGetLVL()
    local sid = self:SteamID()

    local query = string.format( "UPDATE guth_ls SET XP=%d, LVL=%d WHERE SteamID='%s'", xp, lvl, sid )
    local result = sql.Query( query )

    if result == false then return LEVELSYSTEM.Notif( "SQL Error on trying to Save LS Data on " .. self:Name() ) end

    if not silent then LEVELSYSTEM.Notif( "LS Data has been saved on " .. self:Name() ) end
end

--  >   Player:LSGetData
--  >   args: nil
--  >   return: nil
function Player:LSGetData()
    local sid = self:SteamID()

    local query

    query = string.format( "SELECT XP FROM guth_ls WHERE SteamID='%s'", sid )
    local xp = sql.QueryValue( query )

    query = string.format( "SELECT LVL FROM guth_ls WHERE SteamID='%s'", sid )
    local lvl = sql.QueryValue( query )

    if not xp or not lvl then return LEVELSYSTEM.Notif( "Failed on trying to Get LS Data on " .. self:Name() ) end

    self:LSSetLVL( tonumber( lvl ), true )
    self:LSSetXP( tonumber( xp ) )
    self:LSCalcNXP()

    self:LSSendData()

    LEVELSYSTEM.Notif( "LS Data has been loaded on " .. self:Name() )
end

function Player:LSHasData()
    local sid = self:SteamID()

    local query = string.format( "SELECT * FROM guth_ls WHERE SteamID='%s'", sid )
    local result = sql.Query( query )

    return result == nil or istable( result ) and true or false
end

function Player:LSResetData()
    local sid = self:SteamID()

    local query = string.format( "DELETE FROM guth_ls WHERE SteamID='%s'", sid )
    local result = sql.Query( query )

    if result == false then return LEVELSYSTEM.Notif( "Failed on trying to Delete LS Data on " .. self:Name() ) end

    self:LSCreateData()
end

function Player:LSSendData()
    timer.Simple( .1, function()
        self:SetNWInt( "LEVELSYSTEM:LVL", self:LSGetLVL() )
        self:SetNWInt( "LEVELSYSTEM:NXP", self:LSGetNXP() )
        self:SetNWInt( "LEVELSYSTEM:XP", self:LSGetXP() )
    end )
end

--  > XP <  --

--  >   Player:LSAddXP
--  >   args: #1 number
--  >   return: nil
function Player:LSAddXP( num, silent, byPlaying )
    if not num or not isnumber( num ) then return end

    if self:LSGetLVL() == -1 then self:LSResetData() end
    if self:LSGetLVL() >= LEVELSYSTEM.MaximumLVL then return end

    self.LSxp = ( self.LSxp or 0 ) + num
    if self.LSxp >= ( self.LSnxp or 0 ) then
        local dif = ( self.LSnxp or 0 ) - self.LSxp
        --print( self.LSnxp, self.LSxp, dif )

        self:LSAddLVL( 1, silent )

        if dif < 0 then
            timer.Simple( .5, function()
                if not self:IsValid() then return end
                self:LSAddXP( -dif )
            end)
        end
        return
    end

    self:LSSendData()

    if not LEVELSYSTEM.SaveOnTimer then self:LSSaveData() end

    if not silent then
        local notif = byPlaying and LEVELSYSTEM.NotificationXPPlaying or LEVELSYSTEM.NotificationXP

        self:LSSendNotif( string.format( notif, num ), 0, LEVELSYSTEM.NotificationSoundXP )
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
    
    if self:LSGetLVL() >= LEVELSYSTEM.MaximumLVL then return end

    self.LSxp = num
    if self.LSxp >= ( self.LSnxp or 0 ) then
        local dif = ( self.LSnxp or 0 ) - self.LSxp

        self:LSAddLVL( 1, silent )

        if dif < 0 then
            timer.Simple( .5, function()
                if not self:IsValid() then return end
                self:LSAddXP( -dif, silent )
            end)
        end
        return
    end

    self:LSSendData()

    if not LEVELSYSTEM.SaveOnTimer then self:LSSaveData() end
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
function Player:LSAddLVL( num, silent )
    if not num or not isnumber( num ) then return end

    self.LSlvl = math.Clamp( self.LSlvl + num, 1, LEVELSYSTEM.MaximumLVL )
    self.LSxp = 0
    self:LSCalcNXP()

    self:LSSendData()

    if not LEVELSYSTEM.SaveOnTimer then self:LSSaveData() end

    if not silent then
        self:LSSendNotif( string.format( LEVELSYSTEM.NotificationLVL, self:LSGetLVL() ), 0, LEVELSYSTEM.NotificationSoundLVL )
    end
end

--  >   Player:LSSetLVL
--  >   args: #1 number
--  >   return: nil
function Player:LSSetLVL( num, silent )
    if not num or not isnumber( num ) then return end

    self.LSlvl = math.Clamp( num, 1, LEVELSYSTEM.MaximumLVL )
    self.LSxp = 0
    self:LSCalcNXP()

    self:LSSendData()

    if not LEVELSYSTEM.SaveOnTimer then self:LSSaveData() end

    if not silent then
        self:LSSendNotif( string.format( LEVELSYSTEM.NotificationLVL, self:LSGetLVL() ), 0, LEVELSYSTEM.NotificationSoundLVL )
    end
end

--  >   Player:LSGetLVL
--  >   args: nil
--  >   return: Player.LSlvl or -1 (number)
function Player:LSGetLVL()
    return self.LSlvl or -1
end

--  > OTHERS <  --

function Player:LSSendNotif( msg, type, snd )
    net.Start( "LEVELSYSTEM:SendNotif" )
        net.WriteString( msg or "" )
        net.WriteInt( type or 0, 32 )
        net.WriteString( snd or "Resource/warning.wav" )
    net.Send( self )
end

print( "Loaded succesfully" )
