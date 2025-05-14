-- ESP.lua
local Services = require(script.Parent.Services)
local GUI = require(script.Parent.GUI)

local module = {}

-- NPC ESP için Açılır Frame (Sağda)
module.ESPFrame = Instance.new("Frame")
module.ESPFrame.Size = UDim2.new(0, 260, 0, 150)
module.ESPFrame.Position = UDim2.new(1, 10, 0, 0)
module.ESPFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.ESPFrame.BorderSizePixel = 0
module.ESPFrame.Visible = false
module.ESPFrame.Parent = GUI.MainFrame

local ESPCornerFrame = Instance.new("UICorner")
ESPCornerFrame.CornerRadius = UDim.new(0, 8)
ESPCornerFrame.Parent = module.ESPFrame

module.ESPToggle = Instance.new("TextButton")
module.ESPToggle.Size = UDim2.new(0, 240, 0, 50)
module.ESPToggle.Position = UDim2.new(0.5, -120, 0, 25)
module.ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.ESPToggle.Text = "NPC ESP: Kapalı"
module.ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
module.ESPToggle.TextSize = 18
module.ESPToggle.Font = Enum.Font.Gotham
module.ESPToggle.Parent = module.ESPFrame

local ESPToggleCorner = Instance.new("UICorner")
ESPToggleCorner.CornerRadius = UDim.new(0, 8)
ESPToggleCorner.Parent = module.ESPToggle

module.espSettings = {
    showHealth = true,
    showName = true,
    showDistance = true
}

module.espActive = false
module.espConnections = {}
module.espBillboards = {}

module.createESP = function(npc)
    if not npc or not npc:IsA("Model") or not npc:FindFirstChild("HumanoidRootPart") or not npc:FindFirstChild("Humanoid") then
        return
    end

    local humanoid = npc:FindFirstChild("Humanoid")
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(3, 0, 1.5, 0)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.Parent = rootPart
    billboardGui.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = billboardGui

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0.5, 0, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = billboardGui

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 1, 0, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = billboardGui

    module.espBillboards[npc] = {
        gui = billboardGui,
        name = nameLabel,
        health = healthLabel,
        distance = distanceLabel
    }

    local updateConnection = humanoid.Changed:Connect(function(property)
        if property == "Health" or property == "MaxHealth" then
            if module.espSettings.showHealth then
                healthLabel.Text = humanoid.Health .. " / " .. humanoid.MaxHealth
            else
                healthLabel.Text = ""
            end
        end
    end)

    module.espConnections[npc] = updateConnection

    return billboardGui
end

module.enableESP = function()
    if not module.espActive then
        module.espActive = true
        for _, obj in pairs(game.Workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") then
                module.createESP(obj)
            end
        end
        module.ESPToggle.Text = "NPC ESP: Açık"
        module.ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        print("NPC ESP aktif!")
    end
end

module.disableESP = function()
    if module.espActive then
        module.espActive = false
        for npc, data in pairs(module.espBillboards) do
            if data and data.gui and data.gui.Parent then
                data.gui:Destroy()
            end
            if module.espConnections[npc] then
                module.espConnections[npc]:Disconnect()
            end
        end
        module.espBillboards = {}
        module.espConnections = {}
        module.ESPToggle.Text = "NPC ESP: Kapalı"
        module.ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        print("NPC ESP devre dışı!")
    end
end

module.toggleESP = function()
    if module.espActive then
        module.disableESP()
    else
        module.enableESP()
    end
end

module.updateESPSettings = function()
    if module.espActive then
        for npc, data in pairs(module.espBillboards) do
            if data then
                data.name.Visible = module.espSettings.showName
                data.health.Visible = module.espSettings.showHealth
                data.distance.Visible = module.espSettings.showDistance
            end
        end
    end
end

module.toggleESPFrame = function()
    module.ESPFrame.Visible = not module.ESPFrame.Visible
end

return module