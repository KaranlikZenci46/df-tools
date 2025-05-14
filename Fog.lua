-- Fog.lua
local Services = require(script.Parent.Services)
local GUI = require(script.Parent.GUI)

local module = {}

-- Clear Fog için Açılır Frame (Sağda)
module.FogFrame = Instance.new("Frame")
module.FogFrame.Size = UDim2.new(0, 260, 0, 100)
module.FogFrame.Position = UDim2.new(1, 10, 0, 0)
module.FogFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.FogFrame.BorderSizePixel = 0
module.FogFrame.Visible = false
module.FogFrame.Parent = GUI.MainFrame

local FogCornerFrame = Instance.new("UICorner")
FogCornerFrame.CornerRadius = UDim.new(0, 8)
FogCornerFrame.Parent = module.FogFrame

module.FogToggle = Instance.new("TextButton")
module.FogToggle.Size = UDim2.new(0, 240, 0, 50)
module.FogToggle.Position = UDim2.new(0.5, -120, 0, 25)
module.FogToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.FogToggle.Text = "Fog: Açık"
module.FogToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
module.FogToggle.TextSize = 18
module.FogToggle.Font = Enum.Font.Gotham
module.FogToggle.Parent = module.FogFrame

local FogToggleCorner = Instance.new("UICorner")
FogToggleCorner.CornerRadius = UDim.new(0, 8)
FogToggleCorner.Parent = module.FogToggle

module.fogClearLoop = nil
module.fogEnabled = true

module.enableFogClear = function()
    if not module.fogEnabled then
        module.fogEnabled = true
        module.fogClearLoop = game:GetService("RunService").RenderStepped:Connect(function()
            Services.Lighting.FogEnd = 999999
            Services.Lighting.FogStart = 0
        end)
        module.FogToggle.Text = "Fog: Kapalı"
        module.FogToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        print("Fog temizleme aktif!")
    end
end

module.disableFogClear = function()
    if module.fogEnabled then
        module.fogEnabled = false
        if module.fogClearLoop then
            module.fogClearLoop:Disconnect()
            module.fogClearLoop = nil
        end
        Services.Lighting.FogEnd = 197
        Services.Lighting.FogStart = 0
        module.FogToggle.Text = "Fog: Kapalı"
        module.FogToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        print("Fog temizleme devre dışı!")
    end
end

module.toggleFogClear = function()
    if module.fogEnabled then
        module.disableFogClear()
    else
        module.enableFogClear()
    end
end

module.toggleFogFrame = function()
    module.FogFrame.Visible = not module.FogFrame.Visible
end

return module