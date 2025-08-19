-- ⚡ Eugunewu HUB - AutoFish
-- UI dengan Dropdown Scroll + Minimize

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local running = false
local selectedRod = "NormalRod"

-- ================= UI SETUP =================
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "EugunewuHub"

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 180)
mainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 170, 0)
stroke.Thickness = 2

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ Eugunewu HUB"
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundTransparency = 1

-- Content Frame
local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1

-- Dropdown Button
local dropdownBtn = Instance.new("TextButton", content)
dropdownBtn.Size = UDim2.new(1, 0, 0, 30)
dropdownBtn.Text = "🎣 Pilih Pancingan: "..selectedRod
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextSize = 14
dropdownBtn.TextColor3 = Color3.new(1,1,1)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0,6)

-- Dropdown (ScrollingFrame biar bisa scroll)
local dropdownFrame = Instance.new("ScrollingFrame", content)
dropdownFrame.Size = UDim2.new(1, 0, 0, 0) -- awal kecil
dropdownFrame.Position = UDim2.new(0,0,0,35)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
dropdownFrame.ClipsDescendants = true
dropdownFrame.ScrollBarThickness = 4
dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0,6)

local UIListLayout = Instance.new("UIListLayout", dropdownFrame)
UIListLayout.Padding = UDim.new(0,4)

-- List rod
local rods = {
    "NormalRod","BebekRod","GoldRod","DevilRod","KeyRod","PinkRod","ShadowRod",
    "RedShadowRod","SlayerRod","DiamondRod","StarRod","KingRod"
}

-- Buat tombol pilihan rod
for _, rod in ipairs(rods) do
    local opt = Instance.new("TextButton", dropdownFrame)
    opt.Size = UDim2.new(1, -10, 0, 25)
    opt.Text = rod
    opt.BackgroundColor3 = Color3.fromRGB(50,50,50)
    opt.TextColor3 = Color3.new(1,1,1)
    opt.Font = Enum.Font.Gotham
    opt.TextSize = 13
    Instance.new("UICorner", opt).CornerRadius = UDim.new(0,5)

    opt.MouseButton1Click:Connect(function()
        selectedRod = rod
        dropdownBtn.Text = "🎣 "..rod
        TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {Size = UDim2.new(1,0,0,0)}):Play()
        dropdownOpen = false
    end)
end

-- Update canvas size otomatis
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    dropdownFrame.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y+10)
end)

-- Start Button
local startBtn = Instance.new("TextButton", content)
startBtn.Size = UDim2.new(1, 0, 0, 35)
startBtn.Position = UDim2.new(0, 0, 1, -40)
startBtn.Text = "▶ Start Dupe"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,80)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,6)

-- ========== LOGIC ==========
-- Toggle dropdown
local dropdownOpen = false
dropdownBtn.MouseButton1Click:Connect(function()
    if dropdownOpen then
        TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {Size = UDim2.new(1,0,0,0)}):Play()
    else
        local maxHeight = 120 -- tinggi maksimal dropdown (scroll muncul kalau lebih panjang)
        local contentHeight = UIListLayout.AbsoluteContentSize.Y
        local finalHeight = math.min(maxHeight, contentHeight)
        TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {Size = UDim2.new(1,0,0,finalHeight)}):Play()
    end
    dropdownOpen = not dropdownOpen
end)

-- Minimize
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,260,0,180)}):Play()
        content.Visible = true
        title.Visible = true
        minimizeBtn.Text = "-"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,60,0,40)}):Play()
        content.Visible = false
        title.Visible = false
        minimizeBtn.Text = "+"
    end
    minimized = not minimized
end)

-- AutoFish Dupe
local function autoFish()
    local remote = ReplicatedStorage:WaitForChild("BloxbizRemotes"):WaitForChild("OnSendGuiImpressions")
    while running do
        pcall(function()
            remote:FireServer({{
                button_path = "ContextActionGui.ContextButtonFrame.ContextActionButton",
                button_name = "ContextActionButton"
            }})
            local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            local rod = localPlayer.Backpack:FindFirstChild(selectedRod)
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

startBtn.MouseButton1Click:Connect(function()
    running = not running
    startBtn.Text = running and "⏹ Stop Dupe" or "▶ Start Dupe"
    if running then
        task.spawn(autoFish)
    end
end)
