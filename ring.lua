-- =================================================================
-- SIMPLESPY LIGHTWEIGHT - PHIÊN BẢN QUÉT REMOTES ROCK FRUIT
-- =================================================================
local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer

-- Xóa UI cũ nếu chạy lại
if CoreGui:FindFirstChild("RockFruitSpy") then CoreGui.RockFruitSpy:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RockFruitSpy"

-- KHUNG CHÍNH
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 240)
Main.Position = UDim2.new(0.5, -160, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(0, 255, 150)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = " 🕵️‍♂️ Rock Fruit Remote Spy (Logs)"
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- KHUNG HIỂN THỊ LOGS (CÓ THỂ CUỘN)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -65)
Scroll.Position = UDim2.new(0, 5, 0, 30)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Scroll.ScrollBarThickness = 4
local Layout = Instance.new("UIListLayout", Scroll)

-- NÚT XÓA LOGS
local ClearBtn = Instance.new("TextButton", Main)
ClearBtn.Size = UDim2.new(0.9, 0, 0, 25)
ClearBtn.Position = UDim2.new(0.05, 0, 1, -30)
ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Text = "XÓA LOGS TRỐNG"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 12
ClearBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(Scroll:GetChildren()) do if child:IsA("TextBox") then child:Destroy() end end
    Scroll.CanvasSize = UDim2.new(0,0,0,0)
end)

-- HÀM IN RA ĐƯỜNG DẪN REMOTE VÀ ĐỐI SỐ (ARGUMENTS)
local function LogRemote(type, remote, args)
    local remotePath = remote:GetFullName()
    
    -- Chuyển đổi Arguments (Bảng dữ liệu) sang chuỗi chữ để dễ đọc
    local argsStr = ""
    for i, v in pairs(args) do
        argsStr = argsStr .. "[" .. tostring(i) .. "] = " .. typeof(v) .. " (" .. tostring(v) .. "), "
    end
    if argsStr == "" then argsStr = "Không có đối số" end

    -- Tạo ô văn bản hiển thị lệnh (TextBox để người dùng dễ COPY)
    local logBox = Instance.new("TextBox", Scroll)
    logBox.Size = UDim2.new(1, 0, 0, 45)
    logBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    logBox.TextColor3 = Color3.fromRGB(0, 255, 100)
    logBox.Font = Enum.Font.Code
    logBox.TextSize = 10
    logBox.ClearTextOnFocus = false
    logBox.TextEditable = false
    logBox.TextWrapped = true
    logBox.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", logBox).CornerRadius = UDim.new(0, 4)
    
    logBox.Text = string.format("[%s]\nPath: %s\nArgs: %s", type, remote.Name, argsStr)
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    Scroll.CanvasPosition = Vector2.new(0, Layout.AbsoluteContentSize.Y)
end

-- =================================================================
-- HOOK HỆ THỐNG GIAO TIẾP SERVER (HOOKMETAMETHOD)
-- =================================================================
local OldFireServer
OldFireServer = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and self:IsA("RemoteEvent") then
        -- Lọc bỏ các Remote rác của hệ thống Roblox để tránh loãng dữ liệu
        if not string.match(self.Name, "Character") and not string.match(self.Name, "Chat") then
            task.spawn(function()
                LogRemote("EVENT", self, args)
            end)
        end
    end
    return OldFireServer(self, ...)
end)

local OldInvokeServer
OldInvokeServer = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "InvokeServer" and self:IsA("RemoteFunction") then
        task.spawn(function()
            LogRemote("FUNCTION", self, args)
        end)
    end
    return OldInvokeServer(self, ...)
end)

print("[SUCCES] Rock Fruit Spy đang chạy ngầm... Hãy đi thực hiện hành động trong game!")
