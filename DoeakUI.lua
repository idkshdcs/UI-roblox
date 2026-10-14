--[[
    DoeakUI v1.0
    Style: WindUI-inspired structure, rose-tech theme
    API: Window → Tab → Section → Component
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ============ THEME ============
local Colors = {
    Bg      = Color3.fromRGB(10, 7, 11),
    Panel   = Color3.fromRGB(22, 15, 22),
    Panel2  = Color3.fromRGB(30, 20, 30),
    Panel3  = Color3.fromRGB(36, 24, 36),
    Line    = Color3.fromRGB(70, 35, 45),
    Line2   = Color3.fromRGB(110, 55, 75),
    Ink     = Color3.fromRGB(237, 233, 236),
    Dim     = Color3.fromRGB(157, 139, 148),
    Faint   = Color3.fromRGB(107, 93, 100),
    Rose    = Color3.fromRGB(244, 63, 94),
    Rose2   = Color3.fromRGB(251, 113, 133),
    Rose3   = Color3.fromRGB(253, 164, 175),
    Cyan    = Color3.fromRGB(34, 211, 238),
    Good    = Color3.fromRGB(52, 211, 153),
    Warn    = Color3.fromRGB(251, 191, 36),
    Bad     = Color3.fromRGB(248, 113, 113),
}

local Fonts = {
    Mono = Enum.Font.RobotoMono,
    Code = Enum.Font.Code,
    Sans = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
}

-- ============ HELPERS ============
local function mk(class, props)
    local i = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then i[k] = v end
        end
        if props.Parent then i.Parent = props.Parent end
    end
    return i
end

local function corner(parent, r)
    return mk("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = parent })
end

local function stroke(parent, color, thickness, transparency)
    return mk("UIStroke", {
        Color = color or Colors.Line2,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function pad(parent, t, r, b, l)
    r = r or t; b = b or t; l = l or r
    return mk("UIPadding", {
        PaddingTop = UDim.new(0, t),
        PaddingRight = UDim.new(0, r),
        PaddingBottom = UDim.new(0, b),
        PaddingLeft = UDim.new(0, l),
        Parent = parent,
    })
end

local function vlist(parent, gap)
    local l = mk("UIListLayout", { Parent = parent })
    l.FillDirection = Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, gap or 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

local function tween(inst, props, time, style)
    local t = TweenService:Create(
        inst,
        TweenInfo.new(time or 0.16, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

-- ============ LIBRARY ============
local DoeakUI = {}
DoeakUI.__index = DoeakUI
DoeakUI.Colors = Colors
DoeakUI.Fonts = Fonts
DoeakUI.Flags = {}
DoeakUI.Toggles = {}
DoeakUI.Options = {}
DoeakUI.Keybinds = {}

-- ============ NOTIFICATION ============
local NotifGui
local function ensureNotifGui()
    if NotifGui and NotifGui.Parent then return end
    NotifGui = mk("ScreenGui", {
        Name = "DoeakUI_Notifs",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    pcall(function() NotifGui.Parent = game:GetService("CoreGui") end)
    if not NotifGui.Parent then NotifGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

function DoeakUI:Notify(opts)
    opts = opts or {}
    ensureNotifGui()

    local holder = NotifGui:FindFirstChild("Holder")
    if not holder then
        holder = mk("Frame", {
            Name = "Holder",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -18, 1, -18),
            Size = UDim2.fromOffset(300, 400),
            BackgroundTransparency = 1,
            Parent = NotifGui,
        })
        local l = vlist(holder, 8)
        l.VerticalAlignment = Enum.VerticalAlignment.Bottom
        l.HorizontalAlignment = Enum.HorizontalAlignment.Right
    end

    local kind = opts.Type or "info"
    local accent = Colors.Rose
    if kind == "success" then accent = Colors.Good end
    if kind == "warn" then accent = Colors.Warn end
    if kind == "error" then accent = Colors.Bad end

    local card = mk("Frame", {
        BackgroundColor3 = Colors.Panel,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = holder,
    })
    corner(card, 8)
    stroke(card, Colors.Line2, 1, 0.5)
    pad(card, 12, 14, 12, 16)
    vlist(card, 5)

    mk("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 2, 1, -12),
        Position = UDim2.new(0, 0, 0, 6),
        Parent = card,
    })

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Font = Fonts.Code,
        Text = "// " .. string.upper(opts.Title or kind),
        TextColor3 = accent,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Fonts.Mono,
        Text = opts.Text or "",
        TextColor3 = Colors.Ink,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = card,
    })

    task.delay(opts.Duration or 4, function()
        if not card or not card.Parent then return end
        tween(card, { BackgroundTransparency = 1 }, 0.4)
        for _, d in ipairs(card:GetDescendants()) do
            if d:IsA("TextLabel") then tween(d, { TextTransparency = 1 }, 0.4) end
            if d:IsA("UIStroke") then tween(d, { Transparency = 1 }, 0.4) end
            if d:IsA("Frame") then tween(d, { BackgroundTransparency = 1 }, 0.4) end
        end
        task.wait(0.45)
        if card then card:Destroy() end
    end)

    return card
end

-- ============ WINDOW ============
function DoeakUI.new(opts)
    opts = opts or {}

    local self = setmetatable({}, DoeakUI)
    self.Tabs = {}
    self.CurrentTab = nil
    self.WindowTitle = opts.Title or "doeak-ui"
    self.Keybind = opts.Keybind or Enum.KeyCode.RightShift
    self.Minimized = false
    self.Closed = false

    local W = opts.Width or 620
    local H = opts.Height or 460

    -- GUI ROOT
    local gui = mk("ScreenGui", {
        Name = "DoeakUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.Gui = gui

    -- MAIN FRAME
    local win = mk("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(W, H),
        BackgroundColor3 = Colors.Panel,
        BackgroundTransparency = 0.06,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = gui,
    })
    corner(win, 12)
    stroke(win, Colors.Line2, 1, 0.5)
    self.Frame = win

    -- Top glow
    local glow = mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -80, 0, 1),
        Position = UDim2.new(0, 40, 0, 0),
        Parent = win,
    })
    mk("UIGradient", {
        Parent = glow,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Rose),
            ColorSequenceKeypoint.new(0.5, Colors.Rose2),
            ColorSequenceKeypoint.new(1, Colors.Cyan),
        }),
    })

    -- Corner accents
    mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(44, 1),
        Parent = win,
    })
    mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(1, 44),
        Parent = win,
    })
    mk("Frame", {
        BackgroundColor3 = Colors.Cyan,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(44, 1),
        Position = UDim2.new(1, -44, 1, -1),
        Parent = win,
    })
    mk("Frame", {
        BackgroundColor3 = Colors.Cyan,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(1, 44),
        Position = UDim2.new(1, -1, 1, -44),
        Parent = win,
    })

    -- ===== TITLE BAR =====
    local titleBar = mk("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Colors.Bg,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 44),
        Parent = win,
    })
    mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        Parent = titleBar,
    })

    mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, 14, 0.5, -7),
        Parent = titleBar,
    }):AddChild(mk("UICorner", { CornerRadius = UDim.new(1, 0) }))

    mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(6, 6),
        Position = UDim2.new(0, 18, 0.5, -3),
        Parent = titleBar,
    }):AddChild(mk("UICorner", { CornerRadius = UDim.new(1, 0) }))

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Fonts.Code,
        Text = string.upper(opts.Title or "doeak-ui"),
        TextColor3 = Colors.Ink,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    })

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.4, -80, 1, 0),
        Font = Fonts.Code,
        Text = "// v1.0",
        TextColor3 = Colors.Faint,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = titleBar,
    })

    local minBtn = mk("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -72, 0, 0),
        Size = UDim2.fromOffset(28, 44),
        Font = Fonts.Code,
        Text = "—",
        TextColor3 = Colors.Dim,
        TextSize = 14,
        AutoButtonColor = false,
        Parent = titleBar,
    })
    local closeBtn = mk("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -36, 0, 0),
        Size = UDim2.fromOffset(28, 44),
        Font = Fonts.Code,
        Text = "×",
        TextColor3 = Colors.Dim,
        TextSize = 20,
        AutoButtonColor = false,
        Parent = titleBar,
    })

    minBtn.MouseEnter:Connect(function() tween(minBtn, { TextColor3 = Colors.Ink }, 0.12) end)
    minBtn.MouseLeave:Connect(function() tween(minBtn, { TextColor3 = Colors.Dim }, 0.12) end)
    closeBtn.MouseEnter:Connect(function() tween(closeBtn, { TextColor3 = Colors.Bad }, 0.12) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, { TextColor3 = Colors.Dim }, 0.12) end)

    -- ===== TAB BAR (top, horizontal) =====
    local tabBar = mk("Frame", {
        Name = "TabBar",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.new(1, 0, 0, 34),
        Parent = win,
    })
    local tabList = mk("UIListLayout", { Parent = tabBar })
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 6)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.VerticalAlignment = Enum.VerticalAlignment.Center
    pad(tabBar, 0, 16, 0, 16)

    mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -32, 0, 1),
        Position = UDim2.new(0, 16, 0, 78),
        Parent = win,
    })

    -- ===== CONTENT =====
    local content = mk("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 78),
        Size = UDim2.new(1, 0, 1, -78),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.Line2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = win,
    })
    pad(content, 20, 20, 20, 20)
    vlist(content, 16)
    self.Content = content

    -- ===== DRAG =====
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ===== MINIMIZE =====
    minBtn.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        if self.Minimized then
            tween(win, { Size = UDim2.fromOffset(W, 44) }, 0.22)
            tabBar.Visible = false
            content.Visible = false
            win:FindFirstChildOfClass("Frame")
        else
            tween(win, { Size = UDim2.fromOffset(W, H) }, 0.22)
            tabBar.Visible = true
            content.Visible = true
        end
    end)

    -- ===== CLOSE =====
    closeBtn.MouseButton1Click:Connect(function()
        self.Closed = not self.Closed
        gui.Enabled = not self.Closed
    end)

    -- ===== KEYBIND OPEN/CLOSE =====
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.Keybind then
            self.Closed = not self.Closed
            gui.Enabled = not self.Closed
        end
    end)

    return self
