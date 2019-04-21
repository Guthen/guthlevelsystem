LEVELSYSTEM = LEVELSYSTEM or {}

local function data( ply )
    if ply:IsBot() then return end

    if not ply:LSHasData() then
        ply:LSCreateData()
    else
        ply:LSGetData()
    end
end
hook.Add( "PlayerInitialSpawn", "LEVELSYSTEM:SetData", data )

local function saveData( ply )
    if ply:IsBot() then return end

    ply:LSSaveData()
end
hook.Add( "PlayerDisconnect", "LEVELSYSTEM:SaveData", saveData )

--  > Earn XP <  --

hook.Add( "OnNPCKilled", "LEVELSYSTEM:AddXP", function( npc, ply, inf )
    if not ply:IsValid() or not ply:IsPlayer() then return end

    local xp = LEVELSYSTEM.OnNPCKilledXP == -1 and npc:GetMaxHealth() or LEVELSYSTEM.OnNPCKilledXP
    ply:LSAddXP( xp )
end )
if not LEVELSYSTEM.OnNPCKilledEarnXP then hook.Remove( "OnNPCKilled", "LEVELSYSTEM:AddXP" ) end

hook.Add( "PlayerDeath", "LEVELSYSTEM:AddXP", function( ply, _, atk )
    if not atk:IsValid() or not atk:IsPlayer() then return end
    if ply == atk then return end

    local xp = LEVELSYSTEM.PlayerDeathXP or 100
    atk:LSAddXP( xp )
end )
if not LEVELSYSTEM.PlayerDeathEarnXP then hook.Remove( "PlayerDeath", "LEVELSYSTEM:AddXP" ) end

timer.Create( "LEVELSYSTEM:ByPlayingXP", LEVELSYSTEM.ByPlayingTimer, 0, function()
    for _, v in pairs( player.GetAll() ) do
        if v:IsBot() then continue end
        v:LSAddXP( LEVELSYSTEM.ByPlayingXP, nil, true )
    end
end )

timer.Create( "LEVELSYSTEM:SaveData", LEVELSYSTEM.SaveTimer, 0, function()
    for _, v in pairs( player.GetAll() ) do
        if v:IsBot() then continue end
        v:LSSaveData()
    end
end )
if not LEVELSYSTEM.SaveOnTimer then timer.Remove( "LEVELSYSTEM:SaveData" ) end

--  > DarkRP <  --
if DarkRP then
    hook.Add( "playerCanChangeTeam", "LEVELSYSTEM:CanChangeJob", function( ply, job )
        local lvl = RPExtraTeams[job].LSlvl
        print( lvl )
        if lvl then
            return ply:LSGetLVL() >= lvl, string.format( LEVELSYSTEM.NotificationJob, lvl, team.GetName( job ) )
        end
    end )
end

print( "Loaded succesfully" )
