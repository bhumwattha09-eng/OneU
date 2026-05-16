--[[ 
    OneU Studio | UI Library v2.0
    A Premium Luau Framework for Roblox
    
    Credits: OneU Studio
    Inspired by Samsung One UI 8
]]

local OneU = {}
OneU.__index = OneU

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Theme = {
    Main = Color3.fromRGB(13, 110, 253),     
    Background = Color3.fromRGB(18, 18, 20),
    Sidebar = Color3.fromRGB(24, 24, 26),
    Secondary = Color3.fromRGB(32, 32, 35),
    Stroke = Color3.fromRGB(45, 45, 48),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 160, 165),
    Rounding = 28
}

-- Utility: Smooth Tween
function OneU:Tween(obj, props, time)
    local info = TweenInfo.new(time or 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

-- Utility: Dragging
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function OneU.new(title)
    local self = setmetatable({}, OneU)
    self.Tabs = {}
    self.ActiveTab = nil

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OneU_V2"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = (RunService:IsStudio() and game:GetService("Players").LocalPlayer.PlayerGui or CoreGui)
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 680, 0, 460)
    MainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, Theme.Rounding)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Theme.Stroke
    Stroke.Thickness = 1.2
    Stroke.Transparency = 0.5

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner", Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, Theme.Rounding)
    
    -- Sidebar Hide Corner (Cover right side of sidebar)
    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0, 40, 1, 0)
    SidebarCover.Position = UDim2.new(1, -40, 0, 0)
    SidebarCover.BackgroundColor3 = Theme.Sidebar
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Parent = Sidebar

    local SidebarTitle = Instance.new("TextLabel")
    SidebarTitle.Size = UDim2.new(1, 0, 0, 80)
    SidebarTitle.Position = UDim2.new(0, 0, 0, 0)
    SidebarTitle.Text = title or "OneU Studio"
    SidebarTitle.Font = Enum.Font.GothamBold
    SidebarTitle.TextSize = 22
    SidebarTitle.TextColor3 = Theme.Text
    SidebarTitle.BackgroundTransparency = 1
    SidebarTitle.Parent = Sidebar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, 0, 1, -100)
    TabList.Position = UDim2.new(0, 0, 0, 80)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout", TabList)
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Container
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -220, 1, -60)
    Container.Position = UDim2.new(0, 210, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -48, 0, 16)
    CloseBtn.BackgroundColor3 = Theme.Secondary
    CloseBtn.Text = "×"
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.TextSize = 24
    CloseBtn.TextColor3 = Theme.SubText
    CloseBtn.Parent = MainFrame
    
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    local CloseStroke = Instance.new("UIStroke", CloseBtn)
    CloseStroke.Color = Theme.Stroke
    
    CloseBtn.MouseButton1Click:Connect(function()
        OneU:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Transparency = 1}, 0.5)
        wait(0.5)
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function() OneU:Tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 100, 100), BackgroundColor3 = Color3.fromRGB(50, 30, 30)}, 0.3) end)
    CloseBtn.MouseLeave:Connect(function() OneU:Tween(CloseBtn, {TextColor3 = Theme.SubText, BackgroundColor3 = Theme.Secondary}, 0.3) end)

    MakeDraggable(MainFrame, Sidebar)
    
    self.Main = MainFrame
    self.TabList = TabList
    self.Container = Container
    
    return self
end

