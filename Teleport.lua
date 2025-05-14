-- Teleport.lua
local Services = require(script.Parent.Services)
local GUI = require(script.Parent.GUI)

local module = {}

-- NPC Listesi için Açılır Frame (Sağda)
module.NPCFrame = Instance.new("Frame")
module.NPCFrame.Size = UDim2.new(0, 260, 0, 300)
module.NPCFrame.Position = UDim2.new(1, 10, 0, 0)
module.NPCFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.NPCFrame.BorderSizePixel = 0
module.NPCFrame.Visible = false
module.NPCFrame.Parent = GUI.MainFrame

module.NPCList = Instance.new("ScrollingFrame")
module.NPCList.Size = UDim2.new(1, 0, 1, 0)
module.NPCList.BackgroundTransparency = 1
module.NPCList.ScrollBarThickness = 5
module.NPCList.Parent = module.NPCFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = module.NPCFrame

module.NPCListLayout = Instance.new("UIListLayout")
module.NPCListLayout.Padding = UDim.new(0, 5)
module.NPCListLayout.Parent = module.NPCList

-- Bölge TP için Açılır Frame (Sağda)
module.RegionFrame = Instance.new("Frame")
module.RegionFrame.Size = UDim2.new(0, 260, 0, 300)
module.RegionFrame.Position = UDim2.new(1, 10, 0, 0)
module.RegionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.RegionFrame.BorderSizePixel = 0
module.RegionFrame.Visible = false
module.RegionFrame.Parent = GUI.MainFrame

local RegionCornerFrame = Instance.new("UICorner")
RegionCornerFrame.CornerRadius = UDim.new(0, 8)
RegionCornerFrame.Parent = module.RegionFrame

module.RegionList = Instance.new("ScrollingFrame")
module.RegionList.Size = UDim2.new(1, 0, 1, 0)
module.RegionList.BackgroundTransparency = 1
module.RegionList.ScrollBarThickness = 5
module.RegionList.Parent = module.RegionFrame

module.RegionListLayout = Instance.new("UIListLayout")
module.RegionListLayout.Padding = UDim.new(0, 5)
module.RegionListLayout.Parent = module.RegionList

-- Bölge Koordinatları (Burada tanımlandı)
local regions = {
    ["Hayakawa Village"] = Vector3.new(878.25, 757.75, -2265.81),
    ["Okuyia Village"] = Vector3.new(-3210.06, 704.10, -1157.54),
    ["Kamakura Village"] = Vector3.new(-2175.57, 1161.67, -1709.33),
    ["Ent. District"] = Vector3.new(-5410.24, 744.29, -6394.70),
    ["Slayer Corps"] = Vector3.new(-1820.67, 871.55, -6220.80),
    ["Slayer Exam"] = Vector3.new(-5194.09, 792.62, -3044.11)
}

-- Işınlanma Fonksiyonu
module.teleportToPosition = function(position)
    local targetPos = position + Vector3.new(0, 3, 0)
    Services.rootPart.CFrame = CFrame.new(targetPos)
    wait(0.1)
    Services.humanoid.WalkSpeed = 0
    wait(0.1)
    Services.humanoid.WalkSpeed = 16
    print("Seçilen konuma ışınlandın!")
end

-- NPC Listesini Güncelleme Fonksiyonu
module.updateNPCList = function()
    for _, child in pairs(module.NPCList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local npcData = {}
    for _, obj in pairs(game.Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local npcRoot = obj:FindFirstChild("HumanoidRootPart")
            if npcRoot and obj.Humanoid.Health > 0 then
                if not npcData[obj.Name] then
                    npcData[obj.Name] = {}
                end
                table.insert(npcData[obj.Name], npcRoot.Position)
            end
        end
    end

    local npcCount = 0
    for npcName, positions in pairs(npcData) do
        npcCount = npcCount + 1
        local npcButton = Instance.new("TextButton")
        npcButton.Size = UDim2.new(1, -10, 0, 40)
        npcButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        npcButton.Text = npcName .. " (" .. #positions .. " adet)"
        npcButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        npcButton.TextSize = 16
        npcButton.Font = Enum.Font.Gotham
        npcButton.TextXAlignment = Enum.TextXAlignment.Left
        npcButton.Parent = module.NPCList

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = npcButton

        npcButton.MouseButton1Click:Connect(function()
            local randomPosition = positions[math.random(1, #positions)]
            module.teleportToPosition(randomPosition)
        end)
    end

    module.NPCList.CanvasSize = UDim2.new(0, 0, 0, npcCount * 45)
    if npcCount == 0 then
        local noNPC = Instance.new("TextLabel")
        noNPC.Size = UDim2.new(1, 0, 0, 40)
        noNPC.BackgroundTransparency = 1
        noNPC.Text = "NPC bulunamadı!"
        noNPC.TextColor3 = Color3.fromRGB(255, 100, 100)
        noNPC.TextSize = 16
        noNPC.Font = Enum.Font.Gotham
        noNPC.Parent = module.NPCList
    end
end

-- Bölge TP Listesini Güncelle
module.updateRegionList = function()
    for _, child in pairs(module.RegionList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local regionCount = 0
    for regionName, position in pairs(regions) do
        regionCount = regionCount + 1
        local regionButton = Instance.new("TextButton")
        regionButton.Size = UDim2.new(1, -10, 0, 40)
        regionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        regionButton.Text = regionName
        regionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        regionButton.TextSize = 16
        regionButton.Font = Enum.Font.Gotham
        regionButton.TextXAlignment = Enum.TextXAlignment.Left
        regionButton.Parent = module.RegionList

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = regionButton

        regionButton.MouseButton1Click:Connect(function()
            module.teleportToPosition(position)
            print(regionName .. " bölgesine ışınlandın!")
        end)
    end

    module.RegionList.CanvasSize = UDim2.new(0, 0, 0, regionCount * 45)
end

-- Toggle Fonksiyonları
module.toggleNPCFrame = function()
    module.NPCFrame.Visible = not module.NPCFrame.Visible
    module.RegionFrame.Visible = false
    if module.NPCFrame.Visible then
        module.updateNPCList()
    end
end

module.toggleRegionFrame = function()
    module.RegionFrame.Visible = not module.RegionFrame.Visible
    module.NPCFrame.Visible = false
    if module.RegionFrame.Visible then
        module.updateRegionList()
    end
end

return module