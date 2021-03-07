local Player = FindMetaTable( "Player" )

--  > DATA <  --

--  >   Player:LSCreateData
--  >   args: nil
--  >   return: nil
function Player:LSCreateData()
    local query = ( "INSERT INTO guth_ls( SteamID, XP, LVL ) VALUES ( %s, 0, 1 )" ):format( SQLStr( self:SteamID() ) )
    guthlevelsystem.Query( query, function( success, message, data )
        if not success then
            return guthlevelsystem.Notif( ( "Failed while creating data on %q: %s" ):format( self:GetName(), message ) )
        end

        self:LSSetXP( 0, true )
        self:LSSetLVL( 1, true )
        self:LSCalcNXP()
        self:LSSendData()

        guthlevelsystem.Notif( "Data has been created on " .. self:GetName() )

        hook.Run( "guthlevelsystem:OnPlayerCreateData", self )
    end )
end

--  >   Player:LSSaveData
--  >   args: #1 boolean (OPTIONAL)
--  >   return: nil
function Player:LSSaveData( silent )
    local xp = self:LSGetXP()
    local lvl = self:LSGetLVL()

    local query = ( "UPDATE guth_ls SET XP = %d, LVL = %d WHERE SteamID = %s" ):format( xp, lvl, SQLStr( self:SteamID() ) )
    guthlevelsystem.Query( query, function( success, message, data )
        if not success then
            return guthlevelsystem.Notif( ( "Failed while saving data on %q : %s" ):format( self:GetName(), message ) )
        end

        if not silent then guthlevelsystem.Notif( ( "Data has been saved on %q" ):format( self:Name() ) ) end
        hook.Run( "guthlevelsystem:OnPlayerSaveData", self, silent )
    end )
end

--  >   Player:LSLoadData
--  >   args: nil
--  >   return: nil
function Player:LSLoadData()
    local query = ( "SELECT XP, LVL FROM guth_ls WHERE SteamID = %s" ):format( SQLStr( self:SteamID() ) )
    guthlevelsystem.Query( query, function( success, message, data )
        if not success or not data or #data <= 0 then
            return not data and guthlevelsystem.Notif( ( "Failed while loading data on %q : %s" ):format( self:GetName(), message ) )
        end

        self:LSSetLVL( tonumber( data[1].LVL ), true )
        self:LSSetXP( tonumber( data[1].XP ) )
        self:LSCalcNXP()
        self:LSSendData()

        guthlevelsystem.Notif( ( "Data has been loaded on %q" ):format( self:Name() ) )

        hook.Run( "guthlevelsystem:OnPlayerGetData", self )
    end )
end

function Player:LSGetData( callback )
    local query = ( "SELECT * FROM guth_ls WHERE SteamID = %s" ):format( SQLStr( self:SteamID() ) )
    guthlevelsystem.Query( query, callback )
end

function Player:LSResetData()
    local query = ( "DELETE FROM guth_ls WHERE SteamID='%s'" ):format( SQLStr( self:SteamID() ) )
    guthlevelsystem.Query( query, function( success, message, data )
        if not success then
            return guthlevelsystem.Notif( ( "Failed while reseting data on %q : %s" ):format( self:GetName(), message ) )
        end

        self:LSCreateData()

        hook.Run( "guthlevelsystem:OnPlayerResetData", self )
    end )
end

function Player:LSSendData()
    timer.Simple( .1, function()
        self:SetNWInt( "guthlevelsystem:LVL", self:LSGetLVL() )
        self:SetNWInt( "guthlevelsystem:NXP", self:LSGetNXP() )
        self:SetNWInt( "guthlevelsystem:XP", self:LSGetXP() )
    end )
end

--  > XP <  --

