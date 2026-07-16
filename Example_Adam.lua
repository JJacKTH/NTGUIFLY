local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. โหลด GUIS หลักของคุณ (Fluent UI)
-- ==========================================
local Fluent = loadstring(game:HttpGet("https://github.com/JJacKTH/NTGUIFLY/releases/download/1.5.1/FluentPro"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/NTGUIFLY/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "DENGHUB",
    SubTitle = "[RETURN + UPD6] Anime Astral Simulator",
    Version = "1.0.0",
    TabWidth = 200,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Ash Gray",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Search = true,
})

-- ==========================================
-- 2. สร้างระบบ Floating Icon แยก พร้อมระบบแก้ปัญหา Unload
-- ==========================================

-- ลบ UI เก่าทิ้งถ้าเคยรันไปแล้ว ป้องกันการซ้อนทับ
if CoreGui:FindFirstChild("DENGHUB_FloatingIcon") then
    CoreGui.DENGHUB_FloatingIcon:Destroy()
elseif LocalPlayer.PlayerGui:FindFirstChild("DENGHUB_FloatingIcon") then
    LocalPlayer.PlayerGui.DENGHUB_FloatingIcon:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DENGHUB_FloatingIcon"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- พยายามเอาไปไว้ใน CoreGui เพื่อไม่ให้เกมตรวจจับง่าย ถ้าไม่ได้ให้ไว้ใน PlayerGui
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ปุ่ม Icon (จัดให้อยู่กลางจอ-ด้านบน ห่างจากขอบจอ 15 พิกเซล)
local IconButton = Instance.new("ImageButton")
IconButton.Name = "Icon"
IconButton.Parent = ScreenGui
IconButton.AnchorPoint = Vector2.new(0.5, 0) -- จุดหมุนอ้างอิงคือกึ่งกลางด้านบน
IconButton.Position = UDim2.new(0.5, 0, 0, 15) -- แกน X กลางจอ (0.5), แกน Y ห่างจากขอบบนลงมา 15 พิกเซล
IconButton.Size = UDim2.fromOffset(50, 50)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://72061614719261"
IconButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
IconButton.AutoButtonColor = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.5, 0) -- ทำให้กลม 100%
UICorner.Parent = IconButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(180, 10, 20) -- สีขอบแดงตาม Theme
UIStroke.Thickness = 2
UIStroke.Parent = IconButton

-- -----------------------------------------------------------------
-- [สำคัญ] ระบบดักจับการ Unload UI (เมื่อปิด UI ให้ลบ Icon ทิ้งทันที)
-- -----------------------------------------------------------------
local unloadConnection
unloadConnection = RunService.Heartbeat:Connect(function()
    if not Window or not Window.Root or not Window.Root.Parent then
        if ScreenGui then
            ScreenGui:Destroy()
        end
        if unloadConnection then
            unloadConnection:Disconnect()
        end
    end
end)
-- -----------------------------------------------------------------

-- ==========================================
-- 3. ระบบลากวางแบบสมูท (Smooth Dragging & Tap to Toggle)
-- ==========================================
local dragging = false
local dragInput, mousePos, framePos
local dragSpeed = 0.15 
local isMoving = false

IconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        isMoving = false
        mousePos = input.Position
        framePos = IconButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if not isMoving then
                    Window:Minimize()
                end
            end
        end)
    end
end)

IconButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        if delta.Magnitude > 3 then
            isMoving = true
        end
        
        local newPos = UDim2.new(
            framePos.X.Scale, 
            framePos.X.Offset + delta.X, 
            framePos.Y.Scale, 
            framePos.Y.Offset + delta.Y
        )
        TweenService:Create(IconButton, TweenInfo.new(dragSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
    end
end)

-- ==========================================
-- 4. ส่วนของ Tabs และ Settings ด้านล่าง
-- ==========================================
local Tabs = {
    Basic = Window:AddTab({ Title = "Basic", Icon = "solar/home-2-bold" }),
    Advanced = Window:AddTab({ Title = "Advanced", Icon = "solar/tuning-bold" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })
}

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

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("DENGHUB")

SaveManager:BuildGameFolder({
    Folder = "DENGHUB",
    GameName = "Anime Astral Simulator",
    ConfigName = "AnimeAstralConfig",
    AutoSave = true,
    AutoLoad = true,
})

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Fluent:SetTheme("Ash Gray")
Window:SelectTab(1)