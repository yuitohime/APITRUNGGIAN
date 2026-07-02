-- ==========================================
-- HỆ THỐNG GIAO DIỆN (ROCK FRUIT - V6)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local existingUI = CoreGui:FindFirstChild("YuiMobileHub") or Player:WaitForChild("PlayerGui"):FindFirstChild("YuiMobileHub")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuiMobileHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- KHUNG CHÍNH (Thu nhỏ gọn gàng)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 300)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)
Instance.new("UIStroke", MainFrame).Thickness = 1.5

-- TIÊU ĐỀ
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Yui HUB - ROCK FRUIT v6 (Full Shop)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitleLine = Instance.new("Frame", TopBar)
TitleLine.Size = UDim2.new(0, 2, 0, 14)
TitleLine.Position = UDim2.new(0, 4, 0.5, -7)
TitleLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TitleLine.BorderSizePixel = 0

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CỘT TAB (TRÁI) VÀ NỘI DUNG (PHẢI)
local TabContainer = Instance.new("ScrollingFrame", MainFrame)
TabContainer.Size = UDim2.new(0, 110, 1, -35)
TabContainer.Position = UDim2.new(0, 5, 0, 30)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.Padding = UDim.new(0, 3)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -125, 1, -35)
ContentContainer.Position = UDim2.new(0, 120, 0, 30)
ContentContainer.BackgroundTransparency = 1

-- ==========================================
-- THƯ VIỆN GIAO DIỆN CHỐNG LỖI
-- ==========================================
local Tabs = {}
local function CreateTab(name, isFirst)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, -5, 0, 30)
    btn.BackgroundColor3 = isFirst and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(15, 15, 15)
    btn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.Text = "  " .. name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local Indicator = Instance.new("Frame", btn)
    Indicator.Size = UDim2.new(0, 3, 1, -10)
    Indicator.Position = UDim2.new(0, 0, 0, 5)
    Indicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = isFirst

    local page = Instance.new("Frame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = isFirst
    
    local LeftCol = Instance.new("ScrollingFrame", page)
    LeftCol.Size = UDim2.new(0.5, -4, 1, 0)
    LeftCol.BackgroundTransparency = 1
    LeftCol.ScrollBarThickness = 2
    local LeftLayout = Instance.new("UIListLayout", LeftCol)
    LeftLayout.Padding = UDim.new(0, 5)
    
    local RightCol = Instance.new("ScrollingFrame", page)
    RightCol.Size = UDim2.new(0.5, -4, 1, 0)
    RightCol.Position = UDim2.new(0.5, 4, 0, 0)
    RightCol.BackgroundTransparency = 1
    RightCol.ScrollBarThickness = 2
    local RightLayout = Instance.new("UIListLayout", RightCol)
    RightLayout.Padding = UDim.new(0, 5)
    
    LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() LeftCol.CanvasSize = UDim2.new(0,0,0,LeftLayout.AbsoluteContentSize.Y + 10) end)
    RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() RightCol.CanvasSize = UDim2.new(0,0,0,RightLayout.AbsoluteContentSize.Y + 10) end)
    
    -- [ĐÃ FIX LỖI KẸT TAB TẠI ĐÂY]
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Ind.Visible = false
            t.Page.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.Visible = true
        page.Visible = true
    end)
    table.insert(Tabs, {Btn = btn, Page = page, Ind = Indicator})
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabContainer.CanvasSize = UDim2.new(0,0,0,TabLayout.AbsoluteContentSize.Y + 10) end)
    return LeftCol, RightCol
end

local function CreateSection(parentCol, titleText)
    local sec = Instance.new("Frame", parentCol)
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", sec).Color = Color3.fromRGB(40, 40, 40)
    
    local title = Instance.new("TextLabel", sec)
    title.Size = UDim2.new(1, -10, 0, 22)
    title.Position = UDim2.new(0, 5, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(0, 150, 255)
    title.Text = titleText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local layout = Instance.new("UIListLayout", sec)
    layout.Padding = UDim.new(0, 3)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local pad = Instance.new("Frame", sec)
    pad.Size = UDim2.new(1, 0, 0, 22)
    pad.BackgroundTransparency = 1
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sec.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 5) end)
    return sec
