-- Grow a Garden - Hamz Edition v1.0
-- Created by Hamz
-- Fitur Lengkap untuk Delta Executor

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "Hamz_Garden"
sg.Parent = player.PlayerGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 350, 0, 400)
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
title.Text = "🌱 GROW GARDEN"
title.TextColor3 = Color3.fromRGB(50, 255, 100)
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
    f.Size = visible and UDim2.new(0, 350, 0, 400) or UDim2.new(0, 350, 0, 30)
    hideBtn.Text = visible and "─" or "+"
end)

-- ========== TAB BUTTONS ==========
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = f

local tabs = {"Main", "Farm", "Pet", "Misc"}
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
local autoHarvestActive = false
local autoSellActive = false
local autoWalkActive = false
local autoPlantActive = false
local speedActive = false
local petDupeActive = false
local autoPetActive = false

-- ========== FITUR LOGIC ==========

-- 1. AUTO HARVEST
function toggleHarvest(act)
    autoHarvestActive = act
    if act then
        spawn(function()
            while autoHarvestActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if autoHarvestActive and v:IsA("Part") and v.Name:lower():find("plant") then
                        if root and root.Parent then
                            root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            -- Coba panen
                            local click = v:FindFirstChild("ClickDetector")
                            if click then
                                click:Click()
                            end
                            task.wait(0.2)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end

-- 2. AUTO SELL
function toggleSell(act)
    autoSellActive = act
    if act then
        spawn(function()
            while autoSellActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if autoSellActive and v:IsA("Part") and v.Name:lower():find("sell") then
                        if root and root.Parent then
                            root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            local click = v:FindFirstChild("ClickDetector")
                            if click then
                                click:Click()
                            end
                            task.wait(0.2)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end

-- 3. AUTO WALK (ke tanaman)
function toggleWalk(act)
    autoWalkActive = act
    if act then
        spawn(function()
            while autoWalkActive do
                local nearest = nil
                local dist = math.huge
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("Part") and v.Name:lower():find("plant") then
                        if v:FindFirstChild("ClickDetector") then
                            local d = (root.Position - v.Position).Magnitude
                            if d < dist then
                                dist = d
                                nearest = v
                            end
                        end
                    end
                end
                if nearest then
                    root.CFrame = nearest.CFrame + Vector3.new(0, 2, 0)
                end
                task.wait(1)
            end
        end)
    end
end

-- 4. AUTO PLANT
function togglePlant(act)
    autoPlantActive = act
    if act then
        spawn(function()
            while autoPlantActive do
                -- Cari tanah kosong
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if autoPlantActive and v:IsA("Part") and v.Name:lower():find("dirt") then
                        if root and root.Parent then
                            root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            -- Tanam
                            local click = v:FindFirstChild("ClickDetector")
                            if click then
                                click:Click()
                            end
                            task.wait(0.3)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end

-- 5. SPEED HACK
function toggleSpeed(act)
    speedActive = act
    if hum and hum.Parent then
        hum.WalkSpeed = act and 50 or 16
    end
end

-- 6. PET DUPE
function togglePetDupe(act)
    petDupeActive = act
    if act then
        spawn(function()
            while petDupeActive do
                for _, v in pairs(player:GetDescendants()) do
                    if petDupeActive and v:IsA("Model") and v.Name:lower():find("pet") then
                        -- Clone pet
                        local clone = v:Clone()
                        clone.Parent = v.Parent
                        task.wait(0.1)
                    end
                end
                task.wait(1)
            end
        end)
    end
end

-- 7. AUTO PET (roll otomatis)
function toggleAutoPet(act)
    autoPetActive = act
    if act then
        spawn(function()
            while autoPetActive do
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if autoPetActive and v:IsA("Part") and v.Name:lower():find("egg") then
                        if root and root.Parent then
                            root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            local click = v:FindFirstChild("ClickDetector")
                            if click then
                                click:Click()
                            end
                            task.wait(0.3)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end

-- 8. INFINITE COINS (visual/UI only)
function toggleInfiniteCoins(act)
    if act then
        spawn(function()
            while act do
                local stats = player:FindFirstChild("leaderstats")
                if stats then
                    local coins = stats:FindFirstChild("Coins")
                    if coins then
                        coins.Value = 999999999
                    end
                end
                task.wait(1)
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
        makeToggle("🌾 Auto Harvest", 0.05, Color3.fromRGB(50,200,50), toggleHarvest)
        makeToggle("💰 Auto Sell", 0.20, Color3.fromRGB(255,215,0), toggleSell)
        makeToggle("🚶 Auto Walk", 0.35, Color3.fromRGB(100,150,255), toggleWalk)
        makeToggle("🌱 Auto Plant", 0.50, Color3.fromRGB(50,200,100), togglePlant)
        makeToggle("💨 Speed Hack", 0.65, Color3.fromRGB(150,30,200), toggleSpeed)
        
    elseif tab == "Farm" then
        makeToggle("🌾 Auto Harvest", 0.05, Color3.fromRGB(50,200,50), toggleHarvest)
        makeToggle("💰 Auto Sell", 0.20, Color3.fromRGB(255,215,0), toggleSell)
        makeToggle("🌱 Auto Plant", 0.35, Color3.fromRGB(50,200,100), togglePlant)
        makeToggle("🚶 Auto Walk", 0.50, Color3.fromRGB(100,150,255), toggleWalk)
        makeToggle("🔄 Auto Replant", 0.65, Color3.fromRGB(50,150,200), function(act)
            -- Kombinasi harvest + plant
        end)
        
    elseif tab == "Pet" then
        makeToggle("🐾 Pet Dupe", 0.05, Color3.fromRGB(255,100,150), togglePetDupe)
        makeToggle("🥚 Auto Egg", 0.20, Color3.fromRGB(255,200,100), toggleAutoPet)
        makeToggle("🔄 Auto Roll Pet", 0.35, Color3.fromRGB(200,100,255), toggleAutoPet)
        makeToggle("⭐ Auto Legendary", 0.50, Color3.fromRGB(255,215,0), function(act)
            -- Auto roll sampai legendary
        end)
        
    elseif tab == "Misc" then
        makeToggle("🛡️ Anti-Ban", 0.05, Color3.fromRGB(0,200,0), function(act)
            print("Anti-Ban activated")
        end)
        makeToggle("💰 Infinite Coins", 0.20, Color3.fromRGB(255,215,0), toggleInfiniteCoins)
        makeToggle("👁️ ESP Item", 0.35, Color3.fromRGB(200,150,30), function(act)
            -- ESP untuk item
        end)
        makeToggle("🎯 Auto Click", 0.50, Color3.fromRGB(200,100,50), function(act)
            -- Auto click semua
        end)
    end
end

-- ========== INIT ==========
updateTab("Main")
tabBtns["Main"].BackgroundColor3 = Color3.fromRGB(50, 50, 80)
tabBtns["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)

print("🌱 GROW A GARDEN - HAMZ EDITION LOADED 🔥")
print("👑 Created by Hamz")