--[[
    DoeakUI v2.0
    Style: rose-tech, larger text, key system, runtime themes
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- THEMES
-- ============================================================
local Themes = {
    Rose = {
        Bg      = Color3.fromRGB(10, 7, 11),
        Panel   = Color3.fromRGB(22, 15, 22),
        Panel2  = Color3.fromRGB(32, 20, 30),
        Panel3  = Color3.fromRGB(42, 26, 40),
        Line    = Color3.fromRGB(75, 40, 50),
        Line2   = Color3.fromRGB(115, 60, 80),
        Ink     = Color3.fromRGB(240, 236, 239),
        Dim     = Color3.fromRGB(170, 150, 158),
        Faint   = Color3.fromRGB(120, 105, 112),
        Accent  = Color3.fromRGB(244, 63, 94),
        Accent2 = Color3.fromRGB(251, 113, 133),
        Accent3 = Color3.fromRGB(253, 164, 175),
        Cyan    = Color3.fromRGB(34, 211, 238),
        Good    = Color3.fromRGB(52, 211, 153),
        Warn    = Color3.fromRGB(251, 191, 36),
        Bad     = Color3.fromRGB(248, 113, 113),
    },
    Ocean = {
        Bg      = Color3.fromRGB(7, 10, 18),
        Panel   = Color3.fromRGB(15, 22, 34),
        Panel2  = Color3.fromRGB(22, 32, 48),
        Panel3  = Color3.fromRGB(30, 42, 60),
        Line    = Color3.fromRGB(40, 60, 90),
        Line2   = Color3.fromRGB(60, 90, 130),
        Ink     = Color3.fromRGB(230, 240, 250),
        Dim     = Color3.fromRGB(145, 165, 190),
        Faint   = Color3.fromRGB(100, 120, 145),
        Accent  = Color3.fromRGB(14, 165, 233),
        Accent2 = Color3.fromRGB(56, 189, 248),
        Accent3 = Color3.fromRGB(125, 211, 252),
        Cyan    = Color3.fromRGB(167, 139, 250),
        Good    = Color3.fromRGB(34, 211, 238),
        Warn    = Color3.fromRGB(251, 191, 36),
        Bad     = Color3.fromRGB(248, 113, 113),
    },
    Forest = {
        Bg      = Color3.fromRGB(8, 12, 9),
        Panel   = Color3.fromRGB(16, 26, 18),
        Panel2  = Color3.fromRGB(22, 36, 25),
        Panel3  = Color3.fromRGB(30, 48, 34),
        Line    = Color3.fromRGB(40, 70, 45),
        Line2   = Color3.fromRGB(60, 100, 68),
        Ink     = Color3.fromRGB(230, 245, 232),
        Dim     = Color3.fromRGB(150, 180, 155),
        Faint   = Color3.fromRGB(100, 130, 105),
        Accent  = Color3.fromRGB(16, 185, 129),
        Accent2 = Color3.fromRGB(52, 211, 153),
        Accent3 = Color3.fromRGB(110, 231, 183),
        Cyan    = Color3.fromRGB(251, 191, 36),
        Good    = Color3.fromRGB(52, 211, 153),
        Warn    = Color3.fromRGB(251, 191, 36),
        Bad     = Color3.fromRGB(248, 113, 113),
    },
    Sunset = {
        Bg      = Color3.fromRGB(15, 8, 8),
        Panel   = Color3.fromRGB(28, 14, 12),
        Panel2  = Color3.fromRGB(40, 20, 16),
        Panel3  = Color3.fromRGB(52, 28, 22),
        Line    = Color3.fromRGB(80, 40, 30),
        Line2   = Color3.fromRGB(120, 60, 40),
        Ink     = Color3.fromRGB(250, 240, 235),
        Dim     = Color3.fromRGB(190, 155, 140),
        Faint   = Color3.fromRGB(140, 110, 100),
        Accent  = Color3.fromRGB(249, 115, 22),
        Accent2 = Color3.fromRGB(251, 146, 60),
        Accent3 = Color3.fromRGB(253, 186, 116),
        Cyan    = Color3.fromRGB(244, 63, 94),
        Good    = Color3.fromRGB(52, 211, 153),
        Warn    = Color3.fromRGB(251, 191, 36),
        Bad     = Color3.fromRGB(248, 113, 113),
    },
    Lavender = {
        Bg      = Color3.fromRGB(10, 8, 15),
        Panel   = Color3.fromRGB(20, 16, 28),
        Panel2  = Color3.fromRGB(30, 24, 40),
        Panel3  = Color3.fromRGB(42, 34, 56),
        Line    = Color3.fromRGB(60, 48, 80),
        Line2   = Color3.fromRGB(90, 72, 120),
        Ink     = Color3.fromRGB(238, 234, 245),
        Dim     = Color3.fromRGB(170, 155, 190),
        Faint   = Color3.fromRGB(120, 108, 145),
        Accent  = Color3.fromRGB(168, 85, 247),
        Accent2 = Color3.fromRGB(192, 132, 252),
        Accent3 = Color3.fromRGB(216, 180, 254),
        Cyan    = Color3.fromRGB(34, 211, 238),
        Good    = Color3.fromRGB(52, 211, 153),
        Warn    = Color3.fromRGB(251, 191, 36),
        Bad     = Color3.fromRGB(248, 113, 113),
    },
    Mono = {
        Bg      = Color3.fromRGB(8, 8, 9),
        Panel   = Color3.fromRGB(18, 18, 20),
        Panel2  = Color3.fromRGB(28, 28, 30),
        Panel3  = Color3.fromRGB(40, 40, 42),
        Line    = Color3.fromRGB(60, 60, 62),
        Line2   = Color3.fromRGB(90, 90, 92),
        Ink     = Color3.fromRGB(235, 235, 238),
        Dim     = Color3.fromRGB(160, 160, 165),
        Faint   = Color3.fromRGB(110, 110, 115),
        Accent  = Color3.fromRGB(229, 231, 235),
        Accent2 = Color3.fromRGB(243, 244, 246),
        Accent3 = Color3.fromRGB(250, 250, 252),
        Cyan    = Color3.fromRGB(156, 163, 175),
        Good    = Color3.fromRGB(52, 211, 153),
        Warn    = Color3.fromRGB(251, 191, 36),
        Bad     = Color3.fromRGB(248, 113, 113),
    },
    Cyber = {
        Bg      = Color3.fromRGB(8, 10, 8),
        Panel   = Color3.fromRGB(18, 22, 14),
        Panel2  = Color3.fromRGB(28, 34, 20),
        Panel3  = Color3.fromRGB(40, 48, 28),
        Line    = Color3.fromRGB(70, 80, 35),
        Line2   = Color3.fromRGB(105, 120, 50),
        Ink     = Color3.fromRGB(245, 245, 230),
        Dim     = Color3.fromRGB(180, 180, 145),
        Faint   = Color3.fromRGB(130, 130, 105),
        Accent  = Color3.fromRGB(234, 179, 8),
        Accent2 = Color3.fromRGB(250, 204, 21),
        Accent3 = Color3.fromRGB(254, 240, 138),
        Cyan    = Color3.fromRGB(236, 72, 153),
        Good    = Color3.fromRGB(52, 211, 153),
        Warn    = Color3.fromRGB(251, 191, 36),
        Bad     = Color3.fromRGB(248, 113, 113),
    },
}

local CurrentTheme = "Rose"
local C = Themes[CurrentTheme]

local Fonts = {
    Mono = Enum.Font.RobotoMono,
    Code = Enum.Font.Code,
    Sans = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
}

-- ============================================================
-- HELPERS
-- ============================================================
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
    return mk("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent })
end

local function stroke(parent, color, thickness, transparency)
    return mk("UIStroke", {
        Color = color or C.Line2,
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
    l.Padding = UDim.new(0, gap or 8)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

local function tw(inst, props, time, style, dir)
    local t = TweenService:Create(
        inst,
        TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

-- ============================================================
-- THEME REGISTRY (for runtime swap)
-- ============================================================
local Registry = {
    frames = {},     -- {inst=, key="Panel"}  -- key maps to C[key]
    strokes = {},    -- {inst=, key="Line2"}
    texts = {},      -- {inst=, key="Ink"}
    corners = {},
}

local function regFrame(inst, key)
    table.insert(Registry.frames, { inst = inst, key = key })
    inst.BackgroundColor3 = C[key]
    return inst
end

local function regStroke(inst, key)
    table.insert(Registry.strokes, { inst = inst, key = key })
    inst.Color = C[key]
    return inst
end

local function regText(inst, key)
    table.insert(Registry.texts, { inst = inst, key = key })
    inst.TextColor3 = C[key]
    return inst
end

local function clearRegistry()
    Registry.frames = {}
    Registry.strokes = {}
    Registry.texts = {}
end

local function applyTheme(name)
    if not Themes[name] then return end
    CurrentTheme = name
    C = Themes[name]

    for _, e in ipairs(Registry.frames) do
        if e.inst and e.inst.Parent then
            tw(e.inst, { BackgroundColor3 = C[e.key] }, 0.28)
        end
    end
    for _, e in ipairs(Registry.strokes) do
        if e.inst and e.inst.Parent then
            tw(e.inst, { Color = C[e.key] }, 0.28)
        end
    end
    for _, e in ipairs(Registry.texts) do
        if e.inst and e.inst.Parent then
            tw(e.inst, { TextColor3 = C[e.key] }, 0.28)
        end
    end
end

-- ============================================================
-- LIBRARY
-- ============================================================
local DoeakUI = {}
DoeakUI.__index = DoeakUI
DoeakUI.Themes = Themes
DoeakUI.CurrentTheme = function() return CurrentTheme end
DoeakUI.ApplyTheme = applyTheme
DoeakUI.Flags = {}

local ValidKeys = {
    ["DOEAK-VIP-2025"] = true,
    ["DOEAK-BETA-001"] = true,
    ["DOEAK-DEMO-FREE"] = true,
    ["FREE-TRIAL-KEY"] = true,
}
DoeakUI.ValidKeys = ValidKeys

-- ============================================================
-- NOTIFICATION
-- ============================================================
local NotifGui, NotifHolder
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
        Position = UDim2.new(1, -24, 0, 24),
        Size = UDim2.fromOffset(360, 600),
        BackgroundTransparency = 1,
        Parent = NotifGui,
    })
    local l = vlist(NotifHolder, 12)
    l.VerticalAlignment = Enum.VerticalAlignment.Top
    l.HorizontalAlignment = Enum.HorizontalAlignment.Right
end

function DoeakUI:Notify(opts)
    opts = opts or {}
    ensureNotifGui()

    local kind = opts.Type or "info"
    local accent = C.Accent
    if kind == "success" then accent = C.Good end
    if kind == "warn" then accent = C.Warn end
    if kind == "error" then accent = C.Bad end

    local dur = opts.Duration or 4

    local card = mk("Frame", {
        BackgroundColor3 = C.Panel,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    corner(card, 12)
    local cardStroke = stroke(card, C.Line2, 1, 0.5)

    local accentBar = mk("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 1, 0),
        Parent = card,
    })
    corner(accentBar, 12)

    pad(card, 18, 20, 18, 26)

    local contentWrap = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    vlist(contentWrap, 8)

    local titleLabel = mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Font = Fonts.Bold,
        Text = string.upper(opts.Title or kind),
        TextColor3 = accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = contentWrap,
    })

    local bodyLabel = mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Fonts.Mono,
        Text = opts.Text or "",
        TextColor3 = C.Ink,
        TextSize = 15,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        LineHeight = 1.15,
        Parent = contentWrap,
    })

    -- Countdown bar
    local cdTrack = mk("Frame", {
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 3),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Parent = card,
    })
    local cdFill = mk("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = cdTrack,
    })

    card.Position = UDim2.new(1, 400, 0, 0)
    tw(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.36, Enum.EasingStyle.Quart)
    tw(cdFill, { Size = UDim2.new(0, 0, 1, 0) }, dur, Enum.EasingStyle.Linear)

    task.delay(dur, function()
        if not card or not card.Parent then return end
        tw(card, { Position = UDim2.new(1, 400, 0, 0), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Quart)
        tw(cardStroke, { Transparency = 1 }, 0.3)
        tw(titleLabel, { TextTransparency = 1 }, 0.25)
        tw(bodyLabel, { TextTransparency = 1 }, 0.25)
        tw(accentBar, { BackgroundTransparency = 1 }, 0.3)
        tw(cdTrack, { BackgroundTransparency = 1 }, 0.3)
        task.wait(0.4)
        if card then card:Destroy() end
    end)

    return card
end

-- ============================================================
-- KEY SYSTEM
-- ============================================================
local GETKEY_URL = "https://anotepad.com/notes/7xqnhka3"

function DoeakUI.PromptKey(onSuccess)
    local gui = mk("ScreenGui", {
        Name = "DoeakUI_KeyGate",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 1000,
    })
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local backdrop = mk("Frame", {
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Parent = gui,
    })

    local card = mk("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(480, 340),
        BackgroundColor3 = C.Panel,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Parent = gui,
    })
    corner(card, 14)
    stroke(card, C.Line2, 1, 0.5)

    -- Top glow
    local glow = mk("Frame", {
        BackgroundColor3 = C.Accent,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -80, 0, 1),
        Position = UDim2.new(0, 40, 0, 0),
        Parent = card,
    })
    mk("UIGradient", {
        Parent = glow,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Accent),
            ColorSequenceKeypoint.new(0.5, C.Accent2),
            ColorSequenceKeypoint.new(1, C.Cyan),
        }),
    })

    -- Content
    local content = mk("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 28),
        Size = UDim2.new(1, -64, 1, -56),
        Parent = card,
    })
    vlist(content, 18)

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Font = Fonts.Bold,
        Text = "DOEAK-HUB",
        TextColor3 = C.Ink,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = content,
    })

    mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        Font = Fonts.Mono,
        Text = "// nhập key để tiếp tục",
        TextColor3 = C.Dim,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = content,
    })

    -- Key input
    local inputWrap = mk("Frame", {
        BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 56),
        Parent = content,
    })
    corner(inputWrap, 8)
    local inputStroke = stroke(inputWrap, C.Line2, 1, 0.5)
    pad(inputWrap, 0, 18, 0, 18)

    local input = mk("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = Fonts.Mono,
        PlaceholderText = "DOEAK-XXXX-XXXX",
        PlaceholderColor3 = C.Faint,
        Text = "",
        TextColor3 = C.Ink,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = inputWrap,
    })

    input.Focused:Connect(function()
        tw(inputStroke, { Color = C.Accent, Transparency = 0.15 }, 0.16)
    end)
    input.FocusLost:Connect(function()
        tw(inputStroke, { Color = C.Line2, Transparency = 0.5 }, 0.16)
    end)

    -- Status
    local statusLabel = mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = Fonts.Mono,
        Text = "",
        TextColor3 = C.Dim,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = content,
    })

    -- Buttons row
    local btnRow = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52),
        Parent = content,
    })
    local hl = mk("UIListLayout", { Parent = btnRow })
    hl.FillDirection = Enum.FillDirection.Horizontal
    hl.Padding = UDim.new(0, 12)

    local function makeBtn(text, color, w, cb)
        local b = mk("TextButton", {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Size = UDim2.fromOffset(w, 52),
            Font = Fonts.Bold,
            Text = text,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Parent = btnRow,
        })
        corner(b, 8)
        stroke(b, color, 1, 0.3)
        b.MouseEnter:Connect(function() tw(b, { BackgroundTransparency = 0 }, 0.14) end)
        b.MouseLeave:Connect(function() tw(b, { BackgroundTransparency = 0.15 }, 0.14) end)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    makeBtn("GET KEY", C.Accent, 180, function()
        if setclipboard then
            pcall(setclipboard, GETKEY_URL)
            statusLabel.Text = "// đã copy link — paste vào browser"
            statusLabel.TextColor3 = C.Accent3
        end
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(GETKEY_URL)
        end)
    end)

    makeBtn("CHECK", C.Cyan, 180, function()
        local key = input.Text
        if ValidKeys[key] then
            statusLabel.Text = "// key hợp lệ — đang tải UI..."
            statusLabel.TextColor3 = C.Good
            task.wait(0.7)
            gui:Destroy()
            if onSuccess then onSuccess(key) end
        else
            statusLabel.Text = "// key không hợp lệ"
            statusLabel.TextColor3 = C.Bad
            tw(inputWrap, { BackgroundColor3 = C.Bad }, 0.12)
            task.wait(0.15)
            tw(inputWrap, { BackgroundColor3 = C.Bg }, 0.3)
        end
    end)

    input.FocusLost:Connect(function(enter)
        if enter then
            local key = input.Text
            if ValidKeys[key] then
                statusLabel.Text = "// key hợp lệ — đang tải UI..."
                statusLabel.TextColor3 = C.Good
                task.wait(0.7)
                gui:Destroy()
                if onSuccess then onSuccess(key) end
            else
                statusLabel.Text = "// key không hợp lệ"
                statusLabel.TextColor3 = C.Bad
            end
        end
    end)
