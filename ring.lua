-- Project: Glue Piece Auto Farm Hub
-- Lead Developer: Bui Anh Quan
-- Target: CLASS 11B3

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local guiName = "GluePieceHub_11B3"

-- Xóa UI cũ nếu đã tồn tại để tránh trùng lặp
if CoreGui:FindFirstChild(guiName) then
    CoreGui[guiName]:Destroy()
end
if LocalPlayer.PlayerGui:FindFirstChild(guiName) then
    LocalPlayer.PlayerGui[guiName]:Destroy()
end

-- Xác định vị trí đặt UI
local parentGui = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer.PlayerGui

-- ==========================================
-- 1. THIẾT KẾ GIAO DIỆN (UI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = parentGui

-- Main Frame (Hình chữ nhật dài)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 120)
MainFrame.Position = UDim2.new(0.5, -200, 0.8, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- UI Elements
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Glue Piece Auto Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Thu nhỏ (Minimize)
local MinButton = Instance.new("TextButton", MainFrame)
MinButton.Size = UDim2.new(0, 25, 0, 25)
MinButton.Position = UDim2.new(1, -55, 0, 2)
MinButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 4)

-- Nút Xóa (Close)
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -27, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 4)

-- Nút Toggle Auto Farm
local ToggleFarm = Instance.new("TextButton", MainFrame)
ToggleFarm.Size = UDim2.new(0, 180, 0, 40)
ToggleFarm.Position = UDim2.new(0, 10, 0, 50)
ToggleFarm.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleFarm.Text = "Auto Farm: OFF"
ToggleFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFarm.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", ToggleFarm).CornerRadius = UDim.new(0, 6)

-- Nút Toggle Auto Skill (E, R, T, F)
local ToggleSkill = Instance.new("TextButton", MainFrame)
ToggleSkill.Size = UDim2.new(0, 180, 0, 40)
ToggleSkill.Position = UDim2.new(0, 200, 0, 50)
ToggleSkill.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleSkill.Text = "Auto Skill: OFF"
ToggleSkill.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleSkill.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", ToggleSkill).CornerRadius = UDim.new(0, 6)

-- Kéo thả UI (Draggable)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Logic Thu nhỏ / Phóng to (Tween thành ô vuông bên trái)
local isMinimized = false
MinButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0, 0, 0.5, -25) -- Ép sát lề trái
        })
        tween:Play()
        Title.Visible = false
        ToggleFarm.Visible = false
        ToggleSkill.Visible = false
        MinButton.Text = "+"
        MinButton.Size = UDim2.new(1, 0, 1, 0)
        MinButton.Position = UDim2.new(0, 0, 0, 0)
        CloseButton.Visible = false
    else
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 400, 0, 120),
            Position = UDim2.new(0.5, -200, 0.8, -60)
        })
        tween:Play()
        tween.Completed:Wait()
        Title.Visible = true
        ToggleFarm.Visible = true
        ToggleSkill.Visible = true
        MinButton.Text = "-"
        MinButton.Size = UDim2.new(0, 25, 0, 25)
        MinButton.Position = UDim2.new(1, -55, 0, 2)
        CloseButton.Visible = true
    end
end)

-- Logic Đóng UI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==========================================
-- 2. LOGIC TÍNH NĂNG (AUTO FARM & SKILL)
-- ==========================================
local getgenv = getgenv or function() return _G end
getgenv().autoFarm = false
getgenv().autoSkill = false

ToggleFarm.MouseButton1Click:Connect(function()
    getgenv().autoFarm = not getgenv().autoFarm
    ToggleFarm.Text = getgenv().autoFarm and "Auto Farm: ON" or "Auto Farm: OFF"
    ToggleFarm.BackgroundColor3 = getgenv().autoFarm and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 50)
end)

ToggleSkill.MouseButton1Click:Connect(function()
    getgenv().autoSkill = not getgenv().autoSkill
    ToggleSkill.Text = getgenv().autoSkill and "Auto Skill: ON" or "Auto Skill: OFF"
    ToggleSkill.BackgroundColor3 = getgenv().autoSkill and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 50)
end)

-- Hàm quét và lấy toàn bộ quái trên đảo (kiểm tra Humanoid & Máu > 0)
local function getValidMobs()
    local mobs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            -- Loại bỏ local player và NPC không có máu
            if obj.Name ~= LocalPlayer.Name and obj.Humanoid.Health > 0 then
                table.insert(mobs, obj)
            end
        end
    end
    return mobs
end

-- Vòng lặp Auto Farm
task.spawn(function()
    while task.wait() do
        if getgenv().autoFarm then
            local mobs = getValidMobs()
            for _, mob in pairs(mobs) do
                if not getgenv().autoFarm then break end
                
                -- Khóa mục tiêu cho đến khi quái chết
                while mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and getgenv().autoFarm do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Dịch chuyển ra sau lưng quái 5 stud
                            char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                            
                            -- Auto Click (Sử dụng VirtualInputManager để mô phỏng nhấp chuột trái)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end
                    end)
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- Vòng lặp Auto Skill (Trái Ác Quỷ E, R, T, F)
task.spawn(function()
    local skills = {"E", "R", "T", "F"}
    while task.wait(0.5) do
        if getgenv().autoSkill and getgenv().autoFarm then
            for _, key in ipairs(skills) do
                if not getgenv().autoSkill then break end
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
                task.wait(0.2) -- Thời gian nghỉ giữa các chiêu để tránh lag
            end
        end
    end
end)