end

-- ============ TAB ============
function DoeakUI:CreateTab(name)
    local self = self
    local tabName = string.upper(name or "TAB")

    local btn = mk("TextButton", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Size = UDim2.fromOffset(0, 26),
        Font = Fonts.Code,
        Text = tabName,
        TextColor3 = Colors.Dim,
        TextSize = 11,
        Parent = self.Frame.TabBar,
    })
    corner(btn, 5)
    local btnStroke = stroke(btn, Colors.Line, 1, 0.7)
    pad(btn, 0, 12, 0, 12)
    btn.AutomaticSize = Enum.AutomaticSize.X

    local page = mk("Frame", {
        Name = "Page_" .. tabName,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content,
    })
    vlist(page, 16)

    local tab = {
        Name = tabName,
        Button = btn,
        Page = page,
        Window = self,
    }

    self.Tabs[tabName] = tab

    if not self.CurrentTab then
        self:_selectTab(tabName)
    end

    btn.MouseButton1Click:Connect(function()
        self:_selectTab(tabName)
    end)
    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabName then
            tween(btn, { TextColor3 = Colors.Rose3, BackgroundTransparency = 0.25 }, 0.12)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabName then
            tween(btn, { TextColor3 = Colors.Dim, BackgroundTransparency = 0.4 }, 0.12)
        end
    end)

    return tab
