-- GUI.lua
local Services = require(script.Parent.Services)

local module = {}

module.ScreenGui = Instance.new("ScreenGui")
module.ScreenGui.Name = "DemonfallTools"
module.ScreenGui.ResetOnSpawn = false

module.MainFrame = Instance.new("Frame")
module.MainFrame.Size = UDim2.new(0, 250, 0, 300)
module.MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
module.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
module.MainFrame.BorderSizePixel = 0
module.MainFrame.Parent = module.ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = module.MainFrame

module.Title = Instance.new("TextLabel")
module.Title.Size = UDim2.new(1, 0, 0, 40)
module.Title.Position = UDim2.new(0, 0, 0, 0)
module.Title.BackgroundTransparency = 1
module.Title.Text = "Demonfall Tools"
module.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
module.Title.TextSize = 24
module.Title.Font = Enum.Font.GothamBold
module.Title.Parent = module.MainFrame

module.MenuFrame = Instance.new("ScrollingFrame")
module.MenuFrame.Size = UDim2.new(1, 0, 1, -50)
module.MenuFrame.Position = UDim2.new(0, 0, 0, 40)
module.MenuFrame.BackgroundTransparency = 1
module.MenuFrame.ScrollBarThickness = 5
module.MenuFrame.Parent = module.MainFrame

module.MenuListLayout = Instance.new("UIListLayout")
module.MenuListLayout.Padding = UDim.new(0, 10)
module.MenuListLayout.Parent = module.MenuFrame

-- Fonksiyon: Menü butonlarını oluşturur
module.createMenuButton = function(text, onClick)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.Font = Enum.Font.Gotham
    button.Parent = module.MenuFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    button.MouseButton1Click:Connect(onClick)

    return button
end

-- Teleport Menü
module.TeleportMenuButton = module.createMenuButton("NPC Teleport", function()
    require(script.Parent.Teleport).toggleNPCFrame()
end)

-- Godmode Menü
module.GodmodeMenuButton = module.createMenuButton("Godmode", function()
    require(script.Parent.Godmode).toggleGodmodeFrame()
end)

-- Dupe Menü
module.DupeMenuButton = module.createMenuButton("Dupe", function()
    require(script.Parent.Dupe).toggleDupeFrame()
end)

-- Fog Menü
module.FogMenuButton = module.createMenuButton("Clear Fog", function()
    require(script.Parent.Fog).toggleFogFrame()
end)

-- Bölge TP Menü
module.RegionMenuButton = module.createMenuButton("Bölge TP", function()
    require(script.Parent.Teleport).toggleRegionFrame()
end)

-- ESP Menü
module.ESPMenuButton = module.createMenuButton("NPC ESP", function()
    require(script.Parent.ESP).toggleESPFrame()
end)

-- Auto Farm Menü
module.AutoFarmMenuButton = module.createMenuButton("Auto Farm", function()
    require(script.Parent.AutoFarm).toggleAutoFarmFrame()
end)

-- Fly Menü
module.FlyMenuButton = module.createMenuButton("Fly", function()
    require(script.Parent.Fly).toggleFlyFrame()
end)

-- Kapatma Butonu
module.CloseButton = Instance.new("TextButton")
module.CloseButton.Size = UDim2.new(0, 30, 0, 30)
module.CloseButton.Position = UDim2.new(1, -40, 0, 5)
module.CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
module.CloseButton.Text = "X"
module.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
module.CloseButton.TextSize = 18
module.CloseButton.Font = Enum.Font.GothamBold
module.CloseButton.Parent = module.MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 15)
CloseCorner.Parent = module.CloseButton

-- Yeniden Boyutlandırma Alanı (Sağ Alt Köşe)
module.ResizeHandle = Instance.new("Frame")
module.ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
module.ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
module.ResizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
module.ResizeHandle.BorderSizePixel = 0
module.ResizeHandle.Parent = module.MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 5)
ResizeCorner.Parent = module.ResizeHandle

-- ScrollingFrame CanvasSize’ı güncelle
module.updateMenuCanvasSize = function()
    local buttonCount = #module.MenuFrame:GetChildren() - 1
    module.MenuFrame.CanvasSize = UDim2.new(0, 0, 0, buttonCount * 60)
end

module.updateMenuCanvasSize()

-- Sürüklenebilir Yapma
local dragging, dragInput, dragStart, startPos
module.MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.X < (module.MainFrame.AbsolutePosition.X + module.MainFrame.AbsoluteSize.X - 15) then
        dragging = true
        dragStart = input.Position
        startPos = module.MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

module.MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

Services.UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        module.MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Yeniden Boyutlandırma
local resizing, resizeStart, resizeStartSize
module.ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        resizeStartSize = module.MainFrame.Size
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)

module.ResizeHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

Services.UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and resizing then
        local delta = input.Position - resizeStart
        local newWidth = math.max(150, resizeStartSize.X.Offset + delta.X)
        local newHeight = math.max(150, resizeStartSize.Y.Offset + delta.Y)
        module.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)

        -- Butonların boyutlarını güncelle
        module.TeleportMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
        module.GodmodeMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
        module.DupeMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
        module.FogMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
        module.RegionMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
        module.ESPMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
        module.AutoFarmMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
        module.FlyMenuButton.Size = UDim2.new(0, newWidth - 20, 0, 50)
    end
end)

return module