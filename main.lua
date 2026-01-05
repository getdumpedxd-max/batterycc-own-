--// Battery.cc | Beta
--// UI Framework (Custom, No Libs)
--// Executor Friendly

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CLEANUP
pcall(function()
    PlayerGui:FindFirstChild("BatteryCC_UI"):Destroy()
end)

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BatteryCC_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- MAIN PANEL
local Main = Instance.new("Frame")
Main.Size = UDim2.fromScale(0.48, 0.16) -- LONG WIDE
Main.Position = UDim2.fromScale(0.5, 0.18)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BackgroundTransparency = 0.05
Main.Parent = ScreenGui

-- ROUND CORNERS
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 22)
Corner.Parent = Main

-- OUTER GLOW
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(120, 80, 255)
Stroke.Transparency = 0
Stroke.Parent = Main

-- GRADIENT
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,15))
})
Gradient.Parent = Main

-- HEADER
local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromScale(1, 0.22)
Title.BackgroundTransparency = 1
Title.Text = "Battery.cc | Beta"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(180, 140, 255)
Title.Parent = Main

-- PROFILE IMAGE
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.fromOffset(48,48)
Avatar.Position = UDim2.fromOffset(18, 52)
Avatar.BackgroundTransparency = 1
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
Avatar.Parent = Main

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1,0)
AvatarCorner.Parent = Avatar

-- USERNAME
local Username = Instance.new("TextLabel")
Username.Position = UDim2.fromOffset(76, 56)
Username.Size = UDim2.fromOffset(200, 20)
Username.BackgroundTransparency = 1
Username.TextXAlignment = Left
Username.Text = LocalPlayer.Name
Username.Font = Enum.Font.GothamSemibold
Username.TextSize = 14
Username.TextColor3 = Color3.fromRGB(220,220,220)
Username.Parent = Main

-- SUBTEXT
local Sub = Instance.new("TextLabel")
Sub.Position = UDim2.fromOffset(76, 76)
Sub.Size = UDim2.fromOffset(240, 18)
Sub.BackgroundTransparency = 1
Sub.TextXAlignment = Left
Sub.Text = "battery.cc client loaded"
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 12
Sub.TextColor3 = Color3.fromRGB(150,150,150)
Sub.Parent = Main

-- PING DISPLAY
local Ping = Instance.new("TextLabel")
Ping.Size = UDim2.fromOffset(60, 22)
Ping.Position = UDim2.fromScale(0.92, 0.78)
Ping.AnchorPoint = Vector2.new(1,1)
Ping.BackgroundColor3 = Color3.fromRGB(40,160,60)
Ping.Text = "0ms"
Ping.Font = Enum.Font.GothamBold
Ping.TextSize = 12
Ping.TextColor3 = Color3.new(1,1,1)
Ping.Parent = Main

local PingCorner = Instance.new("UICorner")
PingCorner.CornerRadius = UDim.new(0,8)
PingCorner.Parent = Ping

-- BUTTON HOLDER
local ButtonHolder = Instance.new("Frame")
ButtonHolder.Position = UDim2.fromScale(0.42, 0.45)
ButtonHolder.Size = UDim2.fromScale(0.55, 0.42)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = ButtonHolder

-- BUTTON FUNCTION
local function CreateButton(text)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.fromScale(1, 0)
    Btn.AutomaticSize = Y
    Btn.BackgroundColor3 = Color3.fromRGB(22,22,30)
    Btn.Text = text
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.TextColor3 = Color3.fromRGB(220,220,220)
    Btn.Parent = ButtonHolder

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,10)
    c.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40,30,80)
        }):Play()
    end)

    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(22,22,30)
        }):Play()
    end)

    return Btn
end

-- BUTTONS
local LockBtn = CreateButton("Aim Lock")
local ESPBtn = CreateButton("ESP")
local SpeedBtn = CreateButton("CFrame Speed")
local SettingsBtn = CreateButton("Settings")

-- DRAGGING
do
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- PING UPDATE
task.spawn(function()
    while task.wait(1) do
        local ping = math.random(30, 90)
        Ping.Text = ping.."ms"
    end
end)

-- LOAD ANIMATION
Main.BackgroundTransparency = 1
TweenService:Create(Main, TweenInfo.new(0.4), {
    BackgroundTransparency = 0.05
}):Play()
--// ===== Battery.cc ADD-ONS (Safe Append) =====

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 🔹 WELCOME TEXT
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Name = "WelcomeText"
WelcomeText.BackgroundTransparency = 1
WelcomeText.Position = UDim2.fromOffset(0, 30)
WelcomeText.Size = UDim2.new(1, 0, 0, 18)
WelcomeText.Text = "Welcome, "..LocalPlayer.DisplayName
WelcomeText.Font = Enum.Font.Gotham
WelcomeText.TextSize = 13
WelcomeText.TextColor3 = Color3.fromRGB(160,160,180)
WelcomeText.TextTransparency = 0.1
WelcomeText.TextXAlignment = Enum.TextXAlignment.Center
WelcomeText.Parent = Main

-- 🔹 TAB HOLDER
local TabsHolder = Instance.new("Frame")
TabsHolder.Name = "TabsHolder"
TabsHolder.BackgroundTransparency = 1
TabsHolder.Position = UDim2.fromOffset(18, 56)
TabsHolder.Size = UDim2.new(1, -36, 0, 26)
TabsHolder.Parent = Main

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.Padding = UDim.new(0, 10)
TabsLayout.Parent = TabsHolder