end

local function CreateButton(parentSec, text, callback)
    local btn = Instance.new("TextButton", parentSec)
    btn.Size = UDim2.new(1, -10, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(parentSec, text, varName)
    local frame = Instance.new("Frame", parentSec)
    frame.Size = UDim2.new(1, -10, 0, 26)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local switchBg = Instance.new("Frame", frame)
    switchBg.Size = UDim2.new(0, 32, 0, 16)
    switchBg.Position = UDim2.new(1, -32, 0.5, -8)
    switchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switchBg)
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = UDim2.new(0, 2, 0.5, -6)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        _G[varName] = state
        local goalCircle = state and {Position = UDim2.new(1, -14, 0.5, -6)} or {Position = UDim2.new(0, 2, 0.5, -6)}
        local goalBg = state and {BackgroundColor3 = Color3.fromRGB(0, 150, 255)} or {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
        TweenService:Create(circle, TweenInfo.new(0.2), goalCircle):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), goalBg):Play()
    end)
end

local function CreateSlider(parentSec, text, min, max, varName)
    local frame = Instance.new("Frame", parentSec)
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = text .. ": " .. min
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 1, -10)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", sliderBg)
    btn.Size = UDim2.new(1, 0, 1, 14)
    btn.Position = UDim2.new(0, 0, 0.5, -7)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local isDragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. val
        _G[varName] = val
    end
    btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = true; update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
end

local function TP(targetObj)
    if not targetObj then return end
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        if targetObj:IsA("Model") and targetObj.PrimaryPart then hrp.CFrame = targetObj.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
        elseif targetObj:IsA("BasePart") then hrp.CFrame = targetObj.CFrame * CFrame.new(0, 3, 0) end
    end
end

-- ==========================================
-- BIẾN TOÀN CỤC CHÍNH
-- ==========================================
_G.SelectedMobs, _G.SelectedWeapons = {}, {}
_G.AutoFarm, _G.AutoAttack, _G.AutoEquip, _G.AutoChest = false, false, false, false
_G.AttackPos = "Trên đầu"
_G.AttackDist = 5
_G.AutoZ, _G.AutoX, _G.AutoC, _G.AutoV = false, false, false, false
_G.WalkSpeed, _G.JumpPower, _G.Noclip, _G.Fly = 16, 50, false, false

-- ==========================================
-- TẠO 6 TABS (ĐÃ THÊM TAB SHOP TẠI ĐÂY)
-- ==========================================

-- [1] TAB MAIN
local MainLeft, MainRight = CreateTab("Main", true)
local SecMob = CreateSection(MainLeft, "Mob Selection")
local MobDropBtn = CreateButton(SecMob, "Danh Sách Quái ▼", function() end)
local MobListFrame = Instance.new("Frame", SecMob)
MobListFrame.Size = UDim2.new(1, -10, 0, 0); MobListFrame.BackgroundTransparency = 1; MobListFrame.ClipsDescendants = true; MobListFrame.Visible = false
local MobLayout = Instance.new("UIListLayout", MobListFrame); MobLayout.Padding = UDim.new(0, 2)
MobLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() MobListFrame.Size = UDim2.new(1, -10, 0, MobLayout.AbsoluteContentSize.Y) end)

