local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Chỉ bắt các lệnh gửi từ Client lên Server
    if not checkcaller() then
        if method == "FireServer" or method == "InvokeServer" then
            
            -- Lọc bỏ các remote rác (chạy liên tục gây lag console)
            local ignoreList = {"MousePos", "Move", "Update", "Camera", "Walk"}
            local isSpam = false
            for _, name in pairs(ignoreList) do
                if string.match(self.Name, name) then isSpam = true break end
            end
            
            if not isSpam then
                task.spawn(function()
                    warn("--- BẮT ĐƯỢC LỆNH GỬI LÊN SERVER ---")
                    print("Loại Lệnh: ", method)
                    print("Đường dẫn: ", self:GetFullName())
                    print("Dữ liệu mang theo (Args):")
                    for i, v in pairs(args) do
                        print("   ["..tostring(i).."] = ", tostring(v), " (Kiểu: "..typeof(v)..")")
                    end
                    warn("------------------------------------")
                end)
            end
            
        end
    end
    return oldNamecall(self, ...)
end)

warn("✅ Đã bật Console Spy! Hãy mở bảng F9 (hoặc gõ /console) để theo dõi.")
