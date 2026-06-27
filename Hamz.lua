-- Hamz - Survive The Killer Full Script
-- Created by Hamz

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz"
sg.Parent = player.PlayerGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 300, 0, 420)
f.Position = UDim2.new(0.5, -150, 0.5, -210)
f.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
f.BackgroundTransparency = 0.15
f.BorderSizePixel = 0
f.Draggable = true
f.Active = true
f.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
title.BackgroundTransparency = 0.3
title.Text = "🔥 HAMZ v1.0 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = f

local function makeBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, pos, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active, btn)
    end)
    return btn
end

-- FITUR 1: INFINITE JUMP
local jumpActive = false
makeBtn("🦘 Infinite Jump", 0.11, Color3.fromRGB(30, 150, 200), function(act, btn)
    jumpActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 150, 200)
    btn.Text = act and "🦘 JUMP ON" or "🦘 Infinite Jump"
    if act then
        game:GetService("RunService").Stepped:Connect(function()
            if jumpActive and hum then
                hum.JumpPower = 999
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.01)
                hum.JumpPower = 50
            end
        end)
    end
end)

-- FITUR 2: SPEED HACK
local speedActive = false
makeBtn("💨 Speed Hack", 0.24, Color3.fromRGB(150, 30, 200), function(act, btn)
    speedActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 30, 200)
    btn.Text = act and "💨 SPEED ON" or "💨 Speed Hack"
    hum.WalkSpeed = act and 50 or 16
end)

-- FITUR 3: ESP PLAYER
local espActive = false
makeBtn("👁️ ESP Player", 0.37, Color3.fromRGB(200, 150, 30), function(act, btn)
    espActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 150, 30)
    btn.Text = act and "👁️ ESP ON" or "👁️ ESP Player"
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character then
            local h = v.Character:FindFirstChild("Highlight")
            if act and not h then
                h = Instance.new("Highlight")
                h.Adornee = v.Character
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.FillTransparency = 0.4
                h.OutlineColor = Color3.fromRGB(0, 255, 0)
                h.Parent = v.Character
            elseif not act and h then
                h:Destroy()
            end
        end
    end
end)

-- FITUR 4: AUTO MURDERER
local murderActive = false
makeBtn("🔪 Auto Murderer", 0.50, Color3.fromRGB(200, 30, 30), function(act, btn)
    murderActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 30, 30)
    btn.Text = act and "🔪 MURDER ON" or "🔪 Auto Murderer"
    if act then
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if remote then
                    local attack = remote:FindFirstChild("Attack")
                    if attack then attack:FireServer(v, "kill") end
                end
            end
        end
    end
end)

-- FITUR 5: TELEPORT SURVIVOR
local teleBtn = Instance.new("TextButton")
teleBtn.Size = UDim2.new(0.9, 0, 0, 36)
teleBtn.Position = UDim2.new(0.05, 0, 0.63, 0)
teleBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
teleBtn.Text = "🌀 Teleport Survivor"
teleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleBtn.TextScaled = true
teleBtn.Font = Enum.Font.GothamBold
teleBtn.Parent = f
teleBtn.MouseButton1Click:Connect(function()
    local near = nil
    local dist = math.huge
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                near = v
            end
        end
    end
    if near then
        root.CFrame = near.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 3)
    end
end)

-- FITUR 6: AUTO FARM LOOT
local lootActive = false
makeBtn("💎 Auto Farm Loot", 0.76, Color3.fromRGB(30, 200, 150), function(act, btn)
    lootActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 200, 150)
    btn.Text = act and "💎 FARM ON" or "💎 Auto Farm Loot"
    if act then
        spawn(function()
            while lootActive do
                for _, item in pairs(game:GetService("Workspace"):GetChildren()) do
                    if item:IsA("Part") and item.Name:lower():find("loot") then
                        root.CFrame = item.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.1)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- BYPASS ANTI-BAN
local function antiBan()
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remote then
        remote.OnClientInvoke = function(...)
            return true
        end
    end
    
    local ac = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("AntiCheat")
    if ac then ac:Destroy() end
    
    game:GetService("ReplicatedStorage").ChildAdded:Connect(function(child)
        if child.Name:lower():find("ban") or child.Name:lower():find("kick") then
            child:Destroy()
        end
    end)
end

antiBan()

-- AUTO RE-EXECUTE SAAT RESPAWN
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if speedActive then
        hum.WalkSpeed = 50
    end
    task.wait(0.5)
    antiBan()
end)

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.90, 0)
status.BackgroundTransparency = 1
status.Text = "✅ HAMZ LOADED | by Hamz"
status.TextColor3 = Color3.fromRGB(0, 255, 100)
status.TextScaled = true
status.Font = Enum.Font.GothamBold
status.Parent = f

print("🔥 HAMZ SCRIPT LOADED SUCCESSFULLY 🔥")
print("👑 Created by Hamz")