end

function DoeakUI:_selectTab(name)
    for tabName, t in pairs(self.Tabs) do
        local active = tabName == name
        t.Page.Visible = active
        tween(t.Button, {
            TextColor3 = active and Colors.Ink or Colors.Dim,
            BackgroundColor3 = active and Colors.Rose or Colors.Panel2,
            BackgroundTransparency = active and 0.75 or 0.4,
        }, 0.16)
        tween(t.Button.UIStroke, {
            Color = active and Colors.Rose2 or Colors.Line,
            Transparency = active and 0.3 or 0.7,
        }, 0.16)
    end
    self.CurrentTab = name
end

-- ============ SECTION ============
function DoeakUI:CreateSection(tab, opts)
    opts = opts or {}
    local title = string.upper(opts.Name or "SECTION")
    local index = opts.Index

    local wrap = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = tab.Page,
    })
    vlist(wrap, 10)

    local head = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = wrap,
    })
    local hl = mk("UIListLayout", { Parent = head })
    hl.FillDirection = Enum.FillDirection.Horizontal
    hl.Padding = UDim.new(0, 10)
    hl.VerticalAlignment = Enum.VerticalAlignment.Center

    if index then
        mk("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(22, 18),
            Font = Fonts.Code,
            Text = string.format("%02d", index),
            TextColor3 = Colors.Rose,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = head,
        })
    end

    local lbl = mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Fonts.Code,
        Text = title,
        TextColor3 = Colors.Faint,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = head,
    })

    mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -(lbl.AbsoluteSize.X + (index and 34 or 0) + 20), 0, 1),
        Parent = head,
    })

    local body = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = wrap,
    })
    vlist(body, 8)

    return { Frame = wrap, Body = body, Head = head }
