local Fluent = loadstring(game:HttpGet("https://github.com/JJacKTH/NTGUIFLY/releases/download/1.5.1/FluentPro"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/InterfaceManager.lua"))()

-- Get the username of the user running the code
local PlayerName = game:GetService("Players").LocalPlayer.Name

local Window = Fluent:CreateWindow({
    Title = "NTGUIFLY",
    SubTitle = "Complete Elements Reference",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- DISABLED background blur by default (fixes game screen blur)
    Theme = "AshGray", -- Sets default theme to AshGray (as requested)
    MinimizeKey = Enum.KeyCode.LeftControl -- Keybind to hide/show the menu
})

-- Define Tabs
local Tabs = {
    Basic = Window:AddTab({ Title = "Basic", Icon = "solar/widget-bold" }),
    Advanced = Window:AddTab({ Title = "Advanced", Icon = "solar/tuning-bold" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })
}

-- ==========================================
-- 1. TAB: Basic Elements
-- ==========================================

-- Paragraph
Tabs.Basic:AddParagraph({
    Title = "Paragraph Component",
    Content = "This is a paragraph description. It can hold multiple lines of instructions, links, or general info."
})

-- Section
Tabs.Basic:AddSection("Interactions")

-- Button
Tabs.Basic:AddButton({
    Title = "Standard Button",
    Description = "Clicking this executes a function callback",
    Callback = function()
        print("Button clicked!")
    end
})

-- Toggle
local Toggle = Tabs.Basic:AddToggle("MyToggle", { 
    Title = "Toggle Switch", 
    Default = false, 
    Description = "Turn this setting on or off" 
})
Toggle:OnChanged(function(Value)
    print("Toggle changed to:", Value)
end)

-- Slider
local Slider = Tabs.Basic:AddSlider("MySlider", {
    Title = "Slider Control",
    Description = "Adjust numerical value with slider",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0, -- 0 for integers, 1 or more for decimal places
    Callback = function(Value)
        print("Slider value changed to:", Value)
    end
})

-- Input (Textbox)
local Input = Tabs.Basic:AddInput("MyInput", {
    Title = "Text Input",
    Description = "Type text or values below",
    Default = "Default Text",
    Numeric = false, -- Only allows numbers if true
    Finished = true, -- Only calls callback on pressing Enter
    Callback = function(Value)
        print("Input finished:", Value)
    end
})

-- ==========================================
-- 2. TAB: Advanced Elements
-- ==========================================

-- Collapsible Section
local CollapseSec = Tabs.Advanced:AddCollapsibleSection("Collapsible Section", "solar/folder-bold", false)

-- Checkbox
CollapseSec:AddCheckbox("MyCheckbox", {
    Title = "Checkbox Option",
    Default = false,
    Description = "A simple tick checkbox element"
})

-- Dropdown (Single Select)
local Dropdown = Tabs.Advanced:AddDropdown("MyDropdown", {
    Title = "Single Select Dropdown",
    Description = "Choose one option from the list",
    Values = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(Value)
        print("Dropdown selected:", Value)
    end
})

-- Dropdown (Multi Select)
local MultiDropdown = Tabs.Advanced:AddDropdown("MyMultiDropdown", {
    Title = "Multi-Select Dropdown",
    Description = "Choose multiple options simultaneously",
    Values = {"Value A", "Value B", "Value C"},
    Default = {"Value A"},
    Multi = true,
    Callback = function(Value)
        local Selected = {}
        for k, v in pairs(Value) do
            if v then table.insert(Selected, k) end
        end
        print("Multi-Dropdown selected:", table.concat(Selected, ", "))
    end
})

-- Colorpicker
local Colorpicker = Tabs.Advanced:AddColorpicker("MyColorpicker", {
    Title = "Color Picker",
    Default = Color3.fromRGB(0, 125, 255),
    Description = "Select a custom color value"
})
Colorpicker:OnChanged(function(Value)
    print("Color changed to RGB:", Value.R * 255, Value.G * 255, Value.B * 255)
end)

-- Keybind
local Keybind = Tabs.Advanced:AddKeybind("MyKeybind", {
    Title = "Custom Keybind",
    Mode = "Toggle", -- modes: "Always", "Hold", "Toggle"
    Default = "F", -- Default bind key
    Description = "Press key to execute function",
    Callback = function(Value)
        print("Keybind triggered! Current State:", Value)
    end,
    ChangedCallback = function(NewKey)
        print("Keybind changed to:", NewKey)
    end
})

-- Code Block
Tabs.Advanced:AddCode({
    Title = "Code Snippet Display",
    Code = 'print("Hello from Codeblock!")',
    OnCopy = function() 
        print("Code copied to clipboard!") 
    end
})

-- Discord Invite Link
Tabs.Advanced:AddDiscord({
    Title = "Join Discord Community",
    Invite = "JJacKTH", -- Discord server invite code
    Description = "Click to copy Discord invite link"
})

-- Divider
Tabs.Advanced:AddDivider()

-- Image
Tabs.Advanced:AddImage({
    Title = "Custom Image UI",
    Image = "rbxassetid://10844783307", -- Roblox Image ID
    Size = UDim2.fromOffset(64, 64)
})

-- Space
Tabs.Advanced:AddSpace(15) -- Empty vertical spacing

-- ==========================================
-- 3. Settings configuration (Separated by Username)
-- ==========================================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Create folders named after the Username to isolate saves
InterfaceManager:SetFolder("NTGUIFLY_" .. PlayerName)
SaveManager:SetFolder("NTGUIFLY_" .. PlayerName .. "/configs")

-- Build Settings UI inside the Settings Tab
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Default to first Tab
Window:SelectTab(1)

-- Auto-Save and Auto-Load Setup
local configName = "autosave_" .. PlayerName

-- 1. Auto-Load config on startup
task.spawn(function()
    pcall(function()
        if isfile(SaveManager.Folder .. "/settings/" .. configName .. ".json") then
            SaveManager:Load(configName)
            Fluent:Notify({
                Title = "NTGUIFLY",
                Content = "Auto-loaded config for " .. PlayerName,
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "NTGUIFLY",
                Content = "Welcome, " .. PlayerName .. "! No save config found yet.",
                Duration = 5
            })
        end
    end)
end)

-- 2. Auto-Save whenever elements change
task.spawn(function()
    task.wait(1) -- Wait for startup load to complete
    for OptionIdx, OptionObj in pairs(Fluent.Options) do
        -- Skip save/config menu options
        if not OptionIdx:find("^SaveManager_") and not OptionIdx:find("^InterfaceManager_") then
            local originalCallback = OptionObj.Callback
            OptionObj.Callback = function(...)
                if originalCallback then
                    local success, err = pcall(originalCallback, ...)
                    if not success then warn("Callback error: " .. tostring(err)) end
                end
                -- Trigger Save
                pcall(function()
                    SaveManager:Save(configName)
                end)
            end
        end
    end
end)

-- ==========================================
-- 4. Floating Toggle Button (Using Built-in Style Addon)
-- ==========================================
task.spawn(function()
    local FloatingButtonManager = Fluent.FloatingButtonManager
    FloatingButtonManager:SetLibrary(Fluent)
    FloatingButtonManager:SetFolder("NTGUIFLY_" .. PlayerName .. "/floating")

    -- Prevent duplicate buttons on re-run
    local CoreGui = game:GetService("CoreGui")
    local existing = CoreGui:FindFirstChild("NTGUIFLY_Toggle")
    if existing then existing:Destroy() end

    -- Load the built-in modern floating button style
    -- (This automatically creates the button and registers it with FloatingButtonManager)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/FloatingButtonModernStyle.lua"))()

    -- Build Floating Button settings inside the Settings Tab
    FloatingButtonManager:BuildConfigSection(Tabs.Settings)
    FloatingButtonManager:LoadAutoloadConfig()
end)
