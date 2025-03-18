--!Type(UI)

--!SerializeField
local bounceCurve: AnimationCurve = nil

--!SerializeField
local emptyIcon : Texture = nil

--!SerializeField
local RatingOne : Texture = nil
--!SerializeField
local RatingTwo : Texture = nil
--!SerializeField
local RatingThree : Texture = nil
--!SerializeField
local RatingFour : Texture = nil
--!SerializeField
local RatingFive : Texture = nil

--!SerializeField
local heartParts : ParticleSystem = nil
--!SerializeField
local fireParts : ParticleSystem = nil
--!SerializeField
local clapParts : ParticleSystem = nil
--!SerializeField
local tomatoParts : ParticleSystem = nil
--!SerializeField
local BlackHeartParts : ParticleSystem = nil
--!SerializeField
local WhiteHeartParts : ParticleSystem = nil
--!SerializeField
local SparkleParts : ParticleSystem = nil
--!SerializeField
local StarParts : ParticleSystem = nil
--!SerializeField
local DollarParts : ParticleSystem = nil
--!SerializeField
local GoldParts : ParticleSystem = nil
--!SerializeField
local ImpParts : ParticleSystem = nil
--!SerializeField
local EyeParts : ParticleSystem = nil
--!SerializeField
local HeartEyeParts : ParticleSystem = nil

--!SerializeField
local heartParts2 : ParticleSystem = nil
--!SerializeField
local fireParts2 : ParticleSystem = nil
--!SerializeField
local clapParts2 : ParticleSystem = nil
--!SerializeField
local tomatoParts2 : ParticleSystem = nil
--!SerializeField
local BlackHeartParts2 : ParticleSystem = nil
--!SerializeField
local WhiteHeartParts2 : ParticleSystem = nil
--!SerializeField
local SparkleParts2 : ParticleSystem = nil
--!SerializeField
local StarParts2 : ParticleSystem = nil
--!SerializeField
local DollarParts2 : ParticleSystem = nil
--!SerializeField
local GoldParts2 : ParticleSystem = nil
--!SerializeField
local ImpParts2 : ParticleSystem = nil
--!SerializeField
local EyeParts2 : ParticleSystem = nil
--!SerializeField
local HeartEyeParts2 : ParticleSystem = nil


--!Bind
local EmojiElement : UIScrollView = nil
--!Bind
local Emoji_One : UIButton = nil
--!Bind
local Emoji_Two : UIButton = nil
--!Bind
local Emoji_Three : UIButton = nil
--!Bind


--!Bind
local VotingElement : VisualElement = nil
--!Bind
local vote_cta : VisualElement = nil
--!Bind
local One_Star : UIButton = nil
--!Bind
local Two_Stars : UIButton = nil
--!Bind
local Three_Stars : UIButton = nil
--!Bind
local Four_Stars : UIButton = nil
--!Bind
local Five_Stars : UIButton = nil

--!Bind
local oneImage : UIImage = nil
--!Bind
local twoImage : UIImage = nil
--!Bind
local threeImage : UIImage = nil
--!Bind
local fourImage : UIImage = nil
--!Bind
local fiveImage : UIImage = nil

-- Create a table for the buttons
local buttons = {One_Star, Two_Stars, Three_Stars, Four_Stars, Five_Stars}

-- Create a table for the images
local images = {oneImage, twoImage, threeImage, fourImage, fiveImage}

local gameManager = require("GameManager")
local playerTracker = require("PlayerTracker")
local uiManager = require("UIManager")
local audioManager = require("AudioManager")
local InventoryMetaData = require("InventoryMetaData")

local itemMetas = InventoryMetaData.ItemMetas

local currentRating = 1

local secondaryEmojis =
{
    "Tomato_React",
    "Heart_Eyes_React",
    "Sparkle_React",
    "Black_Heart_React",
    "White_Heart_React",
    "Star_React",
    "Eyes_React",
    "Imp_React"
}

local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

local bounceUpTween = Tween:new(
    0,
    -30,
   .5,
    false,
    false,
    function(t) return bounceCurve:Evaluate(t) end,
    function(value, t)
        vote_cta.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(value)))
    end,
    function()
        vote_cta.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(0)))
    end
)

function SetStarsVisible(state)
    VotingElement:EnableInClassList("hide", not state)
    if state then
        Timer.Every(2, function() bounceUpTween:start() end)
    end
end
function SetEmojisVisible(state)
    UpdateOwnedEmojis()
    PopulateEmojiBar()
    EmojiElement:EnableInClassList("hide", not state)
end

-- Function to get the texture based on the rating
local function GetRatingTexture(rating)
    if rating == 1 then
        return RatingOne
    elseif rating == 2 then
        return RatingTwo
    elseif rating == 3 then
        return RatingThree
    elseif rating == 4 then
        return RatingFour
    elseif rating == 5 then
        return RatingFive
    else
        return nil
    end
end

function UpdateImages()
    -- Set all images based on the current rating
    for i, img in ipairs(images) do
        if i <= currentRating then
            img.image = GetRatingTexture(i)
        else
            img.image = emptyIcon
        end

        -- Remove the active class from all images
        img:RemoveFromClassList("active")
    end

    -- Add the active class to the current rating
    if currentRating > 0 and currentRating <= #images then
        images[currentRating]:AddToClassList("active")
    end
end

function NextRoundUI(isMyTurn)
    SetStarsVisible(not isMyTurn)
    SetEmojisVisible(not isMyTurn)
    currentRating = 1
    gameManager.SubmitVote(1) -- Vote at least 1 star
    UpdateImages()
end

function HideStars(state)
    if state == nil then state = true end
    SetStarsVisible(not state)
end

function HideEmojis(state)
    if state == nil then state = true end
    SetEmojisVisible(not state)
