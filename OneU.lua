--[[ 
    OneU Studio | UI Library v3.0 (PRO)
    A Premium Luau Framework for Roblox
    Samsung One UI 8 Design Language
]]

local OneU = {}
OneU.__index = OneU

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Theme = {
    Main = Color3.fromRGB(13, 110, 253),     
    Background = Color3.fromRGB(12, 12, 14),
    Sidebar = Color3.fromRGB(20, 20, 22),
    Secondary = Color3.fromRGB(28, 28, 30),
    Stroke = Color3.fromRGB(50, 50, 55),
    Header = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 160, 165),
    Rounding = 32
}

local function Tween(obj, props, time, style)
    TweenService:Create(obj, TweenInfo.new(time or 0.4, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

-- Improved Dragging with Interaction Checks
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            -- Check if clicking an interactive element to prevent accidental drags
            local focused = game:GetService("GuiService").SelectedObject
            if dragging == false or dragging == nil then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function OneU.new(title)
    local self = setmetatable({}, OneU)
    self.Tabs = {}
    self.ActiveTab = nil
    self.IsSliding = false -- Prevent drag while sliding

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OneU_Elite"
    ScreenGui.Parent = (RunService:IsStudio() and game:GetService("Players").LocalPlayer.PlayerGui or CoreGui)
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 720, 0, 500)
    Main.Position = UDim2.new(0.5, -360, 0.5, -250)
    Main.BackgroundColor3 = Theme.Background
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, Theme.Rounding)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.Stroke
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.6

    -- Sidebar (Navigation)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 220, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Parent = Main
    
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, Theme.Rounding)
    
    local SidebarHeader = Instance.new("TextLabel")
    SidebarHeader.Size = UDim2.new(1, 0, 0, 100)
    SidebarHeader.Text = title or "OneU Studio"
    SidebarHeader.Font = Enum.Font.GothamBold
    SidebarHeader.TextSize = 24
    SidebarHeader.TextColor3 = Theme.Text
    SidebarHeader.BackgroundTransparency = 1
    SidebarHeader.Parent = Sidebar

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -20, 1, -120)
    Scroll.Position = UDim2.new(0, 10, 0, 100)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 0
    Scroll.Parent = Sidebar
    
    Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 6)

    -- Container
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -240, 1, -20)
    Content.Position = UDim2.new(0, 230, 0, 10)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    -- Header Info
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 80)
    Header.BackgroundTransparency = 1
    Header.Parent = Content
    
    local PageTitle = Instance.new("TextLabel")
    PageTitle.Size = UDim2.new(1, 0, 1, 0)
    PageTitle.Text = "Dashboard"
    PageTitle.Font = Enum.Font.GothamBold
    PageTitle.TextSize = 32
    PageTitle.TextColor3 = Theme.Text
    PageTitle.TextXAlignment = Enum.TextXAlignment.Left
    PageTitle.BackgroundTransparency = 1
    PageTitle.Parent = Header

    -- Close
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 32, 0, 32)
    Close.Position = UDim2.new(1, -40, 0, 15)
    Close.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
    Close.Text = ""
    Close.Parent = Main
    Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
    
    Close.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0,0,0,0), Transparency = 1}, 0.5)
        task.wait(0.5) ScreenGui:Destroy()
    end)

    MakeDraggable(Main, Sidebar)
    self.Content = Content
    self.Scroll = Scroll
    self.PageTitle = PageTitle
    return self
end

function OneU:CreateTab(name)
    local Tab = {Elements = {}}
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 44)
    TabBtn.BackgroundColor3 = Theme.Main
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.TextColor3 = Theme.SubText
    TabBtn.Parent = self.Scroll
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 12)
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, -100)
    Page.Position = UDim2.new(0, 0, 0, 100)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.Parent = self.Content
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(self.Scroll:GetChildren()) do if v:IsA("TextButton") then Tween(v, {BackgroundTransparency = 1, TextColor3 = Theme.SubText}, 0.2) end end
        Page.Visible = true
        self.PageTitle.Text = name
        Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = Color3.new(1,1,1)}, 0.3)
    end)

    if not self.ActiveTab then self.ActiveTab = Tab TabBtn.BackgroundTransparency = 0 TabBtn.TextColor3 = Color3.new(1,1,1) Page.Visible = true end

    -- Element: Slider (Improved)
    function Tab:CreateSlider(text, min, max, def, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(0.98, 0, 0, 70)
        Container.BackgroundColor3 = Theme.Secondary
        Container.Parent = Page
        Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 16)
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -40, 0, 30)
        Title.Position = UDim2.new(0, 20, 0, 5)
        Title.Text = text .. " : " .. def
        Title.TextColor3 = Theme.SubText
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 13
        Title.BackgroundTransparency = 1
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Container
        
        local Tray = Instance.new("Frame")
        Tray.Size = UDim2.new(1, -40, 0, 6)
        Tray.Position = UDim2.new(0, 20, 0, 48)
        Tray.BackgroundColor3 = Theme.Background
        Tray.Parent = Container
        Instance.new("UICorner", Tray)
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = Theme.Main
        Fill.Parent = Tray
        Instance.new("UICorner", Fill)

        local Dragging = false
        local function Update()
            local Percent = math.clamp((UserInputService:GetMouseLocation().X - Tray.AbsolutePosition.X) / Tray.AbsoluteSize.X, 0, 1)
            local Value = math.floor(min + (max - min) * Percent)
            Fill.Size = UDim2.new(Percent, 0, 1, 0)
            Title.Text = text .. " : " .. Value
            callback(Value)
        end

        Tray.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true Update() end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update() end
        end)
    end

    -- Element: Toggle
    function Tab:CreateToggle(text, def, callback)
        local state = def or false
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.98, 0, 0, 54)
        Btn.BackgroundColor3 = Theme.Secondary
        Btn.Text = ""
        Btn.Parent = Page
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 16)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -100, 1, 0)
        Label.Position = UDim2.new(0, 20, 0, 0)
        Label.Text = text
        Label.Font = Enum.Font.GothamMedium
        Label.TextColor3 = Theme.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Btn
        
        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 44, 0, 24)
        Switch.Position = UDim2.new(1, -64, 0.5, -12)
        Switch.BackgroundColor3 = state and Theme.Main or Color3.fromRGB(50, 50, 55)
        Switch.Parent = Btn
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
        
        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 18, 0, 18)
        Dot.Position = UDim2.new(0, state and 22 or 4, 0.5, -9)
        Dot.BackgroundColor3 = Color3.new(1,1,1)
        Dot.Parent = Switch
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        Btn.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
            Tween(Switch, {BackgroundColor3 = state and Theme.Main or Color3.fromRGB(50, 50, 55)}, 0.3)
            Tween(Dot, {Position = UDim2.new(0, state and 22 or 4, 0.5, -9)}, 0.3)
        end)
    end

    return Tab
end

return OneU
