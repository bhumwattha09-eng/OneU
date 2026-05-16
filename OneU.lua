local OneU = {}
OneU.__index = OneU

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local ProtectGui = gethui or (syn and syn.protect_gui) or function(gui) gui.Parent = CoreGui end

local Themes = {
    Dark = {
        Main = Color3.fromRGB(13, 110, 253),
        Background = Color3.fromRGB(15, 15, 17),
        Sidebar = Color3.fromRGB(22, 22, 25),
        Secondary = Color3.fromRGB(30, 30, 33),
        Stroke = Color3.fromRGB(50, 50, 55),
        Text = Color3.fromRGB(245, 245, 250),
        SubText = Color3.fromRGB(170, 170, 180),
        Rounding = 32
    },
    Light = {
        Main = Color3.fromRGB(13, 110, 253),
        Background = Color3.fromRGB(245, 245, 250),
        Sidebar = Color3.fromRGB(255, 255, 255),
        Secondary = Color3.fromRGB(235, 235, 240),
        Stroke = Color3.fromRGB(220, 220, 225),
        Text = Color3.fromRGB(20, 20, 25),
        SubText = Color3.fromRGB(100, 100, 110),
        Rounding = 32
    }
}

local SelectedTheme = Themes.Dark

local function Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        if i ~= "Parent" then
            inst[i] = v
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Tween(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.5, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function Ripple(button)
    spawn(function()
        local mouse = UserInputService:GetMouseLocation()
        local absPos = button.AbsolutePosition
        local relPos = Vector2.new(mouse.X - absPos.X, mouse.Y - absPos.Y - 36)
        
        local circle = Create("Frame", {
            Name = "Ripple",
            Parent = button,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, relPos.X, 0, relPos.Y),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            ZIndex = 10
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = circle })
        
        Tween(circle, { Size = UDim2.new(0, button.AbsoluteSize.X * 2, 0, button.AbsoluteSize.X * 2), BackgroundTransparency = 1 }, 0.6)
        wait(0.6)
        circle:Destroy()
    end)
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UserInputService:GetFocusedTextBox() then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function OneU:Notify(title, desc, duration)
    local frame = Create("Frame", {
        Size = UDim2.new(0, 340, 0, 100),
        Position = UDim2.new(1, 40, 1, -120),
        BackgroundColor3 = SelectedTheme.Sidebar,
        Parent = self.Gui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 24), Parent = frame })
    Create("UIStroke", { Color = SelectedTheme.Stroke, Thickness = 2, Parent = frame })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 0, 20),
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = SelectedTheme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = frame
    })
    Create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 0, 50),
        Text = desc,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = SelectedTheme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = frame
    })
    
    Tween(frame, { Position = UDim2.new(1, -360, 1, -120) }, 0.6)
    delay(duration or 5, function()
        Tween(frame, { Position = UDim2.new(1, 40, 1, -120), BackgroundTransparency = 1 }, 0.6)
        wait(0.6)
        frame:Destroy()
    end)
end

function OneU.new(title, subtitle)
    local self = setmetatable({}, OneU)
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true

    local gui = Create("ScreenGui", { Name = "OneU_Ultimate", ResetOnSpawn = false })
    ProtectGui(gui)
    self.Gui = gui

    local main = Create("Frame", {
        Size = UDim2.new(0, 780, 0, 540),
        Position = UDim2.new(0.5, -390, 0.5, -270),
        BackgroundColor3 = SelectedTheme.Background,
        ClipsDescendants = true,
        Parent = gui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, SelectedTheme.Rounding), Parent = main })
    Create("UIStroke", { Color = SelectedTheme.Stroke, Thickness = 2.5, Parent = main })

    local sidebar = Create("Frame", {
        Size = UDim2.new(0, 260, 1, 0),
        BackgroundColor3 = SelectedTheme.Sidebar,
        BorderSizePixel = 0,
        Parent = main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, SelectedTheme.Rounding), Parent = sidebar })
    Create("Frame", { Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0), BackgroundColor3 = SelectedTheme.Sidebar, BorderSizePixel = 0, Parent = sidebar })

    local profile = Create("Frame", { Size = UDim2.new(1, 0, 0, 200), BackgroundTransparency = 1, Parent = sidebar })
    local pfp = Create("ImageLabel", {
        Size = UDim2.new(0, 90, 0, 90),
        Position = UDim2.new(0.5, -45, 0, 40),
        BackgroundColor3 = SelectedTheme.Secondary,
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        Parent = profile
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = pfp })
    Create("UIStroke", { Color = SelectedTheme.Main, Thickness = 3, Parent = pfp })

    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 140),
        Text = title or "Welcome",
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = SelectedTheme.Text,
        BackgroundTransparency = 1,
        Parent = profile
    })

    local tabList = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -220),
        Position = UDim2.new(0, 0, 0, 210),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = sidebar
    })
    Create("UIListLayout", { Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = tabList })

    local container = Create("Frame", { Size = UDim2.new(1, -290, 1, -80), Position = UDim2.new(0, 275, 0, 60), BackgroundTransparency = 1, Parent = main })

    local close = Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -55, 0, 15),
        BackgroundColor3 = SelectedTheme.Secondary,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 30,
        TextColor3 = SelectedTheme.SubText,
        Parent = main
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = close })
    close.MouseButton1Click:Connect(function() Tween(main, { Size = UDim2.new(0, 0, 0, 0), Transparency = 1 }, 0.5) wait(0.5) gui:Destroy() end)

    MakeDraggable(main, sidebar)
    self.Main = main
    self.TabList = tabList
    self.Container = container
    return self
