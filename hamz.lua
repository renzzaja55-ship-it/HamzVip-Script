-- Hamz - Survive The Killer v4.0
-- Menu bergaya ChairWare Hub + ESP Fix Total

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz"
sg.Parent = player.PlayerGui

-- Main Frame (lebih lebar kayak ChairWare)
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
title.Text = "🔥 HAMZ v4.0"
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

-- ========== FITUR TOGGLE ==========
local function makeToggle(text, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = content
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active, btn)
    end)
    return btn
end

-- ========== UPDATE TAB ==========
local toggles = {}

function updateTab(tab)
    for _, child in pairs(content:GetChildren()) do
        child:Destroy()
    end
    toggles = {}
    
    if tab == "Main" then
        toggles[1] = makeToggle("🦘 Infinite Jump", 0.05, Color3.fromRGB(30,150,200), function(act, btn)
            -- Jump logic
        end)
        toggles[2] = makeToggle("💨 Speed Hack", 0.20, Color3.fromRGB(150,30,200), function(act, btn)
            -- Speed logic
        end)
        toggles[3] = makeToggle("👁️ ESP Player", 0.35, Color3.fromRGB(200,150,30), function(act, btn)
            -- ESP logic
        end)
        toggles[4] = makeToggle("🔪 Auto Murderer", 0.50, Color3.fromRGB(200,30,30), function(act, btn)
            -- Murderer logic
        end)
        toggles[5] = makeToggle("💀 Kill All", 0.65, Color3.fromRGB(255,0,100), function(act, btn)
            -- Kill All logic
        end)
        toggles[6] = makeToggle("💎 Auto Farm Loot", 0.80, Color3.fromRGB(30,200,150), function(act, btn)
            -- Loot logic
        end)
    elseif tab == "Visuals" then
        toggles[1] = makeToggle("👁️ ESP (Merah=Killer)", 0.05, Color3.fromRGB(200,150,30), function(act, btn)
            -- ESP with killer detection
        end)
        toggles[2] = makeToggle("🔴 ESP Killer Only", 0.20, Color3.fromRGB(255,0,0), function(act, btn)
            -- Show only killers
        end)
        toggles[3] = makeToggle("🔵 ESP Survivor Only", 0.35, Color3.fromRGB(0,100,255), function(act, btn)
            -- Show only survivors
        end)
        toggles[4] = makeToggle("📏 ESP Distance", 0.50, Color3.fromRGB(0,200,100), function(act, btn)
            -- Show distance
        end)
    elseif tab == "Movement" then
        toggles[1] = makeToggle("🦘 Infinite Jump", 0.05, Color3.fromRGB(30,150,200), function(act, btn)
            -- Jump logic
        end)
        toggles[2] = makeToggle("💨 Speed Hack", 0.20, Color3.fromRGB(150,30,200), function(act, btn)
            -- Speed logic
        end)
        toggles[3] = makeToggle("🌀 Teleport Survivor", 0.35, Color3.fromRGB(200,100,50), function(act, btn)
            -- Teleport logic
        end)
        toggles[4] = makeToggle("🌀 Teleport Loot", 0.50, Color3.fromRGB(30,200,150), function(act, btn)
            -- Teleport to loot
        end)
    elseif tab == "Misc" then
        toggles[1] = makeToggle("💎 Auto Farm Loot", 0.05, Color3.fromRGB(30,200,150), function(act, btn)
            -- Loot logic
        end)
        toggles[2] = makeToggle("🔪 Auto Murderer", 0.20, Color3.fromRGB(200,30,30), function(act, btn)
            -- Murderer logic
        end)
        toggles[3] = makeToggle("💀 Kill All", 0.35, Color3.fromRGB(255,0,100), function(act, btn)
            -- Kill All logic
        end)
        toggles[4] = makeToggle("🛡️ Anti-Ban", 0.50, Color3.fromRGB(0,200,0), function(act, btn)
            -- Anti-ban logic
        end)
    end
end

-- ========== ESP FIX TOTAL ==========
local espActive = false
local espConnections = {}

function updateESP(active)
    espActive = active
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character then
            local h = v.Character:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
    
    if active then
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
                        
                        -- ===== CEK KILLER =====
                        local isKiller = false
                        
                        -- Cek dari Humanoid Name (biasanya killer punya nama khusus)
                        local hum = v.Character:FindFirstChild("Humanoid")
                        if hum then
                            local displayName = hum.DisplayName or ""
                            if displayName:lower():find("killer") or displayName:lower():find("murderer") then
                                isKiller = true
                            end
                        end
                        
                        -- Cek dari Player Data
                        if not isKiller then
                            local data = v:FindFirstChild("PlayerData") or v:FindFirstChild("Data") or v:FindFirstChild("Stats")
                            if data then
                                for _, child in pairs(data:GetChildren()) do
                                    local name = child.Name:lower()
                                    if name:find("role") or name:find("team") or name:find("killer") or name:find("murderer") then
                                        local val = tostring(child.Value):lower()
                                        if val:find("killer") or val:find("murderer") then
                                            isKiller = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- Cek dari leaderstats
                        if not isKiller then
                            local stats = v:FindFirstChild("leaderstats")
                            if stats then
                                for _, child in pairs(stats:GetChildren()) do
                                    local name = child.Name:lower()
                                    if name:find("role") or name:find("team") then
                                        local val = tostring(child.Value):lower()
                                        if val:find("killer") or val:find("murderer") then
                                            isKiller = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- Cek dari Folder/Model
                        if not isKiller and v.Character then
                            for _, child in pairs(v.Character:GetChildren()) do
                                if child:IsA("Tool") or child:IsA("Model") then
                                    local name = child.Name:lower()
                                    if name:find("knife") or name:find("gun") or name:find("sword") or name:find("weapon") or name:find("blade") then
                                        isKiller = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        -- Cek dari Backpack
                        if not isKiller then
                            local backpack = v:FindFirstChild("Backpack")
                            if backpack then
                                for _, child in pairs(backpack:GetChildren()) do
                                    if child:IsA("Tool") then
                                        local name = child.Name:lower()
                                        if name:find("knife") or name:find("gun") or name:find("sword") or name:find("weapon") then
                                            isKiller = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- ===== WARNA =====
                        if isKiller then
                            h.FillColor = Color3.fromRGB(255, 0, 0) -- MERAH TERANG
                            h.OutlineColor = Color3.fromRGB(255, 50, 50)
                        else
                            h.FillColor = Color3.fromRGB(0, 120, 255) -- BIRU TERANG
                            h.OutlineColor = Color3.fromRGB(80, 180, 255)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

-- ========== CALLBACK FUNCTIONS ==========
local function setupCallbacks()
    -- Override toggle functions with actual logic
    local jumpActive = false
    local speedActive = false
    local murderActive = false
    local killAllActive = false
    local lootActive = false
    local espActive = false
    
    -- Update toggles dengan logic sebenarnya
    -- (Di sini bisa ditambahkan logic untuk setiap fitur)
end

-- ========== INIT ==========
updateTab("Main")
tabBtns["Main"].BackgroundColor3 = Color3.fromRGB(50, 50, 80)
tabBtns["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)

print("🔥 HAMZ v4.0 LOADED 🔥")
print("👑 Created by Hamz")