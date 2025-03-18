--!Type(Client)

static_emotes = {
    "emote-no",
    "emote-sad",
    "emote-yes",
    "emote-hello",
    "emote-wave",
    "emote-shy",
    "emote-tired",
    "emoji-angry",
    "emoji-thumbsup",
    "emoji-cursing",
    "emote-greedy",
    "emoji-flex",
    "emoji-gagging",
    "emoji-celebrate",
    "emote-bow",
    "emote-curtsy",
    "emote-hot",
    "emote-confused",
    "idle_singing",
    "emote-frog",
    "emote-cute",
    "emote-cutey"
}

stillPlaying = true

function self:Awake()
    local character = self.gameObject:GetComponent(Character)

    character.renderLayer = LayerMask.NameToLayer("Character");

    -- random height between .8 and 1.2
    local newScale = math.random(80, 120) / 100
    character.renderScale = Vector3.new(newScale,newScale,1)

    function playEmote()
        character:PlayEmote(static_emotes[math.random(1, #static_emotes)], true, function()
            if stillPlaying then playEmote() end
        end)
    end
    
    playEmote()

end