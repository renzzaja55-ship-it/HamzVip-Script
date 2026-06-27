-- Blue Lock: Rivals - Hamz Edition v3.0
-- Created by Hamz
-- Added OP Skills: Super Kick, Curve Ball, Instant Goal, Skill Spam, Auto Shoot

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz_BlueLock"
sg.Parent = player.PlayerGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 350, 0, 480)
f.Position = UDim2.new(0.7, 0, 0.1, 0)
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
title.Text = "⚽ BLUE LOCK v3"
title.TextColor3 = Color3.fromRGB(50, 200, 255)
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
    f.Size = visible and UDim2.new(0, 350, 0, 480) or UDim2.new(0, 350, 0, 30)
    hideBtn.Text = visible and "─" or "+"
end)

-- ========== TAB BUTTONS ==========
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = f

local tabs = {"Main", "Combat", "Movement", "Skills", "Ball"}
local tabBtns = {}
local currentTab = "Main"

local function createTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, 0, 1, 0)
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
    local btn = createTab(name, (i-1) * 0.2)
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
    btn.Size = UDim2.new(0.9, 0, 0, 28)
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
local speedActive = false
local flyActive = false
local noclipActive = false
local autoGoalActive = false
local autoStealActive = false
local autoFarmActive = false
local noCooldownActive = false
local superKickActive = false
local autoDribbleActive = false
local curveBallActive = false
local instantGoalActive = false
local skillSpamActive = false
local autoShootActive = false
local powerShotActive = false

-- ========== FITUR LOGIC ==========

-- 1. ESP PEMAIN & BOLA
function toggleESP(act)
    espActive = act
    -- Hapus ESP lama
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character then
            local h = v.Character:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("Part") and v.Name:lower():find("ball") then
            local h = v:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    
    if act then
        spawn(function()
            while espActive do
                -- ESP Pemain
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= player and v.Character then
                        local h = v.Character:FindFirstChild("Highlight")
                        if not h then
                            h = Instance.new("Highlight")
                            h.Adornee = v.Character
                            h.FillColor = Color3.fromRGB(255, 100, 0)
                            h.FillTransparency = 0.3
                            h.OutlineTransparency = 0.2
                            h.Parent = v.Character
                        end
                    end
                end
                -- ESP Bola
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and v.Name:lower():find("ball") then
                        local h = v:FindFirstChild("Highlight")
                        if not h then
                            h = Instance.new("Highlight")
                            h.Adornee = v
                            h.FillColor = Color3.fromRGB(255, 255, 0)
                            h.FillTransparency = 0.2
                            h.OutlineTransparency = 0.1
                            h.Parent = v
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 2. SPEED HACK
function toggleSpeed(act)
    speedActive = act
    if hum and hum.Parent then
        hum.WalkSpeed = act and 70 or 16
    end
end

-- 3. FLY
function toggleFly(act)
    flyActive = act
    if act then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 50, 0)
        bv.MaxForce = Vector3.new(0, 100000, 0)
        bv.Parent = root
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

-- 4. NOCLIP
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

-- 5. AUTO GOAL
function toggleAutoGoal(act)
    autoGoalActive = act
    if act then
        spawn(function()
            while autoGoalActive do
                local ball = nil
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and v.Name:lower():find("ball") then
                        ball = v
                        break
                    end
                end
                local enemyGoal = nil
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and (v.Name:lower():find("goal") or v.Name:lower():find("gawang")) then
                        local team = v:FindFirstChild("Team")
                        if team and team.Value ~= player.Team then
                            enemyGoal = v
                            break
                        end
                    end
                end
                if ball and enemyGoal then
                    root.CFrame = ball.CFrame + Vector3.new(0, 2, 2)
                    task.wait(0.1)
                    root.CFrame = enemyGoal.CFrame + Vector3.new(0, 2, 5)
                    task.wait(0.2)
                end
                task.wait(0.5)
            end
        end)
    end
end

