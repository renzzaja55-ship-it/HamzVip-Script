-- Hamz - Survive The Killer v3.0
-- FIX: Menu rapi, ESP warna bener, Jump manual, Speed diatur

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz"
sg.Parent = player.PlayerGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 620, 0, 100)
f.Position = UDim2.new(0.5, -310, 0, 10)
f.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
f.BackgroundTransparency = 0.15
f.BorderSizePixel = 1
f.BorderColor3 = Color3.fromRGB(50, 50, 80)
f.Draggable = true
f.Active = true
f.Parent = sg

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 55, 0, 25)
title.Position = UDim2.new(0.01, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡HAMZ"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = f

-- Hide Button
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 30, 0, 18)
hideBtn.Position = UDim2.new(0.95, 0, 0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
hideBtn.Text = "─"
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
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
    hideBtn.Text = visible and "─" or "+"
    f.Size = visible and UDim2.new(0, 620, 0, 100) or UDim2.new(0, 620, 0, 28)
end)

-- ========== FUNGSI TOMBOL ==========
local function makeBtn(text, posX, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 65, 0, 28)
    btn.Position = UDim2.new(posX, 0, 0.12, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
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

-- ========== SLIDER SPEED ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 50, 0, 20)
speedLabel.Position = UDim2.new(0.85, 0, 0.65, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Spd:16"
speedLabel.TextColor3 = Color3.fromRGB(200,200,200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.GothamBold
speedLabel.Parent = f

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0, 60, 0, 15)
speedSlider.Position = UDim2.new(0.85, 0, 0.80, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.Text = "─────●─────"
speedSlider.TextColor3 = Color3.fromRGB(255,255,255)
speedSlider.TextScaled = true
speedSlider.Font = Enum.Font.GothamBold
speedSlider.BorderSizePixel = 0
speedSlider.Parent = f

local speedValue = 16
local speedActive = false
speedSlider.MouseButton1Click:Connect(function()
    local speeds = {16, 25, 35, 45, 55, 70}
    local idx = 1
    for i, v in ipairs(speeds) do
        if v == speedValue then idx = i end
    end
    idx = idx % #speeds + 1
    speedValue = speeds[idx]
    speedLabel.Text = "Spd:"..speedValue
    if speedActive then hum.WalkSpeed = speedValue end
end)

-- ========== FITUR 1: JUMP (MANUAL) ==========
local jumpActive = false
makeBtn("🦘Jump", 0.10, Color3.fromRGB(30, 150, 200), function(act, btn)
    jumpActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0,200,0) or Color3.fromRGB(30,150,200)
    btn.Text = act and "🦘ON" or "🦘Jump"
    if act then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if jumpActive and hum and hum.Parent then
                hum.JumpPower = 80
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.05)
                hum.JumpPower = 50
            end
        end)
    end
end)

-- ========== FITUR 2: SPEED ==========
makeBtn("💨Speed", 0.22, Color3.fromRGB(150, 30, 200), function(act, btn)
    speedActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0,200,0) or Color3.fromRGB(150,30,200)
    btn.Text = act and "💨ON" or "💨Speed"
    if hum and hum.Parent then
        hum.WalkSpeed = act and speedValue or 16
    end
end)

