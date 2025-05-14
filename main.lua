-- Main.lua
local Services = require(script.Services)
local GUI = require(script.GUI)
local Teleport = require(script.Teleport)
local Godmode = require(script.Parent.Godmode)
local Dupe = require(script.Parent.Dupe)
local Fog = require(script.Parent.Fog)
local ESP = require(script.Parent.ESP)
local AutoFarm = require(script.Parent.AutoFarm)
local Fly = require(script.Parent.Fly)

-- GUI'yi başlat
GUI.ScreenGui.Parent = Services.player:WaitForChild("PlayerGui")

-- Teleport modülünü başlat (NPC listesini yükle)
Teleport.updateNPCList()

-- GUI'deki kapatma butonuna basıldığında yapılacaklar
GUI.CloseButton.MouseButton1Click:Connect(function()
    Godmode.disableGodmode()
    Fog.disableFogClear()
    ESP.disableESP()
    AutoFarm.stopAutoRaid()
    AutoFarm.stopAutoNearest()
    Fly.disableFlying()

    GUI.ScreenGui:Destroy()
    print("GUI kapatıldı!")
end)

-- Karakter olaylarını dinle (Godmode ve Fly için)
Services.player.CharacterAdded:Connect(function(newChar)
    Services.waitForCharacter() -- Karakterin hazır olmasını bekle
    if Godmode.godmodeEnabled then
        Godmode.enableGodmode()
    end
    if Fly.isFlying then
        Fly.enableFlying()
    end
end)

-- Her 5 saniyede bir NPC listesini yenile (örnek)
spawn(function()
    while wait(5) do
        if GUI.ScreenGui.Parent and Teleport.NPCFrame.Visible then
            Teleport.updateNPCList()
        end
    end
end)