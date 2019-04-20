LEVELSYSTEM = LEVELSYSTEM or {}

local function data( ply )
    if not ply:IsValid() or not ply:IsPlayer() then return end

    if not ply:LSHasData() then
        ply:LSCreateData()
    else
        ply:LSGetData()
    end
end
hook.Add( "PlayerSpawn", "LEVELSYSTEM:SetData", data )

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

print( "Loaded succesfully" )
