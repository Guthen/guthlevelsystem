--  level system players table, containing XP, Level & Prestige of all players
CREATE TABLE IF NOT EXISTS guthlevelsystem_players( 
    steamid VARCHAR( 20 ) NOT NULL, 
    xp INTEGER NOT NULL, 
    lvl INTEGER NOT NULL,
    prestige INTEGER NOT NULL
);

--  copy data from old to new table 
INSERT INTO guthlevelsystem_players ( steamid, xp, lvl, prestige ) 
    SELECT SteamID, XP, LVL, 0 FROM guth_ls;

--  delete old table
DROP TABLE guth_ls; 