function OneU:CreateTab(name)
    local tab = {Elements = {}}
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 170, 0, 48)
    TabBtn.BackgroundColor3 = Theme.Secondary
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.TextColor3 = Theme.SubText
    TabBtn.Parent = self.TabList
    
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 12)
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 0
    TabPage.Visible = false
    TabPage.Parent = self.Container
    
    local PageLayout = Instance.new("UIListLayout", TabPage)
    PageLayout.Padding = UDim.new(0, 12)
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(self.Container:GetChildren()) do page.Visible = false end
        for _, btn in pairs(self.TabList:GetChildren()) do 
            if btn:IsA("TextButton") then
                OneU:Tween(btn, {BackgroundTransparency = 1, TextColor3 = Theme.SubText}, 0.3)
            end
        end
        TabPage.Visible = true
        OneU:Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = Theme.Text}, 0.3)
    end)

    if not self.ActiveTab then
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.Text
        TabPage.Visible = true
        self.ActiveTab = tab
    end

    function tab:CreateButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.95, 0, 0, 56)
        Btn.BackgroundColor3 = Theme.Secondary
        Btn.Text = ""
        Btn.Parent = TabPage
        
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 14)
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Theme.Stroke
        Stroke.Transparency = 0.8
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 20, 0, 0)
        Label.Text = text
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 15
        Label.TextColor3 = Theme.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Btn
        
        Btn.MouseEnter:Connect(function() OneU:Tween(Btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.3) end)
        Btn.MouseLeave:Connect(function() OneU:Tween(Btn, {BackgroundColor3 = Theme.Secondary}, 0.3) end)
        
        Btn.MouseButton1Click:Connect(function()
            task.spawn(callback)
            Btn.BackgroundColor3 = Theme.Main
            wait(0.1)
            OneU:Tween(Btn, {BackgroundColor3 = Theme.Secondary}, 0.3)
        end)
    end
    
    function tab:CreateToggle(text, default, callback)
        local state = default or false
        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0.95, 0, 0, 56)
        Toggle.BackgroundColor3 = Theme.Secondary
        Toggle.Text = ""
        Toggle.Parent = TabPage
        Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 14)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -100, 1, 0)
        Label.Position = UDim2.new(0, 20, 0, 0)
        Label.Text = text
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 15
        Label.TextColor3 = Theme.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Toggle
        
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 44, 0, 24)
        Box.Position = UDim2.new(1, -64, 0.5, -12)
        Box.BackgroundColor3 = state and Theme.Main or Color3.fromRGB(45, 45, 48)
        Box.Parent = Toggle
        Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)
        
        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 18, 0, 18)
        Dot.Position = UDim2.new(0, state and 22 or 4, 0.5, -9)
        Dot.BackgroundColor3 = Color3.new(1, 1, 1)
        Dot.Parent = Box
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
        
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
            OneU:Tween(Box, {BackgroundColor3 = state and Theme.Main or Color3.fromRGB(45, 45, 48)}, 0.3)
            OneU:Tween(Dot, {Position = UDim2.new(0, state and 22 or 4, 0.5, -9)}, 0.3)
        end)
    end

    function tab:CreateSlider(text, min, max, default, callback)
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(0.95, 0, 0, 84)
        Slider.BackgroundColor3 = Theme.Secondary
        Slider.Parent = TabPage
        Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 14)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -40, 0, 40)
        Label.Position = UDim2.new(0, 20, 0, 4)
        Label.Text = text .. " : " .. default
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 14
        Label.TextColor3 = Theme.SubText
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Slider
        
        local Tray = Instance.new("Frame")
        Tray.Size = UDim2.new(1, -40, 0, 6)
        Tray.Position = UDim2.new(0, 20, 0, 54)
        Tray.BackgroundColor3 = Theme.Background
        Tray.Parent = Slider
        Instance.new("UICorner", Tray)
        
        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Bar.BackgroundColor3 = Theme.Main
        Bar.BorderSizePixel = 0
        Bar.Parent = Tray
        Instance.new("UICorner", Bar)
        
        local sliding = false
        local function update()
            local mousePos = UserInputService:GetMouseLocation().X
            local trayPos = Tray.AbsolutePosition.X
            local traySize = Tray.AbsoluteSize.X
            local percent = math.clamp((mousePos - trayPos) / traySize, 0, 1)
            local val = math.floor(min + (max - min) * percent)
            
            Bar.Size = UDim2.new(percent, 0, 1, 0)
            Label.Text = text .. " : " .. val
            callback(val)
        end
        
        Tray.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true update() end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
        end)
    end

    return tab
end

return OneU