end

function Vote(index)
    currentRating = index
    UpdateImages()

    -- Submit the vote to the player tracker
    gameManager.SubmitVote(currentRating)
    vote_cta:EnableInClassList("hidden", true)
end

-- Register a callback for each button
for index, button in ipairs(buttons) do
    button:RegisterPressCallback(function()
        Vote(index)
    end, true, true, true)
end

function PlayParticle(particleID, count)
    audioManager.PlayEmojiParticleSound()
    local particleMapping = {
        [1] = {heartParts, heartParts2},
        [2] = {fireParts, fireParts2},
        [3] = {clapParts, clapParts2},
        [4] = {tomatoParts, tomatoParts2},
        [5] = {BlackHeartParts, BlackHeartParts2},
        [6] = {WhiteHeartParts, WhiteHeartParts2},
        [7] = {SparkleParts, SparkleParts2},
        [8] = {StarParts, StarParts2},
        [9] = {DollarParts, DollarParts2},
        [10] = {GoldParts, GoldParts2},
        [11] = {ImpParts, ImpParts2},
        [12] = {EyeParts, EyeParts2},
        [13] = {HeartEyeParts, HeartEyeParts2},
    }

    local parts = particleMapping[particleID]
    if parts then
        parts[1]:Emit(count) -- Emit for stage emoji
        parts[2]:Emit(count) -- Emit for podium emoji
    end
end

--[[
    local HeartCounter = 0
    local FireCounter = 0
    local ClapCounter = 0
    local TomatoCounter = 0
    local BlackHeartCounter = 0
    local WhiteHeartCounter = 0
    local SparkleCounter = 0
    local DollarCounter = 0
    local GoldStarCounter = 0
    local StarCounter = 0
    local ImpCounter = 0
    local EyesCounter = 0
    local HeartEyeCounter = 0
]]

-- Create a table for the Emoji Buttons
-- [Inventory ID] = {Button, Owned}
local emojiData = {
    ["Hearts_React"] = {button = Emoji_One, owned = true, emojiValue = 1},
    ["Fire_React"] = {button = Emoji_Two, owned = true, emojiValue = 2},
    ["Clap_React"] = {button = Emoji_Three, owned = true, emojiValue = 3}
}

function UpdateOwnedEmojis()
    local inventory = playerTracker.GetPlayerInventory()
    -- For each item in inventory if item.id is in emojis then set emojis[item.id].Owned to true
    for _, item in ipairs(inventory) do
        if emojiData[item.id] then
            emojiData[item.id].owned = true
        end
    end

    -- For each emoji in emojis set the button to be visible if it is owned
    for _, emoji in pairs(emojiData) do
        emoji.button:EnableInClassList("locked", not emoji.owned)
    end
end

function CreateEmojiItem(id : string, emojiValue : number, ownedDefault : boolean, img : Texture)
    local _emojiButton = UIButton.new()
    _emojiButton:AddToClassList("react-button")

    local _emojiImage = Image.new()
    _emojiImage.image = img

    _emojiButton:Add(_emojiImage)

    EmojiElement:Add(_emojiButton)

    emojiData[id] = {button = _emojiButton, owned = ownedDefault, emojiValue = 0}
    return _emojiButton
end

function PopulateEmojiBar() --- {id, emojiValue, ownedDefault, image}
    -- Don't clear the emoji that has the class "default"
    local defaultEmojis = EmojiElement:Children()
    -- Clear all emojis except the default ones
    for _, emoji in ipairs(defaultEmojis) do
        if not emoji:ClassListContains("default") then
            emoji:RemoveFromHierarchy()
        end
    end

    local emojis = secondaryEmojis
    -- Temporary table to hold sorted emojis
    local sortedEmojis = {}

    -- Separate owned and unowned emojis
    for _, emoji in ipairs(emojis) do
        if itemMetas[emoji] then
            table.insert(sortedEmojis, {
                emoji = emoji,
                owned = emojiData[emoji] and emojiData[emoji].owned or itemMetas[emoji].ownedDefault
            })
        else
            print("[Error] No Meta Data set for: " .. emoji)
        end
    end

    -- Sort emojis so that owned ones come first
    table.sort(sortedEmojis, function(a, b) return a.owned and not b.owned end)

    -- Create emoji buttons based on the sorted list
    for _, entry in ipairs(sortedEmojis) do
        local emoji = entry.emoji
        local emojiVal = itemMetas[emoji].emojiValue
        local emojiImage = itemMetas[emoji].image
        local ownedDefault = itemMetas[emoji].ownedDefault

        local emojiButton = CreateEmojiItem(emoji, emojiVal, ownedDefault, emojiImage)

        emojiButton:RegisterPressCallback(function()
            if not emojiData[emoji].owned then
                -- Popup to purchase the emoji
                uiManager.OpenShopPage("reactions", emoji)
                return -- Unowned, do nothing
            end
            audioManager.PlayEmojiButtonSound()
            uiManager.AddEmoji(emojiVal)
        end, true, true, true)
    end

    UpdateOwnedEmojis()
end

-- Three Default Reactions
Emoji_One:RegisterPressCallback(function()
    audioManager.PlayEmojiButtonSound()
    uiManager.AddEmoji(1)
end, true, true, true)

Emoji_Two:RegisterPressCallback(function()
    audioManager.PlayEmojiButtonSound()
    uiManager.AddEmoji(2)
end, true, true, true)

Emoji_Three:RegisterPressCallback(function()
    audioManager.PlayEmojiButtonSound()
    uiManager.AddEmoji(3)
end, true, true, true)

function self:Start()
    SetStarsVisible(false)
    SetEmojisVisible(false)
    UpdateImages()

    PopulateEmojiBar()
    UpdateOwnedEmojis()
    PopulateEmojiBar()
end