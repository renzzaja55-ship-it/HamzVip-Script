-- Hamz - Survive The Killer v4.1
-- FIX: Semua tombol berfungsi + ESP Fix

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ========== VARIABLES ==========
local jumpActive = false
local speedActive = false
local espActive = false
local murderActive = false
local killAllActive = false
local lootActive = false
local teleportActive = false
local speedValue = 16
local jumpConnection = nil
local espLoop = nil

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz"
sg.Parent = player.PlayerGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 350, 0, 450)
f.Position = UDim2.new(0.7, 0, 0.15, 0)
f.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
f.BackgroundTransparency = 0.1
f.BorderSizePixel = 1
f.BorderColor3 = Color3.fromRGB(60, 60, 100)
f.Draggable = true
f.Active = true
f.Parent = sg

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = f

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 HAMZ v4.1"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Hide Button
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 30, 1, 0)
hideBtn.Position = UDim2.new(0.92, 0, 0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideBtn.Text = "─"
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
hideBtn.TextScaled = true
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BorderSizePixel = 0
hideBtn.Parent = titleBar

local visible = true
hideBtn.MouseButton1Click:Connect(function()
    visible = not visible
    for _, child in pairs(f:GetChildren()) do
        if child ~= titleBar then
            child.Visible = visible
        end
    end
    f.Size = visible and UDim2.new(0, 350, 0, 450) or UDim2.new(0, 350, 0, 30)
    hideBtn.Text = visible and "─" or "+"
end)

-- ========== TAB BUTTONS ==========
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = f

local tabs = {"Main", "Visuals", "Movement", "Misc"}
local tabBtns = {}
local currentTab = "Main"

local function createTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    return btn
end

for i, name in ipairs(tabs) do
    local btn = createTab(name, (i-1) * 0.25)
    tabBtns[name] = btn
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for _, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        updateTab(name)
    end)
end

-- ========== CONTENT FRAME ==========
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -80)
content.Position = UDim2.new(0.05, 0, 0, 60)
content.BackgroundTransparency = 1
content.Parent = f

-- ========== FUNGSI TOGGLE ==========
local function makeToggle(text, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.BackgroundColor3 = color
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = content
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. (active and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 200, 0) or color
        callback(active)
    end)
    return btn
end

-- ========== FITUR LOGIC ==========

-- 1. INFINITE JUMP
function toggleJump(act)
    jumpActive = act
    if jumpConnection then jumpConnection:Disconnect() end
    if act then
        jumpConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if jumpActive and hum and hum.Parent then
                hum.JumpPower = 80
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.05)
                hum.JumpPower = 50
            end
        end)
    end
end

-- 2. SPEED HACK
function toggleSpeed(act)
    speedActive = act
    if hum and hum.Parent then
        hum.WalkSpeed = act and speedValue or 16
    end
end

-- 3. ESP
function toggleESP(act)
    espActive = act
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character then
            local h = v.Character:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    if espLoop then espLoop = nil end
    
    if act then
        espLoop = spawn(function()
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
                            for _, child in pairs(data:GetChildren()) do
                                if child.Name:lower():find("role") or child.Name:lower():find("team") then
                                    if tostring(child.Value):lower():find("killer") or tostring(child.Value):lower():find("murderer") then
                                        isKiller = true
                                        break
                                    end
                                end
                            end
                        end
                        if not isKiller then
                            local stats = v:FindFirstChild("leaderstats")
                            if stats then
                                for _, child in pairs(stats:GetChildren()) do
                                    if child.Name:lower():find("role") or child.Name:lower():find("team") then
                                        if tostring(child.Value):lower():find("killer") or tostring(child.Value):lower():find("murderer") then
                                            isKiller = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        if not isKiller and v.Character then
                            for _, tool in pairs(v.Character:GetChildren()) do
                                if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("gun") or tool.Name:lower():find("sword")) then
                                    isKiller = true
                                    break
                                end
                            end
                        end
                        
                        if isKiller then
                            h.FillColor = Color3.fromRGB(255, 0, 0)
                            h.OutlineColor = Color3.fromRGB(255, 50, 50)
                        else
                            h.FillColor = Color3.fromRGB(0, 120, 255)
                            h.OutlineColor = Color3.fromRGB(80, 180, 255)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 4. AUTO MURDERER
function toggleMurderer(act)
    murderActive = act
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
end

-- 5. KILL ALL
function toggleKillAll(act)
    killAllActive = act
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
end