end

-- ============================================================
-- WINDOW
-- ============================================================
function DoeakUI.new(opts)
    opts = opts or {}
    local self = setmetatable({}, DoeakUI)
    self.Tabs = {}
    self.TabOrder = {}
    self.CurrentTab = nil
    self.WindowTitle = opts.Title or "doeak-hub"
    self.Keybind = opts.Keybind or Enum.KeyCode.RightShift
    self.Minimized = false
    self.Closed = false

    local W = opts.Width or 760
    local H = opts.Height or 560
    local SIDEBAR_W = 180

    local gui = mk("ScreenGui", {
        Name = "DoeakUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.Gui = gui

    -- Backdrop
    local backdrop = mk("Frame", {
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Visible = false,
        Parent = gui,
    })
    self.Backdrop = backdrop

    local win = regFrame(mk("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(W, H),
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = gui,
    }), "Panel")
    corner(win, 14)
    stroke(win, C.Line2, 1, 0.5)
    self.Frame = win

    -- Top glow
    local glow = mk("Frame", {
        BackgroundColor3 = C.Accent,
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
            ColorSequenceKeypoint.new(0, C.Accent),
            ColorSequenceKeypoint.new(0.5, C.Accent2),
            ColorSequenceKeypoint.new(1, C.Cyan),
        }),
    })

    -- Corner accents
    mk("Frame", { BackgroundColor3 = C.Accent, BackgroundTransparency = 0.4, BorderSizePixel = 0, Size = UDim2.fromOffset(48, 1), Parent = win })
    mk("Frame", { BackgroundColor3 = C.Accent, BackgroundTransparency = 0.4, BorderSizePixel = 0, Size = UDim2.fromOffset(1, 48), Parent = win })
    mk("Frame", { BackgroundColor3 = C.Cyan, BackgroundTransparency = 0.4, BorderSizePixel = 0, Size = UDim2.fromOffset(48, 1), Position = UDim2.new(1, -48, 1, -1), Parent = win })
    mk("Frame", { BackgroundColor3 = C.Cyan, BackgroundTransparency = 0.4, BorderSizePixel = 0, Size = UDim2.fromOffset(1, 48), Position = UDim2.new(1, -1, 1, -48), Parent = win })

    -- ===== TITLE BAR =====
    local titleBar = regFrame(mk("Frame", {
        Name = "TitleBar",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 56),
        Parent = win,
    }), "Bg")
    mk("Frame", {
        BackgroundColor3 = C.Line,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        Parent = titleBar,
    })

    -- Logo
    local dotGlow = mk("Frame", {
        BackgroundColor3 = C.Accent,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0, 18, 0.5, -9),
        Parent = titleBar,
    })
    corner(dotGlow, 9)
    local dot = mk("Frame", {
        BackgroundColor3 = C.Accent,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0, 23, 0.5, -4),
        Parent = titleBar,
    })
    corner(dot, 4)

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 46, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Fonts.Bold,
        Text = string.upper(self.WindowTitle),
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    }), "Ink")

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = Fonts.Code,
        Text = "// v2.0",
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = titleBar,
    }), "Faint")

    -- Minimize / Close
    local minBtn = regText(mk("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -88, 0, 0),
        Size = UDim2.fromOffset(36, 56),
        Font = Fonts.Code,
        Text = "—",
        TextSize = 18,
        AutoButtonColor = false,
        Parent = titleBar,
    }), "Dim")
    local closeBtn = regText(mk("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -44, 0, 0),
        Size = UDim2.fromOffset(36, 56),
        Font = Fonts.Code,
        Text = "×",
        TextSize = 24,
        AutoButtonColor = false,
        Parent = titleBar,
    }), "Dim")

    minBtn.MouseEnter:Connect(function() tw(minBtn, { TextColor3 = C.Ink }, 0.12) end)
    minBtn.MouseLeave:Connect(function() tw(minBtn, { TextColor3 = C.Dim }, 0.12) end)
    closeBtn.MouseEnter:Connect(function() tw(closeBtn, { TextColor3 = C.Bad }, 0.12) end)
    closeBtn.MouseLeave:Connect(function() tw(closeBtn, { TextColor3 = C.Dim }, 0.12) end)

    -- ===== SIDEBAR =====
    local sidebar = regFrame(mk("Frame", {
        Name = "Sidebar",
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 56),
        Size = UDim2.fromOffset(SIDEBAR_W, H - 56),
        Parent = win,
    }), "Panel2")

    mk("Frame", {
        BackgroundColor3 = C.Line,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        Parent = sidebar,
    })

    local sidebarHeader = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = sidebar,
    })
    pad(sidebarHeader, 0, 20, 0, 20)

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Fonts.Bold,
        Text = "// TABS",
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebarHeader,
    }), "Faint")

    mk("Frame", {
        BackgroundColor3 = C.Line,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -40, 0, 1),
        Position = UDim2.new(0, 20, 0, 40),
        Parent = sidebar,
    })

    local tabList = mk("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.new(1, 0, 1, -44),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = C.Line2,
        Parent = sidebar,
    })
    pad(tabList, 12, 12, 12, 12)
    vlist(tabList, 6)

    -- ===== CONTENT =====
    local content = mk("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, SIDEBAR_W, 0, 56),
        Size = UDim2.new(1, -SIDEBAR_W, 1, -56),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = C.Line2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = win,
    })
    pad(content, 22, 22, 22, 22)
    vlist(content, 20)
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

    -- Minimize
    minBtn.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        if self.Minimized then
            tw(win, { Size = UDim2.fromOffset(W, 56) }, 0.28, Enum.EasingStyle.Quart)
            sidebar.Visible = false
            content.Visible = false
            minBtn.Text = "+"
        else
            tw(win, { Size = UDim2.fromOffset(W, H) }, 0.28, Enum.EasingStyle.Quart)
            sidebar.Visible = true
            content.Visible = true
            minBtn.Text = "−"
        end
    end)

    -- Close
    closeBtn.MouseButton1Click:Connect(function()
        self.Closed = not self.Closed
        gui.Enabled = not self.Closed
    end)

    -- Keybind
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

        local btn = mk("TextButton", {
            BackgroundColor3 = C.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 44),
            Font = Fonts.Bold,
            Text = "  " .. tabName,
            TextColor3 = C.Dim,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabList,
        })
        corner(btn, 8)

        local indicator = mk("Frame", {
            BackgroundColor3 = C.Accent,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(4, 22),
            Position = UDim2.new(0, 0, 0.5, -11),
            Visible = false,
            Parent = btn,
        })
        corner(indicator, 2)

        local page = mk("Frame", {
            Name = "Page_" .. tabName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = content,
        })
        vlist(page, 18)

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
                tw(btn, { TextColor3 = C.Accent3, BackgroundTransparency = 0.85, BackgroundColor3 = C.Accent }, 0.16)
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.CurrentTab ~= tabName then
                tw(btn, { TextColor3 = C.Dim, BackgroundTransparency = 1 }, 0.16)
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
                TextColor3 = active and C.Ink or C.Dim,
                BackgroundColor3 = C.Accent,
                BackgroundTransparency = active and 0.82 or 1,
            }, 0.18)
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

