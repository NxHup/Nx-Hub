-- =================================================================
-- NX HUB UI LIBRARY (Built-in Custom Image Floating Button - Clean)
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

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = WindowBg

    local OuterStroke = Instance.new("UIStroke")
    OuterStroke.Color = Color3.fromRGB(0, 240, 255)
    OuterStroke.Thickness = 1.5
    OuterStroke.Transparency = 0.1
    OuterStroke.Parent = WindowBg

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

    -- =========================================================
    --  ระบบดาวน์โหลดและจัดการรูปภาพโลโก้ (Custom Logo Loader)
    -- =========================================================
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

    -- =========================================================
    --  ปุ่มลอยแสดงรูปโลโก้แบบสะอาดตา (Clean Image Floating Button)
    -- =========================================================
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

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 16)
    ToggleCorner.Parent = ToggleBtn

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(0, 240, 255)
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = ToggleBtn

    -- แสดงตัวอักษรเฉพาะเวลาไม่มีรูปเท่านั้น
    if not logoAsset then
        local TextFallback = Instance.new("TextLabel")
        TextFallback.Size = UDim2.new(1, 0, 1, 0)
        TextFallback.BackgroundTransparency = 1
        TextFallback.Text = "⚡ NX"
        TextFallback.TextColor3 = Color3.fromRGB(0, 240, 255)
        TextFallback.Font = Enum.Font.GothamBold
        TextFallback.TextSize = 13
        TextFallback.ZIndex = 998
        TextFallback.Parent = ToggleBtn
    end

    -- ระบบลากปุ่มลอย (Draggable Floating Button)
    local floatDragging, floatStart, floatPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = true
            floatStart = input.Position
            floatPos = ToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then floatDragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - floatStart
            ToggleBtn.Position = UDim2.new(floatPos.X.Scale, floatPos.X.Offset + delta.X, floatPos.Y.Scale, floatPos.Y.Offset + delta.Y)
        end
    end)

    ToggleBtn.MouseEnter:Connect(function()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), { Size = UDim2.fromOffset(60, 60), BackgroundColor3 = Color3.fromRGB(28, 34, 54) }):Play()
    end)
    ToggleBtn.MouseLeave:Connect(function()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), { Size = UDim2.fromOffset(56, 56), BackgroundColor3 = Color3.fromRGB(15, 18, 28) }):Play()
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = isMaximized and MAX_SIZE or NORMAL_SIZE
            }):Play()
        end
    end)

    -- Topbar Header
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 46)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = WindowBg

    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(0, 280, 1, 0)
    TitleLbl.Position = UDim2.new(0, 18, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = "<font color=\"#00f0ff\"><b>" .. titleText .. "</b></font>  <font color=\"#ff00b7\">" .. subTitleText .. "</font>"
    TitleLbl.RichText = true
    TitleLbl.TextSize = 16
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Topbar

    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Size = UDim2.new(0, 120, 1, -4)
    ControlsFrame.Position = UDim2.new(1, -125, 0, 2)
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Parent = Topbar

    local ControlsLayout = Instance.new("UIListLayout")
    ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlsLayout.Padding = UDim.new(0, 4)
    ControlsLayout.Parent = ControlsFrame

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 34, 0, 26)
    MinBtn.BackgroundTransparency = 1; MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(200, 205, 225); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 15; MinBtn.Parent = ControlsFrame
    local MinCorner = Instance.new("UICorner"); MinCorner.CornerRadius = UDim.new(0, 8); MinCorner.Parent = MinBtn

    local MaxBtn = Instance.new("TextButton")
    MaxBtn.Size = UDim2.new(0, 34, 0, 26)
    MaxBtn.BackgroundTransparency = 1; MaxBtn.Text = "+"; MaxBtn.TextColor3 = Color3.fromRGB(200, 205, 225); MaxBtn.Font = Enum.Font.GothamBold; MaxBtn.TextSize = 15; MaxBtn.Parent = ControlsFrame
    local MaxCorner = Instance.new("UICorner"); MaxCorner.CornerRadius = UDim.new(0, 8); MaxCorner.Parent = MaxBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 34, 0, 26)
    CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(200, 205, 225); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 13; CloseBtn.Parent = ControlsFrame
    local CloseCorner = Instance.new("UICorner"); CloseCorner.CornerRadius = UDim.new(0, 8); CloseCorner.Parent = CloseBtn

    MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
    MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        TweenService:Create(MainFrame, TweenInfo.new(0.3), { Size = isMaximized and MAX_SIZE or NORMAL_SIZE }):Play()
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 165, 1, -46); Sidebar.Position = UDim2.new(0, 0, 0, 46); Sidebar.BackgroundTransparency = 1; Sidebar.Parent = WindowBg
    local TabListLayout = Instance.new("UIListLayout"); TabListLayout.Padding = UDim.new(0, 6); TabListLayout.Parent = Sidebar
    local SidebarPadding = Instance.new("UIPadding"); SidebarPadding.PaddingTop = UDim.new(0, 12); SidebarPadding.PaddingLeft = UDim.new(0, 10); SidebarPadding.PaddingRight = UDim.new(0, 10); SidebarPadding.Parent = Sidebar

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -175, 1, -56); ContentContainer.Position = UDim2.new(0, 170, 0, 51); ContentContainer.BackgroundTransparency = 1; ContentContainer.Parent = WindowBg

    local function ShowDialog(dConfig)
        local Overlay = Instance.new("Frame")
        Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); Overlay.BackgroundTransparency = 0.5; Overlay.ZIndex = 100; Overlay.Parent = WindowBg
        local DialogBox = Instance.new("Frame")
        DialogBox.Size = UDim2.new(0, 330, 0, 165); DialogBox.Position = UDim2.new(0.5, -165, 0.5, -82); DialogBox.BackgroundColor3 = Color3.fromRGB(22, 25, 38); DialogBox.ZIndex = 101; DialogBox.Parent = Overlay
        local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 16); Corner.Parent = DialogBox
        local Stroke = Instance.new("UIStroke"); Stroke.Color = Color3.fromRGB(0, 240, 255); Stroke.Thickness = 1.5; Stroke.Parent = DialogBox
        local DTitle = Instance.new("TextLabel"); DTitle.Size = UDim2.new(1, -20, 0, 30); DTitle.Position = UDim2.new(0, 10, 0, 10); DTitle.BackgroundTransparency = 1; DTitle.Text = dConfig.Title or "Dialog"; DTitle.TextColor3 = Color3.fromRGB(0, 240, 255); DTitle.Font = Enum.Font.GothamBold; DTitle.TextSize = 15; DTitle.ZIndex = 102; DTitle.Parent = DialogBox
        local DContent = Instance.new("TextLabel"); DContent.Size = UDim2.new(1, -24, 0, 48); DContent.Position = UDim2.new(0, 12, 0, 42); DContent.BackgroundTransparency = 1; DContent.Text = dConfig.Content or ""; DContent.TextColor3 = Color3.fromRGB(230, 235, 245); DContent.Font = Enum.Font.GothamMedium; DContent.TextSize = 12; DContent.TextWrapped = true; DContent.ZIndex = 102; DContent.Parent = DialogBox
        local BtnContainer = Instance.new("Frame"); BtnContainer.Size = UDim2.new(1, -24, 0, 36); BtnContainer.Position = UDim2.new(0, 12, 1, -48); BtnContainer.BackgroundTransparency = 1; BtnContainer.ZIndex = 102; BtnContainer.Parent = DialogBox
        local BtnLayout = Instance.new("UIListLayout"); BtnLayout.FillDirection = Enum.FillDirection.Horizontal; BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; BtnLayout.Padding = UDim.new(0, 10); BtnLayout.Parent = BtnContainer

        for _, btnData in ipairs(dConfig.Buttons or {}) do
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0.48, 0, 1, 0); Btn.BackgroundColor3 = Color3.fromRGB(34, 38, 58); Btn.Text = btnData.Title or "Button"; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Btn.ZIndex = 103; Btn.Parent = BtnContainer
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

    function WindowObj:AddTab(tabConfig)
        local name = tabConfig.Title or "Tab"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 38); TabBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 34); TabBtn.Text = name; TabBtn.TextColor3 = Color3.fromRGB(150, 155, 175); TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left; TabBtn.Parent = Sidebar
        local TabPadding = Instance.new("UIPadding"); TabPadding.PaddingLeft = UDim.new(0, 14); TabPadding.Parent = TabBtn
        local TabCorner = Instance.new("UICorner"); TabCorner.CornerRadius = UDim.new(0, 12); TabCorner.Parent = TabBtn

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 20); Indicator.Position = UDim2.new(0, -10, 0.5, -10); Indicator.BackgroundColor3 = Color3.fromRGB(0, 240, 255); Indicator.Visible = false; Indicator.Parent = TabBtn

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, -5, 1, 0); TabPage.BackgroundTransparency = 1; TabPage.ScrollBarThickness = 3; TabPage.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255); TabPage.Visible = false; TabPage.Parent = ContentContainer
        local PageLayout = Instance.new("UIListLayout"); PageLayout.Padding = UDim.new(0, 10); PageLayout.Parent = TabPage

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.Page.Visible = false; t.Indicator.Visible = false; t.Btn.BackgroundColor3 = Color3.fromRGB(20, 22, 34); t.Btn.TextColor3 = Color3.fromRGB(150, 155, 175) end
            TabPage.Visible = true; Indicator.Visible = true; TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240); TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(Tabs, { Btn = TabBtn, Page = TabPage, Indicator = Indicator })
        if #Tabs == 1 then TabPage.Visible = true; Indicator.Visible = true; TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240); TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end

        local TabObj = {}

        function TabObj:AddToggle(id, toggleConfig)
            local title = toggleConfig.Title or id
            local default = toggleConfig.Default or false
            local state = default

            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 44); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -70, 1, 0); Label.Position = UDim2.new(0, 16, 0, 0); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            local SwitchBg = Instance.new("Frame"); SwitchBg.Size = UDim2.new(0, 46, 0, 24); SwitchBg.Position = UDim2.new(1, -58, 0.5, -12); SwitchBg.BackgroundColor3 = state and Color3.fromRGB(0, 220, 140) or Color3.fromRGB(45, 49, 68); SwitchBg.Parent = Frame
            local SwitchCorner = Instance.new("UICorner"); SwitchCorner.CornerRadius = UDim.new(1, 0); SwitchCorner.Parent = SwitchBg
            local Knob = Instance.new("Frame"); Knob.Size = UDim2.new(0, 20, 0, 20); Knob.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10); Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Knob.Parent = SwitchBg
            local KnobCorner = Instance.new("UICorner"); KnobCorner.CornerRadius = UDim.new(1, 0); KnobCorner.Parent = Knob
            local ClickBtn = Instance.new("TextButton"); ClickBtn.Size = UDim2.new(1, 0, 1, 0); ClickBtn.BackgroundTransparency = 1; ClickBtn.Text = ""; ClickBtn.Parent = Frame

            local changedFunc = nil
            local toggleObj = { Value = state }
            function toggleObj:OnChanged(func)
                changedFunc = func
            end
            function toggleObj:SetValue(val)
                state = val
                toggleObj.Value = val
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), { BackgroundColor3 = state and Color3.fromRGB(0, 220, 140) or Color3.fromRGB(45, 49, 68) }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), { Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10) }):Play()
                if changedFunc then changedFunc(state) end
            end

            ClickBtn.MouseButton1Click:Connect(function()
                toggleObj:SetValue(not state)
            end)

            Options[id] = toggleObj
            return toggleObj
        end

        function TabObj:AddSlider(id, sliderConfig)
            local title = sliderConfig.Title or id
            local min = sliderConfig.Min or 0
            local max = sliderConfig.Max or 100
            local val = sliderConfig.Default or min
            local callback = sliderConfig.Callback

            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 54); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -70, 0, 22); Label.Position = UDim2.new(0, 16, 0, 4); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            local ValLabel = Instance.new("TextLabel"); ValLabel.Size = UDim2.new(0, 50, 0, 22); ValLabel.Position = UDim2.new(1, -62, 0, 4); ValLabel.BackgroundTransparency = 1; ValLabel.Text = tostring(val); ValLabel.TextColor3 = Color3.fromRGB(0, 240, 255); ValLabel.Font = Enum.Font.GothamBold; ValLabel.TextSize = 13; ValLabel.Parent = Frame
            local Bar = Instance.new("TextButton"); Bar.Size = UDim2.new(1, -32, 0, 8); Bar.Position = UDim2.new(0, 16, 0, 33); Bar.BackgroundColor3 = Color3.fromRGB(14, 16, 24); Bar.Text = ""; Bar.Parent = Frame
            local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = UDim.new(1, 0); BarCorner.Parent = Bar
            local Fill = Instance.new("Frame"); Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 240, 255); Fill.BorderSizePixel = 0; Fill.Parent = Bar
            local FillCorner = Instance.new("UICorner"); FillCorner.CornerRadius = UDim.new(1, 0); FillCorner.Parent = Fill

            local changedFunc = nil
            local sliding = false
            local sliderObj = { Value = val }
            function sliderObj:OnChanged(func) changedFunc = func end
            function sliderObj:SetValue(v)
                val = math.clamp(v, min, max)
                sliderObj.Value = val
                Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                ValLabel.Text = tostring(val)
                if callback then callback(val) end
                if changedFunc then changedFunc(val) end
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
            local values = dropConfig.Values or {}
            local isMulti = dropConfig.Multi or false
            local default = dropConfig.Default or 1
            local selected = values[default] or values[1] or "None"
            local expanded = false

            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 44); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.ClipsDescendants = true; Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -150, 0, 44); Label.Position = UDim2.new(0, 16, 0, 0); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            local DropBtn = Instance.new("TextButton"); DropBtn.Size = UDim2.new(0, 130, 0, 28); DropBtn.Position = UDim2.new(1, -142, 0, 8); DropBtn.BackgroundColor3 = Color3.fromRGB(32, 37, 56); DropBtn.Text = tostring(selected) .. " ▼"; DropBtn.TextColor3 = Color3.fromRGB(0, 240, 255); DropBtn.Font = Enum.Font.GothamBold; DropBtn.TextSize = 11; DropBtn.Parent = Frame
            local DropCorner = Instance.new("UICorner"); DropCorner.CornerRadius = UDim.new(0, 10); DropCorner.Parent = DropBtn

            local OptionContainer = Instance.new("Frame"); OptionContainer.Size = UDim2.new(1, -32, 0, #values * 28); OptionContainer.Position = UDim2.new(0, 16, 0, 48); OptionContainer.BackgroundTransparency = 1; OptionContainer.Parent = Frame
            local OptionLayout = Instance.new("UIListLayout"); OptionLayout.Padding = UDim.new(0, 4); OptionLayout.Parent = OptionContainer

            local changedFunc = nil
            local dropObj = { Value = selected, Values = values }
            function dropObj:OnChanged(func) changedFunc = func end
            function dropObj:SetValue(val)
                selected = val
                dropObj.Value = val
                DropBtn.Text = tostring(selected) .. " ▼"
                expanded = false
                TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 44) }):Play()
                if changedFunc then changedFunc(selected) end
            end

            for _, opt in ipairs(values) do
                local OptBtn = Instance.new("TextButton"); OptBtn.Size = UDim2.new(1, 0, 0, 24); OptBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 48); OptBtn.Text = tostring(opt); OptBtn.TextColor3 = Color3.fromRGB(200, 205, 220); OptBtn.Font = Enum.Font.GothamMedium; OptBtn.TextSize = 11; OptBtn.Parent = OptionContainer
                local OptCorner = Instance.new("UICorner"); OptCorner.CornerRadius = UDim.new(0, 8); OptCorner.Parent = OptBtn
                OptBtn.MouseButton1Click:Connect(function() dropObj:SetValue(opt) end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, expanded and (48 + #values * 28 + 10) or 44) }):Play()
            end)

            Options[id] = dropObj
            return dropObj
        end

        function TabObj:AddParagraph(pConfig)
            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 60); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local PTitle = Instance.new("TextLabel"); PTitle.Size = UDim2.new(1, -20, 0, 22); PTitle.Position = UDim2.new(0, 14, 0, 6); PTitle.BackgroundTransparency = 1; PTitle.Text = pConfig.Title or ""; PTitle.TextColor3 = Color3.fromRGB(0, 240, 255); PTitle.Font = Enum.Font.GothamBold; PTitle.TextSize = 13; PTitle.TextXAlignment = Enum.TextXAlignment.Left; PTitle.Parent = Frame
            local PContent = Instance.new("TextLabel"); PContent.Size = UDim2.new(1, -28, 0, 28); PContent.Position = UDim2.new(0, 14, 0, 28); PContent.BackgroundTransparency = 1; PContent.Text = pConfig.Content or ""; PContent.TextColor3 = Color3.fromRGB(200, 205, 220); PContent.Font = Enum.Font.GothamMedium; PContent.TextSize = 11; PContent.TextWrapped = true; PContent.TextXAlignment = Enum.TextXAlignment.Left; PContent.Parent = Frame
        end

        function TabObj:AddButton(btnConfig)
            local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(1, 0, 0, 42); Btn.BackgroundColor3 = Color3.fromRGB(24, 28, 44); Btn.Text = btnConfig.Title or "Button"; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Btn.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Btn
            Btn.MouseButton1Click:Connect(function() if btnConfig.Callback then btnConfig.Callback() end end)
        end

        function TabObj:AddInput(id, inputConfig)
            local title = inputConfig.Title or id
            local val = inputConfig.Default or ""

            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 44); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -160, 1, 0); Label.Position = UDim2.new(0, 16, 0, 0); Label.BackgroundTransparency = 1; Label.Text = title; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            local TextBox = Instance.new("TextBox"); TextBox.Size = UDim2.new(0, 140, 0, 28); TextBox.Position = UDim2.new(1, -152, 0.5, -14); TextBox.BackgroundColor3 = Color3.fromRGB(14, 16, 26); TextBox.Text = val; TextBox.TextColor3 = Color3.fromRGB(0, 240, 255); TextBox.Font = Enum.Font.GothamMedium; TextBox.TextSize = 11; TextBox.Parent = Frame
            local BoxCorner = Instance.new("UICorner"); BoxCorner.CornerRadius = UDim.new(0, 10); BoxCorner.Parent = TextBox

            local changedFunc = nil
            local inputObj = { Value = val }
            function inputObj:OnChanged(func) changedFunc = func end

            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                if inputConfig.Numeric then TextBox.Text = TextBox.Text:gsub("%D+", "") end
                inputObj.Value = TextBox.Text
                if changedFunc then changedFunc(TextBox.Text) end
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

-- Dummy objects for compatibility
local SaveManager = {}
function SaveManager:SetLibrary() end
function SaveManager:IgnoreThemeSettings() end
function SaveManager:SetIgnoreIndexes() end
function SaveManager:SetFolder() end
function SaveManager:BuildConfigSection() end
function SaveManager:LoadAutoloadConfig() end

local InterfaceManager = {}
function InterfaceManager:SetLibrary() end
function InterfaceManager:SetFolder() end
function InterfaceManager:BuildInterfaceSection() end

getgenv().SaveManager = SaveManager
getgenv().InterfaceManager = InterfaceManager

return NXHub, SaveManager, InterfaceManager
