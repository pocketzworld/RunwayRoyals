--!Type(Module)

--!SerializeField
local Heart_Aura_Icon : Texture  = nil -- Item 1 image
--!SerializeField
local Butterfly_Aura_Icon : Texture  = nil -- Item 2 image
--!SerializeField
local Hearts_Black_Icon : Texture  = nil
--!SerializeField
local Hearts_Pastel_Icon : Texture  = nil
--!SerializeField
local Hearts_Pink_Icon : Texture  = nil
--!SerializeField
local Hearts_Purple_Icon : Texture  = nil
--!SerializeField
local Hearts_Red_Icon : Texture  = nil
--!SerializeField
local Hearts_White_Icon : Texture  = nil
--!SerializeField
local Sparkles_Blue_Icon : Texture  = nil
--!SerializeField
local Sparkles_Green_Icon : Texture  = nil
--!SerializeField
local Sparkles_Pink_Icon : Texture  = nil
--!SerializeField
local Sparkles_Purple_Icon : Texture  = nil
--!SerializeField
local Sparkles_White_Icon : Texture  = nil
--!SerializeField
local Sparkles_Yellow_Icon : Texture  = nil
--!SerializeField
local Bats_Icon : Texture  = nil
--!SerializeField
local Bows_Pastel_Icon : Texture  = nil
--!SerializeField
local Cash_Icon : Texture  = nil
--!SerializeField
local Confetti_Player_Icon : Texture  = nil
--!SerializeField
local Feathers_Black_Icon : Texture  = nil
--!SerializeField
local Feathers_Colorfull_Icon : Texture  = nil
--!SerializeField
local Snowflakes_Icon : Texture  = nil
--!SerializeField
local Stars_Gold_Icon : Texture  = nil
--!SerializeField
local Stars_Pastel_Icon : Texture  = nil

--!SerializeField
local Tomato_React_Icon : Texture  = nil
--!SerializeField
local Black_Heart_React_Icon : Texture  = nil
--!SerializeField
local White_Heart_React_Icon : Texture  = nil
--!SerializeField
local Sparkle_React_Icon : Texture  = nil
--!SerializeField
local Star_React_Icon : Texture  = nil
--!SerializeField
local Dollar_React_Icon : Texture  = nil
--!SerializeField
local Gold_React_Icon : Texture  = nil
--!SerializeField
local Imp_React_Icon : Texture  = nil
--!SerializeField
local Eyes_React_Icon : Texture  = nil
--!SerializeField
local Heart_Eyes_React_Icon : Texture  = nil

--!SerializeField
local Small_Package_Icon : Texture  = nil
--!SerializeField
local Medium_Package_Icon : Texture  = nil
--!SerializeField
local Large_Package_Icon : Texture  = nil

clothesShopData = TableValue.new("clothesShopData", {})