MobDropBtn.MouseButton1Click:Connect(function() MobListFrame.Visible = not MobListFrame.Visible; MobDropBtn.Text = MobListFrame.Visible and "Đóng List Quái ▲" or "Danh Sách Quái ▼" end)
local function LoadMobs()
    for _, c in ipairs(MobListFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    _G.SelectedMobs = {}
    local foundMobs = {}
    local folder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
    for _, v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name and not table.find(foundMobs, v.Name) then table.insert(foundMobs, v.Name) end
    end
    for _, mob in ipairs(foundMobs) do
        local btn = CreateButton(MobListFrame, "  ☐ " .. mob, function() end)
        btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        local isSel = false
        btn.MouseButton1Click:Connect(function()
            isSel = not isSel; btn.Text = isSel and "  ☑ " .. mob or "  ☐ " .. mob
            btn.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
            if isSel then table.insert(_G.SelectedMobs, mob) else for i, v in ipairs(_G.SelectedMobs) do if v == mob then table.remove(_G.SelectedMobs, i) break end end end
        end)
    end
end
CreateButton(SecMob, "🔄 Quét Lại Quái", LoadMobs); LoadMobs()

local SecWep = CreateSection(MainLeft, "Auto Equip Weapon")
local WepDropBtn = CreateButton(SecWep, "Chọn Vũ Khí ▼", function() end)
local WepListFrame = Instance.new("Frame", SecWep)
WepListFrame.Size = UDim2.new(1, -10, 0, 0); WepListFrame.BackgroundTransparency = 1; WepListFrame.ClipsDescendants = true; WepListFrame.Visible = false
local WepLayout = Instance.new("UIListLayout", WepListFrame); WepLayout.Padding = UDim.new(0, 2)
WepLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() WepListFrame.Size = UDim2.new(1, -10, 0, WepLayout.AbsoluteContentSize.Y) end)

