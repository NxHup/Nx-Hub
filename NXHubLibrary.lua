-- =================================================================
-- NX HUB UI LIBRARY จะมาดูหาบิดาท่านหรอรู้นะ
-- =================================================================


local NXHub = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local Options = {}
NXHub.Options = Options

local GlobalScreenGui = nil

-- Lucide Icon Asset Map (Verified High-Tech Asset IDs)
local LucideIcons = {
    -- Main (Dashboard / Sparkles / Terminal / Home)
    ["layout-dashboard"] = "rbxassetid://10723346959",
    ["dashboard"] = "rbxassetid://10723346959",
    ["sparkles"] = "rbxassetid://10734976458",
    ["terminal"] = "rbxassetid://10747384394",
    ["home"] = "rbxassetid://10723346959",
    ["main"] = "rbxassetid://10723346959",

    -- Auto Farm (Crosshair / Zap / Swords)
    ["crosshair"] = "rbxassetid://10723373884",
    ["target"] = "rbxassetid://10723373884",
    ["zap"] = "rbxassetid://10747384394",
    ["swords"] = "rbxassetid://10734952039",
    ["sword"] = "rbxassetid://10734952039",
    ["autofarm"] = "rbxassetid://10723373884",

    -- Boss (Skull / Ghost)
    ["skull"] = "rbxassetid://10734975692",
    ["boss"] = "rbxassetid://10734975692",
    ["ghost"] = "rbxassetid://10734975692",

    -- Random (Dices / Gem / Wand / Gift)
    ["dices"] = "rbxassetid://10723376114",
    ["dice"] = "rbxassetid://10723376114",
    ["random"] = "rbxassetid://10723376114",
    ["gem"] = "rbxassetid://10723374120",
    ["wand"] = "rbxassetid://10734976458",

    -- Item (Backpack / Shopping-bag / Package / Hammer)
    ["backpack"] = "rbxassetid://10734954751",
    ["package"] = "rbxassetid://10734954751",
    ["item"] = "rbxassetid://10734954751",
    ["items"] = "rbxassetid://10734954751",
    ["shopping-bag"] = "rbxassetid://10734975124",
    ["hammer"] = "rbxassetid://10734979384",

    -- Teleport (Compass / Map-pin / Navigation)
    ["compass"] = "rbxassetid://10723415903",
    ["map-pin"] = "rbxassetid://10723415903",
    ["navigation"] = "rbxassetid://10723415903",
    ["teleport"] = "rbxassetid://10723415903",
    ["map"] = "rbxassetid://10723415903",

    -- Dungeon (Moon / Shield-check / Castle)
    ["moon"] = "rbxassetid://10734950309",
    ["dungeon"] = "rbxassetid://10734950309",
    ["shield"] = "rbxassetid://10734974077",
    ["shield-check"] = "rbxassetid://10734974077",

    -- Misc (Sliders / Cpu / Wrench / Settings)
    ["sliders"] = "rbxassetid://10734979384",
    ["misc"] = "rbxassetid://10734979384",
    ["cpu"] = "rbxassetid://10734979384",
    ["wrench"] = "rbxassetid://10734979384",
    ["settings"] = "rbxassetid://10734979384"
}

-- Failsafe SaveManager Engine
local SaveManager = { Folder = "NxHubMain" }

function SaveManager:SetFolder(folder) SaveManager.Folder = folder end
function SaveManager:SaveConfig(name)
    name = name or "default"
    if not isfile or not writefile or not makefolder then return end
    pcall(function()
        if not isfolder(SaveManager.Folder) then makefolder(SaveManager.Folder) end
        local saveTable = {}
        for id, opt in pairs(Options) do saveTable[id] = opt.Value end
        writefile(SaveManager.Folder .. "/" .. name .. ".json", HttpService:JSONEncode(saveTable))
    end)
end

function SaveManager:LoadConfig(name)
    name = name or "default"
    if not isfile or not readfile then return end
    local path = SaveManager.Folder .. "/" .. name .. ".json"
    if not isfile(path) then return end
    pcall(function()
        local raw = readfile(path)
        local data = HttpService:JSONDecode(raw)
        if type(data) == "table" then
            for id, val in pairs(data) do
                if Options[id] and Options[id].SetValue then Options[id]:SetValue(val) end
            end
        end
    end)
end

function SaveManager:LoadAutoloadConfig() SaveManager:LoadConfig("default") end
function SaveManager:SetLibrary() end
function SaveManager:IgnoreThemeSettings() end
function SaveManager:SetIgnoreIndexes() end
function SaveManager:BuildConfigSection() end

local InterfaceManager = {}
function InterfaceManager:SetLibrary() end
function InterfaceManager:SetFolder() end
function InterfaceManager:BuildInterfaceSection() end

getgenv().SaveManager = SaveManager
getgenv().InterfaceManager = InterfaceManager