-- ============================================================
-- SECTION
-- ============================================================
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
    vlist(wrap, 14)

    local head = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Parent = wrap,
    })
    local hl = mk("UIListLayout", { Parent = head })
    hl.FillDirection = Enum.FillDirection.Horizontal
    hl.Padding = UDim.new(0, 12)
    hl.VerticalAlignment = Enum.VerticalAlignment.Center

    if index then
        regText(mk("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(32, 24),
            Font = Fonts.Code,
            Text = string.format("%02d", index),
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = head,
        }), "Accent")
    end

    local lbl = regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Fonts.Bold,
        Text = title,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = head,
    }), "Faint")

    regFrame(mk("Frame", {
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -(lbl.AbsoluteSize.X + (index and 44 or 0) + 24), 0, 1),
        Parent = head,
    }), "Line")

    local body = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = wrap,
    })
    vlist(body, 10)

    return { Frame = wrap, Body = body, Head = head }
end

-- ============================================================
-- COMPONENTS
-- ============================================================

-- BUTTON
function DoeakUI.CreateButton(section, opts)
    opts = opts or {}
    local text = opts.Name or "Button"

    local btn = regFrame(mk("TextButton", {
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 48),
        Font = Fonts.Bold,
        Text = text,
        TextSize = 15,
        Parent = section.Body,
    }), "Panel2")
    regText(btn, "Ink")
    corner(btn, 8)
    local s = stroke(btn, C.Line2, 1, 0.55)

    btn.MouseEnter:Connect(function()
        tw(btn, { BackgroundColor3 = C.Accent, BackgroundTransparency = 0.1 }, 0.16)
        tw(s, { Color = C.Accent2, Transparency = 0.2 }, 0.16)
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, { BackgroundColor3 = C.Panel2, BackgroundTransparency = 0.3 }, 0.16)
        tw(s, { Color = C.Line2, Transparency = 0.55 }, 0.16)
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

