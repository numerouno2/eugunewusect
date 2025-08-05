-- 🌌 EUGUNEWU HUB UI (Updated: Roblox Studio Style)
-- Modern Sidebar + Slide Panel + Rounded + Compact + Top User + Minimize Button + AutoFish System

-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local remote = ReplicatedStorage:WaitForChild("BloxbizRemotes"):WaitForChild("OnSendGuiImpressions")

-- STATE
local running, duping, autoSelling, autoLeaveEnabled, fpsBoosted = false, false, false, false, false
local selectedRod = "NormalRod"
local lastLocation = nil
local sellDelay = 2 -- default delay jual (bisa diatur user di Settings)

-- ADMIN IDS
local adminUserIds = {
    [4719890723] = true, [6128717670] = true, [5688434066] = true,
    [7657531329] = true, [4963276186] = true, [8106185708] = true,
    [2527577137] = true, [2910167626] = true, [7898791239] = true,
}

-- COORDS (EDIT SESUAI TEMPAT)
local afkFishPos = Vector3.new(-80, 14, -149)
local sellPos = Vector3.new(-210, 15, 357)
local ambilRodPos = Vector3.new(78, 14, 442)
local afkSpotPos = Vector3.new(500, 20, -150)

-- ROD LIST
local rodList = {
    "AuroraRod", "FischerRod", "HolyRod", "MidasRod",
    "PinkRod", "RelicRod", "SpecialRod", "SunkenRod",
    "UltratechRod", "NormalRod"
}

-- FUNCTION: AutoFish (InstantFish Style)
local function autoFish()
    local remote = ReplicatedStorage:WaitForChild("BloxbizRemotes"):WaitForChild("OnSendGuiImpressions")
    while running do
        pcall(function()
            remote:FireServer({{
                button_path = "ContextActionGui.ContextButtonFrame.ContextActionButton",
                button_name = "ContextActionButton"
            }})
            local rod = localPlayer.Backpack:FindFirstChild(selectedRod)
            local char = localPlayer.Character
            if rod and not char:FindFirstChild(selectedRod) then
                rod.Parent = char
                task.wait(0.002)
            end
            local heldRod = char:FindFirstChild(selectedRod)
            if heldRod then
                local minigame = heldRod:FindFirstChild("MiniGame")
                if minigame then
                    minigame:FireServer("Complete")
                end
            end
        end)
        task.wait()
    end
end

-- FUNCTION: DupeFish
local function dupeFish()
    while duping do
        local remote = ReplicatedStorage:FindFirstChild("MiniGame")
        if remote then
            remote:FireServer("Complete")
            remote:FireServer("Complete")
        end
        task.wait(0.001)
    end
end

-- FUNCTION: Teleport and Sell
local function teleportAndSell()
    local root = character:WaitForChild("HumanoidRootPart")
    lastLocation = root.Position
    root.CFrame = CFrame.new(sellPos + Vector3.new(0,3,0))
    task.wait(sellDelay) -- custom delay (default 2 detik, bisa diubah user)
    for _, obj in pairs(Workspace:GetDescendants()) do
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
    if lastLocation then
        root.CFrame = CFrame.new(lastLocation)
    end
    task.wait(math.random(0, 120))
end

-- FUNCTION: Anti AFK
local function antiAFK()
    while autoSelling do
        task.wait(15)
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Jump = true end
    end
end

-- FUNCTION: Admin Detector
local function checkPlayers()
    while autoLeaveEnabled do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and adminUserIds[player.UserId] then
                localPlayer:Kick("Admin Detected. AutoLeave Active.")
                return
            end
        end
        task.wait(5)
    end
end

-- UI CODE STARTS
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EugunewuModernUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local baseFrame = Instance.new("Frame", screenGui)
baseFrame.Size = UDim2.new(0, 420, 0, 260)
baseFrame.Position = UDim2.new(0, 40, 0.3, 0)
baseFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
baseFrame.Active = true
baseFrame.Draggable = true
Instance.new("UICorner", baseFrame).CornerRadius = UDim.new(0, 12)

