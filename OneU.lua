local OneU = {}
OneU.__index = OneU

local TService = game:GetService("TweenService")
local UIService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Theme = {
    Main = Color3.fromRGB(13, 110, 253),
    Back = Color3.fromRGB(10, 10, 12),
    Card = Color3.fromRGB(24, 24, 26),
    Accent = Color3.fromRGB(35, 35, 38),
    Text = Color3.fromRGB(255, 255, 255),
    Dim = Color3.fromRGB(160, 160, 165),
    Rounding = 32
}

function OneU:Tween(obj, props, time)
    TService:Create(obj, TweenInfo.new(time or 0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), props):Play()
end

function OneU:Drag(frame)
	local dragToggle, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UIService.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			local delta = input.Position - dragStart
			self:Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.15)
		end
	end)
end

function OneU.new(title)
    local self = setmetatable({}, OneU)
    
    local SG = Instance.new("ScreenGui")
    SG.Name = "OneU_" .. math.random(100,999)
    SG.Parent = CoreGui
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 680, 0, 480)
    Main.Position = UDim2.new(0.5, -340, 0.5, -240)
    Main.BackgroundColor3 = Theme.Back
    Main.ClipsDescendants = true
    Main.Parent = SG
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, Theme.Rounding)
    self:Drag(Main)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Card
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, Theme.Rounding)

    local STitle = Instance.new("TextLabel")
    STitle.Size = UDim2.new(1, 0, 0, 80)
    STitle.Position = UDim2.new(0, 0, 0, 20)
    STitle.BackgroundTransparency = 1
    STitle.Text = title or "OneU"
    STitle.TextColor3 = Theme.Text
    STitle.TextSize = 24
    STitle.Font = Enum.Font.GothamBold
    STitle.Parent = Sidebar

    local TCon = Instance.new("ScrollingFrame")
    TCon.Size = UDim2.new(1, -20, 1, -120)
    TCon.Position = UDim2.new(0, 10, 0, 100)
    TCon.BackgroundTransparency = 1
    TCon.ScrollBarThickness = 0
    TCon.Parent = Sidebar
    Instance.new("UIListLayout", TCon).Padding = UDim.new(0, 8)

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -220, 1, -40)
    Content.Position = UDim2.new(0, 210, 0, 20)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    
    self.Tabs = {}
    self.TabContent = Content
    self.TabList = TCon
    self.Gui = SG
    
    return self
end

function OneU:CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 50)
    TabBtn.BackgroundColor3 = Theme.Accent
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Theme.Dim
    TabBtn.TextSize = 14
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Parent = self.TabList
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 16)

    local TPage = Instance.new("ScrollingFrame")
    TPage.Size = UDim2.new(1, 0, 1, 0)
    TPage.BackgroundTransparency = 1
    TPage.Visible = false
    TPage.ScrollBarThickness = 0
    TPage.Parent = self.TabContent
    Instance.new("UIListLayout", TPage).Padding = UDim.new(0, 10)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabContent:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(self.TabList:GetChildren()) do if v:IsA("TextButton") then self:Tween(v, {BackgroundTransparency = 1, TextColor3 = Theme.Dim}, 0.3) end end
        TPage.Visible = true
        self:Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = Theme.Main}, 0.3)
    end)

    if #self.TabList:GetChildren() == 2 then 
        TPage.Visible = true 
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.Main
    end

    local TabObj = {Container = TPage, Lib = self}

    function TabObj:CreateButton(text, cb)
        local B = Instance.new("TextButton")
        B.Size = UDim2.new(1, 0, 0, 55)
        B.BackgroundColor3 = Theme.Card
        B.Text = "  "..text
        B.TextColor3 = Theme.Text
        B.TextSize = 14
        B.Font = Enum.Font.GothamMedium
        B.TextXAlignment = Enum.TextXAlignment.Left
        B.Parent = self.Container
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 18)
        B.MouseButton1Click:Connect(cb)
    end

    function TabObj:CreateSlider(text, min, max, def, cb)
        local S = Instance.new("Frame")
        S.Size = UDim2.new(1, 0, 0, 75)
        S.BackgroundColor3 = Theme.Card
        S.Parent = self.Container
        Instance.new("UICorner", S).CornerRadius = UDim.new(0, 18)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1, -20, 0, 35)
        L.Position = UDim2.new(0, 15, 0, 5)
        L.BackgroundTransparency = 1
        L.Text = text .. " : " .. def
        L.TextColor3 = Theme.Dim
        L.TextSize = 13
        L.Font = Enum.Font.GothamBold
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.Parent = S

        local B = Instance.new("Frame")
        B.Size = UDim2.new(1, -30, 0, 6)
        B.Position = UDim2.new(0, 15, 0, 50)
        B.BackgroundColor3 = Theme.Accent
        B.Parent = S
        Instance.new("UICorner", B)

        local F = Instance.new("Frame")
        F.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
        F.BackgroundColor3 = Theme.Main
        F.Parent = B
        Instance.new("UICorner", F)

        local down = false
        local function update(input)
            local pos = math.clamp((input.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            L.Text = text .. " : " .. val
            F.Size = UDim2.new(pos, 0, 1, 0)
            cb(val)
        end
        S.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = true update(i) end end)
        UIService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = false end end)
        UIService.InputChanged:Connect(function(i) if down and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
    end

    function TabObj:CreateToggle(text, def, cb)
        local T = Instance.new("TextButton")
        T.Size = UDim2.new(1, 0, 0, 60)
        T.BackgroundColor3 = Theme.Card
        T.Text = "  "..text
        T.TextColor3 = Theme.Text
        T.TextSize = 14
        T.Font = Enum.Font.GothamMedium
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.Parent = self.Container
        Instance.new("UICorner", T).CornerRadius = UDim.new(0, 18)

        local S = Instance.new("Frame")
        S.Size = UDim2.new(0, 42, 0, 22)
        S.Position = UDim2.new(1, -55, 0.5, -11)
        S.BackgroundColor3 = def and Theme.Main or Theme.Accent
        S.Parent = T
        Instance.new("UICorner", S).CornerRadius = UDim.new(1, 0)

        local C = Instance.new("Frame")
        C.Size = UDim2.new(0, 16, 0, 16)
        C.Position = UDim2.new(0, def and 22 or 3, 0.5, -8)
        C.BackgroundColor3 = Color3.new(1,1,1)
        C.Parent = S
        Instance.new("UICorner", C).CornerRadius = UDim.new(1, 0)

        local state = def
        T.MouseButton1Click:Connect(function()
            state = not state
            cb(state)
            self.Lib:Tween(S, {BackgroundColor3 = state and Theme.Main or Theme.Accent}, 0.3)
            self.Lib:Tween(C, {Position = UDim2.new(0, state and 22 or 3, 0.5, -8)}, 0.3)
        end)
    end

    return TabObj
end

return OneU