end

-- ============ COMPONENT: BUTTON ============
function DoeakUI:CreateButton(section, opts)
    opts = opts or {}
    local text = opts.Name or "Button"

    local btn = mk("TextButton", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 38),
        Font = Fonts.Mono,
        Text = text,
        TextColor3 = Colors.Ink,
        TextSize = 13,
        Parent = section.Body,
    })
    corner(btn, 6)
    local s = stroke(btn, Colors.Line2, 1, 0.55)

    btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundColor3 = Colors.Rose, BackgroundTransparency = 0.1 }, 0.14)
        tween(s, { Color = Colors.Rose2, Transparency = 0.2 }, 0.14)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundColor3 = Colors.Panel2, BackgroundTransparency = 0.3 }, 0.14)
        tween(s, { Color = Colors.Line2, Transparency = 0.55 }, 0.14)
    end)

    if opts.Callback then
        btn.MouseButton1Click:Connect(function()
            local ok, err = pcall(opts.Callback)
            if not ok then DoeakUI:Notify({ Type = "error", Title = "Error", Text = tostring(err) }) end
        end)
    end
    return btn
end

-- ============ COMPONENT: TOGGLE ============
function DoeakUI:CreateToggle(section, opts)
    opts = opts or {}
    local state = opts.Default or false
    local flag = opts.Flag

    local row = mk("Frame", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        Parent = section.Body,
    })
    corner(row, 6)
    stroke(row, Colors.Line, 1, 0.6)
    pad(row, 0, 14, 0, 14)

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Font = Fonts.Mono,
        Text = opts.Name or "Toggle",
        TextColor3 = Colors.Ink,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local pill = mk("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(42, 22),
        BackgroundColor3 = state and Colors.Rose or Colors.Bg,
        BackgroundTransparency = state and 0 or 0.3,
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(pill, 11)
    local ps = stroke(pill, state and Colors.Rose2 or Colors.Line2, 1, 0.4)

    local knob = mk("Frame", {
        AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
        Position = state and UDim2.new(1, -4, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = state and Colors.Bg or Colors.Ink,
        BorderSizePixel = 0,
        Parent = pill,
    })
    corner(knob, 8)

    local hit = mk("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        Parent = pill,
    })

    local function render()
        local t = state
        knob.AnchorPoint = t and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        tween(knob, {
            Position = t and UDim2.new(1, -4, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
            BackgroundColor3 = t and Colors.Bg or Colors.Ink,
        }, 0.18)
        tween(pill, {
            BackgroundColor3 = t and Colors.Rose or Colors.Bg,
            BackgroundTransparency = t and 0 or 0.3,
        }, 0.18)
        tween(ps, { Color = t and Colors.Rose2 or Colors.Line2 }, 0.18)
    end

    hit.MouseButton1Click:Connect(function()
        state = not state
        if flag then DoeakUI.Flags[flag] = state end
        render()
        if opts.Callback then pcall(opts.Callback, state) end
    end)

    if flag then DoeakUI.Flags[flag] = state end

    local api = {
        Set = function(v)
            state = v and true or false
            if flag then DoeakUI.Flags[flag] = state end
            render()
        end,
        Get = function() return state end,
    }
    table.insert(DoeakUI.Toggles, { api = api, flag = flag })
    return api
end

-- ============ COMPONENT: SLIDER ============
function DoeakUI:CreateSlider(section, opts)
    opts = opts or {}
    local min = opts.Min or 0
    local max = opts.Max or 100
    local val = opts.Default or min
    local decimals = opts.Decimals or 0
    local flag = opts.Flag

    local wrap = mk("Frame", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 56),
        Parent = section.Body,
    })
    corner(wrap, 6)
    stroke(wrap, Colors.Line, 1, 0.6)
    pad(wrap, 10, 14, 10, 14)

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 16),
        Font = Fonts.Mono,
        Text = opts.Name or "Slider",
        TextColor3 = Colors.Ink,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = wrap,
    })

    local valLabel = mk("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(60, 16),
        BackgroundTransparency = 1,
        Font = Fonts.Code,
        Text = tostring(val),
        TextColor3 = Colors.Rose3,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = wrap,
    })

    local track = mk("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Colors.Bg,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = wrap,
    })
    corner(track, 3)

    local fill = mk("Frame", {
        Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Colors.Rose,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(fill, 3)
    mk("UIGradient", {
        Parent = fill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Rose),
            ColorSequenceKeypoint.new(1, Colors.Rose2),
        }),
    })

    local knob = mk("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Colors.Ink,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(knob, 7)

    local dragging = false
    local function updateFromX(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = min + (max - min) * rel
        if decimals == 0 then val = math.floor(val + 0.5)
        else local m = 10 ^ decimals; val = math.floor(val * m + 0.5) / m end
        local t = (val - min) / (max - min)
        fill.Size = UDim2.new(t, 0, 1, 0)
        knob.Position = UDim2.new(t, 0, 0.5, 0)
        valLabel.Text = tostring(val)
        if flag then DoeakUI.Flags[flag] = val end
        if opts.Callback then pcall(opts.Callback, val) end
    end

    local hit = mk("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 20),
        Position = UDim2.new(0, 0, 0, -7),
        Text = "",
        Parent = track,
    })
    hit.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    if flag then DoeakUI.Flags[flag] = val end

    return {
        Set = function(v)
            val = math.clamp(v, min, max)
            local t = (val - min) / (max - min)
            fill.Size = UDim2.new(t, 0, 1, 0)
            knob.Position = UDim2.new(t, 0, 0.5, 0)
            valLabel.Text = tostring(val)
            if flag then DoeakUI.Flags[flag] = val end
        end,
        Get = function() return val end,
    }
end

-- ============ COMPONENT: DROPDOWN ============
function DoeakUI:CreateDropdown(section, opts)
    opts = opts or {}
    local options = opts.Options or {}
    local selected = opts.Default or options[1]
    local flag = opts.Flag
    local expanded = false

    local wrap = mk("Frame", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        Parent = section.Body,
    })
    corner(wrap, 6)
    local ws = stroke(wrap, Colors.Line, 1, 0.6)
    pad(wrap, 0, 14, 0, 14)

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Fonts.Mono,
        Text = opts.Name or "Dropdown",
        TextColor3 = Colors.Ink,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = wrap,
    })

    local valLbl = mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, -20, 1, 0),
        Font = Fonts.Mono,
        Text = tostring(selected) .. "  ▾",
        TextColor3 = Colors.Rose3,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = wrap,
    })

    local hit = mk("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        Parent = wrap,
    })

    local listHolder = mk("Frame", {
        BackgroundColor3 = Colors.Panel,
        Position = UDim2.new(0, 0, 1, 4),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 5,
        Parent = wrap,
    })
    corner(listHolder, 6)
    stroke(listHolder, Colors.Line2, 1, 0.4)

    local list = mk("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Line2,
        ZIndex = 6,
        Parent = listHolder,
    })
    pad(list, 4, 4, 4, 4)
    vlist(list, 2)

    local itemEls = {}
    local function rebuild()
        for _, v in ipairs(itemEls) do v:Destroy() end
        itemEls = {}
        for _, opt in ipairs(options) do
            local o = mk("TextButton", {
                BackgroundColor3 = Colors.Panel2,
                BackgroundTransparency = (opt == selected) and 0.4 or 1,
                Size = UDim2.new(1, 0, 0, 28),
                Font = Fonts.Mono,
                Text = "  " .. tostring(opt),
                TextColor3 = (opt == selected) and Colors.Rose3 or Colors.Ink,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 7,
                Parent = list,
            })
            corner(o, 5)
            o.MouseEnter:Connect(function()
                tween(o, { BackgroundTransparency = 0.7, BackgroundColor3 = Colors.Panel3 }, 0.12)
            end)
            o.MouseLeave:Connect(function()
                tween(o, {
                    BackgroundTransparency = (opt == selected) and 0.4 or 1,
                    BackgroundColor3 = Colors.Panel2,
                }, 0.12)
            end)
            o.MouseButton1Click:Connect(function()
                selected = opt
                valLbl.Text = tostring(opt) .. "  ▾"
                if flag then DoeakUI.Flags[flag] = opt end
                if opts.Callback then pcall(opts.Callback, opt) end
                rebuild()
                expanded = false
                tween(listHolder, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                task.wait(0.2)
                listHolder.Visible = false
            end)
            table.insert(itemEls, o)
        end
    end
    rebuild()

    hit.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            listHolder.Visible = true
            local h = math.min(#options * 30 + 8, 180)
            tween(listHolder, { Size = UDim2.new(1, 0, 0, h) }, 0.22)
            tween(ws, { Color = Colors.Rose }, 0.16)
        else
            tween(listHolder, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
            task.wait(0.18)
            listHolder.Visible = false
            tween(ws, { Color = Colors.Line }, 0.16)
        end
    end)

    if flag then DoeakUI.Flags[flag] = selected end

    local api = {
        Get = function() return selected end,
        Refresh = function(newOptions)
            options = newOptions
            rebuild()
        end,
    }
    table.insert(DoeakUI.Options, { api = api, flag = flag })
    return api
end

-- ============ COMPONENT: INPUT ============
function DoeakUI:CreateInput(section, opts)
    opts = opts or {}
    local flag = opts.Flag

    local wrap = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = section.Body,
    })
    vlist(wrap, 6)

    if opts.Name then
        mk("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Font = Fonts.Code,
            Text = "// " .. string.upper(opts.Name),
            TextColor3 = Colors.Faint,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = wrap,
        })
    end

    local box = mk("Frame", {
        BackgroundColor3 = Colors.Bg,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = wrap,
    })
    corner(box, 6)
    local s = stroke(box, Colors.Line2, 1, 0.55)
    pad(box, 0, 14, 0, 14)

    local input = mk("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = Fonts.Code,
        PlaceholderText = opts.Placeholder or "...",
        PlaceholderColor3 = Colors.Faint,
        Text = opts.Default or "",
        TextColor3 = Colors.Ink,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = box,
    })

    input.Focused:Connect(function()
        tween(s, { Color = Colors.Rose, Transparency = 0.15 }, 0.14)
        tween(box, { BackgroundTransparency = 0.15 }, 0.14)
    end)
    input.FocusLost:Connect(function()
        tween(s, { Color = Colors.Line2, Transparency = 0.55 }, 0.14)
        tween(box, { BackgroundTransparency = 0.35 }, 0.14)
        if flag then DoeakUI.Flags[flag] = input.Text end
        if opts.Callback then pcall(opts.Callback, input.Text) end
    end)

    if flag then DoeakUI.Flags[flag] = input.Text end
    return input
