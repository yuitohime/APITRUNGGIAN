local Player = game.Players.LocalPlayer
local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

-- HÀM ÉP VÒNG TRÒN TỰ CHẠY (Bỏ qua thời gian giữ tay)
local function FirePrompt(prompt)
    if fireproximityprompt then
        -- Dùng lệnh bá đạo của Executor
        fireproximityprompt(prompt, 1, true)
    else
        -- Cách 2 nếu Executor cùi: Ép thời gian giữ về 0
        prompt.HoldDuration = 0
        prompt:InputHoldBegin()
        task.wait(0.1)
        prompt:InputHoldEnd()
    end
end

-- =======================================
-- TÍNH NĂNG 1: AUTO NHẬN QUEST BẰNG VÒNG TRÒN
-- =======================================
local function AutoAcceptQuest(npcName)
    if not hrp then return end
    
    for _, v in pairs(workspace:GetDescendants()) do
        -- Tìm NPC có tên bạn muốn (Ví dụ: "Quest 1")
        if string.find(string.lower(v.Name), string.lower(npcName)) then
            local prompt = v:FindFirstChildOfClass("ProximityPrompt") or v:FindFirstChildWhichIsA("ProximityPrompt", true)
            
            if prompt then
                -- Lưu vị trí cũ
                local oldPos = hrp.CFrame
                
                -- Bay tới chỗ NPC
                hrp.CFrame = (v:IsA("Model") and v.PrimaryPart.CFrame or v.CFrame) * CFrame.new(0, 3, 0)
                task.wait(0.2) -- Chờ load map 1 chút xíu
                
                -- Bấm giữ vòng tròn nhận Quest
                FirePrompt(prompt)
                print("✅ Đã tự động nhận: " .. v.Name)
                
                -- Bay về chỗ cũ
                hrp.CFrame = oldPos
                break
            end
        end
    end
end

-- =======================================
-- TÍNH NĂNG 2: AUTO MỞ RƯƠNG (CHEST) BẰNG VÒNG TRÒN
-- =======================================
local function AutoOpenChest()
    if not hrp then return end
    
    for _, v in pairs(workspace:GetDescendants()) do
        -- Tìm cái nào có chữ Chest và chứa vòng tròn ProximityPrompt
        if string.match(string.lower(v.Name), "chest") then
            local prompt = v:FindFirstChildOfClass("ProximityPrompt") or v:FindFirstChildWhichIsA("ProximityPrompt", true)
            
            if prompt then
                print("📦 Đang mở rương: " .. v.Name)
                hrp.CFrame = (v:IsA("Model") and v.PrimaryPart.CFrame or v.CFrame) * CFrame.new(0, 3, 0)
                task.wait(0.2)
                
                -- Bấm giữ vòng tròn mở rương
                FirePrompt(prompt)
                task.wait(0.5) -- Đợi nhặt đồ xong mới đi tiếp
            end
        end
    end
end

-- CHẠY THỬ LỆNH NÀY XEM NHÂN VẬT CÓ ĐI MỞ RƯƠNG HOẶC NHẬN QUEST KHÔNG NHÉ:
-- AutoAcceptQuest("Quest 1") -- Bạn thử bỏ comment dấu -- ở đầu để test Quest
-- AutoOpenChest()            -- Bạn thử bỏ comment dấu -- ở đầu để test Rương
