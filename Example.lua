local Fluent = loadstring(game:HttpGet("https://github.com/JJacKTH/NTGUIFLY/releases/download/1.5.1/FluentPro"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "DENGHUB",
    SubTitle = "Complete Elements Reference",
    TabWidth = 200,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Ash Gray",
    MinimizeKey = Enum.KeyCode.LeftControl,
    FloatingIcon = {
        Enabled = true,
        Image = "rbxassetid://72061614719261",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0, 20, 0.5, 0)
    }
})

-- Define Tabs
local Tabs = {
    Basic = Window:AddTab({ Title = "Basic", Icon = "solar/home-2-bold" }),
    Advanced = Window:AddTab({ Title = "Advanced", Icon = "solar/tuning-bold" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })
}

-- ==========================================
-- TAB: Basic Elements
-- ==========================================

Tabs.Basic:AddParagraph({
    Title = "Paragraph Component",
    Content = "This is a paragraph description. It can hold multiple lines of instructions, links, or general info."
})

Tabs.Basic:AddSection("Interactions")

Tabs.Basic:AddButton({
    Title = "Standard Button",
    Description = "Clicking this executes a function callback",
    Callback = function()
        print("Button clicked!")
    end
})

local Toggle = Tabs.Basic:AddToggle("MyToggle", { 
    Title = "Toggle Switch", 
    Default = false, 
    Description = "Turn this setting on or off" 
})
Toggle:OnChanged(function(Value)
    print("Toggle changed to:", Value)
end)

local Slider = Tabs.Basic:AddSlider("MySlider", {
    Title = "Slider Control",
    Description = "Adjust numerical value with slider",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print("Slider value changed to:", Value)
    end
})

local Input = Tabs.Basic:AddInput("MyInput", {
    Title = "Text Input",
    Description = "Type text or values below",
    Default = "Default Text",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        print("Input finished:", Value)
    end
})

-- ==========================================
-- TAB: Advanced Elements
-- ==========================================

local CollapseSec = Tabs.Advanced:AddCollapsibleSection("Collapsible Section", "solar/folder-bold", false)

CollapseSec:AddCheckbox("MyCheckbox", {
    Title = "Checkbox Option",
    Default = false,
    Description = "A simple tick checkbox element"
})

local Dropdown = Tabs.Advanced:AddDropdown("MyDropdown", {
    Title = "Single Select Dropdown",
    Description = "Choose one option from the list",
    Values = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(Value)
        print("Dropdown selected:", Value)
    end
})

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

local Colorpicker = Tabs.Advanced:AddColorpicker("MyColorpicker", {
    Title = "Color Picker",
    Default = Color3.fromRGB(0, 125, 255),
    Description = "Select a custom color value"
})
Colorpicker:OnChanged(function(Value)
    print("Color changed to RGB:", Value.R * 255, Value.G * 255, Value.B * 255)
end)

local Keybind = Tabs.Advanced:AddKeybind("MyKeybind", {
    Title = "Custom Keybind",
    Mode = "Toggle",
    Default = "F",
    Description = "Press key to execute function",
    Callback = function(Value)
        print("Keybind triggered! Current State:", Value)
    end,
    ChangedCallback = function(NewKey)
        print("Keybind changed to:", NewKey)
    end
})

Tabs.Advanced:AddCode({
    Title = "Code Snippet Display",
    Code = 'print("Hello from Codeblock!")',
    OnCopy = function() 
        print("Code copied to clipboard!") 
    end
})

Tabs.Advanced:AddDivider()

-- ==========================================
-- TAB: Settings (Interface + Config)
-- ==========================================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("DENGHUB")

-- Build game-specific, user-separated config folder
SaveManager:BuildGameFolder({
    Folder = "DENGHUB",
    GameName = "Anime Astral Simulator",
    ConfigName = "AnimeAstralConfig",
    AutoSave = true,
    AutoLoad = true,
})

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