-- TOGGLE
function DoeakUI.CreateToggle(section, opts)
    opts = opts or {}
    local state = opts.Default or false
    local flag = opts.Flag

    local row = regFrame(mk("Frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 52),
        Parent = section.Body,
    }), "Panel2")
    corner(row, 8)
    stroke(row, C.Line, 1, 0.6)
    pad(row, 0, 18, 0, 18)

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 1, 0),
        Font = Fonts.Mono,
        Text = opts.Name or "Toggle",
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    }), "Ink")

    local pill = regFrame(mk("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(50, 26),
        BackgroundTransparency = state and 0 or 0.3,
        BorderSizePixel = 0,
        Parent = row,
    }), state and "Accent" or "Bg")
    corner(pill, 13)
    local ps = stroke(pill, state and C.Accent2 or C.Line2, 1, 0.4)

    local knob = mk("Frame", {
        AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
        Position = state and UDim2.new(1, -4, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundColor3 = state and C.Bg or C.Ink,
        BorderSizePixel = 0,
        Parent = pill,
    })
    corner(knob, 10)

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
            BackgroundColor3 = t and C.Bg or C.Ink,
        }, 0.24, Enum.EasingStyle.Quart)
        tw(pill, {
            BackgroundColor3 = t and C.Accent or C.Bg,
            BackgroundTransparency = t and 0 or 0.3,
        }, 0.24)
        tw(ps, { Color = t and C.Accent2 or C.Line2 }, 0.24)
    end

    hit.MouseButton1Click:Connect(function()
        state = not state
        if flag then DoeakUI.Flags[flag] = state end
        render()
        if opts.Callback then pcall(opts.Callback, state) end
    end)

    if flag then DoeakUI.Flags[flag] = state end

    return {
        Set = function(v) state = v and true or false; if flag then DoeakUI.Flags[flag] = state end; render() end,
        Get = function() return state end,
    }
