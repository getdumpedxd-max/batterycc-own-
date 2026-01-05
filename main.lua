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
