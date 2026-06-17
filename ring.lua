-- Khởi tạo thư viện UI Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Glue Piece Premium Hub", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "Loading Hub..."
})

-- Các biến Global
_G.AutoFarmAll = false
_G.AutoFarmSelected = false
_G.SelectedMob = ""
_G.AutoSkill = false
_G.SelectedSkills = {}
_G.SelectedShopItem = ""
_G.SelectedTeleport = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Danh sách dữ liệu từ Game Explorer
local MobsList = {
    "Slime", "Snake", "Thug", "Cutie Noob", "Elite Noob", "Evil Thug"
}
local BossesList = {
    "Cutie Boss", "King Noob", "Nooby", "Unknown Boss", "King Slime"
}
local AllTargets = {"Slime", "Snake", "Thug", "Cutie Noob", "Elite Noob", "Evil Thug", "Cutie Boss", "King Noob", "Nooby", "Unknown Boss", "King Slime"}

local ShopList = {
    "Awakening Book", "Black Leg", "Limitless", "OFA [Deku]", 
    "Busoshoku", "Observation", "Random Fruity", "Reset Fruity", 
    "Reset Stats", "Dual Sword", "Geppo", "Soru"
}

local SkillKeys = {"Q", "E", "R", "T", "F", "Z", "X", "C", "V"}

-- ==========================================
-- TẠO CÁC TABS
-- ==========================================
local FarmTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local SkillTab = Window:MakeTab({Name = "Auto Skill", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local ShopTab = Window:MakeTab({Name = "Shop & Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- ==========================================
-- TAB 1: AUTO FARM
-- ==========================================
FarmTab:AddToggle({
    Name = "Auto Farm TẤT CẢ QUÁI (Toàn Bản Đồ)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmAll = Value
    end
})

FarmTab:AddDropdown({
    Name = "Chọn Quái / Boss",
    Default = "Slime",
    Options = AllTargets,
    Callback = function(Value)
        _G.SelectedMob = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Farm Quái Đã Chọn",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmSelected = Value
    end
})

-- ==========================================
-- TAB 2: AUTO SKILL
-- ==========================================
SkillTab:AddDropdown({
    Name = "Chọn Kỹ Năng Cần Dùng",
    Default = "",
    Options = SkillKeys,
    MultipleOptions = true,
    Callback = function(Options)
        _G.SelectedSkills = Options
    end
})

SkillTab:AddToggle({
    Name = "Bật Auto Skill",
    Default = false,
    Callback = function(Value)
        _G.AutoSkill = Value
    end
})

-- ==========================================
-- TAB 3: SHOP & TELEPORT
-- ==========================================
ShopTab:AddSection({Name = "Cửa Hàng"})
ShopTab:AddDropdown({
    Name = "Chọn Vật Phẩm / Kỹ Năng",
    Default = "Awakening Book",
    Options = ShopList,
    Callback = function(Value)
        _G.SelectedShopItem = Value
    end
})

ShopTab:AddButton({
    Name = "Mua Vật Phẩm Đã Chọn",
    Callback = function()
        -- Tìm ClickDetector trong thư mục Shop để tương tác
        local shopFolder = workspace:FindFirstChild("Shop")
        if shopFolder then
            for _, category in pairs(shopFolder:GetChildren()) do
                local item = category:FindFirstChild(_G.SelectedShopItem)
                if item then
                    local clickDetector = item:FindFirstChildWhichIsA("ClickDetector", true)
                    if clickDetector then
                        fireclickdetector(clickDetector)
                        OrionLib:MakeNotification({Name = "Thành công", Content = "Đã mua " .. _G.SelectedShopItem, Time = 3})
                        return
                    end
                end
            end
            OrionLib:MakeNotification({Name = "Lỗi", Content = "Không tìm thấy nút mua của " .. _G.SelectedShopItem, Time = 3})
        end
    end
})

ShopTab:AddSection({Name = "Dịch Chuyển"})
ShopTab:AddDropdown({
    Name = "Chọn Mục Tiêu Teleport",
    Default = "Slime",
    Options = AllTargets,
    Callback = function(Value)
        _G.SelectedTeleport = Value
    end
})

ShopTab:AddButton({
    Name = "Teleport Đến Quái/Boss",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == _G.SelectedTeleport and obj:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame
                OrionLib:MakeNotification({Name = "Thành công", Content = "Đã dịch chuyển đến " .. _G.SelectedTeleport, Time = 3})
                return
            end
        end
        OrionLib:MakeNotification({Name = "Lỗi", Content = "Mục tiêu chưa xuất hiện trên bản đồ!", Time = 3})
    end
})

-- ==========================================
-- LOGIC HOẠT ĐỘNG
-- ==========================================
local function GetMobToFarm()
    local target = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj.Humanoid.Health > 0 and obj.Name ~= LocalPlayer.Name then
                -- Nếu bật Farm tất cả
                if _G.AutoFarmAll then
                    return obj
                -- Nếu bật Farm mục tiêu đã chọn
                elseif _G.AutoFarmSelected and obj.Name == _G.SelectedMob then
                    return obj
                end
            end
        end
    end
    return target
end

-- Vòng lặp Auto Farm (Tấn công + Dịch chuyển)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarmAll or _G.AutoFarmSelected then
            local targetMob = GetMobToFarm()
            if targetMob then
                while targetMob and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 and (_G.AutoFarmAll or _G.AutoFarmSelected) do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Dịch chuyển ra sau lưng quái
                            char.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                            -- Mô phỏng click chuột
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton1(Vector2.new())
                        end
                    end)
                    task.wait(0.05)
                end
            end
        end
    end
end)

-- Vòng lặp Auto Skill
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoSkill and (_G.AutoFarmAll or _G.AutoFarmSelected) then
            for _, key in pairs(_G.SelectedSkills) do
                if not _G.AutoSkill then break end
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
                task.wait(0.3) -- Nghỉ nhẹ giữa các skill để tránh bị kẹt animation
            end
        end
    end
end)

OrionLib:Init()