function NXHub:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local subContent = config.SubContent or ""
    local duration = config.Duration or 5
    
    if not GlobalScreenGui or not GlobalScreenGui.Parent then return end

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 270, 0, subContent ~= "" and 75 or 60)
    NotifFrame.Position = UDim2.new(1, 290, 1, -90)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
    NotifFrame.ZIndex = 200
    NotifFrame.Parent = GlobalScreenGui
    
    local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = NotifFrame
    local Stroke = Instance.new("UIStroke"); Stroke.Color = Color3.fromRGB(0, 240, 255); Stroke.Thickness = 1.5; Stroke.Parent = NotifFrame
    
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -20, 0, 20); TitleLbl.Position = UDim2.new(0, 12, 0, 6); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "🔔 " .. title; TitleLbl.TextColor3 = Color3.fromRGB(0, 240, 255); TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left; TitleLbl.ZIndex = 201; TitleLbl.Parent = NotifFrame
    
    local ContentLbl = Instance.new("TextLabel")
    ContentLbl.Size = UDim2.new(1, -24, 0, 24); ContentLbl.Position = UDim2.new(0, 12, 0, 26); ContentLbl.BackgroundTransparency = 1; ContentLbl.Text = content; ContentLbl.TextColor3 = Color3.fromRGB(220, 225, 240); ContentLbl.Font = Enum.Font.GothamMedium; ContentLbl.TextSize = 11; ContentLbl.TextXAlignment = Enum.TextXAlignment.Left; ContentLbl.ZIndex = 201; ContentLbl.Parent = NotifFrame
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(1, -280, 1, -90) }):Play()
    
    if duration then
        task.delay(duration, function()
            if NotifFrame and NotifFrame.Parent then
                TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(1, 290, 1, -90) }):Play()
                task.wait(0.3)
                NotifFrame:Destroy()
            end
        end)
    end
end