local topBar = Instance.new("Frame", baseFrame)
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -50, 0, 20)
titleLabel.Position = UDim2.new(0, 10, 0, 2)
titleLabel.Text = "🧠 Eugunewu Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.TextSize = 14
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- USER CLOCK (STOPWATCH MODE)
local userClock = Instance.new("TextLabel", topBar)
userClock.Size = UDim2.new(1, -50, 0, 20)
userClock.Position = UDim2.new(0, 10, 0, 26)
userClock.Font = Enum.Font.Gotham
userClock.TextColor3 = Color3.fromRGB(200, 200, 200)
userClock.TextSize = 13
userClock.BackgroundTransparency = 1
userClock.TextXAlignment = Enum.TextXAlignment.Left

-- MULAI STOPWATCH SAAT UI MUNCUL
local startTime = tick()

RunService.RenderStepped:Connect(function()
    local elapsed = math.floor(tick() - startTime)
    local hrs = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    local timeStr = string.format("%02d:%02d:%02d", hrs, mins, secs)
    userClock.Text = "👤 " .. localPlayer.Name .. "  |  ⏱️ " .. timeStr
end)

local minimize = Instance.new("TextButton", topBar)
minimize.Size = UDim2.new(0, 26, 0, 26)
minimize.Position = UDim2.new(1, -30, 0, 12)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 40, 0, 40)
miniBtn.Position = UDim2.new(0, 10, 1, -80)
miniBtn.Text = "🧠EU"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 20
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
miniBtn.Visible = false
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

minimize.MouseButton1Click:Connect(function()
    baseFrame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    baseFrame.Visible = true
    miniBtn.Visible = false
end)

-- SIDEBAR
local sidebar = Instance.new("Frame", baseFrame)
sidebar.Size = UDim2.new(0, 110, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 55)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 1)

local uiList = Instance.new("UIListLayout", sidebar)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,13)

-- TABS
local tabNames = {"Main", "Teleport", "Extras", "Settings"}
local tabButtons = {}
local contentFrames = {}
local activeTab = nil

local function switchTab(tabName)
    for name, frame in pairs(contentFrames) do
        frame.Visible = (name == tabName)
        tabButtons[name].BackgroundColor3 = (name == tabName) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(40, 40, 40)
    end
    activeTab = tabName
end

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = btn

    local content = Instance.new("Frame", baseFrame)
    content.Size = UDim2.new(1, -120, 1, -60)
    content.Position = UDim2.new(0, 115, 0, 55)
    content.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    content.Visible = (i == 1)
    content.BorderSizePixel = 0
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)
    contentFrames[name] = content

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- MAIN TOGGLES
local function createSwitch(parent, label, order, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, order * 35)
    frame.BackgroundTransparency = 1

    local txt = Instance.new("TextLabel", frame)
    txt.Size = UDim2.new(1, -60, 1, 0)
    txt.Text = label
    txt.Font = Enum.Font.Gotham
    txt.TextColor3 = Color3.new(1,1,1)
    txt.TextSize = 14
    txt.BackgroundTransparency = 1
    txt.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(1, -50, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0.5, -4, 1, -4)
    dot.Position = UDim2.new(0, 2, 0, 2)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
        dot:TweenPosition(state and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.2, true)
        callback(state)
    end)
end

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
                for i=1,120 do if not autoSelling then break end task.wait(1) end
            end
        end)
    else
        autoSelling = false
    end
end)

-- Append Teleport & Admin Toggles
createSwitch(contentFrames["Teleport"], "Teleport: Ke Ambil Rod", 0, false, function(val)
    if val then
        local root = character:WaitForChild("HumanoidRootPart")
        lastLocation = root.Position
        root.CFrame = CFrame.new(ambilRodPos + Vector3.new(0,3,0))
    end
end)

createSwitch(contentFrames["Teleport"], "Teleport: Ke Spot Mancing", 1, false, function(val)
    if val then
        local root = character:WaitForChild("HumanoidRootPart")
        lastLocation = root.Position
        root.CFrame = CFrame.new(afkFishPos + Vector3.new(0,3,0))
    end
end)

