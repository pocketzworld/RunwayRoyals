--!Type(ClientAndServer)

--!SerializeField
local particleParent : Transform = nil

--!SerializeField
local heartsAura : ParticleSystem = nil
--!SerializeField
local butterflies : ParticleSystem = nil
--!SerializeField
local heartsBlack : ParticleSystem = nil
--!SerializeField
local heartsPastel : ParticleSystem = nil
--!SerializeField
local heartsPink : ParticleSystem = nil
--!SerializeField
local heartsPurple : ParticleSystem = nil
--!SerializeField
local heartsRed : ParticleSystem = nil
--!SerializeField
local heartsWhite : ParticleSystem = nil
--!SerializeField
local sparklesBlue : ParticleSystem = nil
--!SerializeField
local sparklesGreen : ParticleSystem = nil
--!SerializeField
local sparklesPink : ParticleSystem = nil
--!SerializeField
local sparklesPurple : ParticleSystem = nil
--!SerializeField
local sparklesWhite : ParticleSystem = nil
--!SerializeField
local sparklesYellow : ParticleSystem = nil
--!SerializeField
local bats : ParticleSystem = nil
--!SerializeField
local bowsPastel : ParticleSystem = nil
--!SerializeField
local cash : ParticleSystem = nil
--!SerializeField
local confettiPlayer : ParticleSystem = nil
--!SerializeField
local feathersBlack : ParticleSystem = nil
--!SerializeField
local feathersColorfull : ParticleSystem = nil
--!SerializeField
local snowflakes : ParticleSystem = nil
--!SerializeField
local starsGold : ParticleSystem = nil
--!SerializeField
local starsPastel : ParticleSystem = nil

local particles = {
    heartsAura,
    butterflies,
    heartsBlack,
    heartsPastel,
    heartsPink,
    heartsPurple,
    heartsRed,
    heartsWhite,
    sparklesBlue,
    sparklesGreen,
    sparklesPink,
    sparklesPurple,
    sparklesWhite,
    sparklesYellow,
    bats,
    bowsPastel,
    cash,
    confettiPlayer,
    feathersBlack,
    feathersColorfull,
    snowflakes,
    starsGold,
    starsPastel
}

local currentParticle = nil

function ToggleParticles(state)
    if currentParticle == nil then return end
    if state then
        currentParticle:Play()
    else
        currentParticle:Stop()
    end
end

function SpawnParticle(ID)
    if ID == 0 then if currentParticle ~= nil then Object.Destroy(currentParticle); currentParticle = nil end return end
    if currentParticle ~= nil then Object.Destroy(currentParticle.gameObject) end
    
    currentParticle = Object.Instantiate(particles[ID])
    currentParticle.transform.position = particleParent.position
    currentParticle.transform.parent = particleParent
end