end

-- ============ COMPONENT: KEYBIND ============
function DoeakUI:CreateKeybind(section, opts)
    opts = opts or {}
    local current = opts.Default or Enum.KeyCode.E
    local flag = opts.Flag
    local listening = false

    local row = mk("Frame", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        Parent = section.Body,
    })
    corner(row, 6)
    stroke(row, Colors.Line, 1, 0.6)
    pad(row, 0, 14, 0, 14)

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Fonts.Mono,
        Text = opts.Name or "Keybind",
        TextColor3 = Colors.Ink,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local valBtn = mk("TextButton", {
        BackgroundColor3 = Colors.Bg,
        Position = UDim2.new(1, -110, 0.5, -13),
        Size = UDim2.fromOffset(110, 26),
        Font = Fonts.Code,
        Text = current.Name,
        TextColor3 = Colors.Rose3,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = row,
    })
    corner(valBtn, 5)
    stroke(valBtn, Colors.Line2, 1, 0.5)

    valBtn.MouseEnter:Connect(function() tween(valBtn, { BackgroundColor3 = Colors.Panel3 }, 0.14) end)
    valBtn.MouseLeave:Connect(function() tween(valBtn, { BackgroundColor3 = Colors.Bg }, 0.14) end)

    local conn
    valBtn.MouseButton1Click:Connect(function()
        listening = true
        valBtn.Text = "..."
        if conn then conn:Disconnect() end
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                current = input.KeyCode
                valBtn.Text = current.Name
                listening = false
                conn:Disconnect()
                if flag then DoeakUI.Flags[flag] = current end
                if opts.Callback then pcall(opts.Callback, current) end
                if opts.OnPressed then
                    UserInputService.InputBegan:Connect(function(i, g)
                        if not g and i.KeyCode == current then pcall(opts.OnPressed) end
                    end)
                end
            end
        end)
    end)

    if flag then DoeakUI.Flags[flag] = current end

    -- Press handler
    if opts.OnPressed then
        UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and input.KeyCode == current then
                pcall(opts.OnPressed)
            end
        end)
    end

    return {
        Set = function(k)
            current = k
            valBtn.Text = k.Name
            if flag then DoeakUI.Flags[flag] = k end
        end,
        Get = function() return current end,
    }