-- ========== FITUR 3: ESP (FIX TOTAL) ==========
local espActive = false
makeBtn("👁️ESP", 0.34, Color3.fromRGB(200, 150, 30), function(act, btn)
    espActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,150,30)
    btn.Text = act and "👁️ON" or "👁️ESP"
    
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character then
            local h = v.Character:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    
    if act then
        spawn(function()
            while espActive do
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                        local h = v.Character:FindFirstChild("Highlight")
                        if not h then
                            h = Instance.new("Highlight")
                            h.Adornee = v.Character
                            h.FillTransparency = 0.25
                            h.OutlineTransparency = 0.15
                            h.Parent = v.Character
                        end
                        
                        -- CEK KILLER
                        local isKiller = false
                        local data = v:FindFirstChild("PlayerData") or v:FindFirstChild("Data")
                        if data then
                            local role = data:FindFirstChild("Role") or data:FindFirstChild("Team")
                            if role then
                                local val = tostring(role.Value)
                                if val:lower():find("killer") or val:lower():find("murderer") then
                                    isKiller = true
                                end
                            end
                        end
                        if not isKiller then
                            local stats = v:FindFirstChild("leaderstats")
                            if stats then
                                local role = stats:FindFirstChild("Role")
                                if role then
                                    local val = tostring(role.Value)
                                    if val:lower():find("killer") or val:lower():find("murderer") then
                                        isKiller = true
                                    end
                                end
                            end
                        end
                        -- CEK SENJATA
                        if not isKiller and v.Character then
                            for _, tool in pairs(v.Character:GetChildren()) do
                                if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("gun") or tool.Name:lower():find("sword")) then
                                    isKiller = true
                                    break
                                end
                            end
                        end
                        
                        if isKiller then
                            h.FillColor = Color3.fromRGB(255, 0, 0) -- MERAH
                            h.OutlineColor = Color3.fromRGB(255, 80, 80)
                        else
                            h.FillColor = Color3.fromRGB(0, 120, 255) -- BIRU
                            h.OutlineColor = Color3.fromRGB(80, 180, 255)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)

-- ========== FITUR 4: MURDERER ==========
local murderActive = false
makeBtn("🔪Kill", 0.46, Color3.fromRGB(200, 30, 30), function(act, btn)
    murderActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,30,30)
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
                                task.wait(0.2)
                            end
                        end
                    end
                end
                task.wait(0.8)
            end
        end)
    end
end)

-- ========== FITUR 5: KILL ALL ==========
local killAllActive = false
makeBtn("💀All", 0.58, Color3.fromRGB(255, 0, 100), function(act, btn)
    killAllActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0,200,0) or Color3.fromRGB(255,0,100)
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
                                task.wait(0.05)
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)

-- ========== FITUR 6: LOOT ==========
local lootActive = false
makeBtn("💎Loot", 0.70, Color3.fromRGB(30, 200, 150), function(act, btn)
    lootActive = act
    btn.BackgroundColor3 = act and Color3.fromRGB(0,200,0) or Color3.fromRGB(30,200,150)
    btn.Text = act and "💎ON" or "💎Loot"
    if act then
        spawn(function()
            while lootActive do
                local found = false
                for _, item in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if lootActive and item:IsA("Part") and item.Name:lower():find("loot") then
                        if root and root.Parent then
                            root.CFrame = item.CFrame + Vector3.new(0, 2, 0)
                            found = true
                            task.wait(0.1)
                        end
                    end
                end
                if not found then
                    for _, folder in pairs(game:GetService("Workspace"):GetChildren()) do
                        if lootActive and folder:IsA("Folder") and folder.Name:lower():find("loot") then
                            for _, item in pairs(folder:GetChildren()) do
                                if lootActive and item:IsA("Part") then
                                    if root and root.Parent then
                                        root.CFrame = item.CFrame + Vector3.new(0, 2, 0)
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)

-- ========== BYPASS ==========
local function antiBan()
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remote then remote.OnClientInvoke = function(...) return true end end
    local ac = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("AntiCheat")
    if ac then ac:Destroy() end
    game:GetService("ReplicatedStorage").ChildAdded:Connect(function(child)
        if child.Name:lower():find("ban") or child.Name:lower():find("kick") then child:Destroy() end
    end)
end
antiBan()

-- RESPAWN
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if speedActive then hum.WalkSpeed = speedValue end
    task.wait(0.5)
    antiBan()
end)

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 70, 0, 18)
status.Position = UDim2.new(0.82, 0, 0.75, 0)
status.BackgroundTransparency = 1
status.Text = "✅v3.0"
status.TextColor3 = Color3.fromRGB(0, 255, 100)
status.TextScaled = true
status.Font = Enum.Font.GothamBold
status.Parent = f

print("🔥 HAMZ v3.0 LOADED 🔥")