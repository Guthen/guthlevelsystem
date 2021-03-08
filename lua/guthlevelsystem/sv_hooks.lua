guthlevelsystem = guthlevelsystem or {}

hook.Add( "PlayerInitialSpawn", "guthlevelsystem:SetData", function( ply )
    if ply:IsBot() then return end

    ply:LSGetData( function( success, message, data )
        if not data or #data <= 0 then
            ply:LSCreateData()
        else
            ply:LSLoadData()
        end
    end ) 
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

--  > Earn XP
if guthlevelsystem.OnNPCKilledEarnXP then
    hook.Add( "PostEntityTakeDamage", "guthlevelsystem:AddXP", function( ent, dmg, take )
        if not ent:IsNPC() or ent:Health() > 0 or not take then return end

        local ply = dmg:GetAttacker()
        if not IsValid( ply ) or not ply:IsPlayer() then return end

        local xp = guthlevelsystem.OnNPCKilledXP == -1 and ent:GetMaxHealth() or guthlevelsystem.OnNPCKilledXP
        ply:LSAddXP( xp )
    end )
end

hook.Add( "PlayerDeath", "guthlevelsystem:AddXP", function( ply, _, atk )
    if not atk:IsValid() or not atk:IsPlayer() then return end
    if ply == atk then return end

    local xp = guthlevelsystem.PlayerDeathXP or 100
    atk:LSAddXP( xp )
end )
if not guthlevelsystem.PlayerDeathEarnXP then hook.Remove( "PlayerDeath", "guthlevelsystem:AddXP" ) end

if guthlevelsystem.ByPlayingEarnXP then
    timer.Create( "guthlevelsystem:ByPlayingXP", guthlevelsystem.ByPlayingTimer, 0, function()
        for _, v in pairs( player.GetHumans() ) do
            local m = hook.Run( "guthlevelsystem:OnPlayerAddByPlayingXP", v, guthlevelsystem.ByPlayingXP )
            v:LSAddXP( isnumber( m ) and m or guthlevelsystem.ByPlayingXP, nil, true )
        end
    end )
end

if guthlevelsystem.SaveOnTimer then 
    timer.Create( "guthlevelsystem:SaveData", guthlevelsystem.SaveTimer, 0, function()
        for _, v in pairs( player.GetHumans() ) do
            v:LSSaveData()
        end
    end )
end

--  > DarkRP
hook.Add( "playerCanChangeTeam", "guthlevelsystem:CanChangeJob", function( ply, job )
     if ply:IsPlayer() then
        local lvl = RPExtraTeams[job].LSlvl

        if lvl then
            if ply:LSGetLVL() < lvl then
                return false, string.format( guthlevelsystem.NotificationJob, lvl, team.GetName( job ) )
            end
        end
     end
end )

print( "Loaded succesfully" )
