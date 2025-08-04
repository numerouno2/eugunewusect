--// 🔐 WORKINK KEY LOADER (PRO+ Copy Button) by Eugunewu
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local WORKINK_LINK = "https://workink.net/22xC/c6379clz"
local SCRIPT_LINK = "https://raw.githubusercontent.com/numerouno2/eugunewusect/refs/heads/main/noted.lua"
local TOKEN_FILE = "eugunewu_token.txt"

pcall(function()
    setclipboard(WORKINK_LINK)
    warn("📋 Link Work.ink dicopy otomatis.")
end)

local function getSavedToken()
    if isfile and isfile(TOKEN_FILE) then return readfile(TOKEN_FILE) end
    return nil
end

local function saveToken(token)
    if writefile then writefile(TOKEN_FILE, token) end
end

local function validateToken(token)
    local url = "https://work.ink/_api/v2/token/isValid/" .. token .. "?deleteToken=1"
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return ok and res and res.valid
end

local function showInputUI()
    if CoreGui:FindFirstChild("EuguneKeyUI") then CoreGui.EuguneKeyUI:Destroy() end

    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "EuguneKeyUI"

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 330, 0, 180)
    f.Position = UDim2.new(0.5, -165, 0.5, -90)
    f.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", f)
    title.Text = "🔐 Enter Work.ink Token"
    title.Size = UDim2.new(1,0,0,30)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)

    local box = Instance.new("TextBox", f)
    box.Size = UDim2.new(0.9, 0, 0, 30)
    box.Position = UDim2.new(0.05,0,0.3,0)
    box.PlaceholderText = "Paste your token here"
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.Code
    box.TextSize = 14
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local status = Instance.new("TextLabel", f)
    status.Size = UDim2.new(1,0,0,20)
    status.Position = UDim2.new(0,0,0.56,0)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Code
    status.TextSize = 13
    status.TextColor3 = Color3.fromRGB(255,255,255)
    status.Text = ""

    local copyBtn = Instance.new("TextButton", f)
    copyBtn.Text = "📋 Copy Link Token"
    copyBtn.Size = UDim2.new(0.425, 0, 0, 28)
    copyBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
    copyBtn.Font = Enum.Font.Gotham
    copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    copyBtn.TextSize = 13
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,8)

    copyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(WORKINK_LINK)
            status.Text = "✅ Link berhasil disalin ke clipboard!"
        end)
    end)

    local btn = Instance.new("TextButton", f)
    btn.Text = "✔ VALIDATE"
    btn.Size = UDim2.new(0.425, 0, 0, 28)
    btn.Position = UDim2.new(0.525, 0, 0.75, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0,170,127)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    btn.MouseButton1Click:Connect(function()
        local token = box.Text
        if token == "" then return end
        if validateToken(token) then
            saveToken(token)
            sg:Destroy()
            loadstring(game:HttpGet(SCRIPT_LINK))()
        else
            box.Text = ""
            box.PlaceholderText = "❌ Token salah. Ambil ulang!"
        end
    end)
end

-- 🚀 START
local saved = getSavedToken()
if saved and validateToken(saved) then
    loadstring(game:HttpGet(SCRIPT_LINK))()
else
    showInputUI()
end