WepDropBtn.MouseButton1Click:Connect(function() WepListFrame.Visible = not WepListFrame.Visible end)
local function LoadWeps()
    for _, c in ipairs(WepListFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    _G.SelectedWeapons = {}
    local foundWeps = {}
    for _, v in pairs(Player.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(foundWeps, v.Name) end end
    for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("Tool") then table.insert(foundWeps, v.Name) end end
    for _, wep in ipairs(foundWeps) do
        local btn = CreateButton(WepListFrame, "  ☐ " .. wep, function() end)
        btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        local isSel = false
        btn.MouseButton1Click:Connect(function()
            isSel = not isSel; btn.Text = isSel and "  ☑ " .. wep or "  ☐ " .. wep
            btn.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
            if isSel then table.insert(_G.SelectedWeapons, wep) else for i, v in ipairs(_G.SelectedWeapons) do if v == wep then table.remove(_G.SelectedWeapons, i) break end end end
        end)
    end
end
CreateButton(SecWep, "🔄 Quét Túi Đồ", LoadWeps)

local SecFarm = CreateSection(MainRight, "Farming Config")
CreateToggle(SecFarm, "Tự Cầm Vũ Khí", "AutoEquip")
CreateToggle(SecFarm, "Auto Attack", "AutoAttack")
CreateToggle(SecFarm, "Auto Farm", "AutoFarm")

-- [2] TAB SETTING
local SetLeft, SetRight = CreateTab("Setting", false)
local SecPos = CreateSection(SetLeft, "Attack Position")
local PosList = {"Trên đầu", "Dưới chân", "Sau lưng", "Trước mặt"}
local PosIdx = 1
local PosBtn = CreateButton(SecPos, "Vị Trí: Trên đầu", function() end)
PosBtn.MouseButton1Click:Connect(function() PosIdx = PosIdx + 1; if PosIdx > #PosList then PosIdx = 1 end; _G.AttackPos = PosList[PosIdx]; PosBtn.Text = "Vị Trí: " .. _G.AttackPos end)
CreateSlider(SecPos, "Khoảng Cách", 0, 20, "AttackDist")

local SecSkill = CreateSection(SetRight, "Auto Skills")
CreateToggle(SecSkill, "Dùng Skill Z", "AutoZ")
CreateToggle(SecSkill, "Dùng Skill X", "AutoX")
CreateToggle(SecSkill, "Dùng Skill C", "AutoC")
CreateToggle(SecSkill, "Dùng Skill V", "AutoV")

-- [3] TAB TELEPORT
local TpLeft, TpRight = CreateTab("Teleport", false)
local SecMap = CreateSection(TpLeft, "Map & Island")
local MapList = {"Starter Island", "Jungle", "Desert", "Snow"}
local MapBtn = CreateButton(SecMap, "Đích: Starter Island", function() end)
local MapIdx = 1
MapBtn.MouseButton1Click:Connect(function() MapIdx = MapIdx + 1; if MapIdx > #MapList then MapIdx = 1 end; MapBtn.Text = "Đích: " .. MapList[MapIdx] end)
CreateButton(SecMap, "✈️ Bay Tới Đảo", function() for _, v in pairs(workspace:GetDescendants()) do if v.Name == MapList[MapIdx] then TP(v) break end end end)

local SecNpc = CreateSection(TpRight, "Quest & NPC")
local NpcList = {"Bandit Quest", "Sword Dealer"}
local NpcBtn = CreateButton(SecNpc, "Đích: Bandit Quest", function() end)
local NpcIdx = 1
NpcBtn.MouseButton1Click:Connect(function() NpcIdx = NpcIdx + 1; if NpcIdx > #NpcList then NpcIdx = 1 end; NpcBtn.Text = "Đích: " .. NpcList[NpcIdx] end)
CreateButton(SecNpc, "✈️ Bay Tới NPC", function() for _, v in pairs(workspace:GetDescendants()) do if v.Name == NpcList[NpcIdx] then TP(v) break end end end)

-- [4] TAB SHOP (TÍNH NĂNG MỚI THEO YÊU CẦU)
local ShopLeft, ShopRight = CreateTab("Shop & Chest", false)

-- Hàm tạo Nút Mũi Tên và List chọn để đỡ lặp Code
local function CreateShopDropdown(parentSec, title, scanFolderName)
    local targetObj = nil
    local DropBtn = CreateButton(parentSec, "Chọn " .. title .. " ▼", function() end)
    local ListFrame = Instance.new("Frame", parentSec)
    ListFrame.Size = UDim2.new(1, -10, 0, 0); ListFrame.BackgroundTransparency = 1; ListFrame.ClipsDescendants = true; ListFrame.Visible = false
    local Layout = Instance.new("UIListLayout", ListFrame); Layout.Padding = UDim.new(0, 2)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() ListFrame.Size = UDim2.new(1, -10, 0, Layout.AbsoluteContentSize.Y) end)
    
    DropBtn.MouseButton1Click:Connect(function() ListFrame.Visible = not ListFrame.Visible end)
    
    local function Scan()
        for _, c in ipairs(ListFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local folder = workspace:FindFirstChild(scanFolderName)
        if folder then
            for _, v in pairs(folder:GetChildren()) do
                local btn = CreateButton(ListFrame, "  " .. v.Name, function() end)
                btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
                btn.MouseButton1Click:Connect(function() 
                    targetObj = v
                    DropBtn.Text = "Đã chọn: " .. v.Name
                    ListFrame.Visible = false
                end)
            end
        else
            CreateButton(ListFrame, "Không tìm thấy " .. scanFolderName, function() end).BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        end
    end
    CreateButton(parentSec, "🔄 Quét " .. scanFolderName, Scan)
    CreateButton(parentSec, "✈️ Bay Tới " .. title, function() if targetObj then TP(targetObj) end end)
end

local SecWepShop = CreateSection(ShopLeft, "NpcWeapon")
CreateShopDropdown(SecWepShop, "Vũ Khí", "NpcWeapon")

local SecFruitShop = CreateSection(ShopLeft, "NpcRandomfruit")
CreateShopDropdown(SecFruitShop, "Random Fruit", "NpcRandomfruit")

local SecPromptShop = CreateSection(ShopRight, "NpcPrompt (Haki)")
CreateShopDropdown(SecPromptShop, "Haki & Sell", "npcprompt")

local SecChest = CreateSection(ShopRight, "Chest (Rương)")
CreateToggle(SecChest, "Auto Gom Chest (Rương)", "AutoChest")
CreateButton(SecChest, "✈️ Bay Tới Chest Gần Nhất", function()
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(workspace:GetDescendants()) do
            if string.match(v.Name, "Chest") and (v:IsA("Model") or v:IsA("BasePart")) then
                TP(v)
                break
            end
        end
    end
end)

-- [5] TAB PLAYER
local PlLeft, PlRight = CreateTab("Player", false)
local SecPlMove = CreateSection(PlLeft, "Movement")
CreateSlider(SecPlMove, "Tốc Độ (WalkSpeed)", 16, 250, "WalkSpeed")
CreateSlider(SecPlMove, "Nhảy Cao (JumpPower)", 50, 300, "JumpPower")

local SecPlMisc = CreateSection(PlRight, "Abilities")
CreateToggle(SecPlMisc, "Xuyên Tường (Noclip)", "Noclip")
CreateToggle(SecPlMisc, "Bay (Fly)", "Fly")

RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        Player.Character.Humanoid.JumpPower = _G.JumpPower
    end
    if _G.Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if _G.Fly and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        workspace.Gravity = 0
        local hrp = Player.Character.HumanoidRootPart
        local moveDir = Player.Character.Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then hrp.Velocity = Vector3.new(moveDir.X * 50, hrp.Velocity.Y, moveDir.Z * 50)
        else hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
    else
        workspace.Gravity = 196.2
    end
end)

-- [6] TAB SERVER
local SvLeft, SvRight = CreateTab("Server", false)
local SecSvMan = CreateSection(SvLeft, "Server Manager")
CreateButton(SecSvMan, "Vào Lại (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)
CreateButton(SecSvMan, "Hop Server (Ít Người)", function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, server in pairs(servers) do if server.playing < server.maxPlayers and server.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Player) break end end
end)
local SecPerf = CreateSection(SvRight, "Performance")
CreateButton(SecPerf, "Tối Ưu FPS", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)
CreateButton(SecPerf, "Xóa Hiệu Ứng (Effects)", function()
    for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") then v:Destroy() end end
end)

-- ==========================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- ==========================================
task.spawn(function()
    while task.wait() do
        local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        
        -- Logic Auto Chest (Tự bay gôm rương liên tục)
        if _G.AutoChest and hrp then
            for _, v in pairs(workspace:GetDescendants()) do
                if string.match(v.Name, "Chest") and (v:IsA("Model") or v:IsA("BasePart")) then
                    TP(v)
                    task.wait(0.5) -- Đợi nhặt rương
                end
            end
        end

        -- Xử lý chống búng lên trời khi Farm
        if hrp then
            local bv = hrp:FindFirstChild("AntiFlingBV")
            if _G.AutoFarm then
                for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
                if not bv then bv = Instance.new("BodyVelocity"); bv.Name = "AntiFlingBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0, 0, 0); bv.Parent = hrp end
            else
                if bv then bv:Destroy() end
            end
        end

        if _G.AutoEquip and Player.Character then
            for _, wepName in pairs(_G.SelectedWeapons) do
                local tool = Player.Backpack:FindFirstChild(wepName)
                if tool then Player.Character.Humanoid:EquipTool(tool) end
            end
        end

        if _G.AutoAttack and Player.Character then
            for _, tool in pairs(Player.Character:GetChildren()) do if tool:IsA("Tool") then tool:Activate() end end
        end

        if _G.AutoFarm or _G.AutoAttack then
            if _G.AutoZ then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) end
            if _G.AutoX then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) end
            if _G.AutoC then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) end
            if _G.AutoV then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) end
        end

        if _G.AutoFarm and hrp and #_G.SelectedMobs > 0 then
            local folder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
            for _, mobName in pairs(_G.SelectedMobs) do
                local target = folder:FindFirstChild(mobName)
                if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                    local offset = CFrame.new(0, 0, 0)
                    local dist = _G.AttackDist
                    if _G.AttackPos == "Trên đầu" then offset = CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    elseif _G.AttackPos == "Dưới chân" then offset = CFrame.new(0, -dist, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    elseif _G.AttackPos == "Sau lưng" then offset = CFrame.new(0, 0, dist)
                    elseif _G.AttackPos == "Trước mặt" then offset = CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.rad(180), 0) end
                    
                    hrp.CFrame = target.HumanoidRootPart.CFrame * offset
                    break
                end
            end
        end
    end
end)
