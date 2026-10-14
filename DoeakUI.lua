--[[
    DoeakUI v1.2
    Style: WindUI structure + rose-tech theme
    Fix: Remove AddChild, use Parent assignment
    New: Sidebar tabs, notification countdown, smooth animations
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

local function hlist(parent, gap)
    local l = mk("UIListLayout", { Parent = parent })
    l.FillDirection = Enum.FillDirection.Horizontal
    l.Padding = UDim.new(0, gap or 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    return l
end

local function tw(inst, props, time, style, dir)
    local t = TweenService:Create(
        inst,
        TweenInfo.new(time or 0.16, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
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

-- ============ NOTIFICATION SYSTEM ============
local NotifGui
local NotifHolder
local function ensureNotifGui()
    if NotifGui and NotifGui.Parent then return end
    NotifGui = mk("ScreenGui", {
        Name = "DoeakUI_Notifs",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
    })
    pcall(function() NotifGui.Parent = game:GetService("CoreGui") end)
    if not NotifGui.Parent then NotifGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    NotifHolder = mk("Frame", {
        Name = "Holder",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -20, 0, 20),
        Size = UDim2.fromOffset(320, 500),
        BackgroundTransparency = 1,
        Parent = NotifGui,
    })
    local l = vlist(NotifHolder, 10)
    l.VerticalAlignment = Enum.VerticalAlignment.Top
    l.HorizontalAlignment = Enum.HorizontalAlignment.Right
end

function DoeakUI:Notify(opts)
    opts = opts or {}
    ensureNotifGui()

    local kind = opts.Type or "info"
    local accent = Colors.Rose
    if kind == "success" then accent = Colors.Good end
    if kind == "warn" then accent = Colors.Warn end
    if kind == "error" then accent = Colors.Bad end

    local dur = opts.Duration or 4

    -- Card
    local card = mk("Frame", {
        BackgroundColor3 = Colors.Panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    corner(card, 10)
    local cardStroke = stroke(card, Colors.Line2, 1, 0.5)

    -- Accent bar left
    local accentBar = mk("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = card,
    })
    corner(accentBar, 10)

    -- Content padding
    pad(card, 14, 16, 14, 20)

    local contentWrap = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    vlist(contentWrap, 6)

    -- Title
    local titleLabel = mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Font = Fonts.Code,
        Text = "// " .. string.upper(opts.Title or kind),
        TextColor3 = accent,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = contentWrap,
    })

    -- Body
    local bodyLabel = mk("TextLabel", {
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
        Parent = contentWrap,
    })

    -- Countdown bar (bottom)
    local cdTrack = mk("Frame", {
        BackgroundColor3 = Colors.Bg,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, 2),
        AnchorPoint = Vector2.new(0, 1),
        Parent = card,
    })
    local cdFill = mk("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = cdTrack,
    })
    corner(cdFill, 1)
    local cdGrad = mk("UIGradient", { Parent = cdFill })
    cdGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accent),
        ColorSequenceKeypoint.new(1, accent),
    })

    -- Entry animation: slide in from right
    card.Position = UDim2.new(1, 340, 0, 0)
    tw(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.32, Enum.EasingStyle.Quart)
    tw(card, { BackgroundTransparency = 0.1 }, 0.3)

    -- Countdown animation
    tw(cdFill, { Size = UDim2.new(0, 0, 1, 0) }, dur, Enum.EasingStyle.Linear)

    -- Exit
    task.delay(dur, function()
        if not card or not card.Parent then return end

        -- Slide out
        tw(card, { Position = UDim2.new(1, 340, 0, 0), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Quart)
        tw(cardStroke, { Transparency = 1 }, 0.3)
        tw(titleLabel, { TextTransparency = 1 }, 0.25)
        tw(bodyLabel, { TextTransparency = 1 }, 0.25)
        tw(accentBar, { BackgroundTransparency = 1 }, 0.3)
        tw(cdTrack, { BackgroundTransparency = 1 }, 0.3)
        tw(cdFill, { BackgroundTransparency = 1 }, 0.3)

        task.wait(0.4)
        if card then card:Destroy() end
    end)

    return card
end

-- ============ WINDOW ============
function DoeakUI.new(opts)
    opts = opts or {}
    local self = setmetatable({}, DoeakUI)
    self.Tabs = {}
    self.TabOrder = {}
    self.CurrentTab = nil
    self.WindowTitle = opts.Title or "doeak-ui"
    self.Keybind = opts.Keybind or Enum.KeyCode.RightShift
    self.Minimized = false
    self.Closed = false

    local W = opts.Width or 660
    local H = opts.Height or 470
    local SIDEBAR_W = 150

    -- ROOT GUI
    local gui = mk("ScreenGui", {
        Name = "DoeakUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.Gui = gui

    -- MAIN WINDOW
    local win = mk("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(W, H),
        BackgroundColor3 = Colors.Panel,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = gui,
    })
    corner(win, 12)
    stroke(win, Colors.Line2, 1, 0.5)
    self.Frame = win
    self.BaseSize = UDim2.fromOffset(W, H)

    -- Top glow line
    local glow = mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -100, 0, 1),
        Position = UDim2.new(0, 50, 0, 0),
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
    local tl1 = mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(40, 1),
        Parent = win,
    })
    local tl2 = mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(1, 40),
        Parent = win,
    })
    local br1 = mk("Frame", {
        BackgroundColor3 = Colors.Cyan,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(40, 1),
        Position = UDim2.new(1, -40, 1, -1),
        Parent = win,
    })
    local br2 = mk("Frame", {
        BackgroundColor3 = Colors.Cyan,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(1, 40),
        Position = UDim2.new(1, -1, 1, -40),
        Parent = win,
    })

    -- ===== TITLE BAR =====
    local titleBar = mk("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Colors.Bg,
        BackgroundTransparency = 0.4,
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

    -- Logo glow
    local dotGlow = mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, 14, 0.5, -7),
        Parent = titleBar,
    })
    corner(dotGlow, 7)

    local dot = mk("Frame", {
        BackgroundColor3 = Colors.Rose,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(6, 6),
        Position = UDim2.new(0, 18, 0.5, -3),
        Parent = titleBar,
    })
    corner(dot, 3)

    -- Title text
    mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Fonts.Code,
        Text = string.upper(self.WindowTitle),
        TextColor3 = Colors.Ink,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    })

    -- Version
    mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = Fonts.Code,
        Text = "// v1.2",
        TextColor3 = Colors.Faint,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = titleBar,
    })

    -- Control buttons
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

    minBtn.MouseEnter:Connect(function() tw(minBtn, { TextColor3 = Colors.Ink }, 0.12) end)
    minBtn.MouseLeave:Connect(function() tw(minBtn, { TextColor3 = Colors.Dim }, 0.12) end)
    closeBtn.MouseEnter:Connect(function() tw(closeBtn, { TextColor3 = Colors.Bad }, 0.12) end)
    closeBtn.MouseLeave:Connect(function() tw(closeBtn, { TextColor3 = Colors.Dim }, 0.12) end)

    -- ===== SIDEBAR =====
    local sidebar = mk("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.fromOffset(SIDEBAR_W, H - 44),
        Parent = win,
    })
    self.Sidebar = sidebar

    -- Sidebar right border
    mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        Parent = sidebar,
    })

    -- Sidebar header
    local sidebarHeader = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = sidebar,
    })
    pad(sidebarHeader, 0, 14, 0, 14)

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Fonts.Code,
        Text = "// TABS",
        TextColor3 = Colors.Faint,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebarHeader,
    })

    -- Divider
    mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -28, 0, 1),
        Position = UDim2.new(0, 14, 0, 30),
        Parent = sidebar,
    })

    -- Tab list
    local tabList = mk("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 32),
        Size = UDim2.new(1, 0, 1, -32),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Line2,
        Parent = sidebar,
    })
    pad(tabList, 10, 10, 10, 10)
    vlist(tabList, 4)
    self.TabList = tabList

    -- ===== CONTENT AREA =====
    local content = mk("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, SIDEBAR_W, 0, 44),
        Size = UDim2.new(1, -SIDEBAR_W, 1, -44),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.Line2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = win,
    })
    pad(content, 18, 18, 18, 18)
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
            win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
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
            tw(win, { Size = UDim2.fromOffset(W, 44) }, 0.28, Enum.EasingStyle.Quart)
            tw(sidebar, { BackgroundTransparency = 1 }, 0.2)
            tw(content, { BackgroundTransparency = 1 }, 0.2)
            minBtn.Text = "+"
        else
            tw(win, { Size = UDim2.fromOffset(W, H) }, 0.28, Enum.EasingStyle.Quart)
            tw(sidebar, { BackgroundTransparency = 0.35 }, 0.2)
            minBtn.Text = "−"
        end
    end)

    -- ===== CLOSE =====
    closeBtn.MouseButton1Click:Connect(function()
        self.Closed = not self.Closed
        gui.Enabled = not self.Closed
    end)

    -- ===== KEYBIND =====
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.Keybind then
            self.Closed = not self.Closed
            gui.Enabled = not self.Closed
        end
    end)

    -- ===== METHODS =====
    function self:CreateTab(name)
        local tabName = string.upper(name or "TAB")

        -- Sidebar button
        local btn = mk("TextButton", {
            BackgroundColor3 = Colors.Rose,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Fonts.Mono,
            Text = "  " .. tabName,
            TextColor3 = Colors.Dim,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabList,
        })
        corner(btn, 6)

        -- Active indicator
        local indicator = mk("Frame", {
            BackgroundColor3 = Colors.Rose,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(3, 16),
            Position = UDim2.new(0, 0, 0.5, -8),
            Visible = false,
            Parent = btn,
        })
        corner(indicator, 2)

        -- Page
        local page = mk("Frame", {
            Name = "Page_" .. tabName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = content,
        })
        vlist(page, 14)

        local tab = {
            Name = tabName,
            Button = btn,
            Indicator = indicator,
            Page = page,
            Window = self,
        }
        self.Tabs[tabName] = tab
        table.insert(self.TabOrder, tabName)

        if not self.CurrentTab then
            self:_selectTab(tabName)
        end

        btn.MouseButton1Click:Connect(function()
            self:_selectTab(tabName)
        end)
        btn.MouseEnter:Connect(function()
            if self.CurrentTab ~= tabName then
                tw(btn, { TextColor3 = Colors.Rose3, BackgroundTransparency = 0.85, BackgroundColor3 = Colors.Rose }, 0.14)
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.CurrentTab ~= tabName then
                tw(btn, { TextColor3 = Colors.Dim, BackgroundTransparency = 1 }, 0.14)
            end
        end)

        return tab
    end

    function self:_selectTab(name)
        for tabName, t in pairs(self.Tabs) do
            local active = tabName == name
            t.Page.Visible = active
            t.Indicator.Visible = active
            tw(t.Button, {
                TextColor3 = active and Colors.Ink or Colors.Dim,
                BackgroundColor3 = Colors.Rose,
                BackgroundTransparency = active and 0.82 or 1,
            }, 0.16)
        end
        self.CurrentTab = name
    end

    function self:Destroy()
        gui:Destroy()
    end

    function self:Toggle()
        self.Closed = not self.Closed
        gui.Enabled = not self.Closed
    end

    return self
