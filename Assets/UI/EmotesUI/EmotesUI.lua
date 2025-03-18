--!Type(UI)

--!Bind
local root : UILuaView = nil
--!Bind
local emotes_container: UIScrollView = nil

local playerTracker = require("PlayerTracker")
local gameManger = require("GameManager")
local clothingManager = require("ClothingController")
local uiManager = require("UIManager")

-- Create a table for the Emoji Buttons
local emotes = 
{
    {id = "dance-macarena"   , owned = true  , button = nil},
    {id = "emote-kiss"       , owned = true  , button = nil},
    {id = "emote-pose5"      , owned = true  , button = nil},
    {id = "emoji-angry"      , owned = false , button = nil},
    {id = "emoji-crying"     , owned = false , button = nil},
    {id = "emote-snake"      , owned = false , button = nil},
    {id = "emote-splitsdrop" , owned = false , button = nil},
    {id = "dance-handsup"    , owned = false , button = nil},
    {id = "emoji-gagging"    , owned = false , button = nil},
    {id = "idle_layingdown2" , owned = false , button = nil},
    {id = "emote-punkguitar" , owned = false , button = nil},
    {id = "emote-robot"      , owned = false , button = nil},
    {id = "dance-breakdance" , owned = false , button = nil},
    {id = "emote-embarrassed", owned = false , button = nil},
    {id = "emote-shrink"     , owned = false , button = nil},
    {id = "emote-handstand"  , owned = false , button = nil}
}

-- Function To sort the emotes by owned first
function SortEmotesTable(emotes)
    table.sort(emotes, function(a, b)
        if a.owned == b.owned then
            return a.id < b.id
        end
        return a.owned
    end)
end

function CreateEmoteItemButton(itemID: string, owned : boolean, index : number)
    local _item = VisualElement.new()
    _item:AddToClassList("emote-button")

    local _image = UIImage.new()
    _image:LoadItemPreview("emote", itemID)

    _item:Add(_image)

    emotes_container:Add(_item)

    _item:RegisterPressCallback(function()
        if not owned then 
            uiManager.OpenShopPage("auras", itemID)
            return
        end
        clothingManager.PlayEmote(itemID)
    end)

    emotes[index].button = _item

    return _item
end

function UpdateEmotes(selectedItems: {})
    local inventory = playerTracker.GetPlayerInventory()
    -- For each item in inventory if item.id is in emotes then set emojis[item.id][2] to true
    for _, item in ipairs(inventory) do
        for each, emote in ipairs(emotes) do
            if item.id == emote.id then
                emote.owned = true
            end
        end
    end

    SortEmotesTable(emotes)

    emotes_container:Clear()
    for i, item in ipairs(selectedItems) do
        CreateEmoteItemButton(item.id, item.owned, i)
    end

    -- For each emote in emotes set the button to be visible if it is owned
    for _, emojidata in pairs(emotes) do
        emojidata.button:EnableInClassList("locked", not emojidata.owned)
    end
end

function Toggle(state)
    emotes_container:EnableInClassList("hidden", not state)
end

function self:Start()
    UpdateEmotes(emotes)
    Toggle(false)

    playerTracker.players[client.localPlayer].playerInventory.Changed:Connect(function()
        UpdateEmotes(emotes)
    end)
end