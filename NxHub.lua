-- 1. ตรวจสอบ PlaceId ผ่าน Table Router แบบ local (ป้องกันตัวแปรชนกัน)
local NxHubRouter = {
    ["Rock Fruit Main"] = {
        ID = 119091355492870,
        -- เอา ?v=os.time() ออก เพื่อป้องกัน Error 429
        HTTP = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Main.lua"
    },
    ["Rock Fruit Dungeon"] = {
        ID = 82878101790702,
        HTTP = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Dungeon.lua"
    }
}

local currentPlaceId = game.PlaceId
local isSupported = false

-- 2. วนลูปเช็กแมพที่รองรับ
for _, mapConfig in pairs(NxHubRouter) do
    if currentPlaceId == mapConfig.ID then
        isSupported = true
        print("[Nx Hub] Matching map found! Preparing to load...")
        
        -- 3. ใช้ pcall ครอบไว้ ป้องกันสคริปต์เด้งสีแดงเวลา GitHub หรือเน็ตผู้เล่นมีปัญหา
        local success, err = pcall(function()
            loadstring(game:HttpGet(mapConfig.HTTP))()
        end)
        
        if not success then
            warn("[Nx Hub Error] ไม่สามารถโหลดสคริปต์หลักได้: " .. tostring(err))
            -- ตรงนี้สามารถใส่ระบบแจ้งเตือน (Notification) ในเกมให้ผู้เล่นรู้ได้ว่าเซิร์ฟเวอร์ล่ม
        end
        break
    end
end

-- 4. ถ้าไม่เจอแมพที่รองรับ ให้เตะออกทันทีเพื่อความปลอดภัย
if not isSupported then
    local Players = game:GetService("Players")
    if Players.LocalPlayer then
        pcall(function()
            Players.LocalPlayer:Kick("Nx Hub: สคริปต์นี้ยังไม่รองรับแมพที่คุณกำลังเล่นอยู่! (Unsupported Game!)")
        end)
    end
end
-- 1. ตรวจสอบ PlaceId ผ่าน Table Router แบบ local (ป้องกันตัวแปรชนกัน)
local NxHubRouter = {
    ["Rock Fruit Main"] = {
        ID = 119091355492870,
        -- เอา ?v=os.time() ออก เพื่อป้องกัน Error 429
        HTTP = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Main.lua"
    },
    ["Rock Fruit Dungeon"] = {
        ID = 82878101790702,
        HTTP = "https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NxHub_Dungeon.lua"
    }
}

local currentPlaceId = game.PlaceId
local isSupported = false

-- 2. วนลูปเช็กแมพที่รองรับ
for _, mapConfig in pairs(NxHubRouter) do
    if currentPlaceId == mapConfig.ID then
        isSupported = true
        print("[Nx Hub] Matching map found! Preparing to load...")
        
        -- 3. ใช้ pcall ครอบไว้ ป้องกันสคริปต์เด้งสีแดงเวลา GitHub หรือเน็ตผู้เล่นมีปัญหา
        local success, err = pcall(function()
            loadstring(game:HttpGet(mapConfig.HTTP))()
        end)
        
        if not success then
            warn("[Nx Hub Error] ไม่สามารถโหลดสคริปต์หลักได้: " .. tostring(err))
            -- ตรงนี้สามารถใส่ระบบแจ้งเตือน (Notification) ในเกมให้ผู้เล่นรู้ได้ว่าเซิร์ฟเวอร์ล่ม
        end
        break
    end
end

-- 4. ถ้าไม่เจอแมพที่รองรับ ให้เตะออกทันทีเพื่อความปลอดภัย
if not isSupported then
    local Players = game:GetService("Players")
    if Players.LocalPlayer then
        pcall(function()
            Players.LocalPlayer:Kick("Nx Hub: สคริปต์นี้ยังไม่รองรับแมพที่คุณกำลังเล่นอยู่! (Unsupported Game!)")
        end)
    end
end