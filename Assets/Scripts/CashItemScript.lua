--!Type(ClientAndServer)

--!SerializeField
local particle : ParticleSystem = nil

local cashSpawner = require("CashSpawner")
local audioManager = require("AudioManager")

function self:OnTriggerEnter(collider: Collider)
    if collider.gameObject:GetComponent(Character) then
        local player = collider.gameObject:GetComponent(Character).player
        if player ~= client.localPlayer then
            return
        end
        cashSpawner.collectRequest:FireServer(self.gameObject)
        particle:Play()
        self.gameObject:GetComponent(SphereCollider).enabled = false
        self.gameObject.transform:GetChild(0).gameObject:SetActive(false)
        audioManager.PlayCashSound()
    end
end

function self:ClientAwake()
    cashSpawner.resetCashEvent:Connect(function(cashpositions)
        self.gameObject:GetComponent(SphereCollider).enabled = true
        self.gameObject.transform:GetChild(0).gameObject:SetActive(true)

        for i, posData in ipairs(cashpositions) do
            if posData[1] == self.gameObject then
                self.gameObject.transform.position = posData[2]
            end
        end
    end)
end