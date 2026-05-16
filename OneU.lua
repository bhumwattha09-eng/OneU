--[[ 
    OneU Studio | UI Library v3.0 (Enterprise)
    A Premium Luau Framework for Roblox
    Inspired by Samsung One UI 8
]]

local OneU = {}
OneU.__index = OneU

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Main = Color3.fromRGB(13, 110, 253),     
    Background = Color3.fromRGB(15, 15, 17),
    Sidebar = Color3.fromRGB(22, 22, 25),
    Secondary = Color3.fromRGB(30, 30, 33),
    Stroke = Color3.fromRGB(50, 50, 55),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(170, 170, 180),
    Rounding = 36
}

function OneU:Tween(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.5, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if UserInputService:GetFocusedTextBox() then return end
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

function OneU:Notify(title, desc, duration)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0, 320, 0, 90)
    NotificationFrame.Position = UDim2.new(1, 40, 1, -110)
    NotificationFrame.BackgroundColor3 = Theme.Sidebar
    NotificationFrame.Parent = self.Gui
    
    Instance.new("UICorner", NotificationFrame).CornerRadius = UDim.new(0, 24)
    local Stroke = Instance.new("UIStroke", NotificationFrame)
    Stroke.Color = Theme.Stroke
    Stroke.Thickness = 1.5
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 30)
    Title.Position = UDim2.new(0, 20, 0, 20)
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = NotificationFrame

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -40, 0, 20)
    Desc.Position = UDim2.new(0, 20, 0, 48)
    Desc.Text = desc
    Desc.Font = Enum.Font.GothamMedium
    Desc.TextSize = 14
    Desc.TextColor3 = Theme.SubText
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.BackgroundTransparency = 1
    Desc.Parent = NotificationFrame

    OneU:Tween(NotificationFrame, {Position = UDim2.new(1, -340, 1, -110)}, 0.6)
    
    task.delay(duration or 4, function()
        OneU:Tween(NotificationFrame, {Position = UDim2.new(1, 40, 1, -110), Transparency = 1}, 0.6)
        task.wait(0.6)
        NotificationFrame:Destroy()
    end)
end

function OneU.new(title)
    local self = setmetatable({}, OneU)
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true
    self.Keybind = Enum.KeyCode.L

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OneU_Enterprise"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui)
    self.Gui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 740, 0, 520)
    MainFrame.Position = UDim2.new(0.5, -370, 0.5, -260)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, Theme.Rounding)
    local GlobalStroke = Instance.new("UIStroke", MainFrame)
    GlobalStroke.Color = Theme.Stroke
    GlobalStroke.Thickness = 2

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 240, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, Theme.Rounding)

    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0, 40, 1, 0)
    SidebarCover.Position = UDim2.new(1, -40, 0, 0)
    SidebarCover.BackgroundColor3 = Theme.Sidebar
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Parent = Sidebar

    local Profile = Instance.new("Frame")
    Profile.Size = UDim2.new(1, 0, 0, 180)
    Profile.BackgroundTransparency = 1
    Profile.Parent = Sidebar

    local PFP = Instance.new("ImageLabel")
    PFP.Size = UDim2.new(0, 80, 0, 80)
    PFP.Position = UDim2.new(0.5, -40, 0, 35)
    PFP.BackgroundColor3 = Theme.Secondary
    local success, thumb = pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
    PFP.Image = success and thumb or ""
    PFP.Parent = Profile
    Instance.new("UICorner", PFP).CornerRadius = UDim.new(1, 0)
    local PFPStroke = Instance.new("UIStroke", PFP)
    PFPStroke.Color = Theme.Main
    PFPStroke.Thickness = 2.5

    local Hello = Instance.new("TextLabel")
    Hello.Size = UDim2.new(1, 0, 0, 40)
    Hello.Position = UDim2.new(0, 0, 0, 120)
    Hello.Text = "Hello, " .. LocalPlayer.DisplayName
    Hello.Font = Enum.Font.GothamBold
    Hello.TextSize = 22
    Hello.TextColor3 = Theme.Text
    Hello.BackgroundTransparency = 1
    Hello.Parent = Profile

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, 0, 1, -190)
    TabList.Position = UDim2.new(0, 0, 0, 185)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout", TabList)
    TabLayout.Padding = UDim.new(0, 12)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -270, 1, -60)
    Container.Position = UDim2.new(0, 255, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 36, 0, 36)
    CloseBtn.Position = UDim2.new(1, -52, 0, 18)
    CloseBtn.BackgroundColor3 = Theme.Secondary
    CloseBtn.Text = "×"
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.TextSize = 28
    CloseBtn.TextColor3 = Theme.SubText
    CloseBtn.Parent = MainFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    CloseBtn.MouseButton1Click:Connect(function()
        OneU:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Transparency = 1}, 0.5)
        task.wait(0.5)
        ScreenGui:Destroy()
    end)

    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenBtn.Position = UDim2.new(0, 20, 0.5, -30)
    OpenBtn.BackgroundColor3 = Theme.Main
    OpenBtn.Text = "U"
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 24
    OpenBtn.TextColor3 = Color3.new(1, 1, 1)
    OpenBtn.Visible = UserInputService.TouchEnabled
    OpenBtn.Parent = ScreenGui
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    
    OpenBtn.MouseButton1Click:Connect(function()
        self.Visible = not self.Visible
        OneU:Tween(MainFrame, {Size = self.Visible and UDim2.new(0, 740, 0, 520) or UDim2.new(0, 0, 0, 0), Transparency = self.Visible and 0 or 1}, 0.5)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.Keybind then
            self.Visible = not self.Visible
            OneU:Tween(MainFrame, {Size = self.Visible and UDim2.new(0, 740, 0, 520) or UDim2.new(0, 0, 0, 0), Transparency = self.Visible and 0 or 1}, 0.5)
        end
    end)

    MakeDraggable(MainFrame, Sidebar)
    
    return self