-- 6. AUTO STEAL BALL
function toggleAutoSteal(act)
    autoStealActive = act
    if act then
        spawn(function()
            while autoStealActive do
                local ball = nil
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and v.Name:lower():find("ball") then
                        ball = v
                        break
                    end
                end
                
                if ball then
                    local ballOwner = nil
                    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                        if v ~= player and v.Character then
                            for _, tool in pairs(v.Character:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name:lower():find("ball") then
                                    ballOwner = v
                                    break
                                end
                            end
                        end
                    end
                    
                    if ballOwner then
                        root.CFrame = ballOwner.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 2)
                        task.wait(0.05)
                        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if remote then
                            local tackle = remote:FindFirstChild("Tackle") or remote:FindFirstChild("Steal") or remote:FindFirstChild("Intercept")
                            if tackle then
                                tackle:FireServer(ballOwner)
                            end
                        end
                        local click = ball:FindFirstChild("ClickDetector")
                        if click then
                            click:Click()
                        end
                    else
                        root.CFrame = ball.CFrame + Vector3.new(0, 2, 2)
                        task.wait(0.05)
                        local click = ball:FindFirstChild("ClickDetector")
                        if click then
                            click:Click()
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 7. AUTO FARM
function toggleAutoFarm(act)
    autoFarmActive = act
    if act then
        spawn(function()
            while autoFarmActive do
                local ball = nil
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and v.Name:lower():find("ball") then
                        ball = v
                        break
                    end
                end
                if ball then
                    root.CFrame = ball.CFrame + Vector3.new(0, 2, 2)
                    task.wait(0.1)
                    local click = ball:FindFirstChild("ClickDetector")
                    if click then click:Click() end
                end
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and (v.Name:lower():find("goal") or v.Name:lower():find("gawang")) then
                        local team = v:FindFirstChild("Team")
                        if team and team.Value ~= player.Team then
                            root.CFrame = v.CFrame + Vector3.new(0, 2, 5)
                            task.wait(0.2)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end

-- 8. NO COOLDOWN
function toggleNoCooldown(act)
    noCooldownActive = act
    if act then
        spawn(function()
            while noCooldownActive do
                local abilityController = game:GetService("ReplicatedStorage"):FindFirstChild("Controllers")
                if abilityController then
                    local ac = abilityController:FindFirstChild("AbilityController")
                    if ac then
                        local old = ac.AbilityCooldown
                        ac.AbilityCooldown = function(s, n, ...)
                            return old(s, n, 0, ...)
                        end
                    end
                end
                task.wait(5)
            end
        end)
    end
end

-- 9. SUPER KICK V2 (Efek Ledakan)
function toggleSuperKick(act)
    superKickActive = act
    if act then
        spawn(function()
            while superKickActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if superKickActive and v:IsA("Part") and v.Name:lower():find("ball") then
                        -- Ledakan efek
                        local explosion = Instance.new("Explosion")
                        explosion.Position = v.Position
                        explosion.BlastRadius = 10
                        explosion.BlastPressure = 1000
                        explosion.Parent = game:GetService("Workspace")
                        -- Tendang bola dengan kecepatan tinggi
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = Vector3.new(0, 200, 200)
                        bv.MaxForce = Vector3.new(100000, 100000, 100000)
                        bv.Parent = v
                        task.wait(0.1)
                        bv:Destroy()
                        -- Efek visual tambahan
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(5, 5, 5)
                        part.Position = v.Position
                        part.Anchored = true
                        part.CanCollide = false
                        part.BrickColor = BrickColor.new("Bright red")
                        part.Material = Enum.Material.Neon
                        part.Parent = game:GetService("Workspace")
                        game:GetService("Debris"):AddItem(part, 0.5)
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- 10. AUTO DRIBBLE
function toggleAutoDribble(act)
    autoDribbleActive = act
    if act then
        spawn(function()
            while autoDribbleActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if autoDribbleActive and v:IsA("Part") and v.Name:lower():find("ball") then
                        root.CFrame = v.CFrame + Vector3.new(0, 2, 1)
                        task.wait(0.05)
                        for _, g in pairs(game:GetService("Workspace"):GetDescendants()) do
                            if g:IsA("Part") and (g.Name:lower():find("goal") or g.Name:lower():find("gawang")) then
                                local team = g:FindFirstChild("Team")
                                if team and team.Value ~= player.Team then
                                    local dir = (g.Position - root.Position).Unit
                                    root.CFrame = root.CFrame + Vector3.new(dir.X * 5, 0, dir.Z * 5)
                                    task.wait(0.05)
                                end
                            end
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end

-- ========== SKILL OP BARU ==========

-- 11. CURVE BALL (Bola Berbelok)
function toggleCurveBall(act)
    curveBallActive = act
    if act then
        spawn(function()
            while curveBallActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if curveBallActive and v:IsA("Part") and v.Name:lower():find("ball") then
                        -- Beri efek curve/berbelok
                        local bv = v:FindFirstChild("BodyVelocity")
                        if not bv then
                            bv = Instance.new("BodyVelocity")
                            bv.MaxForce = Vector3.new(100000, 100000, 100000)
                            bv.Parent = v
                        end
                        -- Belokkan bola secara acak
                        local angle = math.rad(math.random(-45, 45))
                        local dir = Vector3.new(math.sin(angle), 0, math.cos(angle))
                        bv.Velocity = dir * 150
                        task.wait(0.1)
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end

-- 12. INSTANT GOAL (Langsung Gol!)
function toggleInstantGoal(act)
    instantGoalActive = act
    if act then
        spawn(function()
            while instantGoalActive do
                -- Cari gawang lawan
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if instantGoalActive and v:IsA("Part") and (v.Name:lower():find("goal") or v.Name:lower():find("gawang")) then
                        local team = v:FindFirstChild("Team")
                        if team and team.Value ~= player.Team then
                            -- Teleport bola ke dalam gawang
                            for _, ball in pairs(game:GetService("Workspace"):GetDescendants()) do
                                if ball:IsA("Part") and ball.Name:lower():find("ball") then
                                    ball.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                                    -- Efek ledakan
                                    local exp = Instance.new("Explosion")
                                    exp.Position = v.Position
                                    exp.BlastRadius = 5
                                    exp.BlastPressure = 500
                                    exp.Parent = game:GetService("Workspace")
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end

-- 13. SKILL SPAM (Spam Ability)
function toggleSkillSpam(act)
    skillSpamActive = act
    if act then
        spawn(function()
            while skillSpamActive do
                -- Cari semua remote yang berhubungan dengan skill
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if remotes then
                    for _, remote in pairs(remotes:GetChildren()) do
                        if remote.Name:lower():find("skill") or remote.Name:lower():find("ability") or remote.Name:lower():find("shoot") then
                            pcall(function()
                                remote:FireServer()
                            end)
                        end
                    end
                end
                -- Alternative: trigger ability melalui controller
                local abilityController = game:GetService("ReplicatedStorage"):FindFirstChild("Controllers")
                if abilityController then
                    local ac = abilityController:FindFirstChild("AbilityController")
                    if ac then
                        pcall(function()
                            ac:ActivateAbility()
                        end)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end

-- 14. AUTO SHOOT (Tendang Otomatis ke Gawang)
function toggleAutoShoot(act)
    autoShootActive = act
    if act then
        spawn(function()
            while autoShootActive do
                local ball = nil
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and v.Name:lower():find("ball") then
                        ball = v
                        break
                    end
                end
                local enemyGoal = nil
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and (v.Name:lower():find("goal") or v.Name:lower():find("gawang")) then
                        local team = v:FindFirstChild("Team")
                        if team and team.Value ~= player.Team then
                            enemyGoal = v
                            break
                        end
                    end
                end
                if ball and enemyGoal then
                    -- Cek jarak bola ke gawang
                    local dist = (ball.Position - enemyGoal.Position).Magnitude
                    if dist < 50 then
                        -- Tendang bola ke gawang
                        local dir = (enemyGoal.Position - ball.Position).Unit
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = dir * 200
                        bv.MaxForce = Vector3.new(100000, 100000, 100000)
                        bv.Parent = ball
                        task.wait(0.1)
                        bv:Destroy()
                        -- Efek tendangan
                        local exp = Instance.new("Explosion")
                        exp.Position = ball.Position
                        exp.BlastRadius = 3
                        exp.BlastPressure = 300
                        exp.Parent = game:GetService("Workspace")
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end

-- 15. POWER SHOT (Tendangan Bertenaga)
function togglePowerShot(act)
    powerShotActive = act
    if act then
        spawn(function()
            while powerShotActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if powerShotActive and v:IsA("Part") and v.Name:lower():find("ball") then
                        -- Efek power shot
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = Vector3.new(0, 300, 300)
                        bv.MaxForce = Vector3.new(1000000, 1000000, 1000000)
                        bv.Parent = v
                        -- Tambah efek neon
                        local neon = Instance.new("Part")
                        neon.Size = Vector3.new(8, 8, 8)
                        neon.Position = v.Position
                        neon.Anchored = true
                        neon.CanCollide = false
                        neon.BrickColor = BrickColor.new("Bright yellow")
                        neon.Material = Enum.Material.Neon
                        neon.Parent = game:GetService("Workspace")
                        game:GetService("Debris"):AddItem(neon, 0.3)
                        -- Getarkan layar (simulasi)
                        game:GetService("Workspace").CurrentCamera.FieldOfView = 120
                        task.wait(0.05)
                        game:GetService("Workspace").CurrentCamera.FieldOfView = 70
                        task.wait(0.1)
                        bv:Destroy()
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- ========== UPDATE TAB ==========
function updateTab(tab)
    for _, child in pairs(content:GetChildren()) do
        child:Destroy()
    end
    
    if tab == "Main" then
        makeToggle("👁️ ESP Player & Ball", 0.03, Color3.fromRGB(200,150,30), toggleESP)
        makeToggle("⚡ Speed Hack", 0.16, Color3.fromRGB(150,30,200), toggleSpeed)
        makeToggle("🎯 Auto Goal", 0.29, Color3.fromRGB(50,200,100), toggleAutoGoal)
        makeToggle("🔄 Auto Steal Ball", 0.42, Color3.fromRGB(255,150,50), toggleAutoSteal)
        makeToggle("🛡️ No Cooldown", 0.55, Color3.fromRGB(0,200,200), toggleNoCooldown)
        makeToggle("⚡ Super Kick V2", 0.68, Color3.fromRGB(255,100,0), toggleSuperKick)
        makeToggle("💥 Power Shot", 0.81, Color3.fromRGB(200,50,200), togglePowerShot)
        
    elseif tab == "Combat" then
        makeToggle("🔄 Auto Steal Ball", 0.03, Color3.fromRGB(255,150,50), toggleAutoSteal)
        makeToggle("🎯 Auto Goal", 0.16, Color3.fromRGB(50,200,100), toggleAutoGoal)
        makeToggle("⚡ Super Kick V2", 0.29, Color3.fromRGB(255,100,0), toggleSuperKick)
        makeToggle("🏃 Auto Dribble", 0.42, Color3.fromRGB(100,200,255), toggleAutoDribble)
        makeToggle("🛡️ No Cooldown", 0.55, Color3.fromRGB(0,200,200), toggleNoCooldown)
        makeToggle("⚔️ Auto Farm", 0.68, Color3.fromRGB(200,50,200), toggleAutoFarm)
        makeToggle("💥 Power Shot", 0.81, Color3.fromRGB(200,50,200), togglePowerShot)
        
    elseif tab == "Movement" then
        makeToggle("🕊️ Fly", 0.03, Color3.fromRGB(100,200,255), toggleFly)
        makeToggle("💨 Speed Hack", 0.16, Color3.fromRGB(150,30,200), toggleSpeed)
        makeToggle("🧱 NoClip", 0.29, Color3.fromRGB(100,100,200), toggleNoclip)
        makeToggle("🦘 Super Jump", 0.42, Color3.fromRGB(30,150,200), function(act)
            hum.JumpPower = act and 200 or 50
        end)
        makeToggle("🏃 Auto Dribble", 0.55, Color3.fromRGB(100,200,255), toggleAutoDribble)
        makeToggle("⚡ Super Kick V2", 0.68, Color3.fromRGB(255,100,0), toggleSuperKick)
        
    elseif tab == "Skills" then
        makeToggle("⚡ Super Kick V2 (Ledakan)", 0.03, Color3.fromRGB(255,100,0), toggleSuperKick)
        makeToggle("🌀 Curve Ball (Berbelok)", 0.16, Color3.fromRGB(0,200,200), toggleCurveBall)
        makeToggle("🎯 Instant Goal (Langsung Gol)", 0.29, Color3.fromRGB(255,215,0), toggleInstantGoal)
        makeToggle("⚡ Skill Spam (Spam Skill)", 0.42, Color3.fromRGB(200,50,200), toggleSkillSpam)
        makeToggle("🎯 Auto Shoot (Tendang Otomatis)", 0.55, Color3.fromRGB(255,150,50), toggleAutoShoot)
        makeToggle("💥 Power Shot (Tendangan Super)", 0.68, Color3.fromRGB(200,50,200), togglePowerShot)
        makeToggle("🛡️ No Cooldown", 0.81, Color3.fromRGB(0,200,200), toggleNoCooldown)
        
    elseif tab == "Ball" then
        makeToggle("🔄 Auto Steal Ball", 0.03, Color3.fromRGB(255,150,50), toggleAutoSteal)
        makeToggle("🎯 Auto Goal", 0.16, Color3.fromRGB(50,200,100), toggleAutoGoal)
        makeToggle("🏃 Auto Dribble", 0.29, Color3.fromRGB(100,200,255), toggleAutoDribble)
        makeToggle("⚡ Super Kick V2", 0.42, Color3.fromRGB(255,100,0), toggleSuperKick)
        makeToggle("⚔️ Auto Farm", 0.55, Color3.fromRGB(200,50,200), toggleAutoFarm)
        makeToggle("👁️ ESP Ball", 0.68, Color3.fromRGB(255,255,0), function(act)
            if act then
                spawn(function()
                    while act do
                        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                            if v:IsA("Part") and v.Name:lower():find("ball") then
                                local h = v:FindFirstChild("Highlight")
                                if not h then
                                    h = Instance.new("Highlight")
                                    h.Adornee = v
                                    h.FillColor = Color3.fromRGB(255, 255, 0)
                                    h.FillTransparency = 0.1
                                    h.OutlineTransparency = 0.1
                                    h.Parent = v
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end)
        makeToggle("🌀 Curve Ball", 0.81, Color3.fromRGB(0,200,200), toggleCurveBall)
    end
end

-- ========== INIT ==========
updateTab("Main")
tabBtns["Main"].BackgroundColor3 = Color3.fromRGB(50, 50, 80)
tabBtns["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)

print("⚽ BLUE LOCK v3 - HAMZ EDITION LOADED 🔥")
print("👑 Created by Hamz - OP Skills Added!")