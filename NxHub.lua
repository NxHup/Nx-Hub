local MAIN_WORLD_ID    = 119091355492870
local DUNGEON_WORLD_ID = 82878101790702
local currentPlaceId   = game.PlaceId


if currentPlaceId ~= MAIN_WORLD_ID and currentPlaceId ~= DUNGEON_WORLD_ID then
    local Players = game:GetService("Players")
    if Players.LocalPlayer then
        pcall(function()
            Players.LocalPlayer:Kick("Nx Hub: สคริปต์นี้รองรับเฉพาะแมพ Rock Fruit เท่านั้น! (Supported Rock Fruit only!)")
        end)
    end
    return
end

print("[Nx Hub Router] Current PlaceId:", currentPlaceId)

local RAW_MAIN    = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Main.lua?v=" .. tostring(os.time())
local RAW_DUNGEON = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Dungeon.lua?v=" .. tostring(os.time())

if currentPlaceId == DUNGEON_WORLD_ID then
    print("[Nx Hub Router] Loading Dungeon Mode via GitHub Raw...")
    loadstring(game:HttpGet(RAW_DUNGEON))()
elseif currentPlaceId == MAIN_WORLD_ID then
    print("[Nx Hub Router] Loading Main World Mode via GitHub Raw...")
    loadstring(game:HttpGet(RAW_MAIN))()
end