end

-- ============ SECTION ============
function DoeakUI.CreateSection(tab, opts)
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

    -- Header
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
            Size = UDim2.fromOffset(24, 18),
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

    -- Line after label
    local line = mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -(lbl.AbsoluteSize.X + (index and 34 or 0) + 20), 0, 1),
        Parent = head,
    })

    -- Body
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
function DoeakUI.CreateButton(section, opts)
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
        tw(btn, { BackgroundColor3 = Colors.Rose, BackgroundTransparency = 0.1 }, 0.16)
        tw(s, { Color = Colors.Rose2, Transparency = 0.2 }, 0.16)
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, { BackgroundColor3 = Colors.Panel2, BackgroundTransparency = 0.3 }, 0.16)
        tw(s, { Color = Colors.Line2, Transparency = 0.55 }, 0.16)
    end)
    btn.MouseButton1Down:Connect(function()
        tw(btn, { Size = UDim2.new(0.98, 0, 0, 36) }, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        tw(btn, { Size = UDim2.new(1, 0, 0, 38) }, 0.14, Enum.EasingStyle.Back)
    end)

    if opts.Callback then
        btn.MouseButton1Click:Connect(function()
            local ok, err = pcall(opts.Callback)
            if not ok then
                DoeakUI:Notify({ Type = "error", Title = "Error", Text = tostring(err) })
            end
        end)
    end
    return btn
end

-- ============ COMPONENT: TOGGLE ============
function DoeakUI.CreateToggle(section, opts)
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
        tw(knob, {
            Position = t and UDim2.new(1, -4, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
            BackgroundColor3 = t and Colors.Bg or Colors.Ink,
        }, 0.22, Enum.EasingStyle.Quart)
        tw(pill, {
            BackgroundColor3 = t and Colors.Rose or Colors.Bg,
            BackgroundTransparency = t and 0 or 0.3,
        }, 0.22)
        tw(ps, { Color = t and Colors.Rose2 or Colors.Line2 }, 0.22)
    end

    hit.MouseButton1Click:Connect(function()
        state = not state
        if flag then DoeakUI.Flags[flag] = state end
        render()
        if opts.Callback then pcall(opts.Callback, state) end
    end)

    if flag then DoeakUI.Flags[flag] = state end

    return {
        Set = function(v)
            state = v and true or false
            if flag then DoeakUI.Flags[flag] = state end
            render()
        end,
        Get = function() return state end,
    }
end

-- ============ COMPONENT: SLIDER ============
function DoeakUI.CreateSlider(section, opts)
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
        Size = UDim2.new(1, 0, 0, 58),
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
    stroke(knob, Colors.Rose, 2, 0.2)

    local dragging = false
    local function updateFromX(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = min + (max - min) * rel
        if decimals == 0 then
            val = math.floor(val + 0.5)
        else
            local m = 10 ^ decimals
            val = math.floor(val * m + 0.5) / m
        end
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
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
function DoeakUI.CreateDropdown(section, opts)
    opts = opts or {}
    local options = opts.Options or {}
    local selected = opts.Default or options[1]
    local flag = opts.Flag
    local expanded = false

    local ITEM_H = 28
    local ITEM_GAP = 2
    local LIST_PAD = 4

    local wrap = mk("Frame", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        ClipsDescendants = false,
        Parent = section.Body,
    })
    corner(wrap, 6)
    local ws = stroke(wrap, Colors.Line, 1, 0.6)
    pad(wrap, 0, 14, 0, 14)

    -- Header
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

    -- Dropdown list (below wrap)
    local listHolder = mk("Frame", {
        BackgroundColor3 = Colors.Panel,
        Position = UDim2.new(0, 0, 1, 4),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
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
        ZIndex = 11,
        Parent = listHolder,
    })
    pad(list, LIST_PAD, LIST_PAD, LIST_PAD, LIST_PAD)
    vlist(list, ITEM_GAP)

    local itemEls = {}
    local function rebuild()
        for _, v in ipairs(itemEls) do
            v:Destroy()
        end
        itemEls = {}
        for _, opt in ipairs(options) do
            local o = mk("TextButton", {
                BackgroundColor3 = Colors.Panel2,
                BackgroundTransparency = (opt == selected) and 0.4 or 1,
                Size = UDim2.new(1, 0, 0, ITEM_H),
                Font = Fonts.Mono,
                Text = "  " .. tostring(opt),
                TextColor3 = (opt == selected) and Colors.Rose3 or Colors.Ink,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 12,
                Parent = list,
            })
            corner(o, 5)
            o.MouseEnter:Connect(function()
                tw(o, { BackgroundTransparency = 0.7, BackgroundColor3 = Colors.Panel3 }, 0.12)
            end)
            o.MouseLeave:Connect(function()
                tw(o, {
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
                tw(listHolder, { Size = UDim2.new(1, 0, 0, 0) }, 0.24, Enum.EasingStyle.Quart)
                tw(ws, { Color = Colors.Line }, 0.16)
                task.wait(0.24)
                listHolder.Visible = false
            end)
            table.insert(itemEls, o)
        end
    end
    rebuild()

    hit.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            local h = math.min(#options * (ITEM_H + ITEM_GAP) + LIST_PAD * 2 - ITEM_GAP, 180)
            listHolder.Visible = true
            listHolder.Size = UDim2.new(1, 0, 0, 0)
            tw(listHolder, { Size = UDim2.new(1, 0, 0, h) }, 0.28, Enum.EasingStyle.Quart)
            tw(ws, { Color = Colors.Rose }, 0.18)
        else
            tw(listHolder, { Size = UDim2.new(1, 0, 0, 0) }, 0.24, Enum.EasingStyle.Quart)
            tw(ws, { Color = Colors.Line }, 0.18)
            task.wait(0.24)
            listHolder.Visible = false
        end
    end)

    if flag then DoeakUI.Flags[flag] = selected end

    return {
        Get = function() return selected end,
        Refresh = function(newOptions)
            options = newOptions
            rebuild()
        end,
    }
end

-- ============ COMPONENT: INPUT ============
function DoeakUI.CreateInput(section, opts)
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
        tw(s, { Color = Colors.Rose, Transparency = 0.15 }, 0.16)
        tw(box, { BackgroundTransparency = 0.15 }, 0.16)
    end)
    input.FocusLost:Connect(function()
        tw(s, { Color = Colors.Line2, Transparency = 0.55 }, 0.16)
        tw(box, { BackgroundTransparency = 0.35 }, 0.16)
        if flag then DoeakUI.Flags[flag] = input.Text end
        if opts.Callback then pcall(opts.Callback, input.Text) end
    end)

    if flag then DoeakUI.Flags[flag] = input.Text end
    return input
end

-- ============ COMPONENT: KEYBIND ============
function DoeakUI.CreateKeybind(section, opts)
    opts = opts or {}
    local current = opts.Default or Enum.KeyCode.E
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

    valBtn.MouseEnter:Connect(function()
        tw(valBtn, { BackgroundColor3 = Colors.Panel3 }, 0.14)
    end)
    valBtn.MouseLeave:Connect(function()
        tw(valBtn, { BackgroundColor3 = Colors.Bg }, 0.14)
    end)

    local conn
    valBtn.MouseButton1Click:Connect(function()
        valBtn.Text = "..."
        if conn then conn:Disconnect() end
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                current = input.KeyCode
                valBtn.Text = current.Name
                conn:Disconnect()
                if flag then DoeakUI.Flags[flag] = current end
                if opts.Callback then pcall(opts.Callback, current) end
            end
        end)
    end)

    if flag then DoeakUI.Flags[flag] = current end

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
function DoeakUI.CreateLabel(section, opts)
    opts = opts or {}
    return mk("TextLabel", {
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
end

-- ============ COMPONENT: DIVIDER ============
function DoeakUI.CreateDivider(section)
    return mk("Frame", {
        BackgroundColor3 = Colors.Line,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Parent = section.Body,
    })
end

-- ============ COMPONENT: PROGRESSBAR ============
function DoeakUI.CreateProgressBar(section, opts)
    opts = opts or {}
    local min = opts.Min or 0
    local max = opts.Max or 100
    local val = opts.Default or min

    local wrap = mk("Frame", {
        BackgroundColor3 = Colors.Panel2,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = section.Body,
    })
    corner(wrap, 6)
    stroke(wrap, Colors.Line, 1, 0.6)
    pad(wrap, 10, 14, 10, 14)

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 16),
        Font = Fonts.Mono,
        Text = opts.Name or "Progress",
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
        Text = "0%",
        TextColor3 = Colors.Rose3,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = wrap,
    })

    local track = mk("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = Colors.Bg,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = wrap,
    })
    corner(track, 4)

    local fill = mk("Frame", {
        Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Colors.Rose,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(fill, 4)
    mk("UIGradient", {
        Parent = fill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Rose),
            ColorSequenceKeypoint.new(1, Colors.Rose2),
        }),
    })

    local function render()
        local t = (val - min) / (max - min)
        tw(fill, { Size = UDim2.new(t, 0, 1, 0) }, 0.3, Enum.EasingStyle.Quart)
        valLabel.Text = tostring(math.floor(t * 100)) .. "%"
    end
    render()

    return {
        Set = function(v)
            val = math.clamp(v, min, max)
            render()
            if opts.Callback then pcall(opts.Callback, val) end
        end,
        Get = function() return val end,
    }
end

return DoeakUI
