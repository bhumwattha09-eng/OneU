--[[ 
    OneU Studio | UI Library v3.0 (PRO)
    Samsung One UI 8 Aesthetic Framework
]]

local OneU = {}
OneU.__index = OneU

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName or LocalPlayer.Name

local Theme = {
    Main = Color3.fromRGB(13, 110, 253),     
    Background = Color3.fromRGB(18, 18, 20),
    Sidebar = Color3.fromRGB(24, 24, 26),
    Secondary = Color3.fromRGB(32, 32, 35),
    Stroke = Color3.fromRGB(50, 50, 55),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 185),
    Rounding = 32
}

function OneU:Tween(obj, props, time, style)
    local info = TweenInfo.new(time or 0.4, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

-- Notification System
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "OneU_Notifications"
NotifGui.DisplayOrder = 100
NotifGui.Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui)

local NotifContainer = Instance.new("Frame", NotifGui)
NotifContainer.Size = UDim2.new(0, 300, 1, 0)
NotifContainer.Position = UDim2.new(1, -320, 0, 0)
NotifContainer.BackgroundTransparency = 1

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 12)

function OneU:Notify(title, desc, duration)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 80)
    Card.BackgroundColor3 = Theme.Sidebar
    Card.Position = UDim2.new(1.2, 0, 0, 0)
    Card.Parent = NotifContainer
    
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 20)
    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color = Theme.Stroke
    
    local T = Instance.new("TextLabel", Card)
    T.Size = UDim2.new(1, -40, 0, 30)
    T.Position = UDim2.new(0, 20, 0, 15)
    T.Text = title
    T.Font = Enum.Font.GothamBold
    T.TextSize = 16
    T.TextColor3 = Theme.Main
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.BackgroundTransparency = 1
    
    local D = Instance.new("TextLabel", Card)
    D.Size = UDim2.new(1, -40, 0, 20)
    D.Position = UDim2.new(0, 20, 0, 42)
    D.Text = desc
    D.Font = Enum.Font.GothamMedium
    D.TextSize = 14
    D.TextColor3 = Theme.SubText
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.BackgroundTransparency = 1
    
    Card.Transparency = 1 T.TextTransparency = 1 D.TextTransparency = 1
    self:Tween(Card, {Position = UDim2.new(0, 0, 0, 0), Transparency = 0}, 0.6)
    self:Tween(T, {TextTransparency = 0}, 0.6)
    self:Tween(D, {TextTransparency = 0}, 0.6)
    
    task.delay(duration or 3, function()
        self:Tween(Card, {Position = UDim2.new(1.2, 0, 0, 0), Transparency = 1}, 0.6)
        task.wait(0.6)
        Card:Destroy()
    end)
end

