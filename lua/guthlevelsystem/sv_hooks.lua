LEVELSYSTEM = LEVELSYSTEM or {}

local function data( ply )
    if not ply:IsValid() or not ply:IsPlayer() then return end

    if not ply:LSHasData() then
        ply:LSCreateData()
    else
        ply:LSGetData()
    end
end
hook.Add( "PlayerInitialSpawn", "LEVELSYSTEM:SetData", data )

print( "Loaded succesfully" )
