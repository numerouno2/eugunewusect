-- 🔥 COMPACT SLIDE UI with Tabbed Menu (Modern Style)
-- by EUGUNEWU

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local remote = ReplicatedStorage:WaitForChild("BloxbizRemotes"):WaitForChild("OnSendGuiImpressions")

-- FLAGS
local running, duping, autoSelling, autoLeaveEnabled = false, false, false, false
local selectedRod = "HolyRod"
local lastLocation = nil

-- ROD LIST
local rodList = {
    "AuroraRod", "FischerRod", "HolyRod", "MidasRod",
    "PinkRod", "RelicRod", "SpecialRod", "SunkenRod",
    "UltratechRod", "NormalRod"
}

-- LOCATIONS
local sellPos = Vector3.new(-210, 15, 357)
local ambilRodPos = Vector3.new(78, 14, 442)
local afkFishPos = Vector3.new(-80, 14, -149)
local afkSpotPos = Vector3.new(-394.36, 19.52, 121.39)

-- ADMIN IDS
local adminUserIds = {
    [4719890723] = true, [6128717670] = true, [5688434066] = true,
    [7657531329] = true, [4963276186] = true, [8106185708] = true,
    [2527577137] = true, [2910167626] = true, [7898791239] = true,
}

-- FUNCTIONALITIES
local function autoFish()
    while running do
        pcall(function()
            local char = localPlayer.Character
            if not char then return end
            remote:FireServer({{
                button_path = "ContextActionGui.ContextButtonFrame.ContextActionButton",
                button_name = "ContextActionButton"
            }})
            task.wait(0.05)
            local rodTool = localPlayer.Backpack:FindFirstChild(selectedRod)
            if rodTool and not char:FindFirstChild(selectedRod) then
                rodTool.Parent = char
            end
            task.wait(0.02)
            local rod = char:FindFirstChild(selectedRod)
            if rod then
                local mini = rod:FindFirstChild("MiniGame")
                if mini then
                    mini:FireServer("Complete")
                end
            end
        end)
        task.wait(0.07)
    end
end

local function dupeFish()
    while duping do
        pcall(function()
            local char = localPlayer.Character
            local rod = char and char:FindFirstChild(selectedRod) or localPlayer.Backpack:FindFirstChild(selectedRod)
            if rod then
                local mini = rod:FindFirstChild("MiniGame")
                if mini then
                    for i = 1, 10 do
                        mini:FireServer("Complete")
                        task.wait(0.02)
                    end
                end
            end
        end)
        task.wait(1)
    end
end

local function teleportAndSell()
    local root = character:WaitForChild("HumanoidRootPart")
    lastLocation = root.Position
    root.CFrame = CFrame.new(sellPos + Vector3.new(0,3,0))
    task.wait(2)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
            if (obj.Parent.Position - root.Position).Magnitude <= 10 then
                obj:InputHoldBegin()
                task.wait(obj.HoldDuration or 1)
                obj:InputHoldEnd()
                break
            end
        end
    end
    task.wait(1)
    if lastLocation then root.CFrame = CFrame.new(lastLocation) end
end

local function antiAFK()
    while autoSelling do
        task.wait(15)
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Jump = true end
    end
end

local function checkPlayers()
    if not autoLeaveEnabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and adminUserIds[p.UserId] then
            localPlayer:Kick("🚨 Admin Detected. Auto-Kick activated.")
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    if autoLeaveEnabled and adminUserIds[p.UserId] then
        localPlayer:Kick("🚨 Admin Detected. Auto-Kick activated.")
    end
end)

-- UI COMPONENTS
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EugunewuUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 270, 0, 175)
frame.Position = UDim2.new(0, 25, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 6)
title.Text = "💠 Eugunewu Hub 💠"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 24, 0, 24)
minimize.Position = UDim2.new(1, -28, 0, 4)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 40, 0, 40)
miniBtn.Position = UDim2.new(0, 10, 1, -60)
miniBtn.Text = "🧠EU"
miniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 20
miniBtn.Visible = false
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

minimize.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    miniBtn.Visible = false
end)

