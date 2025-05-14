-- AutoFarm.lua
local Services = require(script.Parent.Services)
local GUI = require(script.Parent.GUI)

local module = {}

-- Auto Farm için Açılır Frame (Sağda)
module.AutoFarmFrame = Instance.new("Frame")
module.AutoFarmFrame.Size = UDim2.new(0, 260, 0, 150)
module.AutoFarmFrame.Position = UDim2.new(1, 10, 0, 0)
module.AutoFarmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.AutoFarmFrame.BorderSizePixel = 0
module.AutoFarmFrame.Visible = false
module.AutoFarmFrame.Parent = GUI.MainFrame

local AutoFarmCornerFrame = Instance.new("UICorner")
AutoFarmCornerFrame.CornerRadius = UDim.new(0, 8)
AutoFarmCornerFrame.Parent = module.AutoFarmFrame

module.AutoRaidButton = Instance.new("TextButton")
module.AutoRaidButton.Size = UDim2.new(0, 240, 0, 50)
module.AutoRaidButton.Position = UDim2.new(0.5, -120, 0, 25)
module.AutoRaidButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.AutoRaidButton.Text = "Auto Raid: Kapalı"
module.AutoRaidButton.TextColor3 = Color3.fromRGB(255, 255, 255)
module.AutoRaidButton.TextSize = 18
module.AutoRaidButton.Font = Enum.Font.Gotham
module.AutoRaidButton.Parent = module.AutoFarmFrame

local AutoRaidCorner = Instance.new("UICorner")
AutoRaidCorner.CornerRadius = UDim.new(0, 8)
AutoRaidCorner.Parent = module.AutoRaidButton

module.AutoNearestButton = Instance.new("TextButton")
module.AutoNearestButton.Size = UDim2.new(0, 240, 0, 50)
module.AutoNearestButton.Position = UDim2.new(0.5, -120, 0, 80)
module.AutoNearestButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.AutoNearestButton.Text = "Auto Nearest: Kapalı"
module.AutoNearestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
module.AutoNearestButton.TextSize = 18
module.AutoNearestButton.Font = Enum.Font.Gotham
module.AutoNearestButton.Parent = module.AutoFarmFrame

local AutoNearestCorner = Instance.new("UICorner")
AutoNearestCorner.CornerRadius = UDim.new(0, 8)
AutoNearestCorner.Parent = module.AutoNearestButton

module.autoRaidActive = false
module.autoNearestActive = false

module.startAutoRaid = function()
    if not module.autoRaidActive then
        module.autoRaidActive = true
        module.AutoRaidButton.Text = "Auto Raid: Açık"
        module.AutoRaidButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        print("Auto Raid aktif!")

        spawn(function()
            while module.autoRaidActive do
                wait(0.1)
                local closestEnemy, closestDistance = nil, math.huge
                for _, enemy in pairs(game.Workspace:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                        if enemy.Humanoid.Health > 0 then
                            local distance = (Services.rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestEnemy = enemy
                                closestDistance = distance
                            end
                        end
                    end
                end

                if closestEnemy then
                    Services.humanoid.WalkSpeed = 50
                    Services.rootPart.CFrame = CFrame.new(Services.rootPart.Position, closestEnemy.HumanoidRootPart.Position)
                    Services.humanoid:MoveTo(closestEnemy.HumanoidRootPart.Position)
                    wait(2)
                    Services.humanoid.WalkSpeed = 16
                end
            end
        end)
    end
end

module.stopAutoRaid = function()
    if module.autoRaidActive then
        module.autoRaidActive = false
        Services.humanoid:MoveTo(Services.rootPart.Position)
        Services.humanoid.WalkSpeed = 16
        module.AutoRaidButton.Text = "Auto Raid: Kapalı"
        module.AutoRaidButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        print("Auto Raid devre dışı!")
    end
end

module.startAutoNearest = function()
    if not module.autoNearestActive then
        module.autoNearestActive = true
        module.AutoNearestButton.Text = "Auto Nearest: Açık"
        module.AutoNearestButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        print("Auto Nearest aktif!")

        spawn(function()
            while module.autoNearestActive do
                wait(0.1)
                local closestEnemy, closestDistance = nil, math.huge
                for _, enemy in pairs(game.Workspace:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                        if enemy.Humanoid.Health > 0 then
                            local distance = (Services.rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestEnemy = enemy
                                closestDistance = distance
                            end
                        end
                    end
                end

                if closestEnemy then
                    Services.humanoid.WalkSpeed = 50
                    Services.rootPart.CFrame = CFrame.new(Services.rootPart.Position, closestEnemy.HumanoidRootPart.Position)
                    Services.humanoid:MoveTo(closestEnemy.HumanoidRootPart.Position)
                    wait(2)
                    Services.humanoid.WalkSpeed = 16
                end
            end
        end)
    end
end

module.stopAutoNearest = function()
    if module.autoNearestActive then
        module.autoNearestActive = false
        Services.humanoid:MoveTo(Services.rootPart.Position)
        Services.humanoid.WalkSpeed = 16
        module.AutoNearestButton.Text = "Auto Nearest: Kapalı"
        module.AutoNearestButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        print("Auto Nearest devre dışı!")
    end
end

module.toggleAutoFarmFrame = function()
    module.AutoFarmFrame.Visible = not module.AutoFarmFrame.Visible
end

return module