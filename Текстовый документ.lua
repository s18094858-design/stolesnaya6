-- DIMSTAT FLIGHT+NOCLIP SCRIPT v1.0
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Переменные
local fly = false
local noclip = false
local speed = 50
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)

-- Функция полёта
local function toggleFly()
    fly = not fly
    if fly then
        bv.Parent = hrp
    else
        bv.Parent = nil
    end
end

-- Функция ноу-клипа
local function toggleNoclip()
    noclip = not noclip
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end

-- GUI меню
local sg = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DIMSTAT HUB"
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = text
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createButton("🔁 Полёт (F)", 40, toggleFly)
createButton("🚪 Ноу-клип", 80, toggleNoclip)
createButton("🔄 Сбросить всё", 120, function()
    fly = false
    bv.Parent = nil
    noclip = false
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    hum.WalkSpeed = 16
    hum.JumpPower = 50
end)

-- Управление с клавиатуры
local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

-- Логика полёта (обновление каждый кадр)
game:GetService("RunService").Heartbeat:Connect(function()
    if fly and hrp then
        local dir = Vector3.new(0, 0, 0)
        if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(0, 0, -speed) end
        if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir + Vector3.new(0, 0, speed) end
        if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir + Vector3.new(-speed, 0, 0) end
        if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + Vector3.new(speed, 0, 0) end
        if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, speed, 0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir + Vector3.new(0, -speed, 0) end

        local cam = workspace.CurrentCamera
        bv.Velocity = cam.CFrame.LookVector * dir.Z + cam.CFrame.RightVector * dir.X + cam.CFrame.UpVector * dir.Y
    end
end)

print("Скрипт загружен! Нажми F для полёта.")