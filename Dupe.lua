-- Dupe.lua
local Services = require(script.Parent.Services)
local GUI = require(script.Parent.GUI)

local module = {}

-- Dupe için Açılır Frame (Sağda)
module.DupeFrame = Instance.new("Frame")
module.DupeFrame.Size = UDim2.new(0, 260, 0, 150)
module.DupeFrame.Position = UDim2.new(1, 10, 0, 0)
module.DupeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.DupeFrame.BorderSizePixel = 0
module.DupeFrame.Visible = false
module.DupeFrame.Parent = GUI.MainFrame

local DupeCornerFrame = Instance.new("UICorner")
DupeCornerFrame.CornerRadius = UDim.new(0, 8)
DupeCornerFrame.Parent = module.DupeFrame

module.ItemNameBox = Instance.new("TextBox")
module.ItemNameBox.Size = UDim2.new(0, 240, 0, 40)
module.ItemNameBox.Position = UDim2.new(0.5, -120, 0, 20)
module.ItemNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.ItemNameBox.Text = "Item Adı Girin"
module.ItemNameBox.TextColor3 = Color3.fromRGB(150, 150, 150)
module.ItemNameBox.TextSize = 16
module.ItemNameBox.Font = Enum.Font.Gotham
module.ItemNameBox.ClearTextOnFocus = true
module.ItemNameBox.Parent = module.DupeFrame

local ItemBoxCorner = Instance.new("UICorner")
ItemBoxCorner.CornerRadius = UDim.new(0, 8)
ItemBoxCorner.Parent = module.ItemNameBox

module.DupeButton = Instance.new("TextButton")
module.DupeButton.Size = UDim2.new(0, 240, 0, 50)
module.DupeButton.Position = UDim2.new(0.5, -120, 0, 70)
module.DupeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.DupeButton.Text = "Dupe Et"
module.DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
module.DupeButton.TextSize = 18
module.DupeButton.Font = Enum.Font.Gotham
module.DupeButton.Parent = module.DupeFrame

local DupeButtonCorner = Instance.new("UICorner")
DupeButtonCorner.CornerRadius = UDim.new(0, 8)
DupeButtonCorner.Parent = module.DupeButton

module.dupeItem = function(itemName)
    for i = 1, 5 do  -- 5 kez dupe
        Services.fakeLeftClick()
        wait(0.1)
        Services.fakeLeftClick()
        wait(0.1)
        Services.fakeLeftClick()
        wait(0.1)
        Services.fakeLeftClick()
        wait(0.1)
        Services.fakeLeftClick()
        wait(0.1)
        
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(itemName))
        wait(0.1)
    end
    print(itemName .. " adlı eşya 5 kez dupe'landı!")
end

module.toggleDupeFrame = function()
    module.DupeFrame.Visible = not module.DupeFrame.Visible
end

return module