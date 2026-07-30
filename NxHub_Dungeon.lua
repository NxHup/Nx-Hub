-- ============================================================
--   Nx Hub - Dungeon Mode
--   By_Beemyeon
-- ============================================================

-- ล็อกให้ใช้งานได้เฉพาะดันเจี้ยน Rock Fruit เท่านั้น (Place ID: 82878101790702)
if game.PlaceId ~= 82878101790702 then
    local Players = game:GetService("Players")
    if Players.LocalPlayer then
        pcall(function()
            Players.LocalPlayer:Kick("Nx Hub: สคริปต์นี้รองรับเฉพาะดันเจี้ยน Rock Fruit เท่านั้น! (Supported Dungeon only!)")
        end)
    end
    return
end

-- ป้องกันสคริปต์ทำงานซ้ำซ้อน
if getgenv().NxHubDungeonLoaded and getgenv().NxHubDungeonUnload then
    pcall(getgenv().NxHubDungeonUnload)
    task.wait(0.2)
end

-- ============================================================
--  UI Library Load (Same as Main)
-- ============================================================
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/NxHup/Nx-Hub/refs/heads/main/NXHubLibrary.lua"))()

-- ============================================================
--  Services
-- ============================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(c) Character = c end)

local function GetCharacter() return LocalPlayer.Character end
local function GetHRP()
    local c = GetCharacter()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local Remotes         = ReplicatedStorage:WaitForChild("Remotes")
local Action          = Remotes:WaitForChild("Action")
local InventoryRemote = Remotes:WaitForChild("Inventory")

-- ============================================================
--  Helpers
-- ============================================================
local function GetEquippedTool()
    local c = GetCharacter()
    if not c then return nil end
    for _, v in c:GetChildren() do
        if v:IsA("Tool") then return v.Name end
    end
    return nil
end

local function GetBackpackTools()
    local tools, seen = {}, {}
    local c = GetCharacter()
    if c then
        for _, v in c:GetChildren() do
            if v:IsA("Tool") and not seen[v.Name] then
                seen[v.Name] = true; table.insert(tools, v.Name)
            end
        end
    end
    for _, v in LocalPlayer.Backpack:GetChildren() do
        if v:IsA("Tool") and not seen[v.Name] then
            seen[v.Name] = true; table.insert(tools, v.Name)
        end
    end
    table.sort(tools)
    return tools
end

