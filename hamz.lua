-- Hamz - Survive The Killer Full Script v2.0
-- Created by Hamz
-- FIXED: Horizontal menu, all features working, ESP with color differentiation

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz"
sg.Parent = player.PlayerGui

-- Main Frame (HORIZONTAL - lebih kecil)
local f = Instance.new("Frame")
f.Size = UDim2.new(0, 560, 0, 120)
f.Position = UDim2.new(0.5, -280, 0, 10)
f.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
f.BackgroundTransparency = 0.2
f.BorderSizePixel = 0
f.Draggable = true
f.Active = true
f.Parent = sg

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 70, 0, 30)
title.Position = UDim2.new(0.01, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥HAMZ"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = f

-- ========== TOGGLE HIDE ==========
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 40, 0, 20)
hideBtn.Position = UDim2.new(0.93, 0, 0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideBtn.Text = "🔽"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.TextScaled = true
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BorderSizePixel = 0
hideBtn.Parent = f

local visible = true
hideBtn.MouseButton1Click:Connect(function()
    visible = not visible
    for _, child in pairs(f:GetChildren()) do
        if child ~= hideBtn and child ~= title then
            child.Visible = visible
        end
    end
    hideBtn.Text = visible and "🔽" or "🔼"
    f.Size = visible and UDim2.new(0, 560, 0, 120) or UDim2.new(0, 560, 0, 30)
end)

-- ========== BUTTON MAKER ==========
local function makeBtn(text, posX, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 0, 30)
    btn.Position = UDim2.new(posX, 0, posY, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = f
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active, btn)
    end)
    return btn
end

-- ========== FITUR 1: INFINITE JUMP (FIXED) ==========
local jumpActive = false
local jumpConnection
makeBtn("🦘Jump", 0.12, 0.05, Color3.fromRGB(30, 150, 200), function(act, btn)
    jumpActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 150, 200)
    btn.Text = act and "🦘ON" or "🦘Jump"
    if jumpConnection then jumpConnection:Disconnect() end
    if act then
        jumpConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if jumpActive and hum and hum.Parent then
                hum.JumpPower = 100
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait()
                hum.JumpPower = 50
            end
        end)
    end
end)

-- ========== FITUR 2: SPEED HACK (FIXED) ==========
local speedActive = false
makeBtn("💨Speed", 0.23, 0.05, Color3.fromRGB(150, 30, 200), function(act, btn)
    speedActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 30, 200)
    btn.Text = act and "💨ON" or "💨Speed"
    if hum and hum.Parent then
        hum.WalkSpeed = act and 55 or 16
    end
end)

-- ========== FITUR 3: ESP DENGAN WARNA (FIXED) ==========
local espActive = false
makeBtn("👁️ESP", 0.34, 0.05, Color3.fromRGB(200, 150, 30), function(act, btn)
    espActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 150, 30)
    btn.Text = act and "👁️ON" or "👁️ESP"
    
    -- Hapus semua ESP lama
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character then
            local h = v.Character:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    
    if act then
        -- Fungsi update ESP setiap detik
        spawn(function()
            while espActive do
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= player and v.Character then
                        local h = v.Character:FindFirstChild("Highlight")
                        if not h then
                            h = Instance.new("Highlight")
                            h.Adornee = v.Character
                            h.FillTransparency = 0.3
                            h.OutlineTransparency = 0.2
                            h.Parent = v.Character
                        end
                        
                        -- CEK APAKAH DIA PEMBUNUH (MURDERER)
                        local isMurderer = false
                        -- Cek dari game state (biasanya ada di PlayerStats atau leaderstats)
                        local stats = v:FindFirstChild("leaderstats")
                        if stats then
                            local role = stats:FindFirstChild("Role")
                            if role and (role.Value == "Murderer" or role.Value == "Killer") then
                                isMurderer = true
                            end
                        end
                        -- Alternatif: cek dari player data
                        if not isMurderer then
                            local data = v:FindFirstChild("PlayerData")
                            if data then
                                local role = data:FindFirstChild("Role")
                                if role and (role.Value == "Murderer" or role.Value == "Killer") then
                                    isMurderer = true
                                end
                            end
                        end
                        
                        -- Set warna: MERAH untuk pembunuh, BIRU untuk survivor
                        if isMurderer then
                            h.FillColor = Color3.fromRGB(255, 0, 0) -- MERAH
                            h.OutlineColor = Color3.fromRGB(255, 100, 100)
                        else
                            h.FillColor = Color3.fromRGB(0, 100, 255) -- BIRU
                            h.OutlineColor = Color3.fromRGB(100, 150, 255)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- ========== FITUR 4: AUTO MURDERER (FIXED) ==========
local murderActive = false
makeBtn("🔪Kill", 0.45, 0.05, Color3.fromRGB(200, 30, 30), function(act, btn)
    murderActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 30, 30)
    btn.Text = act and "🔪ON" or "🔪Kill"
    if act then
        spawn(function()
            while murderActive do
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if remote then
                            local attack = remote:FindFirstChild("Attack")
                            if attack then 
                                attack:FireServer(v, "kill")
                                task.wait(0.3)
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- ========== FITUR 5: AUTO KILL ALL (NEW) ==========
local killAllActive = false
makeBtn("💀All", 0.56, 0.05, Color3.fromRGB(255, 0, 100), function(act, btn)
    killAllActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 100)
    btn.Text = act and "💀ON" or "💀All"
    if act then
        spawn(function()
            while killAllActive do
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if remote then
                            local attack = remote:FindFirstChild("Attack")
                            if attack then 
                                attack:FireServer(v, "kill")
                                task.wait(0.1)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- ========== FITUR 6: AUTO FARM LOOT (FIXED) ==========
local lootActive = false
makeBtn("💎Loot", 0.67, 0.05, Color3.fromRGB(30, 200, 150), function(act, btn)
    lootActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 200, 150)
    btn.Text = act and "💎ON" or "💎Loot"
    if act then
        spawn(function()
            while lootActive do
                -- Cari loot di workspace
                for _, item in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if lootActive and item:IsA("Part") and item.Name:lower():find("loot") then
                        if root and root.Parent then
                            root.CFrame = item.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.15)
                        end
                    end
                end
                -- Cari loot di folder lain
                for _, folder in pairs(game:GetService("Workspace"):GetChildren()) do
                    if lootActive and folder:IsA("Folder") and folder.Name:lower():find("loot") then
                        for _, item in pairs(folder:GetChildren()) do
                            if lootActive and item:IsA("Part") then
                                if root and root.Parent then
                                    root.CFrame = item.CFrame + Vector3.new(0, 2, 0)
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- ========== BYPASS ANTI-BAN ==========
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

-- ========== AUTO RE-EXECUTE SAAT RESPAWN ==========
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if speedActive then
        hum.WalkSpeed = 55
    end
    task.wait(0.5)
    antiBan()
end)

-- ========== STATUS ==========
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 120, 0, 20)
status.Position = UDim2.new(0.78, 0, 0.75, 0)
status.BackgroundTransparency = 1
status.Text = "✅ v2.0 by Hamz"
status.TextColor3 = Color3.fromRGB(0, 255, 100)
status.TextScaled = true
status.Font = Enum.Font.GothamBold
status.Parent = f

print("🔥 HAMZ v2.0 LOADED SUCCESSFULLY 🔥")
print("👑 Created by Hamz")