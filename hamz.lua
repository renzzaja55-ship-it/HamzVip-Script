-- Dead Rails - Hamz Edition v1.0
-- Created by Hamz
-- Fitur Lengkap untuk Delta Executor

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz_DeadRails"
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
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚂 DEAD RAILS"
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

local tabs = {"Main", "Combat", "Movement", "Teleport"}
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

-- ========== VARIABLES ==========
local espActive = false
local killAuraActive = false
local flyActive = false
local speedActive = false
local noclipActive = false
local autoBondActive = false
local autoFuelActive = false
local autoHealActive = false

-- ========== FITUR LOGIC ==========

-- 1. ESP
function toggleESP(act)
    espActive = act
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character then
            local h = v.Character:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    -- ESP Zombie
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("zombie") then
            local h = v:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    
    if act then
        spawn(function()
            while espActive do
                -- Player ESP
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= player and v.Character then
                        local h = v.Character:FindFirstChild("Highlight")
                        if not h then
                            h = Instance.new("Highlight")
                            h.Adornee = v.Character
                            h.FillColor = Color3.fromRGB(0, 200, 255)
                            h.FillTransparency = 0.3
                            h.OutlineTransparency = 0.2
                            h.Parent = v.Character
                        end
                    end
                end
                -- Zombie ESP
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Model") and v.Name:lower():find("zombie") then
                        local h = v:FindFirstChild("Highlight")
                        if not h then
                            h = Instance.new("Highlight")
                            h.Adornee = v
                            h.FillColor = Color3.fromRGB(255, 0, 0)
                            h.FillTransparency = 0.3
                            h.OutlineTransparency = 0.2
                            h.Parent = v
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 2. KILL AURA
function toggleKillAura(act)
    killAuraActive = act
    if act then
        spawn(function()
            while killAuraActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if killAuraActive and v:IsA("Model") and v.Name:lower():find("zombie") and v:FindFirstChild("Humanoid") then
                        local dist = (root.Position - v.PrimaryPart.Position).Magnitude
                        if dist < 20 then
                            v.Humanoid.Health = 0
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end

-- 3. FLY
function toggleFly(act)
    flyActive = act
    if act then
        local fly = Instance.new("BodyVelocity")
        fly.Velocity = Vector3.new(0, 50, 0)
        fly.MaxForce = Vector3.new(0, 100000, 0)
        fly.Parent = root
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if flyActive and root:FindFirstChild("BodyVelocity") then
                root.BodyVelocity.Velocity = Vector3.new(0, 50, 0)
            end
        end)
    else
        if root:FindFirstChild("BodyVelocity") then
            root.BodyVelocity:Destroy()
        end
    end
end

-- 4. SPEED HACK
function toggleSpeed(act)
    speedActive = act
    if hum and hum.Parent then
        hum.WalkSpeed = act and 50 or 16
    end
end

-- 5. NOCLIP
function toggleNoclip(act)
    noclipActive = act
    if act then
        spawn(function()
            while noclipActive do
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CanCollide = false
                end
                task.wait(0.1)
            end
        end)
    else
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CanCollide = true
        end
    end
end

-- 6. AUTO BONDS
function toggleAutoBond(act)
    autoBondActive = act
    if act then
        spawn(function()
            while autoBondActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if autoBondActive and v:IsA("Part") and v.Name:lower():find("bond") then
                        if root and root.Parent then
                            root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 7. AUTO FUEL
function toggleAutoFuel(act)
    autoFuelActive = act
    if act then
        spawn(function()
            while autoFuelActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if autoFuelActive and v:IsA("Part") and v.Name:lower():find("fuel") then
                        if root and root.Parent then
                            root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 8. AUTO HEAL
function toggleAutoHeal(act)
    autoHealActive = act
    if act then
        spawn(function()
            while autoHealActive do
                if hum and hum.Parent then
                    -- Cari bandage/medkit di inventory
                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        for _, tool in pairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and (tool.Name:lower():find("bandage") or tool.Name:lower():find("medkit")) then
                                tool.Parent = char
                                tool:Activate()
                                task.wait(0.5)
                                tool.Parent = backpack
                            end
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
end

-- 9. TELEPORT FUNCTIONS
function teleportTo(pos)
    root.CFrame = CFrame.new(pos)
end

-- ========== UPDATE TAB ==========
function updateTab(tab)
    for _, child in pairs(content:GetChildren()) do
        child:Destroy()
    end
    
    if tab == "Main" then
        makeToggle("👁️ ESP Player & Zombie", 0.05, Color3.fromRGB(200,150,30), toggleESP)
        makeToggle("⚔️ Kill Aura", 0.20, Color3.fromRGB(255,0,0), toggleKillAura)
        makeToggle("🔄 Auto Bonds", 0.35, Color3.fromRGB(255,215,0), toggleAutoBond)
        makeToggle("⛽ Auto Fuel", 0.50, Color3.fromRGB(255,150,50), toggleAutoFuel)
        makeToggle("🏥 Auto Heal", 0.65, Color3.fromRGB(0,200,100), toggleAutoHeal)
        
    elseif tab == "Combat" then
        makeToggle("⚔️ Kill Aura", 0.05, Color3.fromRGB(255,0,0), toggleKillAura)
        makeToggle("🏹 Auto Aim", 0.20, Color3.fromRGB(200,100,50), function(act)
            -- Aimbot sederhana
        end)
        makeToggle("🔫 Rapid Fire", 0.35, Color3.fromRGB(200,50,200), function(act)
            -- Rapid fire
        end)
        makeToggle("💥 Explosive Ammo", 0.50, Color3.fromRGB(255,100,0), function(act)
            -- Explosive ammo
        end)
        
    elseif tab == "Movement" then
        makeToggle("🕊️ Fly", 0.05, Color3.fromRGB(100,200,255), toggleFly)
        makeToggle("💨 Speed Hack", 0.20, Color3.fromRGB(150,30,200), toggleSpeed)
        makeToggle("🧱 NoClip", 0.35, Color3.fromRGB(100,100,200), toggleNoclip)
        makeToggle("🦘 Super Jump", 0.50, Color3.fromRGB(30,150,200), function(act)
            hum.JumpPower = act and 200 or 50
        end)
        
    elseif tab == "Teleport" then
        local btn1 = makeToggle("📍 Teleport ke End", 0.05, Color3.fromRGB(0,200,0), function(act)
            if act then
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v.Name:lower():find("end") then
                        teleportTo(v.Position)
                        break
                    end
                end
            end
        end)
        local btn2 = makeToggle("📍 Teleport ke Tesla Lab", 0.20, Color3.fromRGB(0,150,255), function(act)
            if act then
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v.Name:lower():find("tesla") then
                        teleportTo(v.Position)
                        break
                    end
                end
            end
        end)
        local btn3 = makeToggle("📍 Teleport ke Castle", 0.35, Color3.fromRGB(150,100,50), function(act)
            if act then
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v.Name:lower():find("castle") then
                        teleportTo(v.Position)
                        break
                    end
                end
            end
        end)
        local btn4 = makeToggle("📍 Teleport ke Fort", 0.50, Color3.fromRGB(100,150,50), function(act)
            if act then
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v.Name:lower():find("fort") then
                        teleportTo(v.Position)
                        break
                    end
                end
            end
        end)
    end
end

-- ========== INIT ==========
updateTab("Main")
tabBtns["Main"].BackgroundColor3 = Color3.fromRGB(50, 50, 80)
tabBtns["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)

print("🚂 DEAD RAILS - HAMZ EDITION LOADED 🔥")
print("👑 Created by Hamz")