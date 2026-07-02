-- Gọi thẳng từ Github gốc để tránh lỗi mạng
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/sirius-hub/rayfield/main/source'))()

-- Tạo Cửa sổ (Window)
local Window = Rayfield:CreateWindow({
   Name = "Rock Fruit Hub | Đã Fix Lỗi",
   LoadingTitle = "Đang tải giao diện...",
   LoadingSubtitle = "Vui lòng chờ một chút!",
   ConfigurationSaving = {
      Enabled = false -- ĐÃ TẮT: Tránh lỗi crash menu trên điện thoại
   },
   KeySystem = false
})

local TabFarm = Window:CreateTab("Farm Mobs", 4483362458) 

TabFarm:CreateButton({
   Name = "✅ Nếu bạn thấy nút này, Menu đã hoạt động!",
   Callback = function()
      Rayfield:Notify({
         Title = "Thành công",
         Content = "Giao diện đã hiển thị bình thường!",
         Duration = 3
      })
   end,
})

-- Phần Dropdown chọn nhiều quái (Test)
TabFarm:CreateDropdown({
   Name = "Test chọn nhiều quái",
   Options = {"Quái 1", "Quái 2", "Quái 3"},
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "TestDropdown",
   Callback = function(Options)
      print("Đã chọn:", table.concat(Options, ", "))
   end,
})