createSwitch(contentFrames["Teleport"], "Teleport: Ke Hiding Spot", 2, false, function(val)
    if val then
        local root = character:WaitForChild("HumanoidRootPart")
        lastLocation = root.Position
        root.CFrame = CFrame.new(afkSpotPos + Vector3.new(0,3,0))
    end
end)

-- Toggle: Admin Detector
createSwitch(contentFrames["Extras"], "Admin Detector", 0, false, function(val)
    autoLeaveEnabled = val
    if val then task.spawn(checkPlayers) end
end)

-- Dropdown Rod Selector in Settings
local rodLabel = Instance.new("TextLabel", contentFrames["Settings"])
rodLabel.Size = UDim2.new(1, 0, 0, 16)
rodLabel.Position = UDim2.new(0, 10, 0, 3)
rodLabel.Text = "🎣 Pilih Pancingan:"
rodLabel.Font = Enum.Font.Gotham
rodLabel.TextSize = 14
rodLabel.TextColor3 = Color3.new(1, 1, 1)
rodLabel.BackgroundTransparency = 1
rodLabel.TextXAlignment = Enum.TextXAlignment.Left

local rodDropdown = Instance.new("TextButton", contentFrames["Settings"])
rodDropdown.Size = UDim2.new(1, -20, 0, 26)
rodDropdown.Position = UDim2.new(0, 10, 0, 20)
rodDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
rodDropdown.TextColor3 = Color3.new(1, 1, 1)
rodDropdown.Font = Enum.Font.Gotham
rodDropdown.TextSize = 14
rodDropdown.Text = selectedRod or "Pilih Rod"
Instance.new("UICorner", rodDropdown).CornerRadius = UDim.new(0, 6)

local dropdownList = Instance.new("ScrollingFrame", contentFrames["Settings"])
dropdownList.Size = UDim2.new(1, -20, 0, 100)
dropdownList.Position = UDim2.new(0, 10, 0, 50)
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

-- SETTINGS TAB UI (should be parented inside your Settings tab frame)
local settingsTab = contentFrames and contentFrames["Settings"] or nil
if not settingsTab then return warn("⚠️ Settings tab not found!") end

-- SLIDER: Delay Jual (detik)
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -20, 0, 80)
sliderFrame.Position = UDim2.new(0, 10, 0, 86)
sliderFrame.BackgroundTransparency = 1 -- Hilangkan background
sliderFrame.Parent = contentFrames["Settings"]

local title = Instance.new("TextLabel")
title.Text = "⚙️ Delay Jual (detik)"
title.Size = UDim2.new(1, 10, 0, 10)
title.Position = UDim2.new(0, -80, 0, -30)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = sliderFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, -40, 0, 14)
sliderBar.Position = UDim2.new(0, 10, 0, -10)
sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBar.Parent = sliderFrame
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 7)

local knob = Instance.new("ImageButton")
knob.Size = UDim2.new(0, 18, 1.5, 0)
knob.Position = UDim2.new((sellDelay - 2) / 8, -9, 0, -3)
knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
knob.AutoButtonColor = false
knob.Parent = sliderBar
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local valueLabel = Instance.new("TextLabel")
valueLabel.Text = tostring(sellDelay) .. " detik"
valueLabel.Position = UDim2.new(0.5, -60, 1, -80)
valueLabel.Size = UDim2.new(0, 100, 0, 20)
valueLabel.Font = Enum.Font.Gotham
valueLabel.TextSize = 13
valueLabel.TextColor3 = Color3.new(1, 1, 1)
valueLabel.BackgroundTransparency = 1
valueLabel.Parent = sliderFrame

-- Support drag/touch
local dragging = false

knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local relX = input.Position.X - sliderBar.AbsolutePosition.X
        local pct = math.clamp(relX / sliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(pct * 8 + 2 + 0.5)
        sellDelay = value
        knob.Position = UDim2.new((value - 2)/8, -9, 0, -3)
        valueLabel.Text = tostring(value) .. " detik"
    end
end)