end

-- ============ COMPONENT: LABEL ============
function DoeakUI:CreateLabel(section, opts)
    opts = opts or {}
    local lbl = mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Fonts.Mono,
        Text = opts.Text or "",
        TextColor3 = opts.Color or Colors.Dim,
        TextSize = opts.Size or 12,
        TextWrapped = true,
        TextXAlignment = opts.Align or Enum.TextXAlignment.Left,
        Parent = section.Body,
    })
    return lbl
end

-- ============ COMPONENT: DIVIDER ============
function DoeakUI:CreateDivider(section)
    return mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Parent = section.Body,
    })
end

-- ============ CONFIG ============
function DoeakUI:SaveConfig(name)
    if not name or name == "" then
        return DoeakUI:Notify({ Type = "error", Title = "Config", Text = "Tên config trống" })
    end
    local data = {}
    for k, v in pairs(DoeakUI.Flags) do
        if typeof(v) == "EnumItem" then
            data[k] = { __type = "EnumItem", value = v.Name, enum = tostring(v.EnumType) }
        else
            data[k] = v
        end
    end
    local json = HttpService:JSONEncode(data)
    if writefile then
        pcall(writefile, "DoeakUI_" .. name .. ".json", json)
        DoeakUI:Notify({ Type = "success", Title = "Config", Text = "Đã lưu: " .. name })
    else
        DoeakUI:Notify({ Type = "warn", Title = "Config", Text = "Executor không hỗ trợ writefile" })
    end
