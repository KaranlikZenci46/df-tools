-- Services.lua
local module = {}

module.Players = game:GetService("Players")
module.ReplicatedStorage = game:GetService("ReplicatedStorage")
module.UserInputService = game:GetService("UserInputService")
module.Lighting = game:GetService("Lighting")
module.VirtualInputManager = game:GetService("VirtualInputManager")

module.player = module.Players.LocalPlayer

-- Karakterin hazır olmasını bekleyen fonksiyon
module.waitForCharacter = function()
    module.character = module.player.Character or module.player.CharacterAdded:Wait()
    module.rootPart = module.character:WaitForChild("HumanoidRootPart")
    module.humanoid = module.character:WaitForChild("Humanoid")
    module.backpack = module.player:WaitForChild("Backpack")
end

-- Karakter zaten varsa hemen çağır, yoksa olay dinleyicisi ekle
if module.player.Character then
    module.waitForCharacter()
else
    module.player.CharacterAdded:Connect(module.waitForCharacter)
end

-- Sahte sol tıklama simülasyonu (buraya taşındı)
module.fakeLeftClick = function()
    module.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)   -- Mouse down
    wait()  -- Kısa bir gecikme
    module.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)  -- Mouse up
end

return module