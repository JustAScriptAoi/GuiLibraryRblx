# #1 Ui Library Modified By ZainPlenger

# Lib Url
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustAScriptAoi/GuiLibraryRblx/refs/heads/LOL/Xiuxian-Ui-dontghosob-DontGhosob_MyUi_67_67"))()

# Example Window

local Window = lib:NewWindow("Xiuxian", {Icon = "settings"}, "Black")
Window:SetFooter("v1.0 - Xiuxian") ---- You Can Change Black Theme For Other Theme

# Button 
Main:CreateButton("A", function()
    print("hl")
end, "mouse-pointer-click") ---- You Can Change Icon For Other Icon

# Toggle
Main:CreateToggle("B", false, function(state)
    print("B:", state)
end, "zap")

# Slidders
Main:CreateSlider("C", 99, 9999, 99, function(value)
    print("C:", value)
end, "gauge")

# Dropdown
Main:CreateDropdown("Mode", {"A", "b", "c"}, 2, function(option)
    print("Mode:", option)
end, "list")

# DropdownMulti (same but you can 2x Sellect)
Main:CreateDropdownMulti("Fruits", {"Apple", "Banana", "Orange"}, {"Apple"}, function(list)
    print("C:", table.concat(list, ", "))
end, "shopping-bag")

# Notification 
lib:SendNotification("Hello", "hjghh", 3, "bell", 2)
