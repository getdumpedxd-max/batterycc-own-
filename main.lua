--// Battery.cc | Beta
--// Executor: Xeno / Velocity / Swift
--// UI + Core Features
--// Built clean, no external UI libs

if not game:IsLoaded() then
    game.Loaded:Wait()
end

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--------------------------------------------------
-- GUI ROOT
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BatteryCC"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

--------------------------------------------------
-- MAIN PANEL
--------------------------------------------------
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 150)
Main.Position = UDim2.new(0.5, -260, 0.5, -75)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 22)
MainCorner.Parent = Main

--------------------------------------------------
-- OUTER GLOW
--------------------------------------------------
local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Thickness = 2
Stroke.Transparency = 0
Stroke.Color = Color3.fromRGB(170, 120, 255)

--------------------------------------------------
-- GRADIENT
--------------------------------------------------
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 160, 255))
}
Gradient.Rotation = 25
Gradient.Parent = Stroke

--------------------------------------------------
-- TITLE
--------------------------------------------------
local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.Text = "Battery.cc | Beta"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Left
Title.TextColor3 = Color3.fromRGB(190, 150, 255)
Title.Parent = Main

--------------------------------------------------
-- PROFILE
--------------------------------------------------
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 60, 0, 60)
Avatar.Position = UDim2.new(0, 18, 0, 50)
Avatar.BackgroundTransparency = 1
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
Avatar.Parent = Main

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = Avatar

local Username = Instance.new("TextLabel")
Username.BackgroundTransparency = 1
Username.Position = UDim2.new(0, 90, 0, 58)
Username.Size = UDim2.new(0, 200, 0, 24)
Username.Text = LocalPlayer.Name
Username.Font = Enum.Font.GothamMedium
Username.TextSize = 15
Username.TextXAlignment = Left
Username.TextColor3 = Color3.fromRGB(230, 230, 240)
Username.Parent = Main

--------------------------------------------------
-- STATUS TEXT
--------------------------------------------------
local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 90, 0, 82)
Status.Size = UDim2.new(0, 300, 0, 20)
Status.Text = "Idle"
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextXAlignment = Left
Status.TextColor3 = Color3.fromRGB(150, 150, 170)
Status.Parent = Main

--------------------------------------------------
-- DRAGGING
--------------------------------------------------
do
    local dragging = false
    local dragStart, startPos

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
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

--------------------------------------------------
-- TARGETING / CAMLOCK
--------------------------------------------------
local CamlockEnabled = false
local LockedTarget = nil
local HitPart = "Head"

local TargetHighlight = Instance.new("Highlight")
TargetHighlight.FillColor = Color3.fromRGB(160, 80, 255)
TargetHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
TargetHighlight.FillTransparency = 0.5
TargetHighlight.Enabled = false
TargetHighlight.Parent = ScreenGui

local function GetClosestTarget()
    local mousePos = UserInputService:GetMouseLocation()
    local closest, dist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(HitPart) then
            local part = plr.Character[HitPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local mag = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if mag < dist then
                    dist = mag
                    closest = plr
                end
            end
        end
    end

    return closest
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.C then
        CamlockEnabled = not CamlockEnabled
        if CamlockEnabled then
            LockedTarget = GetClosestTarget()
            Status.Text = "Locked"
        else
            LockedTarget = nil
            TargetHighlight.Enabled = false
            Status.Text = "Idle"
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not CamlockEnabled then return end
    if not LockedTarget or not LockedTarget.Character then return end

    local part = LockedTarget.Character:FindFirstChild(HitPart)
    if not part then return end

    TargetHighlight.Adornee = LockedTarget.Character
    TargetHighlight.Enabled = true

    Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
end)

--------------------------------------------------
-- VISUAL PULSE (UI FEEL)
--------------------------------------------------
task.spawn(function()
    while task.wait(1.2) do
        TweenService:Create(
            Stroke,
            TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Transparency = Stroke.Transparency == 0 and 0.35 or 0}
        ):Play()
    end
end)

--------------------------------------------------
-- FINISH
--------------------------------------------------
print("[Battery.cc] Loaded")
