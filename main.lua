--// TAPPED – Interface Shell
--// Executor: Xeno

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- YOUR LOGO DECAL
local LOGO_DECAL = "rbxassetid://102358320247371"

-- Theme
local Theme = {
    Background = Color3.fromRGB(10,10,14),
    Panel = Color3.fromRGB(17,17,23),
    Inner = Color3.fromRGB(23,23,30),
    Cyan = Color3.fromRGB(0,210,255),
    Purple = Color3.fromRGB(155,95,255),
    Text = Color3.fromRGB(235,235,235)
}

-- GUI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TAPPED_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.fromScale(0.5, 0.55)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Theme.Background
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

-- Stroke Glow
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.45
Stroke.Color = Theme.Cyan

task.spawn(function()
    while true do
        TweenService:Create(Stroke, TweenInfo.new(1.4), {Color = Theme.Purple}):Play()
        task.wait(1.4)
        TweenService:Create(Stroke, TweenInfo.new(1.4), {Color = Theme.Cyan}):Play()
        task.wait(1.4)
    end
end)

-- 🔥 TOP BAR (FIXED HEIGHT)
local TOPBAR_HEIGHT = 130

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,TOPBAR_HEIGHT)
TopBar.BackgroundColor3 = Theme.Panel
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,14)

-- 👤 AVATAR
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0,56,0,56)
Avatar.Position = UDim2.new(0.5,0,0,12)
Avatar.AnchorPoint = Vector2.new(0.5,0)
Avatar.BackgroundColor3 = Theme.Inner
Avatar.ScaleType = Enum.ScaleType.Crop
Avatar.Parent = TopBar
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1,0)

local AvatarStroke = Instance.new("UIStroke", Avatar)
AvatarStroke.Color = Theme.Cyan
AvatarStroke.Transparency = 0.3

task.spawn(function()
    local thumb = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size180x180
    )
    Avatar.Image = thumb
end)

-- 🖼️ LOGO (UNDER AVATAR)
local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(0,220,0,40)
LogoImage.Position = UDim2.new(0.5,0,0,78)
LogoImage.AnchorPoint = Vector2.new(0.5,0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = LOGO_DECAL
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.Parent = TopBar

-- Tabs Panel (FIXED)
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0,150,1,-(TOPBAR_HEIGHT + 20))
Tabs.Position = UDim2.new(0,14,0,TOPBAR_HEIGHT + 6)
Tabs.BackgroundColor3 = Theme.Panel
Tabs.Parent = Main
Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0,14)

local TabLayout = Instance.new("UIListLayout", Tabs)
TabLayout.Padding = UDim.new(0,10)

-- Content Panel (FIXED)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-180,1,-(TOPBAR_HEIGHT + 20))
Content.Position = UDim2.new(0,170,0,TOPBAR_HEIGHT + 6)
Content.BackgroundColor3 = Theme.Panel
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0,14)

-- Pages
local Pages = {}

local function CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,-20,0,44)
    Button.BackgroundColor3 = Theme.Inner
    Button.Text = name
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.TextColor3 = Theme.Text
    Button.Parent = Tabs
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,10)

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1,0,1,0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Content

    Pages[name] = Page

    Button.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)

    return Page
end

-- Tabs
CreateTab("Main")
CreateTab("Rage")
CreateTab("World")
CreateTab("Misc")
CreateTab("Settings")
CreateTab("Premium")
Pages["Main"].Visible = true

-- Toggle GUI
local ToggleKey = Enum.KeyCode.RightShift
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == ToggleKey then
        Main.Visible = not Main.Visible
    end
end)

-- Dragging
do
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
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