end

-- SLIDER
function DoeakUI.CreateSlider(section, opts)
    opts = opts or {}
    local min, max = opts.Min or 0, opts.Max or 100
    local val = opts.Default or min
    local decimals = opts.Decimals or 0
    local flag = opts.Flag

    local wrap = regFrame(mk("Frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 70),
        Parent = section.Body,
    }), "Panel2")
    corner(wrap, 8)
    stroke(wrap, C.Line, 1, 0.6)
    pad(wrap, 12, 18, 12, 18)

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 0, 22),
        Font = Fonts.Mono,
        Text = opts.Name or "Slider",
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = wrap,
    }), "Ink")

    local valLabel = regText(mk("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(80, 22),
        BackgroundTransparency = 1,
        Font = Fonts.Code,
        Text = tostring(val),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = wrap,
    }), "Accent3")

    local track = regFrame(mk("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = wrap,
    }), "Bg")
    corner(track, 4)

    local fill = regFrame(mk("Frame", {
        Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
        BorderSizePixel = 0,
        Parent = track,
    }), "Accent")
    corner(fill, 4)
    mk("UIGradient", {
        Parent = fill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Accent),
            ColorSequenceKeypoint.new(1, C.Accent2),
        }),
    })

    local knob = regFrame(mk("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        BorderSizePixel = 0,
        Parent = track,
    }), "Ink")
    corner(knob, 9)
    stroke(knob, C.Accent, 2, 0.2)

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
        Size = UDim2.new(1, 0, 1, 24),
        Position = UDim2.new(0, 0, 0, -8),
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