-- ============================================================
--  Window
-- ============================================================
local Window = Fluent:CreateWindow({
    Title       = "Nx Hub",
    SubTitle    = "By_Beemyeon [Dungeon Mode]",
    Logo        = "https://cdn.jsdelivr.net/gh/NxHup/Nx-Hub@main/f5756ce8-6683-4be4-9845-29f066e64369.jpg",
    TabWidth    = 135,
    Size        = UDim2.fromOffset(480, 360),
    Acrylic     = true,
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main     = Window:AddTab({ Title = "Main",      Icon = "home" }),
    Farm     = Window:AddTab({ Title = "Dungeon",   Icon = "swords" }),
    Rejoin   = Window:AddTab({ Title = "Auto Join", Icon = "refresh-cw" }),
    Misc     = Window:AddTab({ Title = "Misc",      Icon = "box" }),
}

local Options = Fluent.Options
Fluent:Notify({ Title = "Nx Hub [Dungeon]", Content = "Dungeon Mode Loaded!", Duration = 4 })

-- ============================================================
--  State
-- ============================================================
local selectedWeaponCategories = {"Melee"}
local weaponCategoryIndex = 1

local function GetCurrentWeaponCategory()
    if #selectedWeaponCategories == 0 then return "Melee" end
    return selectedWeaponCategories[weaponCategoryIndex] or "Melee"
end

local function AdvanceWeaponCategory()
    if #selectedWeaponCategories > 1 then
        weaponCategoryIndex = (weaponCategoryIndex % #selectedWeaponCategories) + 1
    end
end

local function GetToolCategory(tool)
    if not tool or not tool:IsA("Tool") then return "Melee" end
    
    local toolType = tool:GetAttribute("Type") or tool:GetAttribute("WeaponType") or tool:GetAttribute("Category") or tool.ToolTip
    if toolType and toolType ~= "" then
        local tLower = string.lower(tostring(toolType))
        if string.find(tLower, "sword") then return "Sword" end
        if string.find(tLower, "fruit") or string.find(tLower, "devil") then return "DevilFruit" end
        if string.find(tLower, "special") or string.find(tLower, "gun") then return "Special" end
        if string.find(tLower, "melee") or string.find(tLower, "combat") then return "Melee" end
    end
    
    local name = string.lower(tool.Name)
    if string.find(name, "fruit") or string.find(name, "ผล") or string.find(name, "demon") or string.find(name, "dark") or string.find(name, "light") or string.find(name, "ice") or string.find(name, "flame") or string.find(name, "magma") or string.find(name, "buddha") or string.find(name, "dragon") or string.find(name, "leopard") or string.find(name, "dough") then return "DevilFruit" end
    if string.find(name, "sword") or string.find(name, "katana") or string.find(name, "blade") or string.find(name, "saber") or string.find(name, "scythe") or string.find(name, "dagger") or string.find(name, "spear") or string.find(name, "cutlass") or string.find(name, "yoru") or string.find(name, "bisento") or string.find(name, "pole") or string.find(name, "trident") then return "Sword" end
    if string.find(name, "special") or string.find(name, "gun") or string.find(name, "slingshot") or string.find(name, "rifle") or string.find(name, "cannon") or string.find(name, "bazooka") then return "Special" end
    
    return "Melee"
end

local function GetBestToolForCategory(category)
    local char = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and GetToolCategory(tool) == category then
                return tool
            end
        end
    end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and GetToolCategory(tool) == category then
                return tool
            end
        end
    end
    if char then
        local t = char:FindFirstChildOfClass("Tool")
        if t then return t end
    end
    if backpack then
        local t = backpack:FindFirstChildOfClass("Tool")
        if t then return t end
    end
    return nil
end

-- ============================================================
--  Auto Weapon Equip
-- ============================================================
local lastWeaponRotateTime = 0

local function EnsureWeaponEquipped()
    pcall(function()
        local c = GetCharacter()
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        
        -- สลับประเภทอาวุธตามเวลา (ทุก 5 วินาที เมื่อเลือกหลายประเภท)
        local now = tick()
        if #selectedWeaponCategories > 1 and (now - lastWeaponRotateTime) >= 0.5 then
            AdvanceWeaponCategory()
            lastWeaponRotateTime = now
        end
        
        local targetTool = GetBestToolForCategory(GetCurrentWeaponCategory())
        if not targetTool then return end
        
        local currentTool = c:FindFirstChildOfClass("Tool")
        if currentTool and currentTool.Name == targetTool.Name then return end
        
        if targetTool.Parent == LocalPlayer.Backpack then
            hum:EquipTool(targetTool)
        end
    end)
end

-- ============================================================
--  Auto Attack Loop
-- ============================================================
local function StartAttackLoop()
    EnsureWeaponEquipped()
    if autoAttackLoop then return end
    autoAttackLoop = task.spawn(function()
        while true do
            EnsureWeaponEquipped()
            local c = GetCharacter()
            if c then
                local equipped = c:FindFirstChildOfClass("Tool")
                if equipped then
                    pcall(function() Action:FireServer(equipped, "hit") end)
                    pcall(function() Action:FireServer(equipped.Name, "hit") end)
                    pcall(function() equipped:Activate() end)
                end
            end
            task.wait(0.1)
        end
    end)
end

local function StopAttackLoop()
    if autoAttackLoop then
        task.cancel(autoAttackLoop)
        autoAttackLoop = nil
    end
end

local function IsMobNearbyForSkill()
    local hrp = GetHRP()
    if not hrp then return false end
    local pos = hrp.Position
    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = {LocalPlayer.Character}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then table.insert(filterList, p.Character) end
    end
    params.FilterDescendantsInstances = filterList
    
    local parts = workspace:GetPartBoundsInRadius(pos, 35, params)
    for _, part in ipairs(parts) do
        local model = part:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChildOfClass("Humanoid") then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                return true
            end
        end
    end
    return false
end

local function GetEquippedToolInstance()
    local c = GetCharacter()
    if not c then return nil end
    for _, v in ipairs(c:GetChildren()) do
        if v:IsA("Tool") then return v end
    end
    return nil
end

local function StartSkillLoop()
    if skillLoop then return end
    skillLoop = task.spawn(function()
        while true do
            local onlyNear = Options.DungSkillOnlyNearMob and Options.DungSkillOnlyNearMob.Value
            if not onlyNear or IsMobNearbyForSkill() then
                local delay = (Options.DungSkillDelay and Options.DungSkillDelay.Value or 0) * 0.1
                local toolInst = GetEquippedToolInstance()
                if toolInst then
                    local toolName = toolInst.Name
                    if Options.DungSkillZ and Options.DungSkillZ.Value then
                        pcall(function() Action:FireServer(toolInst, "z") end)
                        pcall(function() Action:FireServer(toolName, "z") end)
                        if delay > 0 then task.wait(delay) end
                    end
                    if Options.DungSkillX and Options.DungSkillX.Value then
                        pcall(function() Action:FireServer(toolInst, "x") end)
                        pcall(function() Action:FireServer(toolName, "x") end)
                        if delay > 0 then task.wait(delay) end
                    end
                    if Options.DungSkillC and Options.DungSkillC.Value then
                        pcall(function() Action:FireServer(toolInst, "c") end)
                        pcall(function() Action:FireServer(toolName, "c") end)
                        if delay > 0 then task.wait(delay) end
                    end
                    if Options.DungSkillV and Options.DungSkillV.Value then
                        pcall(function() Action:FireServer(toolInst, "v") end)
                        pcall(function() Action:FireServer(toolName, "v") end)
                        if delay > 0 then task.wait(delay) end
                    end
                end
            end
            task.wait()
        end
    end)
end

local function CheckSkillLoop()
    if skillLoop then
        task.cancel(skillLoop)
        skillLoop = nil
    end
    local any = (Options.DungSkillZ and Options.DungSkillZ.Value)
        or (Options.DungSkillX and Options.DungSkillX.Value)
        or (Options.DungSkillC and Options.DungSkillC.Value)
        or (Options.DungSkillV and Options.DungSkillV.Value)
    if any then
        StartSkillLoop()
    end
end

-- ============================================================
--  TAB: MAIN
-- ============================================================
local WeaponDropdown = Tabs.Main:AddDropdown("DungWeaponSelect", {
    Title       = "Select Weapon Category",
    Description = "เลือกหมวดหมู่อาวุธที่จะใช้ฟาร์มมอนดันเจียน",
    Values      = {"Melee", "Sword", "Special", "DevilFruit"},
    Multi       = true,
    Default     = {"Melee"},
})
WeaponDropdown:OnChanged(function(val)
    local newList = {}
    if typeof(val) == "table" then
        for k, v in pairs(val) do
            if v == true then table.insert(newList, k)
            elseif typeof(v) == "string" then table.insert(newList, v) end
        end
    elseif typeof(val) == "string" and val ~= "" then
        table.insert(newList, val)
    end
    if #newList == 0 then newList = {"Melee"} end
    selectedWeaponCategories = newList
    weaponCategoryIndex = 1
end)

-- Auto Haki
Tabs.Main:AddToggle("DungAutoHaki", {
    Title       = "Auto Haki",
    Description = "เปิดใช้งานฮาคิอัตโนมัติ",
    Default     = false
}):OnChanged(function()
    if Options.DungAutoHaki.Value then
        if autoHakiLoop then return end
        autoHakiLoop = task.spawn(function()
            while Options.DungAutoHaki.Value do
                local c = GetCharacter()
                if c then
                    local hasHaki = c:FindFirstChild("HakiFolder") ~= nil
                    if not hasHaki then
                        pcall(function() Action:FireServer("Misc", "buso") end)
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        if autoHakiLoop then task.cancel(autoHakiLoop); autoHakiLoop = nil end
    end
end)

-- Auto Skill
Tabs.Main:AddParagraph({ Title = "Auto Skill", Content = "เปิด Toggle ด้านล่างเพื่อใช้สกิลอัตโนมัติ" })
Tabs.Main:AddToggle("DungSkillOnlyNearMob", {
    Title       = "Skill Only Near Monster",
    Description = "ปล่อยสกิลเฉพาะตอนอยู่ใกล้มอนสเตอร์เท่านั้น",
    Default     = true
}):OnChanged(CheckSkillLoop)
Tabs.Main:AddSlider("DungSkillDelay", {
    Title       = "Skill Delay",
    Description = "หน่วงเวลาระหว่างสกิล (x0.1s) | 0 = ปล่อยทันที",
    Default     = 0,
    Min         = 0,
    Max         = 50,
    Rounding    = 0,
    Callback    = function(v) end
})
Tabs.Main:AddToggle("DungSkillZ", { Title = "Auto Skill Z", Default = false }):OnChanged(CheckSkillLoop)
Tabs.Main:AddToggle("DungSkillX", { Title = "Auto Skill X", Default = false }):OnChanged(CheckSkillLoop)
Tabs.Main:AddToggle("DungSkillC", { Title = "Auto Skill C", Default = false }):OnChanged(CheckSkillLoop)
Tabs.Main:AddToggle("DungSkillV", { Title = "Auto Skill V", Default = false }):OnChanged(CheckSkillLoop)

-- Farm Position
Tabs.Main:AddDropdown("DungFarmPosition", {
    Title       = "Farm Position",
    Description = "ตำแหน่งที่จะยืนฟาร์มมอน",
    Values      = {"Above", "Below", "Behind", "In Front"},
    Multi       = false,
    Default     = 4,
})
Tabs.Main:AddSlider("DungFarmDistance", {
    Title       = "Farm Distance",
    Description = "ระยะห่างจากเป้าหมาย",
    Default     = 10,
    Min         = 0,
    Max         = 30,
    Rounding    = 1,
    Callback    = function(v) end
})

-- ============================================================
--  TAB: DUNGEON
-- ============================================================
-- หาฐาน (RocketTower / Tower) ในดันเจี้ยน
local function FindBase()
    -- ลองหาจากชื่อทั่วไปของฐานดันเจี้ยน
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("BasePart") then
            local name = string.lower(v.Name)
            if string.find(name, "tower") or string.find(name, "base") or string.find(name, "rocket") or string.find(name, "crystal") then
                local part = v:IsA("BasePart") and v or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))
                if part then return part end
            end
        end
    end
    return nil
end

-- หามอนที่ใกล้ฐานมากที่สุด (ตัวที่กำลังจะถึงฐานก่อน = อันตรายที่สุด)
local function GetNearestAliveMob()
    local nearest = nil
    local minDist = math.huge
    local base = FindBase()
    local refPos
    if base then
        refPos = base.Position  -- ใช้ตำแหน่งฐานเป็น reference
    else
        local hrp = GetHRP()
        refPos = hrp and hrp.Position or Vector3.zero  -- fallback ใช้ตำแหน่งผู้เล่น
    end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model")
            and v:FindFirstChild("Humanoid")
            and v.Humanoid.Health > 0
            and v:FindFirstChild("HumanoidRootPart")
            and not Players:GetPlayerFromCharacter(v)
        then
            local dist = (v.HumanoidRootPart.Position - refPos).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = v
            end
        end
    end
    return nearest
end

-- Move to mob using Farm Position setting
local function MoveTo(target)
    local hrp = GetHRP()
    if not hrp or not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local tCF   = target.HumanoidRootPart.CFrame
    local tPos  = tCF.Position
    local pos   = Options.DungFarmPosition and Options.DungFarmPosition.Value or "Above"
    local dist  = Options.DungFarmDistance and Options.DungFarmDistance.Value or 10
    local finalPos
    if pos == "Above" then
        finalPos = tPos + Vector3.new(0, dist, 0)
    elseif pos == "Below" then
        finalPos = tPos + Vector3.new(0, -dist, 0)
    elseif pos == "Behind" then
        finalPos = (tCF * CFrame.new(0, 0, dist)).Position
    elseif pos == "In Front" then
        finalPos = (tCF * CFrame.new(0, 0, -dist)).Position
    end
    local targetCF = CFrame.lookAt(finalPos or tPos, tPos)
    hrp.CFrame = targetCF
    hrp.AssemblyLinearVelocity  = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end
local removeDungeonEffectsConn = nil
local function DisableParticle(v)
    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Explosion") then
        pcall(function() v.Enabled = false end)
        pcall(function() v:Destroy() end)
    elseif v:IsA("Decal") or v:IsA("Texture") then
        pcall(function() v.Texture = "" end)
    end
end

Tabs.Farm:AddToggle("DungRemoveEffects", {
    Title       = "Remove Dungeon Effects (ลบเอฟเฟคในดัน)",
    Description = "ลบสกิล เอฟเฟกต์ แสง Particle ในดันเจี้ยนทั้งหมดออกเพื่อลดอาการกระตุก",
    Default     = true
}):OnChanged(function()
    if Options.DungRemoveEffects.Value then
        for _, v in ipairs(workspace:GetDescendants()) do
            DisableParticle(v)
        end
        if removeDungeonEffectsConn then removeDungeonEffectsConn:Disconnect() end
        removeDungeonEffectsConn = workspace.DescendantAdded:Connect(function(v)
            if Options.DungRemoveEffects and Options.DungRemoveEffects.Value then
                DisableParticle(v)
            end
        end)
    else
        if removeDungeonEffectsConn then
            removeDungeonEffectsConn:Disconnect()
            removeDungeonEffectsConn = nil
        end
    end
end)

Tabs.Farm:AddToggle("DungAutoFarm", {
    Title       = "Auto Farm Dungeon (ตีมอนดันเจี้ยนอัตโนมัติ)",
    Description = "วาร์ปตีมอนสเตอร์ในดันเจี้ยนให้อัตโนมัติ",
    Default     = true
}):OnChanged(function()
    if Options.DungAutoFarm.Value then
        StartAttackLoop()
        if autoFarmLoop then return end

        local currentTarget        = nil
        local RETARGET_INTERVAL    = 0.5
        local lastRetargetTime     = 0

        autoFarmLoop = RunService.Heartbeat:Connect(function()
            if not Options.DungAutoFarm.Value then return end
            EnsureWeaponEquipped()

            local hrp = GetHRP()
            if not hrp then return end

            -- เช็คว่าเป้าปัจจุบันยังมีชีวิตอยู่ไหม
            local targetAlive = currentTarget
                and currentTarget:FindFirstChild("Humanoid")
                and currentTarget.Humanoid.Health > 0
                and currentTarget:FindFirstChild("HumanoidRootPart")

            -- เปลี่ยนเป้าหมายใหม่ถ้าตายแล้ว หรือถึงเวลา retarget
            local now = tick()
            if not targetAlive or (now - lastRetargetTime) >= RETARGET_INTERVAL then
                currentTarget = GetNearestAliveMob()
                lastRetargetTime = now
            end

            if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                -- คำนวณตำแหน่งที่ควรยืน
                local tCF  = currentTarget.HumanoidRootPart.CFrame
                local tPos = tCF.Position
                local pos  = Options.DungFarmPosition and Options.DungFarmPosition.Value or "Above"
                local dist = Options.DungFarmDistance and Options.DungFarmDistance.Value or 10
                local finalPos
                if pos == "Above" then
                    finalPos = tPos + Vector3.new(0, dist, 0)
                elseif pos == "Below" then
                    finalPos = tPos + Vector3.new(0, -dist, 0)
                elseif pos == "Behind" then
                    finalPos = (tCF * CFrame.new(0, 0, dist)).Position
                elseif pos == "In Front" then
                    finalPos = (tCF * CFrame.new(0, 0, -dist)).Position
                end
                finalPos = finalPos or tPos

                -- วาร์ปทุก frame เลย (ติดกาวกับ mob = 0 delay smooth 100%)
                hrp.CFrame = CFrame.lookAt(finalPos, tPos)
                hrp.AssemblyLinearVelocity  = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            -- else: ไม่มีมอน → ไม่ต้องทำอะไร รอมอน respawn
            end
        end)
    else
        if autoFarmLoop then autoFarmLoop:Disconnect(); autoFarmLoop = nil end
        StopAttackLoop()
    end
end)

Tabs.Farm:AddParagraph({
    Title   = "Tips การฟาร์มดันเจี้ยน",
    Content = "1. เปิด Auto Hold Weapon ก่อนเพื่อให้ถืออาวุธตลอด\n2. เปิด Auto Haki เพื่อเพิ่มดาเมจ\n3. ปรับ Farm Position และ Farm Distance ให้เหมาะกับอาวุธ\n4. เปิด Auto Skill Z/X/C/V เพื่อยิงสกิลอัตโนมัติ"
})

-- ============================================================
--  TAB: AUTO REJOIN (ตรวจ HP ฐานจาก UI จริงๆ)
-- ============================================================

-- อ่าน HP ฐานจาก BillboardGui บน RocketTower โดยตรง
-- Path: workspace.island.Moon.RocketTower.Attachment.BillboardGui.Healthbar.HealthText
local function GetBaseHP()
    local ok, cur, max = pcall(function()
        local label = workspace.island.Moon.RocketTower.Attachment.BillboardGui.Healthbar.HealthText
        local txt = label.Text or ""
        -- จับ pattern "19500/50000"
        local c, m = string.match(txt, "(%d+)%s*/%s*(%d+)")
        return tonumber(c), tonumber(m)
    end)
    if ok and cur then return cur, max end
    return nil, nil
end

Tabs.Rejoin:AddDropdown("JoinServerMode", {
    Title       = "รูปแบบการย้ายเซิร์ฟเวอร์",
    Values      = {"เซิร์ฟคนน้อยสุด (Low Players)", "สุ่มปกติ (Random Server)"},
    Default     = "เซิร์ฟคนน้อยสุด (Low Players)",
    Callback    = function() end
})

Tabs.Rejoin:AddSlider("RejoinDelay", {
    Title       = "Delay ก่อนวาร์ป (วิ)",
    Description = "รอกี่วิหลัง HP = 0 ก่อนออก",
    Default     = 3,
    Min         = 0,
    Max         = 15,
    Rounding    = 0,
    Callback    = function() end
})

-- ฟังก์ชันค้นหา JobId ของเซิร์ฟเวอร์คนน้อยสุดในแมพหลัก
local function GetSmallServerJobId(placeId)
    local HttpService = game:GetService("HttpService")
    local req = (syn and syn.request) or (http and http.request) or request or (http_request)
    
    local url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, response
    if req then
        success, response = pcall(function()
            return req({Url = url, Method = "GET"})
        end)
    else
        success, response = pcall(function()
            return {Body = game:HttpGet(url)}
        end)
    end
    
    if success and response and response.Body then
        local ok, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if ok and data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing and server.playing < server.maxPlayers and server.id ~= game.JobId then
                    return server.id
                end
            end
        end
    end
    return nil
end

Tabs.Rejoin:AddToggle("AutoRejoin", {
    Title       = "Auto Join กลับแมพหลัก (เมื่อ HP ฐาน = 0)",
    Description = "ตรวจ HP จาก UI วาร์ปกลับแมพหลักให้อัตโนมัติ",
    Default     = false
}):OnChanged(function()
    if Options.AutoRejoin.Value then
        if baseWatchLoop then return end
        baseWatchLoop = task.spawn(function()
            local triggered = false
            while Options.AutoRejoin.Value and not triggered do
                local cur, max = GetBaseHP()
                if cur and cur <= 0 then
                    triggered = true
                    local delay = Options.RejoinDelay and Options.RejoinDelay.Value or 3

                    -- หยุดฟาร์มทันที
                    if autoFarmLoop then autoFarmLoop:Disconnect(); autoFarmLoop = nil end
                    StopAttackLoop()
                    if Options.DungAutoFarm then
                        pcall(function() Options.DungAutoFarm:SetValue(false) end)
                    end

                    Fluent:Notify({
                        Title    = "Nx Hub Dungeon",
                        Content  = "HP ฐาน = 0! หยุดฟาร์มแล้ว กำลังวาร์ปใน " .. delay .. " วิ...",
                        Duration = delay + 2
                    })
                    task.wait(delay)

                    local MAIN_PLACE_ID = 119091355492870
                    local mode = Options.JoinServerMode and Options.JoinServerMode.Value or "เซิร์ฟคนน้อยสุด (Low Players)"
                    local teleportSuccess = false
                    local attempts = 0

                    while not teleportSuccess and attempts < 5 do
                        attempts = attempts + 1
                        
                        if mode == "เซิร์ฟคนน้อยสุด (Low Players)" then
                            local smallJobId = GetSmallServerJobId(MAIN_PLACE_ID)
                            if smallJobId then
                                teleportSuccess = pcall(function()
                                    TeleportService:TeleportToPlaceInstance(MAIN_PLACE_ID, smallJobId, LocalPlayer)
                                end)
                            end
                        end

                        if not teleportSuccess then
                            teleportSuccess = pcall(function()
                                TeleportService:TeleportAsync(MAIN_PLACE_ID, {LocalPlayer})
                            end)
                        end
                        if not teleportSuccess then
                            teleportSuccess = pcall(function()
                                TeleportService:Teleport(MAIN_PLACE_ID)
                            end)
                        end

                        if not teleportSuccess and attempts < 5 then
                            task.wait(2)
                        end
                    end
                end
                task.wait(1)
            end
            baseWatchLoop = nil
        end)
    else
        if baseWatchLoop then task.cancel(baseWatchLoop); baseWatchLoop = nil end
    end
end)

Tabs.Rejoin:AddParagraph({
    Title   = "วิธีใช้",
    Content = "• เมื่อเลือดฐานเหลือ 0 ระบบจะหยุดฟาร์มและพาวาร์ปกลับแมพหลักให้อัตโนมัติ"
})

-- ============================================================
--  TAB: MISC (Anti-AFK & System Utilities)
-- ============================================================
local antiAfkConn = nil
local VirtualUser = game:GetService("VirtualUser")

local function EnableAntiAFK()
    if antiAfkConn then return end
    antiAfkConn = LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
end

local function DisableAntiAFK()
    if antiAfkConn then
        antiAfkConn:Disconnect()
        antiAfkConn = nil
    end
end

Tabs.Misc:AddToggle("DungAntiAFK", {
    Title       = "Anti AFK",
    Description = "ป้องกันเกมดีดออกเวลาไม่ได้ขยับตัวในดันเจี้ยน",
    Default     = true
}):OnChanged(function()
    if Options.DungAntiAFK.Value then
        EnableAntiAFK()
    else
        DisableAntiAFK()
    end
end)

Tabs.Misc:AddKeybind("DungToggleKeybind", {
    Title       = "Menu Toggle Keybind",
    Description = "ปุ่มคีย์ลัดสำหรับเปิด/ปิดเมนู UI บนคอมพิวเตอร์",
    Mode        = "Toggle",
    Default     = "LeftControl",
    Callback    = function(Value)
        Window:Minimize()
    end,
    ChangedCallback = function(NewKey)
        Window.MinimizeKey = NewKey
    end
})

-- เปิด Anti AFK อัตโนมัติทันทีที่โหลดดันเจี้ยน
EnableAntiAFK()

-- ============================================================
--  Real-time Config Auto Save & Load
-- ============================================================
local function SanitizeValue(val)
    local t = typeof(val)
    if t == "boolean" or t == "number" or t == "string" then
        return val
    elseif t == "table" then
        local cleanTable = {}
        for k, v in pairs(val) do
            local cleanV = SanitizeValue(v)
            if cleanV ~= nil then
                cleanTable[tostring(k)] = cleanV
            end
        end
        return cleanTable
    end
    return nil
end

pcall(function()
    if makefolder then
        makefolder("NXHubSettings")
    end
end)

local excludeFromLoad = {
    DungToggleKeybind = true
}

-- Load configuration at startup
pcall(function()
    local json = nil
    if isfile and isfile("NXHubSettings/DungeonWorld.json") then
        json = readfile("NXHubSettings/DungeonWorld.json")
    elseif isfile and isfile("DungeonWorld.json") then
        json = readfile("DungeonWorld.json")
    end

    if json and json ~= "" then
        local config = HttpService:JSONDecode(json)
        for idx, val in pairs(config) do
            if Options[idx] and Options[idx].SetValue and not excludeFromLoad[idx] then
                pcall(function()
                    Options[idx]:SetValue(val)
                end)
            end
        end
    end
end)

-- Background thread to save configuration in real-time
local lastConfigString = ""

-- ยกเลิก save loop เก่าก่อน (ป้องกัน loop ซ้ำตอน re-execute)
if getgenv().NxHubDungeonSaveLoop then
    pcall(function() task.cancel(getgenv().NxHubDungeonSaveLoop) end)
    getgenv().NxHubDungeonSaveLoop = nil
end

getgenv().NxHubDungeonSaveLoop = task.spawn(function()
    -- แจ้งว่า save loop เริ่มทำงานแล้ว
    task.wait(2)
    local optCount = 0
    for _ in pairs(Options) do optCount = optCount + 1 end
    Fluent:Notify({
        Title   = "[Dungeon] Save Loop Started",
        Content = "Options count: " .. optCount .. " | writefile: " .. tostring(writefile ~= nil) .. " | makefolder: " .. tostring(makefolder ~= nil),
        Duration = 8
    })

    while task.wait(1) do
        local currentConfig = {}
        for idx, option in pairs(Options) do
            if option and option.Value ~= nil and not excludeFromLoad[idx] then
                local cleanVal = SanitizeValue(option.Value)
                if cleanVal ~= nil then
                    currentConfig[idx] = cleanVal
                end
            end
        end

        local ok2, json = pcall(function() return HttpService:JSONEncode(currentConfig) end)
        if not ok2 then
            Fluent:Notify({ Title = "[Dungeon] Encode Error", Content = tostring(json), Duration = 5 })
        elseif json and json ~= lastConfigString then
            lastConfigString = json
            local saveOk, saveErr = pcall(function()
                if makefolder then makefolder("NXHubSettings") end
                writefile("NXHubSettings/DungeonWorld.json", json)
            end)
            if not saveOk then
                Fluent:Notify({ Title = "[Dungeon] Save Error", Content = tostring(saveErr), Duration = 8 })
            end
            pcall(function()
                writefile("DungeonWorld.json", json)
            end)
        end
    end
end)

-- ============================================================
--  Anti-re-execute cleanup
-- ============================================================
getgenv().NxHubDungeonLoaded = true
getgenv().NxHubDungeonUnload = function()
    pcall(function() if autoAttackLoop then task.cancel(autoAttackLoop) end end)
    pcall(function() if skillLoop      then task.cancel(skillLoop)      end end)
    pcall(function() if autoHakiLoop   then task.cancel(autoHakiLoop)   end end)
    pcall(function() if autoFarmLoop   then autoFarmLoop:Disconnect()   end end)
    pcall(function() if autoHoldConn   then autoHoldConn:Disconnect()   end end)
    pcall(function() if baseWatchLoop  then task.cancel(baseWatchLoop)  end end)
    pcall(function()
        if removeDungeonEffectsConn then
            removeDungeonEffectsConn:Disconnect()
            removeDungeonEffectsConn = nil
        end
    end)
    -- ยกเลิก save loop
    pcall(function()
        if getgenv().NxHubDungeonSaveLoop then
            task.cancel(getgenv().NxHubDungeonSaveLoop)
            getgenv().NxHubDungeonSaveLoop = nil
        end
    end)
    pcall(function() ToggleGui:Destroy() end)
    getgenv().NxHubDungeonLoaded = false
end

Window:SelectTab(2) -- เปิดไปที่แท็บ Dungeon ทันที
