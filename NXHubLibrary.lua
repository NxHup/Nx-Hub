-- =================================================================
-- NX HUB UI LIBRARY (สำหรับอัปโหลดขึ้น GitHub)
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

function NXHub:CreateWindow(hubTitle)
    local ParentGui = CoreGui
    if gethui then ParentGui = gethui() elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    if ParentGui:FindFirstChild("NXHubLibraryMaster") then ParentGui:FindFirstChild("NXHubLibraryMaster"):Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NXHubLibraryMaster"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ParentGui

    local NORMAL_SIZE = UDim2.new(0, 670, 0, 465)
    local MAX_SIZE = UDim2.new(0, 850, 0, 585)
    local isMaximized = false
    local ConfigData = {}
    local Options = {}

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

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 46)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = WindowBg

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 250, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "<font color=\"#00f0ff\"><b>NX</b></font> <font color=\"#ffffff\"><b>HUB</b></font>  <font color=\"#ff00b7\">" .. (hubTitle or "V14") .. "</font>"
    Title.RichText = true
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

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

    local function ShowDialog(config)
        local Overlay = Instance.new("Frame")
        Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); Overlay.BackgroundTransparency = 0.5; Overlay.ZIndex = 100; Overlay.Parent = WindowBg
        local DialogBox = Instance.new("Frame")
        DialogBox.Size = UDim2.new(0, 330, 0, 165); DialogBox.Position = UDim2.new(0.5, -165, 0.5, -82); DialogBox.BackgroundColor3 = Color3.fromRGB(22, 25, 38); DialogBox.ZIndex = 101; DialogBox.Parent = Overlay
        local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 16); Corner.Parent = DialogBox
        local Stroke = Instance.new("UIStroke"); Stroke.Color = Color3.fromRGB(0, 240, 255); Stroke.Thickness = 1.5; Stroke.Parent = DialogBox
        local TitleLbl = Instance.new("TextLabel"); TitleLbl.Size = UDim2.new(1, -20, 0, 30); TitleLbl.Position = UDim2.new(0, 10, 0, 10); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = config.Title or "Dialog"; TitleLbl.TextColor3 = Color3.fromRGB(0, 240, 255); TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 15; TitleLbl.ZIndex = 102; TitleLbl.Parent = DialogBox
        local ContentLbl = Instance.new("TextLabel"); ContentLbl.Size = UDim2.new(1, -24, 0, 48); ContentLbl.Position = UDim2.new(0, 12, 0, 42); ContentLbl.BackgroundTransparency = 1; ContentLbl.Text = config.Content or ""; ContentLbl.TextColor3 = Color3.fromRGB(230, 235, 245); ContentLbl.Font = Enum.Font.GothamMedium; ContentLbl.TextSize = 12; ContentLbl.TextWrapped = true; ContentLbl.ZIndex = 102; ContentLbl.Parent = DialogBox
        local BtnContainer = Instance.new("Frame"); BtnContainer.Size = UDim2.new(1, -24, 0, 36); BtnContainer.Position = UDim2.new(0, 12, 1, -48); BtnContainer.BackgroundTransparency = 1; BtnContainer.ZIndex = 102; BtnContainer.Parent = DialogBox
        local BtnLayout = Instance.new("UIListLayout"); BtnLayout.FillDirection = Enum.FillDirection.Horizontal; BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; BtnLayout.Padding = UDim.new(0, 10); BtnLayout.Parent = BtnContainer

        for _, btnData in ipairs(config.Buttons or {}) do
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

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local WindowObj = {}
    local Tabs = {}

    function WindowObj:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 38); TabBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 34); TabBtn.Text = (icon and icon .. "  " or "") .. name; TabBtn.TextColor3 = Color3.fromRGB(150, 155, 175); TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextSize = 12; TabBtn.TextXAlignment = Enum.TextXAlignment.Left; TabBtn.Parent = Sidebar
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
        function TabObj:AddToggle(id, text, default, callback)
            local state = default or false
            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 44); Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 36); Frame.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Frame
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(1, -70, 1, 0); Label.Position = UDim2.new(0, 16, 0, 0); Label.BackgroundTransparency = 1; Label.Text = text; Label.TextColor3 = Color3.fromRGB(230, 235, 245); Label.Font = Enum.Font.GothamMedium; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame
            local SwitchBg = Instance.new("Frame"); SwitchBg.Size = UDim2.new(0, 46, 0, 24); SwitchBg.Position = UDim2.new(1, -58, 0.5, -12); SwitchBg.BackgroundColor3 = state and Color3.fromRGB(0, 220, 140) or Color3.fromRGB(45, 49, 68); SwitchBg.Parent = Frame
            local SwitchCorner = Instance.new("UICorner"); SwitchCorner.CornerRadius = UDim.new(1, 0); SwitchCorner.Parent = SwitchBg
            local Knob = Instance.new("Frame"); Knob.Size = UDim2.new(0, 20, 0, 20); Knob.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10); Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Knob.Parent = SwitchBg
            local KnobCorner = Instance.new("UICorner"); KnobCorner.CornerRadius = UDim.new(1, 0); KnobCorner.Parent = Knob
            local ClickBtn = Instance.new("TextButton"); ClickBtn.Size = UDim2.new(1, 0, 1, 0); ClickBtn.BackgroundTransparency = 1; ClickBtn.Text = ""; ClickBtn.Parent = Frame

            ClickBtn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), { BackgroundColor3 = state and Color3.fromRGB(0, 220, 140) or Color3.fromRGB(45, 49, 68) }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), { Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10) }):Play()
                if callback then callback(state) end
            end)
        end

        function TabObj:AddButton(text, callback)
            local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(1, 0, 0, 42); Btn.BackgroundColor3 = Color3.fromRGB(24, 28, 44); Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Btn.Parent = TabPage
            local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 14); Corner.Parent = Btn
            Btn.MouseButton1Click:Connect(callback)
        end

        return TabObj
    end

    return WindowObj
end

return NXHub