-- DROPDOWN
function DoeakUI.CreateDropdown(section, opts)
    opts = opts or {}
    local options = opts.Options or {}
    local selected = opts.Default or options[1]
    local flag = opts.Flag
    local expanded = false
    local ITEM_H, ITEM_GAP, LIST_PAD = 34, 4, 6

    local wrap = regFrame(mk("Frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 52),
        ClipsDescendants = false,
        Parent = section.Body,
    }), "Panel2")
    corner(wrap, 8)
    local ws = stroke(wrap, C.Line, 1, 0.6)
    pad(wrap, 0, 18, 0, 18)

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Fonts.Mono,
        Text = opts.Name or "Dropdown",
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = wrap,
    }), "Ink")

    local valLbl = regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, -24, 1, 0),
        Font = Fonts.Mono,
        Text = tostring(selected) .. "  ▾",
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = wrap,
    }), "Accent3")

    local hit = mk("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        Parent = wrap,
    })

    local listHolder = regFrame(mk("Frame", {
        Position = UDim2.new(0, 0, 1, 6),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = wrap,
    }), "Panel")
    corner(listHolder, 8)
    stroke(listHolder, C.Line2, 1, 0.4)

    local list = mk("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Line2,
        ZIndex = 11,
        Parent = listHolder,
    })
    pad(list, LIST_PAD, LIST_PAD, LIST_PAD, LIST_PAD)
    vlist(list, ITEM_GAP)

    local itemEls = {}
    local function rebuild()
        for _, v in ipairs(itemEls) do v:Destroy() end
        itemEls = {}
        for _, opt in ipairs(options) do
            local isSel = opt == selected
            local o = regFrame(mk("TextButton", {
                BackgroundTransparency = isSel and 0.4 or 1,
                Size = UDim2.new(1, 0, 0, ITEM_H),
                Font = Fonts.Mono,
                Text = "  " .. tostring(opt),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 12,
                Parent = list,
            }), "Panel2")
            regText(o, isSel and "Accent3" or "Ink")
            corner(o, 6)
            o.MouseEnter:Connect(function()
                tw(o, { BackgroundTransparency = 0.7, BackgroundColor3 = C.Panel3 }, 0.12)
            end)
            o.MouseLeave:Connect(function()
                tw(o, { BackgroundTransparency = (opt == selected) and 0.4 or 1, BackgroundColor3 = C.Panel2 }, 0.12)
            end)
            o.MouseButton1Click:Connect(function()
                selected = opt
                valLbl.Text = tostring(opt) .. "  ▾"
                if flag then DoeakUI.Flags[flag] = opt end
                if opts.Callback then pcall(opts.Callback, opt) end
                rebuild()
                expanded = false
                tw(listHolder, { Size = UDim2.new(1, 0, 0, 0) }, 0.26, Enum.EasingStyle.Quart)
                tw(ws, { Color = C.Line }, 0.16)
                task.wait(0.26)
                listHolder.Visible = false
            end)
            table.insert(itemEls, o)
        end
    end
    rebuild()

    hit.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            local h = math.min(#options * (ITEM_H + ITEM_GAP) + LIST_PAD * 2 - ITEM_GAP, 220)
            listHolder.Visible = true
            listHolder.Size = UDim2.new(1, 0, 0, 0)
            tw(listHolder, { Size = UDim2.new(1, 0, 0, h) }, 0.3, Enum.EasingStyle.Quart)
            tw(ws, { Color = C.Accent }, 0.18)
        else
            tw(listHolder, { Size = UDim2.new(1, 0, 0, 0) }, 0.26, Enum.EasingStyle.Quart)
            tw(ws, { Color = C.Line }, 0.18)
            task.wait(0.26)
            listHolder.Visible = false
        end
    end)

    if flag then DoeakUI.Flags[flag] = selected end

    return {
        Get = function() return selected end,
        Refresh = function(newOptions) options = newOptions; rebuild() end,
    }
