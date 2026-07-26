-- =================================================================
-- NX HUB UI LIBRARY (Scrolling Sidebar & Complete 8-Tab Fix)
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

-- Real SaveManager Engine
local SaveManager = {
    Folder = "NxHubMain"
}

function SaveManager:SetFolder(folder)
    SaveManager.Folder = folder
end

function SaveManager:SaveConfig(name)
    name = name or "default"
    if not isfile or not writefile or not makefolder then return end
    pcall(function()
        if not isfolder(SaveManager.Folder) then makefolder(SaveManager.Folder) end
        local saveTable = {}
        for id, opt in pairs(Options) do
            saveTable[id] = opt.Value
        end
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
                if Options[id] and Options[id].SetValue then
                    Options[id]:SetValue(val)
                end
            end
        end
    end)
end

function SaveManager:LoadAutoloadConfig()
    SaveManager:LoadConfig("default")
end

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

    local TitleLbl = Instance.new("TextLabel"); TitleLbl.Size = UDim2.new(0, 280, 1, 0); TitleLbl.Position = UDim2.new(0, 18, 0, 0); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "<font color=\"#00f0ff\"><b>" .. titleText .. "</b></font>  <font color=\"#ff00b7\">" .. subTitleText .. "</font>"; TitleLbl.RichText = true; TitleLbl.TextSize = 16; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left; TitleLbl.Parent = Topbar

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

    -- 🟢 Sidebar เลื่อนลงได้แบบ ScrollingFrame
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 165, 1, -112)
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

    -- 🟢 StatusWidget (ขนาด Compact 54px พอดีคำ ไม่บังแท็บ)
    local StatusWidget = Instance.new("Frame")
    StatusWidget.Name = "StatusWidget"
    StatusWidget.Size = UDim2.new(0, 145, 0, 54)
    StatusWidget.Position = UDim2.new(0, 10, 1, -60)
    StatusWidget.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
    StatusWidget.Parent = WindowBg

    local WidgetCorner = Instance.new("UICorner"); WidgetCorner.CornerRadius = UDim.new(0, 10); WidgetCorner.Parent = StatusWidget
    local WidgetStroke = Instance.new("UIStroke"); WidgetStroke.Color = Color3.fromRGB(0, 240, 255); WidgetStroke.Thickness = 1;