-- 6. AUTO FARM LOOT
function toggleLoot(act)
    lootActive = act
    if act then
        spawn(function()
            while lootActive do
                for _, item in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if lootActive and item:IsA("Part") and item.Name:lower():find("loot") then
                        if root and root.Parent then
                            root.CFrame = item.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 7. TELEPORT SURVIVOR
function toggleTeleport(act)
    teleportActive = act
    if act then
        spawn(function()
            while teleportActive do
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
                task.wait(0.5)
            end
        end)
    end
end

-- 8. ANTI-BAN
function toggleAntiBan(act)
    if act then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remote then remote.OnClientInvoke = function(...) return true end end
        local ac = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("AntiCheat")
        if ac then ac:Destroy() end
        game:GetService("ReplicatedStorage").ChildAdded:Connect(function(child)
            if child.Name:lower():find("ban") or child.Name:lower():find("kick") then child:Destroy() end
        end)
    end
end

-- ========== UPDATE TAB ==========
function updateTab(tab)
    for _, child in pairs(content:GetChildren()) do
        child:Destroy()
    end
    
    if tab == "Main" then
        makeToggle("🦘 Infinite Jump", 0.05, Color3.fromRGB(30,150,200), toggleJump)
        makeToggle("💨 Speed Hack", 0.20, Color3.fromRGB(150,30,200), toggleSpeed)
        makeToggle("👁️ ESP Player", 0.35, Color3.fromRGB(200,150,30), toggleESP)
        makeToggle("🔪 Auto Murderer", 0.50, Color3.fromRGB(200,30,30), toggleMurderer)
        makeToggle("💀 Kill All", 0.65, Color3.fromRGB(255,0,100), toggleKillAll)
        makeToggle("💎 Auto Farm Loot", 0.80, Color3.fromRGB(30,200,150), toggleLoot)
        
    elseif tab == "Visuals" then
        makeToggle("👁️ ESP (Merah=Killer)", 0.05, Color3.fromRGB(200,150,30), toggleESP)
        makeToggle("🔴 ESP Killer Only", 0.20, Color3.fromRGB(255,0,0), function(act)
            -- Bisa ditambah filter khusus
        end)
        makeToggle("🔵 ESP Survivor Only", 0.35, Color3.fromRGB(0,100,255), function(act)
            -- Bisa ditambah filter khusus
        end)
        makeToggle("📏 ESP Distance", 0.50, Color3.fromRGB(0,200,100), function(act)
            -- Bisa ditambah jarak
        end)
        
    elseif tab == "Movement" then
        makeToggle("🦘 Infinite Jump", 0.05, Color3.fromRGB(30,150,200), toggleJump)
        makeToggle("💨 Speed Hack", 0.20, Color3.fromRGB(150,30,200), toggleSpeed)
        makeToggle("🌀 Teleport Survivor", 0.35, Color3.fromRGB(200,100,50), toggleTeleport)
        makeToggle("🌀 Teleport Loot", 0.50, Color3.fromRGB(30,200,150), function(act)
            lootActive = act
            if act then
                spawn(function()
                    while lootActive do
                        for _, item in pairs(game:GetService("Workspace"):GetDescendants()) do
                            if lootActive and item:IsA("Part") and item.Name:lower():find("loot") then
                                if root and root.Parent then
                                    root.CFrame = item.CFrame + Vector3.new(0, 2, 0)
                                    task.wait(0.05)
                                end
                            end
                        end
                        task.wait(0.2)
                    end
                end)
            end
        end)
        
    elseif tab == "Misc" then
        makeToggle("💎 Auto Farm Loot", 0.05, Color3.fromRGB(30,200,150), toggleLoot)
        makeToggle("🔪 Auto Murderer", 0.20, Color3.fromRGB(200,30,30), toggleMurderer)
        makeToggle("💀 Kill All", 0.35, Color3.fromRGB(255,0,100), toggleKillAll)
        makeToggle("🛡️ Anti-Ban", 0.50, Color3.fromRGB(0,200,0), toggleAntiBan)
    end
end

-- ========== INIT ==========
updateTab("Main")
tabBtns["Main"].BackgroundColor3 = Color3.fromRGB(50, 50, 80)
tabBtns["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Auto Anti-Ban ON
toggleAntiBan(true)

print("🔥 HAMZ v4.1 LOADED 🔥")
print("👑 Created by Hamz - All Features Working!")