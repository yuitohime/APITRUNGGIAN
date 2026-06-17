-- Khởi tạo thư viện UI Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Glue Piece Ultimate Hub", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "Loading Ultimate Features..."
})

-- Các biến Global
_G.AutoFarmAll = false
_G.AutoFarmSelected = false
_G.SelectedMob = ""

_G.AutoBoss = false
_G.SelectedBoss = ""

_G.AutoSkill = false
_G.SelectedSkills = {}

_G.EquipAllWeapons = false
_G.AutoAttack = false

_G.SelectedShopItem = ""
_G.SelectedTeleport = ""
_G.SelectedSpawn = ""
_G.AutoSetSpawn = false

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

-- Danh sách dữ liệu
local MobsList = {
    "Slime", "Snake", "Thug", "Cutie Noob", "Elite Noob", "Evil Thug"
}

-- Cập nhật danh sách Boss từ ảnh mới
local BossesList = {
    "Cutie Boss", "King Noob", "Nooby", "Unknown Boss", "King Slime",
    "Duck Boss", "Kyo", "Sans", "Shinoa", "Sword Master"
}

local AllTargets = {}
for _, v in pairs(MobsList) do table.insert(AllTargets, v) end
for _, v in pairs(BossesList) do table.insert(AllTargets, v) end

-- Dữ liệu Shop, Kỹ Năng và Vũ Khí từ ảnh
local ShopList = {
    "Awakening Book", "Black Leg", "Limitless", "OFA [Deku]", 
    "Busoshoku", "Observation", "Random Fruity", "Reset Fruity", 
    "Reset Stats", "Dual Sword", "Geppo", "Soru",
    "Epic Sword", "Saber", "Triple Katana" -- Thêm vũ khí mới
}

local SpawnIslands = {"Eight Island [Spawn Manager]"} -- Có thể thêm thủ công nếu biết tên đảo khác
local SkillKeys = {"Q", "E", "R", "T", "F", "Z", "X", "C", "V"}

-- ==========================================
-- TAB 1: AUTO FARM & BOSS
-- ==========================================
local FarmTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})

FarmTab:AddSection({Name = "Cấu Hình Tấn Công"})
FarmTab:AddToggle({
    Name = "Tự Động Đánh (Auto Attack)",
    Default = false,
    Callback = function(Value)
        _G.AutoAttack = Value
    end
})

FarmTab:AddToggle({
    Name = "Sử Dụng NHIỀU VŨ KHÍ CÙNG LÚC",
    Default = false,
    Callback = function(Value)
        _G.EquipAllWeapons = Value
        if not Value then
            -- Bỏ trang bị (Unequip) tất cả khi tắt
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = LocalPlayer.Backpack
                end
            end
        end
    end
})

FarmTab:AddSection({Name = "Quét Quái Thường"})
FarmTab:AddToggle({
    Name = "Auto Farm TẤT CẢ QUÁI",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmAll = Value
    end
})

