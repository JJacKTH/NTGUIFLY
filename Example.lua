local Fluent = loadstring(game:HttpGet("https://github.com/JJacKTH/NTGUIFLY/releases/download/1.5.1/FluentPro"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "NTGUIFLY",
    SubTitle = "by JJacKTH",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Enables background blur (Requires Graphic Quality >= 8)
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Keybind to hide/show the menu
})

-- Define Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "solar/home-bold" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })
}

-- Main Tab Elements
Tabs.Main:AddParagraph({
    Title = "Welcome!",
    Content = "This is a clean, production-ready template for NTGUIFLY."
})

-- Example Toggle
local Toggle = Tabs.Main:AddToggle("MyToggle", { 
    Title = "Toggle Example", 
    Default = false 
})

Toggle:OnChanged(function(Value)
    print("Toggle changed to:", Value)
end)

-- Example Button
Tabs.Main:AddButton({
    Title = "Button Example",
    Description = "Click this button to trigger a dialog",
    Callback = function()
        Window:Dialog({
            Title = "Notification",
            Content = "You clicked the example button!",
            Buttons = {
                {
                    Title = "OK",
                    Callback = function()
                        print("Confirmed!")
                    end
                }
            }
        })
    end
})

-- Settings and Configurations Setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Folders where settings and configs will be saved on your device
InterfaceManager:SetFolder("NTGUIFLY_Settings")
SaveManager:SetFolder("NTGUIFLY_Settings/configs")

-- Build Settings UI inside the Settings Tab
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Select the default tab
Window:SelectTab(1)

-- Notify user that the script has loaded successfully
Fluent:Notify({
    Title = "NTGUIFLY Loaded",
    Content = "Press Left Control to toggle menu.",
    Duration = 5
})

-- Load auto-saved config
SaveManager:LoadAutoloadConfig()