end

function OneU:CreateTab(name)
    local tab = {Elements = {}}
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 200, 0, 58)
    TabBtn.BackgroundColor3 = Theme.Secondary
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 18
    TabBtn.TextColor3 = Theme.SubText
    TabBtn.Parent = self.TabList
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 18)
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 0
    TabPage.Visible = false
    TabPage.Parent = self.Container
    
    local PageLayout = Instance.new("UIListLayout", TabPage)
    PageLayout.Padding = UDim.new(0, 16)
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(self.Container:GetChildren()) do page.Visible = false end
        for _, btn in pairs(self.TabList:GetChildren()) do 
            if btn:IsA("TextButton") then
                OneU:Tween(btn, {BackgroundTransparency = 1, TextSize = 18, TextColor3 = Theme.SubText}, 0.4)
            end
        end
        TabPage.Visible = true
        OneU:Tween(TabBtn, {BackgroundTransparency = 0, TextSize = 20, TextColor3 = Theme.Text}, 0.4)
    end)

    if not self.ActiveTab then
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.Text
        TabBtn.TextSize = 20
        TabPage.Visible = true
        self.ActiveTab = tab
    end

    function tab:CreateButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.98, 0, 0, 68)
        Btn.BackgroundColor3 = Theme.Secondary
        Btn.Text = ""
        Btn.Parent = TabPage
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 20)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.Text = text
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 20
        Label.TextColor3 = Theme.Text
        Label.BackgroundTransparency = 1
        Label.Parent = Btn
        
        Btn.MouseEnter:Connect(function() OneU:Tween(Btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}, 0.4) end)
        Btn.MouseLeave:Connect(function() OneU:Tween(Btn, {BackgroundColor3 = Theme.Secondary}, 0.4) end)
        
        Btn.MouseButton1Click:Connect(function()
            task.spawn(callback)
            Btn.BackgroundColor3 = Theme.Main
            task.wait(0.15)
            OneU:Tween(Btn, {BackgroundColor3 = Theme.Secondary}, 0.4)
        end)
    end
    
    function tab:CreateToggle(text, default, callback)
        local state = default or false
        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0.98, 0, 0, 68)
        Toggle.BackgroundColor3 = Theme.Secondary
        Toggle.Text = ""
        Toggle.Parent = TabPage
        Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 20)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -140, 1, 0)
        Label.Position = UDim2.new(0, 28, 0, 0)
        Label.Text = text
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 20
        Label.TextColor3 = Theme.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Toggle
        
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 54, 0, 30)
        Box.Position = UDim2.new(1, -82, 0.5, -15)
        Box.BackgroundColor3 = state and Theme.Main or Color3.fromRGB(65, 65, 70)
        Box.Parent = Toggle
        Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)
        
        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 24, 0, 24)
        Dot.Position = UDim2.new(0, state and 26 or 4, 0.5, -12)
        Dot.BackgroundColor3 = Color3.new(1, 1, 1)
        Dot.Parent = Box
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
        
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
            OneU:Tween(Box, {BackgroundColor3 = state and Theme.Main or Color3.fromRGB(65, 65, 70)}, 0.4)
            OneU:Tween(Dot, {Position = UDim2.new(0, state and 26 or 4, 0.5, -12)}, 0.4)
        end)
    end

    function tab:CreateSlider(text, min, max, default, callback)
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(0.98, 0, 0, 110)
        Slider.BackgroundColor3 = Theme.Secondary
        Slider.Parent = TabPage
        Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 20)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -56, 0, 48)
        Label.Position = UDim2.new(0, 28, 0, 10)
        Label.Text = text .. " : " .. default
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 18
        Label.TextColor3 = Theme.SubText
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Slider
        
        local Tray = Instance.new("Frame")
        Tray.Size = UDim2.new(1, -56, 0, 10)
        Tray.Position = UDim2.new(0, 28, 0, 72)
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
        local function update(input)
            local pos = input.Position.X
            local absPos = Tray.AbsolutePosition.X
            local size = Tray.AbsoluteSize.X
            local percent = math.clamp((pos - absPos) / size, 0, 1)
            local val = math.floor(min + (max - min) * percent)
            
            OneU:Tween(Bar, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
            Label.Text = text .. " : " .. val
            callback(val)
        end
        
        Tray.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                update(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end

    return tab
end

return OneU