end

-- INPUT
function DoeakUI.CreateInput(section, opts)
    opts = opts or {}
    local flag = opts.Flag

    local wrap = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = section.Body,
    })
    vlist(wrap, 8)

    if opts.Name then
        regText(mk("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Font = Fonts.Bold,
            Text = "// " .. string.upper(opts.Name),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = wrap,
        }), "Faint")
    end

    local box = regFrame(mk("Frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 48),
        Parent = wrap,
    }), "Bg")
    corner(box, 8)
    local s = stroke(box, C.Line2, 1, 0.55)
    pad(box, 0, 18, 0, 18)

    local input = regText(mk("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = Fonts.Mono,
        PlaceholderText = opts.Placeholder or "...",
        Text = opts.Default or "",
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = box,
    }), "Ink")
    input.PlaceholderColor3 = C.Faint

    input.Focused:Connect(function()
        tw(s, { Color = C.Accent, Transparency = 0.15 }, 0.16)
        tw(box, { BackgroundTransparency = 0.15 }, 0.16)
    end)
    input.FocusLost:Connect(function()
        tw(s, { Color = C.Line2, Transparency = 0.55 }, 0.16)
        tw(box, { BackgroundTransparency = 0.35 }, 0.16)
        if flag then DoeakUI.Flags[flag] = input.Text end
        if opts.Callback then pcall(opts.Callback, input.Text) end
    end)

    if flag then DoeakUI.Flags[flag] = input.Text end
    return input
end

-- KEYBIND
function DoeakUI.CreateKeybind(section, opts)
    opts = opts or {}
    local current = opts.Default or Enum.KeyCode.E
    local flag = opts.Flag

    local row = regFrame(mk("Frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 52),
        Parent = section.Body,
    }), "Panel2")
    corner(row, 8)
    stroke(row, C.Line, 1, 0.6)
    pad(row, 0, 18, 0, 18)

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Fonts.Mono,
        Text = opts.Name or "Keybind",
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    }), "Ink")

    local valBtn = regFrame(mk("TextButton", {
        Position = UDim2.new(1, -120, 0.5, -16),
        Size = UDim2.fromOffset(120, 32),
        Font = Fonts.Code,
        Text = current.Name,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = row,
    }), "Bg")
    regText(valBtn, "Accent3")
    corner(valBtn, 6)
    stroke(valBtn, C.Line2, 1, 0.5)

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
            if not gp and input.KeyCode == current then pcall(opts.OnPressed) end
        end)
    end

    return {
        Set = function(k) current = k; valBtn.Text = k.Name; if flag then DoeakUI.Flags[flag] = k end end,
        Get = function() return current end,
    }
end

-- LABEL
function DoeakUI.CreateLabel(section, opts)
    opts = opts or {}
    local lbl = regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Fonts.Mono,
        Text = opts.Text or "",
        TextSize = opts.Size or 14,
        TextWrapped = true,
        TextXAlignment = opts.Align or Enum.TextXAlignment.Left,
        LineHeight = 1.15,
        Parent = section.Body,
    }), opts.ColorKey or "Dim")
    return lbl
