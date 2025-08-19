-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DupeUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,35)
header.BackgroundColor3 = Color3.fromRGB(20,20,20)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-70,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "🎣 Eugunewu HUB PVID"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,25,0,25)
minimizeBtn.Position = UDim2.new(1,-60,0.5,-12)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimizeBtn.Text = "-"
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0.5,-12)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "X"
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-35)
content.Position = UDim2.new(0,0,0,35)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Dropdown Button
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1,-40,0,30)
dropdownBtn.Position = UDim2.new(0,20,0,15)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropdownBtn.Text = "Pilih Pancingan ▼"
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextSize = 14
dropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
dropdownBtn.Parent = content
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0,6)

-- Dropdown Frame
local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Size = UDim2.new(1,-40,0,0)
dropdownFrame.Position = UDim2.new(0,20,0,50)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ScrollBarThickness = 4
dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
dropdownFrame.Visible = true
dropdownFrame.ClipsDescendants = true
dropdownFrame.Parent = content
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0,6)
local UIListLayout = Instance.new("UIListLayout", dropdownFrame)
UIListLayout.Padding = UDim.new(0,2)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- List Rods
local rods = {
    "NormalRod","GoldRod","ShadowRod","KeyRod","DevilRod",
    "PinkRod","BebekRod","KingRod","StarRod","DiamondRod",
    "RedShadowRod","SlayerRod"
}

local selectedRod = "NormalRod"
for _, rod in ipairs(rods) do
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -5, 0, 25)
    item.BackgroundColor3 = Color3.fromRGB(70,70,70)
    item.Text = rod
    item.Font = Enum.Font.Gotham
    item.TextSize = 14
    item.TextColor3 = Color3.fromRGB(255,255,255)
    item.Parent = dropdownFrame
    Instance.new("UICorner", item).CornerRadius = UDim.new(0,6)

    item.MouseButton1Click:Connect(function()
        selectedRod = rod
        dropdownBtn.Text = rod.." ▼"
        TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {Size = UDim2.new(1,-40,0,0)}):Play()
        dropdownOpen = false
    end)
end

-- Update Scroll & Height
local function updateDropdownHeight()
    local maxVisible = 2 * 30 -- hanya 2 item
    local contentHeight = UIListLayout.AbsoluteContentSize.Y
    dropdownFrame.CanvasSize = UDim2.new(0,0,0,contentHeight)
    local finalHeight = math.min(contentHeight, maxVisible)
    dropdownFrame.Size = UDim2.new(1,-40,0,finalHeight)
end
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDropdownHeight)
updateDropdownHeight()

-- Toggle Dropdown
local dropdownOpen = false
dropdownBtn.MouseButton1Click:Connect(function()
    if dropdownOpen then
        TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {Size = UDim2.new(1,-40,0,0)}):Play()
    else
        updateDropdownHeight()
    end
    dropdownOpen = not dropdownOpen
end)

-- Start Button
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1,-40,0,35)
startBtn.Position = UDim2.new(0,20,1,-50)
startBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
startBtn.Text = "🚀 Start Dupe"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 16
startBtn.TextColor3 = Color3.fromRGB(255,255,255)
startBtn.Parent = content
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,8)

-- AUTO FISH DUPE
local running = false
local function autoFish()
    local remote = ReplicatedStorage:WaitForChild("BloxbizRemotes"):WaitForChild("OnSendGuiImpressions")
    while running do
        pcall(function()
            remote:FireServer({{
                button_path = "ContextActionGui.ContextButtonFrame.ContextActionButton",
                button_name = "ContextActionButton"
            }})

            local char = player.Character or player.CharacterAdded:Wait()
            local rod = player.Backpack:FindFirstChild(selectedRod)
            if rod and not char:FindFirstChild(selectedRod) then
                rod.Parent = char
                task.wait(0.001)
            end

            local heldRod = char:FindFirstChild(selectedRod)
            if heldRod then
                local minigame = heldRod:FindFirstChild("MiniGame")
                if minigame then
                    for i = 1, 50 do
                        minigame:FireServer("Complete")
                    end
                end
            end
        end)
        task.wait(0.05)
    end
end

-- Toggle Start/Stop
startBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        startBtn.Text = "⏹ Stop Dupe"
        startBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        task.spawn(autoFish)
    else
        startBtn.Text = "🚀 Start Dupe"
        startBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
    end
end)

-- Close Action
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    running = false
end)

-- Minimize Action
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0,280,0,35)}):Play()
        content.Visible = false
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0,280,0,200)}):Play()
        content.Visible = true
    end
end)