-- Tabs UI
local tabNames = {"Main", "Teleport", "Settings", "Extras"}
local currentTab = "Main"
local contentFrames = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 60, 0, 26)
    btn.Position = UDim2.new(0, 10 + ((i-1)*65), 0, 38)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1, -20, 1, -80)
    content.Position = UDim2.new(0, 10, 0, 70)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    contentFrames[name] = content

    btn.MouseButton1Click:Connect(function()
        for _, fr in pairs(contentFrames) do fr.Visible = false end
        content.Visible = true
        currentTab = name
    end)
end

-- Button with toggle switch
local function createSwitch(parent, text, order, default, callback)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, -60, 0, 26)
    label.Position = UDim2.new(0, 0, 0, order * 30)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1

    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(0, 44, 0, 22)
    toggle.Position = UDim2.new(1, -50, 0, order * 30 + 2)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60,60,60)
    toggle.Text = ""
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

    local dot = Instance.new("Frame", toggle)
    dot.Size = UDim2.new(0.5, -4, 1, -4)
    dot.Position = default and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.Name = "Dot"
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local toggled = default
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggle.BackgroundColor3 = toggled and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
        dot:TweenPosition(toggled and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.2, true)
        callback(toggled)
    end)
end

-- Main Tab Content
createSwitch(contentFrames["Main"], "Start AutoFish", 0, false, function(val)
    if val and not running then running = true task.spawn(autoFish) else running = false end
end)

createSwitch(contentFrames["Main"], "Dupe Fish (Beta)", 1, false, function(val)
    if val and not duping then duping = true task.spawn(dupeFish) else duping = false end
end)

createSwitch(contentFrames["Main"], "AutoSell", 2, false, function(val)
    if val and not autoSelling then
        autoSelling = true
        task.spawn(antiAFK)
        task.spawn(function()
            while autoSelling do
                teleportAndSell()
                for i=1,180 do if not autoSelling then break end task.wait(1) end
            end
        end)
    else
        autoSelling = false
    end
end)

-- Settings Tab Content

-- Dropdown Rod Selector in Settings
local rodLabel = Instance.new("TextLabel", contentFrames["Settings"])
rodLabel.Size = UDim2.new(1, 0, 0, 16)
rodLabel.Position = UDim2.new(0, 0, 0, 3)
rodLabel.Text = "🎣 Pilih Pancingan:"
rodLabel.Font = Enum.Font.Gotham
rodLabel.TextSize = 14
rodLabel.TextColor3 = Color3.new(1, 1, 1)
rodLabel.BackgroundTransparency = 1
rodLabel.TextXAlignment = Enum.TextXAlignment.Left

local rodDropdown = Instance.new("TextButton", contentFrames["Settings"])
rodDropdown.Size = UDim2.new(1, -20, 0, 26)
rodDropdown.Position = UDim2.new(0, 0, 0, 20)
rodDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
rodDropdown.TextColor3 = Color3.new(1, 1, 1)
rodDropdown.Font = Enum.Font.Gotham
rodDropdown.TextSize = 14
rodDropdown.Text = selectedRod or "Pilih Rod"
Instance.new("UICorner", rodDropdown).CornerRadius = UDim.new(0, 6)