function NXHub:CreateWindow(config)
    local titleText = config.Title or "Nx Hub"
    local subTitleText = config.SubTitle or ""

    local ParentGui = CoreGui
    if gethui then ParentGui = gethui() elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    if ParentGui:FindFirstChild("NXHubFluentMaster") then ParentGui:FindFirstChild("NXHubFluentMaster"):Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NXHubFluentMaster"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ParentGui
    GlobalScreenGui = ScreenGui

    local NORMAL_SIZE = config.Size or UDim2.new(0, 670, 0, 465)
    local MAX_SIZE = UDim2.new(0, 850, 0, 585)
    local isMaximized = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = NORMAL_SIZE
    MainFrame.Position = UDim2.new(0.5, -335, 0.5, -232)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    local WindowBg = Instance.new("Frame")
    WindowBg.Size = UDim2.new(1, 0, 1, 0)
    WindowBg.BackgroundColor3 = Color3.fromRGB(11, 13, 20)
    WindowBg.BorderSizePixel = 0
    WindowBg.ClipsDescendants = true
    WindowBg.Parent = MainFrame

    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 20); MainCorner.Parent = WindowBg
    local OuterStroke = Instance.new("UIStroke"); OuterStroke.Color = Color3.fromRGB(0, 240, 255); OuterStroke.Thickness = 1.5; OuterStroke.Transparency = 0.1; OuterStroke.Parent = WindowBg

    local OuterGradient = Instance.new("UIGradient")
    OuterGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 240, 255)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(160, 30, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 0, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
    })
    OuterGradient.Rotation = 45
    OuterGradient.Parent = OuterStroke

    task.spawn(function()
        while task.wait(0.03) do
            if not ScreenGui or not ScreenGui.Parent then break end
            OuterGradient.Rotation = (OuterGradient.Rotation + 1) % 360
        end
    end)

    -- Logo Loader
    local logoConfig = config.Logo or config.LogoUrl or "https://cdn.jsdelivr.net/gh/NxHup/Nx-Hub@main/f5756ce8-6683-4be4-9845-29f066e64369.jpg"
    local logoAsset = nil

    if typeof(logoConfig) == "string" then
        if string.find(logoConfig, "http://") or string.find(logoConfig, "https://") then
            local filename = "NXHubCustomLogo.png"
            pcall(function()
                if isfile and writefile and game.HttpGet then
                    if not isfile(filename) then
                        local imageData = game:HttpGet(logoConfig)
                        if imageData and #imageData > 500 and not string.find(imageData, "Too Many Requests") then
                            writefile(filename, imageData)
                        end
                    end
                    if isfile(filename) and getcustomasset then
                        logoAsset = getcustomasset(filename)
                    end
                end
            end)
        else
            logoAsset = logoConfig
        end
    end

    -- Floating Button
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "NXFloatingToggle"
    ToggleBtn.Size = UDim2.new(0, 56, 0, 56)
    ToggleBtn.Position = UDim2.new(0, 16, 0.4, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
    if logoAsset then ToggleBtn.Image = logoAsset end
    ToggleBtn.ScaleType = Enum.ScaleType.Fit
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.ZIndex = 999
    ToggleBtn.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner"); ToggleCorner.CornerRadius = UDim.new(0, 16); ToggleCorner.Parent = ToggleBtn
    local ToggleStroke = Instance.new("UIStroke"); ToggleStroke.Color = Color3.fromRGB(0, 240, 255); ToggleStroke.Thickness = 2; ToggleStroke.Parent = ToggleBtn

    if not logoAsset then
        local TextFallback = Instance.new("TextLabel")
        TextFallback.Size = UDim2.new(1, 0, 1, 0); TextFallback.BackgroundTransparency = 1; TextFallback.Text = "⚡ NX"; TextFallback.TextColor3 = Color3.fromRGB(0, 240, 255); TextFallback.Font = Enum.Font.GothamBold; TextFallback.TextSize = 13; TextFallback.ZIndex = 998; TextFallback.Parent = ToggleBtn
    end

    local floatDragging, floatStart, floatPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = true; floatStart = input.Position; floatPos = ToggleBtn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then floatDragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - floatStart
            ToggleBtn.Position = UDim2.new(floatPos.X.Scale, floatPos.X.Offset + delta.X, floatPos.Y.Scale, floatPos.Y.Offset + delta.Y)
        end
    end)

    ToggleBtn.MouseEnter:Connect(function() TweenService:Create(ToggleBtn, TweenInfo.new(0.2), { Size = UDim2.fromOffset(60, 60), BackgroundColor3 = Color3.fromRGB(28, 34, 54) }):Play() end)
    ToggleBtn.MouseLeave:Connect(function() TweenService:Create(ToggleBtn, TweenInfo.new(0.2), { Size = UDim2.fromOffset(56, 56), BackgroundColor3 = Color3.fromRGB(15, 18, 28) }):Play() end)

    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = isMaximized and MAX_SIZE or NORMAL_SIZE }):Play()
        end
    end)

    -- Topbar Header
    local Topbar = Instance.new("Frame"); Topbar.Name = "Topbar"; Topbar.Size = UDim2.new(1, 0, 0, 46); Topbar.BackgroundTransparency = 1; Topbar.Parent = WindowBg

    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(0, 240, 1, 0)
    TitleLbl.Position = UDim2.new(0, 18, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = "<font color=\"#00f0ff\" size=\"17\"><b>" .. titleText .. "</b></font>   <font color=\"#ff00b7\" size=\"11\">" .. subTitleText .. "</font>"
    TitleLbl.RichText = true
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Topbar

    -- Topbar FPS & Ping Pill Badge
    local StatusPill = Instance.new("Frame")
    StatusPill.Name = "StatusPill"
    StatusPill.Size = UDim2.new(0, 160, 0, 26)
    StatusPill.Position = UDim2.new(1, -295, 0.5, -13)
    StatusPill.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
    StatusPill.Parent = Topbar

    local PillCorner = Instance.new("UICorner"); PillCorner.CornerRadius = UDim.new(0, 8); PillCorner.Parent = StatusPill
    local PillStroke = Instance.new("UIStroke"); PillStroke.Color = Color3.fromRGB(0, 240, 255); PillStroke.Thickness = 1; PillStroke.Transparency = 0.5; PillStroke.Parent = StatusPill

    local FpsLbl = Instance.new("TextLabel")
    FpsLbl.Size = UDim2.new(0.5, -2, 1, 0); FpsLbl.Position = UDim2.new(0, 4, 0, 0); FpsLbl.BackgroundTransparency = 1; FpsLbl.Text = "⚡ -- FPS"; FpsLbl.TextColor3 = Color3.fromRGB(0, 240, 255); FpsLbl.Font = Enum.Font.GothamBold; FpsLbl.TextSize = 10; FpsLbl.Parent = StatusPill
    local PingLbl = Instance.new("TextLabel")
    PingLbl.Size = UDim2.new(0.5, -2, 1, 0); PingLbl.Position = UDim2.new(0.5, 0, 0, 0); PingLbl.BackgroundTransparency = 1; PingLbl.Text = "📶 -- ms"; PingLbl.TextColor3 = Color3.fromRGB(0, 255, 150); PingLbl.Font = Enum.Font.GothamBold; PingLbl.TextSize = 10; PingLbl.Parent = StatusPill

    task.spawn(function()
        local lastFrameTime = os.clock()
        local frameCount = 0
        local fps = 60

        local renderConn
        renderConn = RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local now = os.clock()
            if now - lastFrameTime >= 1 then
                fps = math.floor(frameCount / (now - lastFrameTime))
                frameCount = 0
                lastFrameTime = now
            end
        end)

        while task.wait(0.5) do
            if not ScreenGui or not ScreenGui.Parent then
                if renderConn then renderConn:Disconnect() end
                break
            end

            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)

            FpsLbl.Text = "⚡ " .. tostring(fps) .. " FPS"
            PingLbl.Text = "📶 " .. tostring(ping) .. " ms"
        end
    end)

    local ControlsFrame = Instance.new("Frame"); ControlsFrame.Size = UDim2.new(0, 120, 1, -4); ControlsFrame.Position = UDim2.new(1, -125, 0, 2); ControlsFrame.BackgroundTransparency = 1; ControlsFrame.Parent = Topbar
    local ControlsLayout = Instance.new("UIListLayout"); ControlsLayout.FillDirection = Enum.FillDirection.Horizontal; ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; ControlsLayout.Padding = UDim.new(0, 4); ControlsLayout.Parent = ControlsFrame

    local MinBtn = Instance.new("TextButton"); MinBtn.Size = UDim2.new(0, 34, 0, 26); MinBtn.BackgroundTransparency = 1; MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(200, 205, 225); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 15; MinBtn.Parent = ControlsFrame
    local MinCorner = Instance.new("UICorner"); MinCorner.CornerRadius = UDim.new(0, 8); MinCorner.Parent = MinBtn

    local MaxBtn = Instance.new("TextButton"); MaxBtn.Size = UDim2.new(0, 34, 0, 26); MaxBtn.BackgroundTransparency = 1; MaxBtn.Text = "+"; MaxBtn.TextColor3 = Color3.fromRGB(200, 205, 225); MaxBtn.Font = Enum.Font.GothamBold; MaxBtn.TextSize = 15; MaxBtn.Parent = ControlsFrame
    local MaxCorner = Instance.new("UICorner"); MaxCorner.CornerRadius = UDim.new(0, 8); MaxCorner.Parent = MaxBtn

    local CloseBtn = Instance.new("TextButton"); CloseBtn.Size = UDim2.new(0, 34, 0, 26); CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(200, 205, 225); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 13; CloseBtn.Parent = ControlsFrame
    local CloseCorner = Instance.new("UICorner"); CloseCorner.CornerRadius = UDim.new(0, 8); CloseCorner.Parent = CloseBtn

    MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
    MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        TweenService:Create(MainFrame, TweenInfo.new(0.3), { Size = isMaximized and MAX_SIZE or NORMAL_SIZE }):Play()
    end)

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 165, 1, -54)
    Sidebar.Position = UDim2.new(0, 0, 0, 46)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = WindowBg

    local TabListLayout = Instance.new("UIListLayout"); TabListLayout.Padding = UDim.new(0, 5); TabListLayout.Parent = Sidebar
    local SidebarPadding = Instance.new("UIPadding"); SidebarPadding.PaddingTop = UDim.new(0, 8); SidebarPadding.PaddingLeft = UDim.new(0, 10); SidebarPadding.PaddingRight = UDim.new(0, 10); SidebarPadding.PaddingBottom = UDim.new(0, 8); SidebarPadding.Parent = Sidebar

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16)
    end)

    local ContentContainer = Instance.new("Frame"); ContentContainer.Size = UDim2.new(1, -175, 1, -56); ContentContainer.Position = UDim2.new(0, 170, 0, 51); ContentContainer.BackgroundTransparency = 1; ContentContainer.Parent = WindowBg

    local function ShowDialog(dConfig)
        local Overlay = Instance.new("Frame"); Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); Overlay.BackgroundTransparency = 0.5; Overlay.ZIndex = 100; Overlay.Parent = WindowBg
        local DialogBox = Instance.new("Frame"); DialogBox.Size = UDim2.new(0, 330, 0, 165); DialogBox.Position = UDim2.new(0.5, -165, 0.5, -82); DialogBox.BackgroundColor3 = Color3.fromRGB(22, 25, 38); DialogBox.ZIndex = 101; DialogBox.Parent = Overlay
        local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 16); Corner.Parent = DialogBox
        local Stroke = Instance.new("UIStroke"); Stroke.Color = Color3.fromRGB(0, 240, 255); Stroke.Thickness = 1.5; Stroke.Parent = DialogBox
        local DTitle = Instance.new("TextLabel"); DTitle.Size = UDim2.new(1, -20, 0, 30); DTitle.Position = UDim2.new(0, 10, 0, 10); DTitle.BackgroundTransparency = 1; DTitle.Text = dConfig.Title or "Dialog"; DTitle.TextColor3 = Color3.fromRGB(0, 240, 255); DTitle.Font = Enum.Font.GothamBold; DTitle.TextSize = 15; DTitle.ZIndex = 102; DTitle.Parent = DialogBox
        local DContent = Instance.new("TextLabel"); DContent.Size = UDim2.new(1, -24, 0, 48); DContent.Position = UDim2.new(0, 12, 0, 42); DContent.BackgroundTransparency = 1; DContent.Text = dConfig.Content or ""; DContent.TextColor3 = Color3.fromRGB(230, 235, 245); DContent.Font = Enum.Font.GothamMedium; DContent.TextSize = 12; DContent.TextWrapped = true; DContent.ZIndex = 102; DContent.Parent = DialogBox
        local BtnContainer = Instance.new("Frame"); BtnContainer.Size = UDim2.new(1, -24, 0, 36); BtnContainer.Position = UDim2.new(0, 12, 1, -48); BtnContainer.BackgroundTransparency = 1; BtnContainer.ZIndex = 102; BtnContainer.Parent = DialogBox
        local BtnLayout = Instance.new("UIListLayout"); BtnLayout.FillDirection = Enum.FillDirection.Horizontal; BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; BtnLayout.Padding = UDim.new(0, 10); BtnLayout.Parent = BtnContainer

        for _, btnData in ipairs(dConfig.Buttons or {}) do
            local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(0.48, 0, 1, 0); Btn.BackgroundColor3 = Color3.fromRGB(34, 38, 58); Btn.Text = btnData.Title or "Button"; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Btn.ZIndex = 103; Btn.Parent = BtnContainer
            local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(0, 10); BtnCorner.Parent = Btn
            Btn.MouseButton1Click:Connect(function() Overlay:Destroy(); if btnData.Callback then btnData.Callback() end end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(function()
        ShowDialog({
            Title = "⚠️ ยืนยันการปิด NX HUB",
            Content = "คุณแน่ใจหรือไม่ว่าต้องการปิดสคริปต์?",
            Buttons = {
                { Title = "ปิดสคริปต์", Callback = function() TweenService:Create(MainFrame, TweenInfo.new(0.25), { Size = UDim2.new(0, 0, 0, 0) }):Play(); task.wait(0.25); ScreenGui:Destroy() end },
                { Title = "ยกเลิก", Callback = function() end }
            }
        })
    end)

    local minKey = config.MinimizeKey or Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and (input.KeyCode == minKey or input.KeyCode == Enum.KeyCode.LeftControl) then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local WindowObj = {}
    local Tabs = {}

    -- 🟢 AddTab: Universal Icon System (Lucide Icon, URL Image, Roblox Asset ID, Text Emoji)
    function WindowObj:AddTab(tabConfig)
        local name = tabConfig.Title or "Tab"
        local iconInput = tabConfig.Icon
        local iconAsset = "rbxassetid://10723346959" -- Default High-Tech Icon

        if iconInput then
            local rawStr = tostring(iconInput)
            local cleanKey = string.lower(rawStr):gsub("%s+", ""):gsub("%-+", "")
            
            if LucideIcons[cleanKey] then
                iconAsset = LucideIcons[cleanKey]
            elseif LucideIcons[string.lower(rawStr)] then
                iconAsset = LucideIcons[string.lower(rawStr)]
            elseif string.find(rawStr, "http://") or string.find(rawStr, "https://") then
                local iconFileName = "NXTabIcon_" .. string.gsub(rawStr, "%W", "") .. ".png"
                pcall(function()
                    if isfile and writefile and game.HttpGet then
                        if not isfile(iconFileName) then
                            local imgData = game:HttpGet(rawStr)
                            if imgData and #imgData > 200 then writefile(iconFileName, imgData) end
                        end
                        if isfile(iconFileName) and getcustomasset then
                            iconAsset = getcustomasset(iconFileName)
                        end
                    end
                end)
            elseif string.find(rawStr, "rbxassetid://") or tonumber(rawStr) then
                iconAsset = string.find(rawStr, "rbxassetid://") and rawStr or ("rbxassetid://" .. rawStr)
            end
        end

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
        TabBtn.Text = ""
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner"); TabCorner.CornerRadius = UDim.new(0, 12); TabCorner.Parent = TabBtn

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 18)
        Indicator.Position = UDim2.new(0, 2, 0.5, -9)
        Indicator.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        Indicator.Visible = false
        Indicator.Parent = TabBtn

        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.new(0, 16, 0, 16)
        IconImg.Position = UDim2.new(0, 12, 0.5, -8)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = iconAsset
        IconImg.ImageColor3 = Color3.fromRGB(150, 155, 175)
        IconImg.Parent = TabBtn

        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, -39, 1, 0)
        TabText.Position = UDim2.new(0, 34, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = name
        TabText.TextColor3 = Color3.fromRGB(150, 155, 175)
        TabText.Font = Enum.Font.GothamMedium
        TabText.TextSize = 12
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabBtn

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, -5, 1, 0); TabPage.BackgroundTransparency = 1; TabPage.ScrollBarThickness = 3; TabPage.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255); TabPage.Visible = false; TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y; TabPage.CanvasSize = UDim2.new(0, 0, 0, 0); TabPage.Parent = ContentContainer
        
        local PageLayout = Instance.new("UIListLayout"); PageLayout.Padding = UDim.new(0, 10); PageLayout.SortOrder = Enum.SortOrder.LayoutOrder; PageLayout.Parent = TabPage

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Indicator.Visible = false
                t.Btn.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
                t.TabText.TextColor3 = Color3.fromRGB(150, 155, 175)
                if t.IconImg then t.IconImg.ImageColor3 = Color3.fromRGB(150, 155, 175) end
            end
            TabPage.Visible = true
            Indicator.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            if IconImg then IconImg.ImageColor3 = Color3.fromRGB(255, 255, 255) end
        end)

        table.insert(Tabs, { Btn = TabBtn, Page = TabPage, Indicator = Indicator, TabText = TabText, IconImg = IconImg })
        
        if #Tabs == 1 then
            TabPage.Visible = true
            Indicator.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            if IconImg then IconImg.ImageColor3 = Color3.fromRGB(255, 255, 255) end
        end

        local TabObj = {}

        local currentLayoutOrder = 0
        local function getNextOrder()
            currentLayoutOrder = currentLayoutOrder + 1
            return currentLayoutOrder
        end

        function TabObj:AddToggle(id, toggleConfig)
            local title = toggleConfig.Title or id
            local desc = toggleConfig.Description or ""
            local default = toggleConfig.Default or false
            local state = default
            local hasDesc = (desc ~= "")

            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, hasDesc and 56 or 44); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.LayoutOrder = getNextOrder(); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -70, 0, hasDesc and 22 or 44); Label.Position = UDim2.new(0, 16, 0, hasDesc and 8 or 0); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            
            if hasDesc then
                local DescLabel = Instance.new("TextLabel"); DescLabel.Size = UDim2.new(1, -70, 0, 18); DescLabel.Position = UDim2.new(0, 16, 0, 28); DescLabel.BackgroundTransparency = 1; DescLabel.Text = desc; DescLabel.TextColor3 = Color3.fromRGB(140, 150, 175); DescLabel.Font = Enum.Font.GothamMedium; DescLabel.TextSize = 10; DescLabel.TextXAlignment = Enum.TextXAlignment.Left; DescLabel.Parent = Frame
            end

            local SwitchBg = Instance.new("Frame"); SwitchBg.Size = UDim2.new(0, 46, 0, 24); SwitchBg.Position = UDim2.new(1, -58, 0.5, -12); SwitchBg.BackgroundColor3 = state and Color3.fromRGB(0, 220, 140) or Color3.fromRGB(45, 49, 68); SwitchBg.Parent = Frame
            local SwitchCorner = Instance.new("UICorner"); SwitchCorner.CornerRadius = UDim.new(1, 0); SwitchCorner.Parent = SwitchBg
            local Knob = Instance.new("Frame"); Knob.Size = UDim2.new(0, 20, 0, 20); Knob.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10); Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Knob.Parent = SwitchBg
            local KnobCorner = Instance.new("UICorner"); KnobCorner.CornerRadius = UDim.new(1, 0); KnobCorner.Parent = Knob
            local ClickBtn = Instance.new("TextButton"); ClickBtn.Size = UDim2.new(1, 0, 1, 0); ClickBtn.BackgroundTransparency = 1; ClickBtn.Text = ""; ClickBtn.Parent = Frame

            local changedFunc = nil
            local toggleObj = { Value = state }
            
            function toggleObj:OnChanged(func)
                changedFunc = func
                if changedFunc and state ~= nil then
                    task.spawn(function() pcall(function() changedFunc(state) end) end)
                end
            end
            
            function toggleObj:SetValue(val)
                state = (val == true)
                toggleObj.Value = state
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), { BackgroundColor3 = state and Color3.fromRGB(0, 220, 140) or Color3.fromRGB(45, 49, 68) }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), { Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10) }):Play()
                if changedFunc then pcall(function() changedFunc(state) end) end
                SaveManager:SaveConfig("default")
            end

            ClickBtn.MouseButton1Click:Connect(function() toggleObj:SetValue(not state) end)

            Options[id] = toggleObj
            return toggleObj
        end

        -- AddSlider with Circular White Knob
        function TabObj:AddSlider(id, sliderConfig)
            local title = sliderConfig.Title or id
            local desc = sliderConfig.Description or ""
            local min = sliderConfig.Min or 0
            local max = sliderConfig.Max or 100
            local val = sliderConfig.Default or min
            local callback = sliderConfig.Callback
            local hasDesc = (desc ~= "")

            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, hasDesc and 68 or 54); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.LayoutOrder = getNextOrder(); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -70, 0, 22); Label.Position = UDim2.new(0, 16, 0, 4); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            
            if hasDesc then
                local DescLabel = Instance.new("TextLabel"); DescLabel.Size = UDim2.new(1, -70, 0, 18); DescLabel.Position = UDim2.new(0, 16, 0, 24); DescLabel.BackgroundTransparency = 1; DescLabel.Text = desc; DescLabel.TextColor3 = Color3.fromRGB(140, 150, 175); DescLabel.Font = Enum.Font.GothamMedium; DescLabel.TextSize = 10; DescLabel.TextXAlignment = Enum.TextXAlignment.Left; DescLabel.Parent = Frame
            end

            local ValLabel = Instance.new("TextLabel"); ValLabel.Size = UDim2.new(0, 50, 0, 22); ValLabel.Position = UDim2.new(1, -62, 0, 4); ValLabel.BackgroundTransparency = 1; ValLabel.Text = tostring(val); ValLabel.TextColor3 = Color3.fromRGB(0, 240, 255); ValLabel.Font = Enum.Font.GothamBold; ValLabel.TextSize = 13; ValLabel.Parent = Frame
            local Bar = Instance.new("TextButton"); Bar.Size = UDim2.new(1, -32, 0, 8); Bar.Position = UDim2.new(0, 16, 0, hasDesc and 48 or 33); Bar.BackgroundColor3 = Color3.fromRGB(14, 16, 24); Bar.Text = ""; Bar.Parent = Frame
            local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = UDim.new(1, 0); BarCorner.Parent = Bar
            
            local ratio = math.clamp((val - min) / (max - min), 0, 1)
            local Fill = Instance.new("Frame"); Fill.Size = UDim2.new(ratio, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 190, 255); Fill.BorderSizePixel = 0; Fill.Parent = Bar
            local FillCorner = Instance.new("UICorner"); FillCorner.CornerRadius = UDim.new(1, 0); FillCorner.Parent = Fill

            -- ⚪ Circular Slider Knob
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = UDim2.new(ratio, -8, 0.5, -8)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.ZIndex = 5
            Knob.Parent = Bar

            local KnobCorner = Instance.new("UICorner"); KnobCorner.CornerRadius = UDim.new(1, 0); KnobCorner.Parent = Knob
            local KnobStroke = Instance.new("UIStroke"); KnobStroke.Color = Color3.fromRGB(0, 190, 255); KnobStroke.Thickness = 1.5; KnobStroke.Parent = Knob

            local changedFunc = nil
            local sliding = false
            local sliderObj = { Value = val }
            
            function sliderObj:OnChanged(func)
                changedFunc = func
                if changedFunc and val ~= nil then
                    task.spawn(function() pcall(function() changedFunc(val) end) end)
                end
            end
            
            function sliderObj:SetValue(v)
                val = math.clamp(v, min, max)
                sliderObj.Value = val
                local r = math.clamp((val - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(r, 0, 1, 0)
                Knob.Position = UDim2.new(r, -8, 0.5, -8)
                ValLabel.Text = tostring(val)
                if callback then callback(val) end
                if changedFunc then pcall(function() changedFunc(val) end) end
                SaveManager:SaveConfig("default")
            end

            local function move(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                sliderObj:SetValue(math.floor(min + ((max - min) * pos)))
            end

            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; move(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
            UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then move(input) end end)

            Options[id] = sliderObj
            return sliderObj
        end

        function TabObj:AddDropdown(id, dropConfig)
            local title = dropConfig.Title or id
            local desc = dropConfig.Description or ""
            local values = dropConfig.Values or {}
            local isMulti = dropConfig.Multi or false
            local default = dropConfig.Default or 1
            local expanded = false
            local hasDesc = (desc ~= "")

            local baseH = hasDesc and 56 or 44
            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, baseH); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.ClipsDescendants = true; Frame.LayoutOrder = getNextOrder(); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -150, 0, hasDesc and 22 or 44); Label.Position = UDim2.new(0, 16, 0, hasDesc and 8 or 0); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            
            if hasDesc then
                local DescLabel = Instance.new("TextLabel"); DescLabel.Size = UDim2.new(1, -150, 0, 18); DescLabel.Position = UDim2.new(0, 16, 0, 28); DescLabel.BackgroundTransparency = 1; DescLabel.Text = desc; DescLabel.TextColor3 = Color3.fromRGB(140, 150, 175); DescLabel.Font = Enum.Font.GothamMedium; DescLabel.TextSize = 10; DescLabel.TextXAlignment = Enum.TextXAlignment.Left; DescLabel.Parent = Frame
            end

            local selected = values[default] or values[1] or "None"
            local selectedMulti = {}

            if isMulti then
                if typeof(default) == "table" then
                    for k, v in pairs(default) do
                        if typeof(k) == "string" then selectedMulti[k] = v else selectedMulti[v] = true end
                    end
                elseif typeof(default) == "number" and values[default] then
                    selectedMulti[values[default]] = true
                elseif typeof(default) == "string" then
                    selectedMulti[default] = true
                end
            end

            local count = 0
            for k, v in pairs(selectedMulti) do if v then count = count + 1 end end
            local initialBtnText = isMulti and (count .. " Selected ▼") or (tostring(selected) .. " ▼")

            local DropBtn = Instance.new("TextButton"); DropBtn.Size = UDim2.new(0, 130, 0, 28); DropBtn.Position = UDim2.new(1, -142, 0, hasDesc and 14 or 8); DropBtn.BackgroundColor3 = Color3.fromRGB(32, 37, 56); DropBtn.Text = initialBtnText; DropBtn.TextColor3 = Color3.fromRGB(0, 240, 255); DropBtn.Font = Enum.Font.GothamBold; DropBtn.TextSize = 11; DropBtn.Parent = Frame
            local DropCorner = Instance.new("UICorner"); DropCorner.CornerRadius = UDim.new(0, 10); DropCorner.Parent = DropBtn

            local OptionContainer = Instance.new("Frame"); OptionContainer.Size = UDim2.new(1, -32, 0, #values * 28); OptionContainer.Position = UDim2.new(0, 16, 0, baseH + 4); OptionContainer.BackgroundTransparency = 1; OptionContainer.Parent = Frame
            local OptionLayout = Instance.new("UIListLayout"); OptionLayout.Padding = UDim.new(0, 4); OptionLayout.Parent = OptionContainer

            local optionButtons = {}
            local changedFunc = nil
            local dropObj = { Value = isMulti and selectedMulti or selected, Values = values }
            
            function dropObj:OnChanged(func)
                changedFunc = func
                if changedFunc then
                    task.spawn(function() pcall(function() changedFunc(dropObj.Value) end) end)
                end
            end
            
            function dropObj:SetValue(val)
                if isMulti and typeof(val) == "table" then
                    selectedMulti = val
                    dropObj.Value = val
                    local cnt = 0
                    for k, v in pairs(selectedMulti) do if v then cnt = cnt + 1 end end
                    DropBtn.Text = cnt .. " Selected ▼"

                    for opt, optBtn in pairs(optionButtons) do
                        local isSel = (selectedMulti[opt] == true)
                        optBtn.BackgroundColor3 = isSel and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(28, 32, 48)
                        optBtn.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 205, 220)
                    end
                else
                    selected = val
                    dropObj.Value = val
                    DropBtn.Text = tostring(selected) .. " ▼"
                    
                    for opt, optBtn in pairs(optionButtons) do
                        local isSel = (opt == selected)
                        optBtn.BackgroundColor3 = isSel and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(28, 32, 48)
                        optBtn.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 205, 220)
                    end

                    expanded = false
                    TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, baseH) }):Play()
                end
                if changedFunc then pcall(function() changedFunc(dropObj.Value) end) end
                SaveManager:SaveConfig("default")
            end

            for _, opt in ipairs(values) do
                local OptBtn = Instance.new("TextButton"); OptBtn.Size = UDim2.new(1, 0, 0, 24); OptBtn.BackgroundColor3 = (isMulti and selectedMulti[opt]) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(28, 32, 48); OptBtn.Text = tostring(opt); OptBtn.TextColor3 = Color3.fromRGB(200, 205, 220); OptBtn.Font = Enum.Font.GothamMedium; OptBtn.TextSize = 11; OptBtn.Parent = OptionContainer
                local OptCorner = Instance.new("UICorner"); OptCorner.CornerRadius = UDim.new(0, 8); OptCorner.Parent = OptBtn
                
                optionButtons[opt] = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    if isMulti then
                        selectedMulti[opt] = not selectedMulti[opt]
                        OptBtn.BackgroundColor3 = selectedMulti[opt] and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(28, 32, 48)
                        OptBtn.TextColor3 = selectedMulti[opt] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 205, 220)
                        local cnt = 0
                        for k, v in pairs(selectedMulti) do if v then cnt = cnt + 1 end end
                        DropBtn.Text = cnt .. " Selected ▼"
                        dropObj.Value = selectedMulti
                        if changedFunc then pcall(function() changedFunc(selectedMulti) end) end
                        SaveManager:SaveConfig("default")
                    else
                        dropObj:SetValue(opt)
                    end
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, expanded and (baseH + 8 + #values * 28) or baseH) }):Play()
            end)

            Options[id] = dropObj
            return dropObj
        end

        function TabObj:AddParagraph(pConfig)
            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 60); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.LayoutOrder = getNextOrder(); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local PTitle = Instance.new("TextLabel"); PTitle.Size = UDim2.new(1, -20, 0, 22); PTitle.Position = UDim2.new(0, 14, 0, 6); PTitle.BackgroundTransparency = 1; PTitle.Text = pConfig.Title or ""; PTitle.TextColor3 = Color3.fromRGB(0, 240, 255); PTitle.Font = Enum.Font.GothamBold; PTitle.TextSize = 13; PTitle.TextXAlignment = Enum.TextXAlignment.Left; PTitle.Parent = Frame
            local PContent = Instance.new("TextLabel"); PContent.Size = UDim2.new(1, -28, 0, 28); PContent.Position = UDim2.new(0, 14, 0, 28); PContent.BackgroundTransparency = 1; PContent.Text = pConfig.Content or ""; PContent.TextColor3 = Color3.fromRGB(200, 205, 220); PContent.Font = Enum.Font.GothamMedium; PContent.TextSize = 11; PContent.TextWrapped = true; PContent.TextXAlignment = Enum.TextXAlignment.Left; PContent.Parent = Frame
        end

        -- AddButton (Action Button)
        function TabObj:AddButton(btnConfig)
            local title = btnConfig.Title or "Button"
            local desc = btnConfig.Description or ""
            local hasDesc = (desc ~= "")

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, hasDesc and 56 or 44)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.LayoutOrder = getNextOrder()
            Btn.Parent = TabPage

            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Btn
            local Stroke = Instance.new("UIStroke"); Stroke.Color = Color3.fromRGB(0, 240, 255); Stroke.Thickness = 1; Stroke.Transparency = 0.7; Stroke.Parent = Btn

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -110, 0, hasDesc and 22 or 44)
            TitleLabel.Position = UDim2.new(0, 16, 0, hasDesc and 8 or 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 12
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = Btn

            if hasDesc then
                local DescLabel = Instance.new("TextLabel")
                DescLabel.Size = UDim2.new(1, -110, 0, 18)
                DescLabel.Position = UDim2.new(0, 16, 0, 28)
                DescLabel.BackgroundTransparency = 1
                DescLabel.Text = desc
                DescLabel.TextColor3 = Color3.fromRGB(140, 150, 175)
                DescLabel.Font = Enum.Font.GothamMedium
                DescLabel.TextSize = 10
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.Parent = Btn
            end

            local ActionBadge = Instance.new("Frame")
            ActionBadge.Size = UDim2.new(0, 80, 0, 26)
            ActionBadge.Position = UDim2.new(1, -94, 0.5, -13)
            ActionBadge.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
            ActionBadge.Parent = Btn

            local BadgeCorner = Instance.new("UICorner"); BadgeCorner.CornerRadius = UDim.new(0, 8); BadgeCorner.Parent = ActionBadge

            local BadgeText = Instance.new("TextLabel")
            BadgeText.Size = UDim2.new(1, 0, 1, 0)
            BadgeText.BackgroundTransparency = 1
            BadgeText.Text = "▶ Click"
            BadgeText.TextColor3 = Color3.fromRGB(10, 14, 24)
            BadgeText.Font = Enum.Font.GothamBold
            BadgeText.TextSize = 11
            BadgeText.Parent = ActionBadge

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 36, 56) }):Play()
                TweenService:Create(Stroke, TweenInfo.new(0.2), { Transparency = 0.2 }):Play()
                TweenService:Create(ActionBadge, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0, 230, 255) }):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(22, 26, 40) }):Play()
                TweenService:Create(Stroke, TweenInfo.new(0.2), { Transparency = 0.7 }):Play()
                TweenService:Create(ActionBadge, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0, 190, 255) }):Play()
            end)

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(ActionBadge, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
                task.wait(0.1)
                TweenService:Create(ActionBadge, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0, 190, 255) }):Play()
                if btnConfig.Callback then btnConfig.Callback() end
            end)
        end

        -- AddInput
        function TabObj:AddInput(id, inputConfig)
            local title = inputConfig.Title or id
            local desc = inputConfig.Description or ""
            local val = inputConfig.Default or ""
            local hasDesc = (desc ~= "")

            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, hasDesc and 56 or 44); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.LayoutOrder = getNextOrder(); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -160, 0, hasDesc and 22 or 44); Label.Position = UDim2.new(0, 16, 0, hasDesc and 8 or 0); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            
            if hasDesc me
                local DescLabel = Instance.new("TextLabel"); DescLabel.Size = UDim2.new(1, -160, 0, 18); DescLabel.Position = UDim2.new(0, 16, 0, 28); DescLabel.BackgroundTransparency = 1; DescLabel.Text = desc; DescLabel.TextColor3 = Color3.fromRGB(140, 150, 175); DescLabel.Font = Enum.Font.GothamMedium; DescLabel.TextSize = 10; DescLabel.TextXAlignment = Enum.TextXAlignment.Left; DescLabel.Parent = Frame
            end

            local TextBox = Instance.new("TextBox"); TextBox.Size = UDim2.new(0, 140, 0, 28); TextBox.Position = UDim2.new(1, -152, 0.5, -14); TextBox.BackgroundColor3 = Color3.fromRGB(14, 16, 26); TextBox.Text = val; TextBox.TextColor3 = Color3.fromRGB(0, 240, 255); TextBox.Font = Enum.Font.GothamMedium; TextBox.TextSize = 11; TextBox.Parent = Frame
            local BoxCorner = Instance.new("UICorner"); BoxCorner.CornerRadius = UDim.new(0, 10); BoxCorner.Parent = TextBox

            local changedFunc = nil
            local inputObj = { Value = val }
            
            function inputObj:OnChanged(func)
                changedFunc = func
                if changedFunc and val ~= nil then
                    task.spawn(function() pcall(function() changedFunc(val) end) end)
                end
            end

            function inputObj:SetValue(v)
                v = tostring(v or "")
                inputObj.Value = v
                TextBox.Text = v
                if changedFunc then pcall(function() changedFunc(v) end) end
                SaveManager:SaveConfig("default")
            end

            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                if inputConfig.Numeric then TextBox.Text = TextBox.Text:gsub("%D+", "") end
                inputObj.Value = TextBox.Text
                if changedFunc then pcall(function() changedFunc(TextBox.Text) end) end
                SaveManager:SaveConfig("default")
            end)

            Options[id] = inputObj
            return inputObj
        end

        return TabObj
    end

    function WindowObj:SelectTab(idx) end
    function WindowObj:Minimize() MainFrame.Visible = not MainFrame.Visible end
    function WindowObj:Dialog(dConfig) ShowDialog(dConfig) end

    return WindowObj
end

return NXHub, SaveManager, InterfaceManager