-- 🔹 TAB FUNCTION
local Tabs = {}
local ActiveTab = nil

local function CreateTab(name)
    local Tab = Instance.new("TextButton")
    Tab.Name = name.."Tab"
    Tab.Size = UDim2.fromOffset(70, 24)
    Tab.BackgroundColor3 = Color3.fromRGB(18,18,26)
    Tab.Text = name
    Tab.Font = Enum.Font.GothamMedium
    Tab.TextSize = 12
    Tab.TextColor3 = Color3.fromRGB(170,170,190)
    Tab.AutoButtonColor = false
    Tab.Parent = TabsHolder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Tab

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(90,70,200)
    Stroke.Transparency = 1
    Stroke.Parent = Tab

    Tab.MouseButton1Click:Connect(function()
        if ActiveTab then
            TweenService:Create(ActiveTab, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(18,18,26),
                TextColor3 = Color3.fromRGB(170,170,190)
            }):Play()
            ActiveTab.UIStroke.Transparency = 1
        end

        ActiveTab = Tab
        TweenService:Create(Tab, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40,30,80),
            TextColor3 = Color3.fromRGB(220,220,255)
        }):Play()
        Stroke.Transparency = 0
    end)

    Tabs[name] = Tab
    return Tab
end

-- 🔹 CREATE TABS (200-char width safe)
CreateTab("Main")
CreateTab("Rage")
CreateTab("Misc")
CreateTab("World")
CreateTab("Settings")
CreateTab("HVH")

-- Auto-select Main
task.delay(0.1, function()
    Tabs["Main"]:Activate()
end)
--// ===== Battery.cc ADD-ON #2 =====
--// Tabs | Indicator | Toggle Key

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

------------------------------------------------
-- UI TOGGLE (RightShift)
------------------------------------------------
local UIVisible = true
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        UIVisible = not UIVisible
        Main.Visible = UIVisible
    end
end)

------------------------------------------------
-- TAB CONTENT HOLDER
------------------------------------------------
local Pages = Instance.new("Frame")
Pages.Name = "Pages"
Pages.BackgroundTransparency = 1
Pages.Position = UDim2.fromOffset(18, 90)
Pages.Size = UDim2.new(1, -36, 1, -100)
Pages.Parent = Main

------------------------------------------------
-- PAGE CREATOR
------------------------------------------------
local PageMap = {}
local CurrentPage = nil

local function CreatePage(name)
    local Page = Instance.new("Frame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.fromScale(1,1)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Pages

    PageMap[name] = Page
    return Page
end

-- Create Pages
local MainPage     = CreatePage("Main")
local RagePage     = CreatePage("Rage")
local MiscPage     = CreatePage("Misc")
local WorldPage    = CreatePage("World")
local SettingsPage = CreatePage("Settings")
local HVHPage      = CreatePage("HVH")

------------------------------------------------
-- PAGE PLACEHOLDER TEXT (features come later)
------------------------------------------------
local function PageLabel(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.fromScale(1,1)
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(180,180,200)
    lbl.TextWrapped = true
    lbl.Parent = page
end

PageLabel(MainPage, "Main\n\n• Aim Assist\n• Target Info\n• Core Systems")
PageLabel(RagePage, "Rage\n\n• Resolver\n• Prediction\n• Aggressive Logic")
PageLabel(MiscPage, "Misc\n\n• Movement\n• Keybinds\n• UI Options")
PageLabel(WorldPage, "World\n\n• ESP\n• World Tweaks\n• Lighting")
PageLabel(SettingsPage, "Settings\n\n• Configs\n• Performance\n• UI")
PageLabel(HVHPage, "HVH\n\n• Anti-Aim\n• Desync\n• HVH Logic")

------------------------------------------------
-- TAB INDICATOR (Animated Line)
------------------------------------------------
local Indicator = Instance.new("Frame")
Indicator.BackgroundColor3 = Color3.fromRGB(140,100,255)
Indicator.Size = UDim2.fromOffset(0, 2)
Indicator.Position = UDim2.new(0, 0, 1, -2)
Indicator.Parent = TabsHolder

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(1,0)
IndicatorCorner.Parent = Indicator

------------------------------------------------
-- TAB SWITCH FUNCTION
------------------------------------------------
local function SwitchTab(tabButton, tabName)
    if CurrentPage then
        CurrentPage.Visible = false
    end

    CurrentPage = PageMap[tabName]
    CurrentPage.Visible = true

    -- Move indicator
    TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
        Size = UDim2.fromOffset(tabButton.AbsoluteSize.X, 2),
        Position = UDim2.fromOffset(
            tabButton.AbsolutePosition.X - TabsHolder.AbsolutePosition.X,
            TabsHolder.AbsoluteSize.Y - 2
        )
    }):Play()
end

------------------------------------------------
-- CONNECT EXISTING TABS
------------------------------------------------
for name, tab in pairs(Tabs) do
    tab.MouseButton1Click:Connect(function()
        SwitchTab(tab, name)
    end)
end

-- Default Tab
task.delay(0.05, function()
    SwitchTab(Tabs["Main"], "Main")
end)