FarmTab:AddDropdown({
    Name = "Chọn Quái Để Farm",
    Default = "Slime",
    Options = MobsList,
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

FarmTab:AddSection({Name = "Săn Boss (Liên Tục)"})
FarmTab:AddDropdown({
    Name = "Chọn Boss",
    Default = "Cutie Boss",
    Options = BossesList,
    Callback = function(Value)
        _G.SelectedBoss = Value
    end
})

FarmTab:AddToggle({
    Name = "Bật Auto Săn Boss",
    Default = false,
    Callback = function(Value)
        _G.AutoBoss = Value
    end
})

-- ==========================================
-- TAB 2: ESP & DROP ITEMS (TÌM TRÁI ÁC QUỶ)
-- ==========================================
local ESPTab = Window:MakeTab({Name = "ESP Đồ Rơi", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local ESPListDropdown = ESPTab:AddDropdown({
    Name = "Danh sách vật phẩm rơi (Fruit, v.v)",
    Default = "",
    Options = {"Chưa có dữ liệu"},
    Callback = function(Value)
        -- Chọn vật phẩm thì làm gì đó (Ví dụ: tele đến)
        print("Đã chọn:", Value)
    end
})

ESPTab:AddButton({
    Name = "Làm Mới Danh Sách Vật Phẩm",
    Callback = function()
        local dropItems = {}
        -- Tìm kiếm trong workspace, giả sử vật phẩm rơi nằm trong thư mục 'Drops' hoặc thẳng trong workspace
        -- Bạn cần kiểm tra xem game để vật phẩm rơi ở đâu. Ở đây mình quét toàn bộ Part có chứa chữ "Fruit" hoặc "Drop"
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Tool") or obj:IsA("Model") then
                -- Lọc tên nếu là Fruit
                if string.match(string.lower(obj.Name), "fruit") or string.match(string.lower(obj.Name), "drop") then
                    table.insert(dropItems, obj.Name)
                    -- Tạo ESP Text
                    if not obj:FindFirstChild("ESPTag") then
                        local billboard = Instance.new("BillboardGui", obj)
                        billboard.Name = "ESPTag"
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        
                        local textLabel = Instance.new("TextLabel", billboard)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = obj.Name .. " [Vật Phẩm]"
                        textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        textLabel.TextScaled = true
                    end
                end
            end
        end
        
        if #dropItems == 0 then
            table.insert(dropItems, "Không có đồ nào trên map")
        end
        ESPListDropdown:Refresh(dropItems, true)
    end
})

-- ==========================================
-- TAB 3: AUTO SKILL
-- ==========================================
local SkillTab = Window:MakeTab({Name = "Auto Skill", Icon = "rbxassetid://4483345998", PremiumOnly = false})
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
-- TAB 4: SHOP, TELEPORT & SPAWN
-- ==========================================
local ShopTab = Window:MakeTab({Name = "Bản Đồ & Cửa Hàng", Icon = "rbxassetid://4483345998", PremiumOnly = false})

ShopTab:AddSection({Name = "Auto Set Spawn"})
ShopTab:AddDropdown({
    Name = "Chọn Đảo Spawn",
    Default = "Eight Island [Spawn Manager]",
    Options = SpawnIslands,
    Callback = function(Value)
        _G.SelectedSpawn = Value
    end
})

ShopTab:AddToggle({
    Name = "Tự Động Đặt Điểm Hồi Sinh (Spawn)",
    Default = false,
    Callback = function(Value)
        _G.AutoSetSpawn = Value
        if Value then
            task.spawn(function()
                while _G.AutoSetSpawn do
                    local spawnFolder = workspace:FindFirstChild("Spawn Manager")
                    if spawnFolder then
                        local island = spawnFolder:FindFirstChild(_G.SelectedSpawn)
                        if island then
                            local clickDetector = island:FindFirstChildWhichIsA("ClickDetector", true)
                            if clickDetector then
                                fireclickdetector(clickDetector)
                                OrionLib:MakeNotification({Name = "Spawn", Content = "Đã lưu vị trí hồi sinh!", Time = 2})
                            end
                        end
                    end
                    task.wait(10) -- Mỗi 10s check 1 lần
                end
            end)
        end
    end
})

ShopTab:AddSection({Name = "Cửa Hàng"})
ShopTab:AddDropdown({
    Name = "Chọn Vật Phẩm / Kỹ Năng",
    Default = "Epic Sword",
    Options = ShopList,
    Callback = function(Value)
        _G.SelectedShopItem = Value
    end
})

ShopTab:AddButton({
    Name = "Mua Từ Shop",
    Callback = function()
        local shopFolder = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("Weapon") or workspace:FindFirstChild("Technique")
        if shopFolder then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == _G.SelectedShopItem then
                    local clickDetector = obj:FindFirstChildWhichIsA("ClickDetector", true)
                    if clickDetector then
                        fireclickdetector(clickDetector)
                        OrionLib:MakeNotification({Name = "Thành công", Content = "Đã thao tác mua " .. _G.SelectedShopItem, Time = 3})
                        return
                    end
                end
            end
            OrionLib:MakeNotification({Name = "Lỗi", Content = "Không tìm thấy nút mua của " .. _G.SelectedShopItem, Time = 3})
        end
    end
})

-- ==========================================
-- LOGIC HOẠT ĐỘNG CHÍNH
-- ==========================================

-- Hàm Cầm Tất Cả Vũ Khí (Equip All)
local function EquipAllTools()
    if _G.EquipAllWeapons then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- Ép tool vào character để sử dụng cùng lúc
                tool.Parent = LocalPlayer.Character
            end
        end
    end
end

-- Hàm Tìm Quái hoặc Boss
local function GetTarget()
    if _G.AutoBoss then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == _G.SelectedBoss and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Humanoid.Health > 0 then
                    return obj
                end
            end
        end
        return nil
    end

    if _G.AutoFarmAll or _G.AutoFarmSelected then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Humanoid.Health > 0 and obj.Name ~= LocalPlayer.Name then
                    -- Loại bỏ Boss khỏi list farm thường để tránh nhầm
                    local isBoss = false
                    for _, b in pairs(BossesList) do
                        if obj.Name == b then isBoss = true break end
                    end

                    if not isBoss then
                        if _G.AutoFarmAll then return obj end
                        if _G.AutoFarmSelected and obj.Name == _G.SelectedMob then return obj end
                    end
                end
            end
        end
    end
    return nil
end

-- Vòng lặp Auto Farm / Auto Boss
task.spawn(function()
    while task.wait() do
        if _G.AutoFarmAll or _G.AutoFarmSelected or _G.AutoBoss then
            EquipAllTools()
            local targetMob = GetTarget()
            
            if targetMob then
                while targetMob and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 do
                    if not (_G.AutoFarmAll or _G.AutoFarmSelected or _G.AutoBoss) then break end
                    
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Bay ra sau lưng mục tiêu
                            char.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                            
                            -- Tự động đánh (Tương tự click chuột trái)
                            if _G.AutoAttack then
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton1(Vector2.new())
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            else
                -- Nếu đang săn boss mà boss chưa ra, chờ đợi
                if _G.AutoBoss then
                    task.wait(1)
                end
            end
        end
    end
end)

-- Vòng lặp Auto Skill
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoSkill and (_G.AutoFarmAll or _G.AutoFarmSelected or _G.AutoBoss) then
            for _, key in pairs(_G.SelectedSkills) do
                if not _G.AutoSkill then break end
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
                task.wait(0.3)
            end
        end
    end
end)

OrionLib:Init()