end

function DoeakUI:LoadConfig(name)
    if not isfile or not readfile then
        return DoeakUI:Notify({ Type = "warn", Title = "Config", Text = "Executor không hỗ trợ đọc file" })
    end
    if not isfile("DoeakUI_" .. name .. ".json") then
        return DoeakUI:Notify({ Type = "error", Title = "Config", Text = "Không tìm thấy: " .. name })
    end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile("DoeakUI_" .. name .. ".json"))
    end)
    if not ok then
        return DoeakUI:Notify({ Type = "error", Title = "Config", Text = "File hỏng" })
    end
    for k, v in pairs(decoded) do
        if type(v) == "table" and v.__type == "EnumItem" then
            local ok2, e = pcall(function()
                return Enum[v.enum][v.value]
            end)
            if ok2 then DoeakUI.Flags[k] = e end
        else
            DoeakUI.Flags[k] = v
        end
    end
    for _, t in ipairs(DoeakUI.Toggles) do
        if t.flag then t.api.Set(DoeakUI.Flags[t.flag]) end
    end
    DoeakUI:Notify({ Type = "success", Title = "Config", Text = "Đã nạp: " .. name })
end

function DoeakUI:ListConfigs()
    if not listfiles then
        DoeakUI:Notify({ Type = "warn", Title = "Config", Text = "Executor không hỗ trợ listfiles" })
        return {}
    end
    local files = {}
    for _, f in ipairs(listfiles("")) do
        local m = f:match("DoeakUI_(.+)%.json")
        if m then table.insert(files, m) end
    end
    return files
end

-- ============ TOGGLE UI ============
function DoeakUI:Toggle()
    if not self.Gui then return end
    self.Closed = not self.Closed
    self.Gui.Enabled = not self.Closed
end

function DoeakUI:SetKeybind(key)
    self.Keybind = key
end

return DoeakUI