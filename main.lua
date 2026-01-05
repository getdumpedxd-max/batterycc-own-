--// Battery.cc – UI + Targeting
--// Executor: Xeno / Velocity

if not game:IsLoaded() then
    game.Loaded:Wait()
end

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// =========================
--// UI SHELL (YOUR STYLE)
--// =========================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BatteryCC"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromScale(0.22, 0.18)
Main.Position = UDim2.fromScale(0.39, 0.38)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Battery.cc | Beta"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(180, 120, 255)
Title.Parent = Main

--// Drag
do
    local dragging, dragInput, startPos, startMouse

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startMouse = input.Position
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
            local delta = input.Position - startMouse
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// =========================
--// TARGETING LOGIC
--// =========================

local StickyAimEnabled = false
local lockedTarget = nil
local targetHitPart = "Head"

-- Highlight
local targetHighlight = Instance.new("Highlight")
targetHighlight.FillColor = Color3.fromRGB(170, 0, 255)
targetHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
targetHighlight.FillTransparency = 0.45
targetHighlight.Enabled = false
targetHighlight.Parent = game.CoreGui

--// Find closest player to mouse
local function getClosestTarget()
    local mousePos = UserInputService:GetMouseLocation()
    local closest, dist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(targetHitPart) then
            local part = plr.Character[targetHitPart]
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

--// Keybind (C)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.C then
        StickyAimEnabled = not StickyAimEnabled

        if StickyAimEnabled then
            lockedTarget = getClosestTarget()
        else
            lockedTarget = nil
            targetHighlight.Enabled = false
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
end)

--// Camera Lock Loop
RunService.RenderStepped:Connect(function()
    if not StickyAimEnabled then return end
    if not lockedTarget or not lockedTarget.Character then return end

    local part = lockedTarget.Character:FindFirstChild(targetHitPart)
    if not part then return end

    targetHighlight.Adornee = lockedTarget.Character
    targetHighlight.Enabled = true

    Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
end)

--// =========================
--// HITSOUNDS
--// =========================

getgenv().hitsounds = {
    ["Bubble"] = "rbxassetid://6534947588",
    ["Pop"] = "rbxassetid://198598793",
    ["Neverlose"] = "rbxassetid://6534948092",
    ["Fatality"] = "rbxassetid://6534947869"
}

getgenv().selectedHitsound = "Bubble"
getgenv().hitsoundEnabled = true
getgenv().hitsoundVolume = 1

function playHitsound()
    if not getgenv().hitsoundEnabled then return end
    local sound = Instance.new("Sound")
    sound.SoundId = getgenv().hitsounds[getgenv().selectedHitsound]
    sound.Volume = getgenv().hitsoundVolume
    sound.Parent = workspace
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

--// Notify loaded
print("[Battery.cc] Loaded successfully")