ItemMetas = 
{
    --------------- Auras ---------------
    ["Heart_Aura"] = 
    {
        name = "Hearts Aura", 
        description = "Cloud of Hearts around your Avatar on the Runway", 
        image = Heart_Aura_Icon, 
        itemType = "auraEffect", 
        effectId = 1,
        price = 9999
    }, 
    ["Butterfly_Aura"] = 
    {
        name = "Butterflies Aura", 
        description = "Cloud of Butterflies around your Avatar on the Runway", 
        image = Butterfly_Aura_Icon, 
        itemType = "auraEffect", 
        effectId = 2,
        price = 499
    },
    ["Hearts_Black"] = 
    {
        name = "Black Hearts Aura", 
        description = "Cloud of Black Hearts around your Avatar on the Runway", 
        image = Hearts_Black_Icon, 
        itemType = "auraEffect", 
        effectId = 3,
        price = 299
    },
    ["Hearts_Pastel"] = 
    {
        name = "Pastel Hearts Aura", 
        description = "Cloud of Pastel Hearts around your Avatar on the Runway", 
        image = Hearts_Pastel_Icon, 
        itemType = "auraEffect", 
        effectId = 4,
        price = 499
    },
    ["Hearts_Pink"] = 
    {
        name = "Pink Hearts Aura", 
        description = "Cloud of Pink Hearts around your Avatar on the Runway", 
        image = Hearts_Pink_Icon, 
        itemType = "auraEffect", 
        effectId = 5,
        price = 99
    },
    ["Hearts_Purple"] = 
    {
        name = "Purple Hearts Aura", 
        description = "Cloud of Purple Hearts around your Avatar on the Runway", 
        image = Hearts_Purple_Icon, 
        itemType = "auraEffect", 
        effectId = 6,
        price = 299
    },
    ["Hearts_Red"] = 
    {
        name = "Red Hearts Aura", 
        description = "Cloud of Red Hearts around your Avatar on the Runway", 
        image = Hearts_Red_Icon, 
        itemType = "auraEffect", 
        effectId = 7,
        price = 99
    },
    ["Hearts_White"] = 
    {
        name = "White Hearts Aura", 
        description = "Cloud of White Hearts around your Avatar on the Runway", 
        image = Hearts_White_Icon, 
        itemType = "auraEffect", 
        effectId = 8,
        price = 499
    },
    ["Sparkles_Blue"] = 
    {
        name = "Blue Sparkles Aura", 
        description = "Cloud of Blue Sparkles around your Avatar on the Runway", 
        image = Sparkles_Blue_Icon, 
        itemType = "auraEffect", 
        effectId = 9,
        price = 299
    },
    ["Sparkles_Green"] = 
    {
        name = "Green Sparkles Aura", 
        description = "Cloud of Green Sparkles around your Avatar on the Runway", 
        image = Sparkles_Green_Icon, 
        itemType = "auraEffect", 
        effectId = 10,
        price = 299
    },
    ["Sparkles_Pink"] = 
    {
        name = "Pink Sparkles Aura", 
        description = "Cloud of Pink Sparkles around your Avatar on the Runway", 
        image = Sparkles_Pink_Icon, 
        itemType = "auraEffect", 
        effectId = 11,
        price = 299
    },
    ["Sparkles_Purple"] = 
    {
        name = "Purple Sparkles Aura", 
        description = "Cloud of Purple Sparkles around your Avatar on the Runway", 
        image = Sparkles_Purple_Icon, 
        itemType = "auraEffect", 
        effectId = 12,
        price = 299
    },
    ["Sparkles_White"] = 
    {
        name = "White Sparkles Aura", 
        description = "Cloud of White Sparkles around your Avatar on the Runway", 
        image = Sparkles_White_Icon, 
        itemType = "auraEffect", 
        effectId = 13,
        price = 99
    },
    ["Sparkles_Yellow"] = 
    {
        name = "Yellow Sparkles Aura", 
        description = "Cloud of Yellow Sparkles around your Avatar on the Runway", 
        image = Sparkles_Yellow_Icon, 
        itemType = "auraEffect", 
        effectId = 14,
        price = 499
    },
    ["Bats"] = 
    {
        name = "Bats Aura", 
        description = "Cloud of Bats around your Avatar on the Runway", 
        image = Bats_Icon, 
        itemType = "auraEffect", 
        effectId = 15,
        price = 499
    },
    ["Bows_Pastel"] = 
    {
        name = "Pastel Bows Aura", 
        description = "Cloud of Pastel Bows around your Avatar on the Runway", 
        image = Bows_Pastel_Icon, 
        itemType = "auraEffect", 
        effectId = 16,
        price = 299
    },
    ["Cash"] = 
    {
        name = "Cash Aura", 
        description = "Cloud of Cash around your Avatar on the Runway", 
        image = Cash_Icon, 
        itemType = "auraEffect", 
        effectId = 17,
        price = 499
    },
    ["Confetti_Player"] = 
    {
        name = "Player Confetti Aura", 
        description = "Cloud of Confetti around your Avatar on the Runway", 
        image = Confetti_Player_Icon, 
        itemType = "auraEffect", 
        effectId = 18,
        price = 99
    },
    ["Feathers_Black"] = 
    {
        name = "Black Feathers Aura", 
        description = "Cloud of Black Feathers around your Avatar on the Runway", 
        image = Feathers_Black_Icon, 
        itemType = "auraEffect", 
        effectId = 19,
        price = 299
    },
    ["Feathers_Colorfull"] = 
    {
        name = "Colorful Feathers Aura", 
        description = "Cloud of Colorful Feathers around your Avatar on the Runway", 
        image = Feathers_Colorfull_Icon, 
        itemType = "auraEffect", 
        effectId = 20,
        price = 499
    },
    ["Snowflakes"] = 
    {
        name = "Snowflakes Aura", 
        description = "Cloud of Snowflakes around your Avatar on the Runway", 
        image = Snowflakes_Icon, 
        itemType = "auraEffect", 
        effectId = 21,
        price = 299
    },
    ["Stars_Gold"] = 
    {
        name = "Gold Stars Aura", 
        description = "Cloud of Gold Stars around your Avatar on the Runway", 
        image = Stars_Gold_Icon, 
        itemType = "auraEffect", 
        effectId = 22,
        price = 299
    },
    ["Stars_Pastel"] = 
    {
        name = "Pastel Stars Aura", 
        description = "Cloud of Pastel Stars around your Avatar on the Runway", 
        image = Stars_Pastel_Icon, 
        itemType = "auraEffect", 
        effectId = 23,
        price = 499
    },
    --------------- Reactions ---------------
    ["Tomato_React"] = 
    {
        name = "Tomato Reaction", 
        description = "Throw Tomatos at the Runway with the Reactions bar", 
        image = Tomato_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 4,
        ownedDefault = false,
        price = 99
    },
    ["Black_Heart_React"] = 
    {
        name = "Black Heart Reaction", 
        description = "Send Black Hearts with the Reactions bar", 
        image = Black_Heart_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 5,
        ownedDefault = false,
        price = 99
    },
    ["White_Heart_React"] = 
    {
        name = "White Heart Reaction", 
        description = "Send White Hearts with the Reactions bar", 
        image = White_Heart_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 6,
        ownedDefault = false,
        price = 99
    },
    ["Sparkle_React"] = 
    {
        name = "Sparkle Reaction", 
        description = "Send Sparkles with the Reactions bar", 
        image = Sparkle_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 7,
        ownedDefault = false,
        price = 99
    },
    ["Star_React"] = 
    {
        name = "Star Reaction", 
        description = "Send Stars with the Reactions bar", 
        image = Star_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 8,
        ownedDefault = false,
        price = 99
    },
    ["Dollar_React"] = 
    {
        name = "Dollar Reaction", 
        description = "Send Dollar Bills with the Reactions bar", 
        image = Dollar_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 9,
        ownedDefault = false,
        price = 99
    },
    ["Gold_React"] = 
    {
        name = "Gold Reaction", 
        description = "Send Gold Emojis with the Reactions bar", 
        image = Gold_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 10,
        ownedDefault = false,
        price = 99
    },
    ["Imp_React"] = 
    {
        name = "Imp Reaction", 
        description = "Send Imps with the Reactions bar", 
        image = Imp_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 11,
        ownedDefault = false,
        price = 99
    },
    ["Eyes_React"] = 
    {
        name = "Eyes Reaction", 
        description = "Send Eyes with the Reactions bar", 
        image = Eyes_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 12,
        ownedDefault = false,
        price = 99
    },
    ["Heart_Eyes_React"] = 
    {
        name = "Heart Eyes Reaction", 
        description = "Send Heart Eyes with the Reactions bar", 
        image = Heart_Eyes_React_Icon, 
        itemType = "reactionEffect", 
        emojiValue = 13,
        ownedDefault = false,
        price = 99
    },

    -------------- Emotes ---------------
    ["dance-macarena"] =
    {
        name = "Macarena Dance", 
        description = "Perform the iconic Macarena dance!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 99
    },

    ["emote-kiss"] =
    {
        name = "Blow a Kiss", 
        description = "Send a lovely kiss to someone!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 50
    },

    ["emote-pose5"] =
    {
        name = "Cool Pose", 
        description = "Strike a confident pose!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 25
    },

    ["emoji-angry"] =
    {
        name = "Angry Face", 
        description = "Show your frustration!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 10
    },

    ["emoji-crying"] =
    {
        name = "Crying", 
        description = "Tears of sadness!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 50
    },

    ["emote-snake"] =
    {
        name = "Snake Move", 
        description = "Move like a snake!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 89
    },

    ["emote-splitsdrop"] =
    {
        name = "Splits Drop", 
        description = "Drop into the splits!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 150
    },

    ["dance-handsup"] =
    {
        name = "Hands Up Dance", 
        description = "Raise your hands and dance!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 99
    },

    ["emoji-gagging"] =
    {
        name = "Gagging", 
        description = "Express extreme disgust!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 49
    },

    ["idle_layingdown2"] =
    {
        name = "Lay Down", 
        description = "Relax and lay down!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 49
    },

    ["emote-punkguitar"] =
    {
        name = "Punk Guitar", 
        description = "Shred on an air guitar!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 99
    },

    ["emote-robot"] =
    {
        name = "Robot Dance", 
        description = "Move like a robot!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 75
    },

    ["dance-breakdance"] =
    {
        name = "Breakdance", 
        description = "Show off your breakdance moves!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 150
    },

    ["emote-embarrassed"] =
    {
        name = "Embarrassed", 
        description = "Express your embarrassment!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 35
    },

    ["emote-shrink"] =
    {
        name = "Shrink Down", 
        description = "Make yourself small and shy!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 250
    },

    ["emote-handstand"] =
    {
        name = "Handstand", 
        description = "Show off your balance with a handstand!", 
        image = "fetch", 
        itemType = "emote", 
        ownedDefault = false,
        price = 99
    },


    --------------- Deals ---------------
    ["runway_classic_token"] = 
    {
        name = "100 Runway Cash",
        description = "(100 Cash for 100 Gold): Works perfectly for purchasing one cheap item, aligning well with 99 Cash items!",
        image = Small_Package_Icon,
        itemType = "deal",
        effectId = nil,
        price = 100,
    },
    ["runway_classic_token_sevenfifty"] = 
    {
        name = "750 Runway Cash",
        description = "(750 Cash for 700 Gold): Offers flexibility to purchase multiple items across all pricing categories, providing good value!",
        image = Medium_Package_Icon,
        itemType = "deal",
        effectId = nil,
        price = 700,
    },
    ["runway_classic_token_seventeenhundred"] = 
    {
        name = "1700 Runway Cash",
        description = "(1700 Cash for 1400 Gold): Great value for buying higher quantities and more expensive items!",
        image = Large_Package_Icon,
        itemType = "deal",
        effectId = nil,
        price = 1400,
    }
}

function GetClothingStoreDataFromStorage()
    Storage.GetValue("ClothesShopData", function(data)
        local newData = data
        if newData == nil then 
            Storage.SetValue("ClothesShopData", {{id = "item-id", cost = 100 , displayName = "DisplayName"}})
            newData = {}
        end
        clothesShopData.value = newData
    end)
end

function self:ServerStart()
    GetClothingStoreDataFromStorage()
end