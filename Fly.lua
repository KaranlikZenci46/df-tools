-- Fly.lua
local Services = require(script.Parent.Services)
local GUI = require(script.Parent.GUI)

local module = {}

-- Fly için Açılır Frame (Sağda)
module.FlyFrame = Instance.new("Frame")
module.FlyFrame.Size = UDim2.new(0, 260, 0, 100)
module.FlyFrame.Position = UDim2.new(1, 10, 0, 0)
module.FlyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
module.FlyFrame.BorderSizePixel = 0
module.FlyFrame.Visible = false
module.FlyFrame.Parent = GUI.MainFrame

local FlyCornerFrame = Instance.new("UICorner")
FlyCornerFrame.CornerRadius = UDim.new(0, 8)
FlyCornerFrame.Parent = module.FlyFrame

module.FlyToggle = Instance.new("TextButton")
module.FlyToggle.Size = UDim2.new(0, 240, 0, 50)
module.FlyToggle.Position = UDim2.new(0.5, -120, 0, 25)
module.FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
module.FlyToggle.Text = "Fly: Kapalı"
module.FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
module.FlyToggle.TextSize = 18
module.FlyToggle.Font = Enum.Font.Gotham
module.FlyToggle.Parent = module.FlyFrame

local FlyToggleCorner = Instance.new("UICorner")
FlyToggleCorner.CornerRadius = UDim.new(0, 8)
FlyToggleCorner.Parent = module.FlyToggle

module.isFlying = false
module.flySpeed = 50
module.inputConnection = nil

module.enableFlying = function()
    if not module.isFlying then
        module.isFlying = true
        module.FlyToggle.Text = "Fly: Açık"
        module.FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        print("Uçma modu aktif!")

        Services.humanoid.PlatformStand = true
        Services.humanoid.WalkSpeed = 0

        module.inputConnection = Services.UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local vector = Vector3.new()
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    vector += Services.rootPart.CFrame.LookVector
                elseif Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    vector -= Services.rootPart.CFrame.LookVector
                end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    vector -= Services.rootPart.CFrame.RightVector
                elseif Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    vector += Services.rootPart.CFrame.RightVector
                end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    vector += Vector3.new(0, 1, 0)
                elseif Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    vector -= Vector3.new(0, 1, 0)
                end
                if vector.Magnitude > 0 then
                    Services.rootPart.CFrame = Services.rootPart.CFrame + vector.Unit * module.flySpeed
                end
            end
        end)
    end
end

module.disableFlying = function()
    if module.isFlying then
        module.isFlying = false
        module.FlyToggle.Text = "Fly: Kapalı"
        module.FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        print("Uçma modu devre dışı!")

        Services.humanoid.PlatformStand = false
        Services.humanoid.WalkSpeed = 16
        if module.inputConnection then
            module.inputConnection:Disconnect()
            module.inputConnection = nil
        end
    end
end

module.toggleFlying = function()
    if module.isFlying then
        module.disableFlying()
    else
        module.enableFlying()
    end
end

module.toggleFlyFrame = function()
    module.FlyFrame.Visible = not module.FlyFrame.Visible
end

return module