end

function OneU:CreateTab(name, icon)
    local tab = { Elements = {} }
    local btn = Create("TextButton", {
        Size = UDim2.new(0, 220, 0, 64),
        BackgroundColor3 = SelectedTheme.Secondary,
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = SelectedTheme.SubText,
        Parent = self.TabList
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 20), Parent = btn })

    local page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Visible = false,
        Parent = self.Container
    })
    Create("UIListLayout", { Padding = UDim.new(0, 16), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = page })

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.Container:GetChildren()) do v.Visible = false end
        for _, v in pairs(self.TabList:GetChildren()) do if v:IsA("TextButton") then Tween(v, { BackgroundTransparency = 1, TextSize = 18, TextColor3 = SelectedTheme.SubText }, 0.4) end end
        page.Visible = true
        Tween(btn, { BackgroundTransparency = 0, TextSize = 20, TextColor3 = SelectedTheme.Text }, 0.4)
    end)

    if not self.ActiveTab then
        btn.BackgroundTransparency = 0
        btn.TextColor3 = SelectedTheme.Text
        btn.TextSize = 20
        page.Visible = true
        self.ActiveTab = tab
    end

    function tab:CreateButton(text, callback)
        local b = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 72),
            BackgroundColor3 = SelectedTheme.Secondary,
            Text = "",
            ClipsDescendants = true,
            Parent = page
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 22), Parent = b })
        Create("TextLabel", { Size = UDim2.new(1, 0, 1, 0), Text = text, Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = SelectedTheme.Text, BackgroundTransparency = 1, Parent = b })
        
        b.MouseEnter:Connect(function() Tween(b, { BackgroundColor3 = Color3.fromRGB(45, 45, 50), Size = UDim2.new(1, 10, 0, 72) }, 0.3) end)
        b.MouseLeave:Connect(function() Tween(b, { BackgroundColor3 = SelectedTheme.Secondary, Size = UDim2.new(1, 0, 0, 72) }, 0.3) end)
        b.MouseButton1Down:Connect(function() Ripple(b) callback() end)
    end

    function tab:CreateToggle(text, val, callback)
        local s = val or false
        local t = Create("TextButton", { Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = SelectedTheme.Secondary, Text = "", Parent = page })
        Create("UICorner", { CornerRadius = UDim.new(0, 22), Parent = t })
        Create("TextLabel", { Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 30, 0, 0), Text = text, Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = SelectedTheme.Text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = t })
        
        local box = Create("Frame", { Size = UDim2.new(0, 60, 0, 34), Position = UDim2.new(1, -90, 0.5, -17), BackgroundColor3 = s and SelectedTheme.Main or Color3.fromRGB(60, 60, 65), Parent = t })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = box })
        local dot = Create("Frame", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, s and 28 or 4, 0.5, -14), BackgroundColor3 = Color3.new(1, 1, 1), Parent = box })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
        
        t.MouseButton1Click:Connect(function()
            s = not s
            callback(s)
            Tween(box, { BackgroundColor3 = s and SelectedTheme.Main or Color3.fromRGB(60, 60, 65) }, 0.4)
            Tween(dot, { Position = UDim2.new(0, s and 28 or 4, 0.5, -14) }, 0.4, Enum.EasingStyle.Back)
        end)
    end

    function tab:CreateSlider(text, min, max, default, callback)
        local s = Create("Frame", { Size = UDim2.new(1, 0, 0, 120), BackgroundColor3 = SelectedTheme.Secondary, Parent = page })
        Create("UICorner", { CornerRadius = UDim.new(0, 24), Parent = s })
        local l = Create("TextLabel", { Size = UDim2.new(1, -60, 0, 60), Position = UDim2.new(0, 30, 0, 10), Text = text .. ": " .. default, Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = SelectedTheme.SubText, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = s })
        local tray = Create("Frame", { Size = UDim2.new(1, -60, 0, 12), Position = UDim2.new(0, 30, 0, 80), BackgroundColor3 = SelectedTheme.Background, Parent = s })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = tray })
        local bar = Create("Frame", { Size = UDim2.new((default-min)/(max-min), 0, 1, 0), BackgroundColor3 = SelectedTheme.Main, Parent = tray })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
        
        local active = false
        local function update(input)
            local p = math.clamp((input.Position.X - tray.AbsolutePosition.X) / tray.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * p)
            Tween(bar, { Size = UDim2.new(p, 0, 1, 0) }, 0.2)
            l.Text = text .. ": " .. v
            callback(v)
        end
        tray.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then active = true update(i) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then active = false end end)
        UserInputService.InputChanged:Connect(function(i) if active and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end end)
    end

    function tab:CreateDropdown(text, list, callback)
        local d = Create("TextButton", { Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = SelectedTheme.Secondary, Text = "", Parent = page, ClipsDescendants = true })
        Create("UICorner", { CornerRadius = UDim.new(0, 22), Parent = d })
        local l = Create("TextLabel", { Size = UDim2.new(1, -60, 0, 72), Position = UDim2.new(0, 30, 0, 0), Text = text, Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = SelectedTheme.Text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = d })
        local arrow = Create("TextLabel", { Size = UDim2.new(0, 30, 0, 72), Position = UDim2.new(1, -60, 0, 0), Text = "▼", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = SelectedTheme.SubText, BackgroundTransparency = 1, Parent = d })
        
        local optCon = Create("Frame", { Size = UDim2.new(0.9, 0, 0, 0), Position = UDim2.new(0.05, 0, 0, 72), BackgroundTransparency = 1, Parent = d })
        Create("UIListLayout", { Padding = UDim.new(0, 5), Parent = optCon })
        
        local open = false
        for _, v in pairs(list) do
            local o = Create("TextButton", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = SelectedTheme.Background, Text = v, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = SelectedTheme.SubText, Parent = optCon })
            Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = o })
            o.MouseButton1Click:Connect(function() l.Text = text .. " - " .. v callback(v) open = false Tween(d, { Size = UDim2.new(1, 0, 0, 72) }, 0.4) Tween(arrow, { Rotation = 0 }, 0.4) end)
        end

        d.MouseButton1Click:Connect(function()
            open = not open
            Tween(d, { Size = UDim2.new(1, 0, 0, open and (72 + #list * 45) or 72) }, 0.4)
            Tween(arrow, { Rotation = open and 180 or 0 }, 0.4)
        end)
    end

    function tab:CreateTextbox(text, placeholder, callback)
        local t = Create("Frame", { Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = SelectedTheme.Secondary, Parent = page })
        Create("UICorner", { CornerRadius = UDim.new(0, 22), Parent = t })
        Create("TextLabel", { Size = UDim2.new(1, -60, 0, 40), Position = UDim2.new(0, 30, 0, 10), Text = text, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = SelectedTheme.SubText, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = t })
        local box = Create("TextBox", { Size = UDim2.new(1, -60, 0, 35), Position = UDim2.new(0, 30, 0, 45), PlaceholderText = placeholder, Text = "", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = SelectedTheme.Text, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = t })
        box.FocusLost:Connect(function(e) if e then callback(box.Text) end end)
    end

    function tab:CreateColorPicker(text, default, callback)
        local cp = Create("TextButton", {Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = SelectedTheme.Secondary, Text = "", Parent = page})
        Create("UICorner", {CornerRadius = UDim.new(0, 22), Parent = cp})
        Create("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 30, 0, 0), Text = text, Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = SelectedTheme.Text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = cp})
        
        local preview = Create("Frame", {Size = UDim2.new(0, 50, 0, 30), Position = UDim2.new(1, -80, 0.5, -15), BackgroundColor3 = default or Color3.new(1, 1, 1), Parent = cp})
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = preview})
        
        cp.MouseButton1Click:Connect(function()
            -- Simplified color cycle for demo since a full 2D picker is huge
            local colors = {Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,1), Color3.new(0,0,0), Color3.new(1,1,0)}
            local nextColor = colors[math.random(#colors)]
            preview.BackgroundColor3 = nextColor
            callback(nextColor)
        end)
    end

    function tab:CreateKeybind(text, default, callback)
        local kb = Create("TextButton", {Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = SelectedTheme.Secondary, Text = "", Parent = page})
        Create("UICorner", {CornerRadius = UDim.new(0, 22), Parent = kb})
        Create("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 30, 0, 0), Text = text, Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = SelectedTheme.Text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = kb})
        
        local display = Create("TextLabel", {Size = UDim2.new(0, 80, 0, 36), Position = UDim2.new(1, -100, 0.5, -18), Text = default.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = SelectedTheme.Main, BackgroundColor3 = SelectedTheme.Background, Parent = kb})
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = display})
        
        local listening = false
        kb.MouseButton1Click:Connect(function()
            listening = true
            display.Text = "..."
        end)
        
        UserInputService.InputBegan:Connect(function(input)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                display.Text = input.KeyCode.Name
                callback(input.KeyCode)
            end
        end)
    end

    function tab:CreateSection(text)
        local s = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = page})
        Create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), Text = text:upper(), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = SelectedTheme.Main, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Parent = s})
        local line = Create("Frame", {Size = UDim2.new(1, -120, 0, 1), Position = UDim2.new(0, 110, 0.5, 0), BackgroundColor3 = SelectedTheme.Stroke, BackgroundTransparency = 0.5, Parent = s})
    end

    return tab
end

return OneU