function OneU.new(title)
    local self = setmetatable({}, OneU)
    self.Keybind = Enum.KeyCode.L
    self.IsVisible = true
    self.Dragging = false
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OneU_PRO"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui)
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 720, 0, 480)
    Main.Position = UDim2.new(0.5, -360, 0.5, -240)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, Theme.Rounding)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Theme.Stroke
    Stroke.Thickness = 1.5

    -- Sidebar / Profile Section
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 220, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, Theme.Rounding)
    
    -- Profile Head
    local PFP = Instance.new("ImageLabel", Sidebar)
    PFP.Size = UDim2.new(0, 70, 0, 70)
    PFP.Position = UDim2.new(0.5, -35, 0, 40)
    PFP.BackgroundColor3 = Theme.Secondary
    PFP.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    Instance.new("UICorner", PFP).CornerRadius = UDim.new(1, 0)
    
    local Greeting = Instance.new("TextLabel", Sidebar)
    Greeting.Size = UDim2.new(1, 0, 0, 40)
    Greeting.Position = UDim2.new(0, 0, 0, 120)
    Greeting.Text = "Hello, " .. PlayerName
    Greeting.Font = Enum.Font.GothamBold
    Greeting.TextSize = 18
    Greeting.TextColor3 = Theme.Text
    Greeting.BackgroundTransparency = 1
    
    local TabList = Instance.new("ScrollingFrame", Sidebar)
    TabList.Size = UDim2.new(1, 0, 1, -200)
    TabList.Position = UDim2.new(0, 0, 0, 180)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 10)
    
    -- Interaction logic
    local function ToggleUI()
        self.IsVisible = not self.IsVisible
        local targetPos = self.IsVisible and UDim2.new(0.5, -360, 0.5, -240) or UDim2.new(0.5, -360, 1.2, 0)
        self:Tween(Main, {Position = targetPos}, 0.6, Enum.EasingStyle.Back)
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == self.Keybind then ToggleUI() end
    end)
    
    -- Mobile Toggle
    if UserInputService.TouchEnabled then
        local MobBtn = Instance.new("TextButton", ScreenGui)
        MobBtn.Size = UDim2.new(0, 60, 0, 60)
        MobBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
        MobBtn.BackgroundColor3 = Theme.Main
        MobBtn.Text = "U" MobBtn.Font = Enum.Font.GothamBold MobBtn.TextSize = 24 MobBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", MobBtn).CornerRadius = UDim.new(1, 0)
        MobBtn.MouseButton1Click:Connect(ToggleUI)
    end

    -- Dragging with conflict check
    Sidebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.Dragging = true
            local dragStart = input.Position
            local startPos = Main.Position
            
            local moveConn
            moveConn = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                    local delta = move.Position - dragStart
                    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.Dragging = false
                    moveConn:Disconnect()
                end
            end)
        end
    end)

    self.Main = Main
    self.TabList = TabList
    self.Container = Instance.new("Frame", Main)
    self.Container.Size = UDim2.new(1, -250, 1, -40)
    self.Container.Position = UDim2.new(0, 235, 0, 20)
    self.Container.BackgroundTransparency = 1
    
    return self
end

function OneU:CreateTab(name)
    local tab = {}
    local Page = Instance.new("ScrollingFrame", self.Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.Stroke
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 12)
    
    local TabBtn = Instance.new("TextButton", self.TabList)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 50)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 16
    TabBtn.TextColor3 = Theme.SubText
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 15)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(self.TabList:GetChildren()) do if v:IsA("TextButton") then self:Tween(v, {BackgroundTransparency = 1, TextColor3 = Theme.SubText}, 0.3) end end
        Page.Visible = true
        self:Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.Text}, 0.3)
    end)
    
    if #self.TabList:GetChildren() == 2 then -- First tab logic (1 layout + 1 btn)
        Page.Visible = true
        TabBtn.BackgroundTransparency = 0
        TabBtn.BackgroundColor3 = Theme.Secondary
        TabBtn.TextColor3 = Theme.Text
    end

    function tab:CreateButton(text, callback)
        local B = Instance.new("TextButton", Page)
        B.Size = UDim2.new(0.98, 0, 0, 65)
        B.BackgroundColor3 = Theme.Secondary
        B.Text = text
        B.Font = Enum.Font.GothamBold
        B.TextSize = 18
        B.TextColor3 = Theme.Text
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 20)
        B.MouseButton1Click:Connect(callback)
    end

    function tab:CreateSlider(text, min, max, def, callback)
        local S = Instance.new("Frame", Page)
        S.Size = UDim2.new(0.98, 0, 0, 90)
        S.BackgroundColor3 = Theme.Secondary
        Instance.new("UICorner", S).CornerRadius = UDim.new(0, 20)
        
        local L = Instance.new("TextLabel", S)
        L.Size = UDim2.new(1, -40, 0, 40)
        L.Position = UDim2.new(0, 20, 0, 10)
        L.Text = text .. ": " .. def
        L.Font = Enum.Font.GothamBold
        L.TextSize = 16
        L.TextColor3 = Theme.Text
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.BackgroundTransparency = 1
        
        local Bar = Instance.new("Frame", S)
        Bar.Size = UDim2.new(1, -40, 0, 8)
        Bar.Position = UDim2.new(0, 20, 0, 60)
        Bar.BackgroundColor3 = Theme.Background
        Instance.new("UICorner", Bar)
        
        local Fill = Instance.new("Frame", Bar)
        Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = Theme.Main
        Instance.new("UICorner", Fill)

        local dragging = false
        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max-min)*percent)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                L.Text = text .. ": " .. val
                callback(val)
            end
        end)
    end

    return tab
end

return OneU
