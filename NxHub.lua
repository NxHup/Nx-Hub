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

local CDN_MAIN    = "https://cdn.jsdelivr.net/gh/NxHup/Nx-Hub@main/NxHub_Main.lua"
local CDN_DUNGEON = "https://cdn.jsdelivr.net/gh/NxHup/Nx-Hub@main/NxHub_Dungeon.lua"

if currentPlaceId == DUNGEON_WORLD_ID then
    print("[Nx Hub Router] Loading Dungeon Mode via CDN...")
    if isfile and isfile("NxHub_Dungeon.lua") then
        loadfile("NxHub_Dungeon.lua")()
    else
        loadstring(game:HttpGet(CDN_DUNGEON))()
    end
elseif currentPlaceId == MAIN_WORLD_ID then
    print("[Nx Hub Router] Loading Main World Mode via CDN...")
    if isfile and isfile("NxHub_Main.lua") then
        loadfile("NxHub_Main.lua")()
    else
        loadstring(game:HttpGet(CDN_MAIN))()
    end
end
