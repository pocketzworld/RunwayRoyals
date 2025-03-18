--!Type(Module)

--!SerializeField
local BGMusic: AudioShader = nil
--!SerializeField
local idleMusicURL : string = "https://streamssl.chilltrax.com:80/"


--!SerializeField
local EmojiParticle: AudioShader = nil
--!SerializeField
local EmojiButton: AudioShader = nil

--!SerializeField
local CameraFlashFinal: AudioShader = nil
--!SerializeField
local VictoryParticlesSounds: AudioShader = nil
--!SerializeField
local CameraFlashSmall: AudioShader = nil
--!SerializeField
local TeleportSound: AudioShader = nil
--!SerializeField
local AlertSound: AudioShader = nil
--!SerializeField
local TickSound: AudioShader = nil
--!SerializeField
local ShowtimeSound: AudioShader = nil
--!SerializeField
local HitReadySound: AudioShader = nil
--!SerializeField
local StartingSound: AudioShader = nil
--!SerializeField
local DressUpSound: AudioShader = nil
--!SerializeField
local NextModelSound: AudioShader = nil
--!SerializeField
local CashSound: AudioShader = nil
--!SerializeField
local clothSound: AudioShader = nil

local camsFlashing = false
local flashTime = 0.2

RoundMusicPlaying = BoolValue.new("RoundMusicPlaying", false)


function self:ClientAwake()
    Audio:PlayMusicURL(idleMusicURL, 0.1)
    RoundMusicPlaying.Changed:Connect(function(newVal)
        if newVal then
            Audio:StopMusic(true)
            Audio:PlayMusic(BGMusic, 1)
        else
            Audio:StopMusic(true)
            Audio:PlayMusicURL(idleMusicURL, 0.1)
        end
    end)

    Timer.Every(flashTime, function()
        if camsFlashing then
            if math.random(1,10) < 8 then return end
            Audio:PlayShader(CameraFlashSmall)
        end
    end)
end

function PlayCameraFlashFinal()
    Audio:PlayShader(CameraFlashFinal)
    Audio:PlayShader(VictoryParticlesSounds)
end

function PlayCameraFlashSmall()
    camsFlashing = true
end

function StopCameraFlashSmall()
    camsFlashing = false
end

function PlayTeleportSound()
    Audio:PlayShader(TeleportSound)
end

function PlayEmojiParticleSound()
    Audio:PlayShader(EmojiParticle)
end

function PlayEmojiButtonSound()
    Audio:PlayShader(EmojiButton)
end

function PlayAlertSound()
    Audio:PlayShader(AlertSound)
end

function PlayTickSound()
    Audio:PlayShader(TickSound)
end

function PlayShowtimeSound()
    Audio:PlayShader(ShowtimeSound)
end

function PlayHitReadySound()
    Audio:PlayShader(HitReadySound)
end

function PlayStartingSound()
    Audio:PlayShader(StartingSound)
end

function PlayDressUpSound()
    Audio:PlayShader(DressUpSound)
end

function PlayNextModelSound()
    Audio:PlayShader(NextModelSound)
end

function PlayCashSound()
    Audio:PlayShader(CashSound)
end

function PlayClothSound()
    Audio:PlayShader(clothSound)
end