--  >   Player:LSAddXP
--  >   args: #1 number
--  >   return: nil
function Player:LSAddXP( num, silent, byPlaying )
    if not num or not isnumber( num ) then return end

    if self:LSGetLVL() == -1 then self:LSResetData() end
    if self:LSGetLVL() >= guthlevelsystem.MaximumLVL then return end

    local should = hook.Run( "guthlevelsystem:ShouldPlayerAddXP", self, num, silent, byPlaying )
    if should == false then return end

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

    if not guthlevelsystem.SaveOnTimer then self:LSSaveData() end

    if not silent then
        local notif = byPlaying and guthlevelsystem.NotificationXPPlaying or guthlevelsystem.NotificationXP

        self:LSSendNotif( string.format( notif, num ), 0, guthlevelsystem.NotificationSoundXP )
    end

    hook.Run( "guthlevelsystem:OnPlayerAddXP", self, num, silent, byPlaying )
end

--  >   Player:LSCalcNXP
--  >   args: nil
--  >   return: Player.LSnxp (number)
function Player:LSCalcNXP()
    self.LSnxp = self:LSGetLVL() * guthlevelsystem.NXBase * ( guthlevelsystem.NXPMultiplicator or 1 )
    return self.LSnxp
end

--  >   Player:LSSetXP
--  >   args: #1 number
--  >   return: nil
function Player:LSSetXP( num )
    if not num or not isnumber( num ) then return end

    if self:LSGetLVL() >= guthlevelsystem.MaximumLVL then return end

    local should = hook.Run( "guthlevelsystem:ShouldPlayerSetXP", self, num )
    if should == false then return end

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

    if not guthlevelsystem.SaveOnTimer then self:LSSaveData() end

    hook.Run( "guthlevelsystem:OnPlayerSetXP", self, num )
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

    local should = hook.Run( "guthlevelsystem:ShouldPlayerAddLVL", self, num )
    if should == false then return end

    self.LSlvl = math.Clamp( ( self.LSlvl or 0 ) + num, 1, guthlevelsystem.MaximumLVL )
    self.LSxp = 0
    self:LSCalcNXP()

    self:LSSendData()

    if not guthlevelsystem.SaveOnTimer then self:LSSaveData() end

    if not silent then
        self:LSSendNotif( string.format( guthlevelsystem.NotificationLVL, self:LSGetLVL() ), 0, guthlevelsystem.NotificationSoundLVL )
    end

    hook.Run( "guthlevelsystem:OnPlayerAddLVL", self, num )
end

--  >   Player:LSSetLVL
--  >   args: #1 number
--  >   return: nil
function Player:LSSetLVL( num, silent )
    if not num or not isnumber( num ) then return end

    local should = hook.Run( "guthlevelsystem:ShouldPlayerSetLVL", self, num, silent )
    if should == false then return end

    self.LSlvl = math.Clamp( num, 1, guthlevelsystem.MaximumLVL )
    self.LSxp = 0
    self:LSCalcNXP()

    self:LSSendData()

    if not guthlevelsystem.SaveOnTimer then self:LSSaveData() end

    if not silent then
        self:LSSendNotif( string.format( guthlevelsystem.NotificationLVL, self:LSGetLVL() ), 0, guthlevelsystem.NotificationSoundLVL )
    end

    hook.Run( "guthlevelsystem:OnPlayerSetLVL", self, num, silent )
end

--  >   Player:LSGetLVL
--  >   args: nil
--  >   return: Player.LSlvl or -1 (number)
function Player:LSGetLVL()
    return self.LSlvl or -1
end

--  > OTHERS <  --

function Player:LSSendNotif( msg, _type, snd )
    local should = hook.Run( "guthlevelsystem:ShouldPlayerSendNotif", self, msg, _type, snd )
    if should == false then return end

    net.Start( "guthlevelsystem:SendNotif" )
        net.WriteString( msg or "" )
        net.WriteInt( _type or 0, 32 )
        net.WriteString( snd or "Resource/warning.wav" )
    net.Send( self )

    hook.Run( "guthlevelsystem:OnPlayerSendNotif", self, msg, _type, snd )
end

print( "Loaded succesfully" )
