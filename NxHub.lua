local NxHubRouter = {
    ["Rock Fruit Main"] = {
        ID = 119091355492870,
      
        HTTP = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Main.lua"
    },
    ["Rock Fruit Dungeon"] = {
        ID = 82878101790702,
        HTTP = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Dungeon.lua"
    }
}

local currentPlaceId = game.PlaceId
local isSupported = false


for _, mapConfig in pairs(NxHubRouter) do
    if currentPlaceId == mapConfig.ID then
        isSupported = true
        print("[Nx Hub] Matching map found! Preparing to load...")
        

        local success, err = pcall(function()
            loadstring(game:HttpGet(mapConfig.HTTP))()
        end)
        
        if not success then
            warn("[Nx Hub Error] ไม่สามารถโหลดสคริปต์หลักได้: " .. tostring(err))

        end
        break
    end
end


if not isSupported then
    local Players = game:GetService("Players")
    if Players.LocalPlayer then
        pcall(function()
            Players.LocalPlayer:Kick("Nx Hub: สคริปต์นี้ยังไม่รองรับแมพที่คุณกำลังเล่นอยู่! (Unsupported Game!)")
        end)
    end
end
