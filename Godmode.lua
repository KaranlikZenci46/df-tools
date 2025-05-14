-- Godmode.lua
local Services = require(script.Parent.Services)
local GUI = require(script.Parent.GUI)

local module = {}

-- Godmode için Açılır Frame (Sağda)
module.GodmodeFrame = Instance.new("Frame")
module.GodmodeFrame.Size = UDim2.new(0, 260, 0, 100)
module.GodmodeFrame.Position = UDim2.new(1, 10, 0, 0)
module.GodmodeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.GodmodeFrame.BorderSizePixel = 0
module.GodmodeFrame.Visible = false
module.GodmodeFrame.Parent = GUI.MainFrame

local GodmodeCornerFrame = Instance.new("UICorner")
GodmodeCornerFrame.CornerRadius = UDim.new(0, 8)
GodmodeCornerFrame.Parent = module.GodmodeFrame

module.GodmodeToggle = Instance.new("TextButton")
module.GodmodeToggle.Size = UDim2.new(0, 240, 0, 50)
module.GodmodeToggle.Position = UDim2.new(0.5, -120, 0, 25)
module.GodmodeToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.GodmodeToggle.Text = "Godmode: Kapalı"
module.GodmodeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
module.GodmodeToggle.TextSize = 18
module.GodmodeToggle.Font = Enum.Font.Gotham
module.GodmodeToggle.Parent = module.GodmodeFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = module.GodmodeToggle

module.godmodeEnabled = false
local originalMaxHealth = 0
local regenRate = 100

module.enableGodmode = function()
    if not module.godmodeEnabled then
        module.godmodeEnabled = true
        originalMaxHealth = Services.humanoid.MaxHealth
        Services.humanoid.MaxHealth = math.huge
        Services.humanoid.Health = math.huge
        Services.humanoid.Regeneration = regenRate
        module.GodmodeToggle.Text = "Godmode: Açık"
        module.GodmodeToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        print("Godmode aktif!")
    end
end

module.disableGodmode = function()
    if module.godmodeEnabled then
        module.godmodeEnabled = false
        Services.humanoid.MaxHealth = originalMaxHealth
        Services.humanoid.Regeneration = 0
        module.GodmodeToggle.Text = "Godmode: Kapalı"
        module.GodmodeToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        print("Godmode devre dışı!")
    end
end

module.toggleGodmode = function()
    if module.godmodeEnabled then
        module.disableGodmode()
    else
        module.enableGodmode()
    end
end

module.toggleGodmodeFrame = function()
    module.GodmodeFrame.Visible = not module.GodmodeFrame.Visible
end

return module