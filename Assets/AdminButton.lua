--!Type(ClientAndServer)

local reFetchRequest = Event.new("ReFetchRequest")

local clothingCollections = require("ClothingCollections")

function self:ClientStart()
    if client.localPlayer.name ~= "NautisShadrick" then
        self.gameObject:SetActive(false)
    end
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
        reFetchRequest:FireServer()
    end)
end

function self:ServerStart()
    reFetchRequest:Connect(function(player)
        if player.name ~= "NautisShadrick" then
            return
        end
        clothingCollections.FetchClothingSetFromStorage()
    end)
end