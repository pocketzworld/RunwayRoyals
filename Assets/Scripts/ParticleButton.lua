--!Type(ClientAndServer)

--!SerializeField
local partID : number = 1

local changeParticleRequest = Event.new("ChangeParticleRequest")

local playerTracker = require("PlayerTracker")

function self:ClientAwake()
    local tap = self.gameObject:GetComponent(TapHandler)

    tap.Tapped:Connect(function()
        changeParticleRequest:FireServer()
    end)
end

function self:ServerAwake()
    changeParticleRequest:Connect(function(player)
        playerTracker.players[player].playerParticle.value = partID
    end)
end