end

-- DIVIDER
function DoeakUI.CreateDivider(section)
    return regFrame(mk("Frame", {
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Parent = section.Body,
    }), "Line")
end

-- PROGRESS BAR
function DoeakUI.CreateProgressBar(section, opts)
    opts = opts or {}
    local min, max = opts.Min or 0, opts.Max or 100
    local val = opts.Default or min

    local wrap = regFrame(mk("Frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 62),
        Parent = section.Body,
    }), "Panel2")
    corner(wrap, 8)
    stroke(wrap, C.Line, 1, 0.6)
    pad(wrap, 12, 18, 12, 18)

    regText(mk("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 0, 20),
        Font = Fonts.Mono,
        Text = opts.Name or "Progress",
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = wrap,
    }), "Ink")

    local valLabel = regText(mk("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(80, 20),
        BackgroundTransparency = 1,
        Font = Fonts.Code,
        Text = "0%",
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = wrap,
    }), "Accent3")

    local track = regFrame(mk("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = wrap,
    }), "Bg")
    corner(track, 5)

    local fill = regFrame(mk("Frame", {
        Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
        BorderSizePixel = 0,
        Parent = track,
    }), "Accent")
    corner(fill, 5)
    mk("UIGradient", {
        Parent = fill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Accent),
            ColorSequenceKeypoint.new(1, C.Accent2),
        }),
    })

    local function render()
        local t = (val - min) / (max - min)
        tw(fill, { Size = UDim2.new(t, 0, 1, 0) }, 0.32, Enum.EasingStyle.Quart)
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

-- ============================================================
-- CONFIG TAB BUILDER (auto-added helper)
-- ============================================================
function DoeakUI.BuildConfigTab(window, tab)
    local section = DoeakUI.CreateSection(tab, { Index = 1, Name = "Theme" })

    local themeNames = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNames, name)
    end
    table.sort(themeNames)

    DoeakUI.CreateDropdown(section, {
        Name = "Chọn theme",
        Options = themeNames,
        Default = CurrentTheme,
        Callback = function(pick)
            applyTheme(pick)
            DoeakUI:Notify({
                Type = "success",
                Title = "Theme",
                Text = "Đã đổi sang " .. pick,
                Duration = 2.5,
            })
        end,
    })

    local section2 = DoeakUI.CreateSection(tab, { Index = 2, Name = "Key" })

    DoeakUI.CreateLabel(section2, {
        Text = "Mở link để lấy key, paste vào UI mỗi lần chạy.",
        ColorKey = "Dim",
    })

    DoeakUI.CreateButton(section2, {
        Name = "Lấy Key",
        Callback = function()
            if setclipboard then pcall(setclipboard, GETKEY_URL) end
            DoeakUI:Notify({
                Type = "info",
                Title = "Get Key",
                Text = "Đã copy link vào clipboard.\n" .. GETKEY_URL,
                Duration = 6,
            })
        end,
    })

    local section3 = DoeakUI.CreateSection(tab, { Index = 3, Name = "Config" })

    DoeakUI.CreateButton(section3, {
        Name = "Save Config",
        Callback = function()
            if not writefile then
                DoeakUI:Notify({ Type = "warn", Title = "Config", Text = "Executor không hỗ trợ." })
                return
            end
            local data = {}
            for k, v in pairs(DoeakUI.Flags) do
                if typeof(v) == "EnumItem" then
                    data[k] = { __t = "Enum", enum = tostring(v.EnumType), value = v.Name }
                else
                    data[k] = v
                end
            end
            pcall(writefile, "DoeakUI_config.json", HttpService:JSONEncode(data))
            DoeakUI:Notify({ Type = "success", Title = "Config", Text = "Đã lưu." })
        end,
    })

    DoeakUI.CreateButton(section3, {
        Name = "Load Config",
        Callback = function()
            if not isfile or not readfile then
                DoeakUI:Notify({ Type = "warn", Title = "Config", Text = "Executor không hỗ trợ." })
                return
            end
            if not isfile("DoeakUI_config.json") then
                DoeakUI:Notify({ Type = "error", Title = "Config", Text = "Chưa có file lưu." })
                return
            end
            local ok, data = pcall(function() return HttpService:JSONDecode(readfile("DoeakUI_config.json")) end)
            if not ok then
                DoeakUI:Notify({ Type = "error", Title = "Config", Text = "File hỏng." })
                return
            end
            for k, v in pairs(data) do
                if type(v) == "table" and v.__t == "Enum" then
                    local ok2, e = pcall(function() return Enum[v.enum][v.value] end)
                    if ok2 then DoeakUI.Flags[k] = e end
                else
                    DoeakUI.Flags[k] = v
                end
            end
            DoeakUI:Notify({ Type = "success", Title = "Config", Text = "Đã nạp." })
        end,
    })

    DoeakUI.CreateButton(section3, {
        Name = "Reset UI",
        Callback = function()
            window:Destroy()
            DoeakUI:Notify({ Type = "info", Title = "Reset", Text = "Chạy lại script để load UI mới." })
        end,
    })
end

return DoeakUI
