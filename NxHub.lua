-- ============================================================
--   Nx Hub - Universal Loader & Place Router
--   By_Beemyeon
-- ============================================================

local MAIN_WORLD_ID    = 119091355492870
local DUNGEON_WORLD_ID = 82878101790702
local currentPlaceId   = game.PlaceId

print("[Nx Hub Router] Current PlaceId:", currentPlaceId)

if currentPlaceId == DUNGEON_WORLD_ID then
    print("[Nx Hub Router] Loading Dungeon Mode...")
    if isfile and isfile("NxHub_Dungeon.lua") then
        loadfile("NxHub_Dungeon.lua")()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NxHup/Nx-Hub/main/NxHub_Dungeon.lua"))()
    end
else
    print("[Nx Hub Router] Loading Main World Mode...")
    if isfile and isfile("NxHub_Main.lua") then
        loadfile("NxHub_Main.lua")()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NxHup/Nx-Hub/main/NxHub_Main.lua"))()
    end
end