local dropdownList = Instance.new("ScrollingFrame", contentFrames["Settings"])
dropdownList.Size = UDim2.new(1, -20, 0, 100)
dropdownList.Position = UDim2.new(0, 0, 0, 50)
dropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dropdownList.Visible = false
dropdownList.ClipsDescendants = true
dropdownList.ScrollBarThickness = 6
dropdownList.CanvasSize = UDim2.new(0, 0, 0, #rodList * 24)
Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", dropdownList)
layout.Padding = UDim.new(0, 2)

for _, rodName in ipairs(rodList) do
    local rodBtn = Instance.new("TextButton", dropdownList)
    rodBtn.Size = UDim2.new(1, 0, 0, 22)
    rodBtn.Text = rodName
    rodBtn.Font = Enum.Font.Gotham
    rodBtn.TextSize = 13
    rodBtn.TextColor3 = Color3.new(1, 1, 1)
    rodBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Instance.new("UICorner", rodBtn).CornerRadius = UDim.new(0, 4)

    rodBtn.MouseButton1Click:Connect(function()
        selectedRod = rodName
        rodDropdown.Text = rodName
        dropdownList.Visible = false
    end)
end

rodDropdown.MouseButton1Click:Connect(function()
    dropdownList.Visible = not dropdownList.Visible
end)

-- Teleport Tab Content
createSwitch(contentFrames["Teleport"], "Ke Ambil Rod", 0, false, function(val)
    if val then
        local root = character:WaitForChild("HumanoidRootPart")
        lastLocation = root.Position
        root.CFrame = CFrame.new(ambilRodPos + Vector3.new(0,3,0))
    end
end)

createSwitch(contentFrames["Teleport"], "Ke Spot Mancing", 1, false, function(val)
    if val then
        local root = character:WaitForChild("HumanoidRootPart")
        lastLocation = root.Position
        root.CFrame = CFrame.new(afkFishPos + Vector3.new(0,3,0))
    end
end)

createSwitch(contentFrames["Teleport"], "Hidding Spot", 2, false, function(val)
    if val then
        local root = character:WaitForChild("HumanoidRootPart")
        lastLocation = root.Position
        root.CFrame = CFrame.new(afkSpotPos + Vector3.new(0,3,0))
    end
end)


-- Extras Tab Content
local function teleportAndSell()
    local root = character:WaitForChild("HumanoidRootPart")
    lastLocation = root.Position
    root.CFrame = CFrame.new(sellPos + Vector3.new(0,3,0))

    -- Tunggu 2 detik di tempat jual
    task.wait(2)

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
            if (obj.Parent.Position - root.Position).Magnitude <= 10 then
                obj:InputHoldBegin()
                task.wait(obj.HoldDuration or 1)
                obj:InputHoldEnd()
                break
            end
        end
    end

    task.wait(1) -- Delay sebentar sebelum balik

    if lastLocation then
        root.CFrame = CFrame.new(lastLocation)
    end

    -- Setelah balik, delay tunggu acak sebelum jual lagi
    task.wait(math.random(0, 600)) -- 0 - 600 detik (0 - 10 menit)
end

local function antiAFK()
    while autoSelling do
        task.wait(15)
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Jump = true end
    end
end

-- Extras Tab Content
createSwitch(contentFrames["Extras"], "Admin Detector", 0, false, function(val)
    autoLeaveEnabled = val
    checkPlayers()
end)

createSwitch(contentFrames["Extras"], "FPS Boost Mode", 1, false, function(val)
    fpsBoosted = val
    if val then
        for _, obj in pairs(workspace:GetDescendants()) do
            local lowerName = obj.Name:lower()
            if obj:IsA("BasePart") or obj:IsA("Model") then
                if (lowerName:find("tree") or lowerName:find("leaf") or lowerName:find("grass") or lowerName:find("flower") or lowerName:find("bush") or lowerName:find("seat") or lowerName:find("bench") or lowerName:find("building") or lowerName:find("wall") or lowerName:find("rock") or lowerName:find("fence") or lowerName:find("light")) and not obj:IsDescendantOf(localPlayer.Character) then
                    pcall(function() obj:Destroy() end)
                end
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("Beam") or obj:IsA("SurfaceAppearance") then
                pcall(function() obj:Destroy() end)
            end
        end

        local function hideOtherCharacter(char)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    pcall(function()
                        part.Transparency = 1
                        part.CanCollide = false
                    end)
                end
            end
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                hideOtherCharacter(player.Character)
            end
        end

        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                hideOtherCharacter(char)
            end)
        end)

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        Lighting.ClockTime = 12

        if Terrain then
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterColor = Color3.new(0, 0, 0)
        end

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    end
end)

createSwitch(contentFrames["Extras"], "Remove Animations", 2, false, function(val)
    if val and character then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("Animator") or v:IsA("AnimationController") then
                v:Destroy()
            end
        end
    end
end)
