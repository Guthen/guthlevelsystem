guthlevelsystem = guthlevelsystem or {}

hook.Add( "PlayerInitialSpawn", "guthlevelsystem:SetData", function( ply )
    if ply:IsBot() then return end

    if not ply:LSHasData() then
        ply:LSCreateData()
    else
        ply:LSGetData()
    end
end )

hook.Add( "PlayerDisconnect", "guthlevelsystem:SaveData", function( ply )
    if ply:IsBot() then return end

    ply:LSSaveData()
end)

hook.Add( "ShutDown", "guthlevelsystem:SaveData", function()
    if not sql.TableExists( "guth_ls" ) then return end
    for _, v in pairs( player.GetHumans() ) do
        v:LSSaveData()
    end
end )

--  > Earn XP <  --

hook.Add( "OnNPCKilled", "guthlevelsystem:AddXP", function( npc, ply, inf )
    if not ply:IsValid() or not ply:IsPlayer() then return end

    local xp = guthlevelsystem.OnNPCKilledXP == -1 and npc:GetMaxHealth() or guthlevelsystem.OnNPCKilledXP
    ply:LSAddXP( xp )
end )
if not guthlevelsystem.OnNPCKilledEarnXP then hook.Remove( "OnNPCKilled", "guthlevelsystem:AddXP" ) end

hook.Add( "PlayerDeath", "guthlevelsystem:AddXP", function( ply, _, atk )
    if not atk:IsValid() or not atk:IsPlayer() then return end
    if ply == atk then return end

    local xp = guthlevelsystem.PlayerDeathXP or 100
    atk:LSAddXP( xp )
end )
if not guthlevelsystem.PlayerDeathEarnXP then hook.Remove( "PlayerDeath", "guthlevelsystem:AddXP" ) end

timer.Create( "guthlevelsystem:ByPlayingXP", guthlevelsystem.ByPlayingTimer, 0, function()
    for _, v in pairs( player.GetHumans() ) do
        local m = hook.Run( "guthlevelsystem:OnPlayerAddByPlayingXP", v, guthlevelsystem.ByPlayingXP )
        v:LSAddXP( m and isnumber( m ) and m or guthlevelsystem.ByPlayingXP, nil, true )
    end
end )

timer.Create( "guthlevelsystem:SaveData", guthlevelsystem.SaveTimer, 0, function()
    for _, v in pairs( player.GetHumans() ) do
        v:LSSaveData()
    end
end )
if not guthlevelsystem.SaveOnTimer then timer.Remove( "guthlevelsystem:SaveData" ) end

--  > DarkRP <  --
hook.Add( "playerCanChangeTeam", "guthlevelsystem:CanChangeJob", function( ply, job )
     if ply:IsPlayer() then
         local lvl = RPExtraTeams[job].LSlvl

         if lvl then
             return ply:LSGetLVL() >= lvl, string.format( guthlevelsystem.NotificationJob, lvl, team.GetName( job ) )
         end
     end
end )

print( "Loaded succesfully" )
