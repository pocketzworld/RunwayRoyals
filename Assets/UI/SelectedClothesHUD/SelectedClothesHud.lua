--!Type(UI)

--!Bind
local clothes_container: UIScrollView = nil

local clothingController = require("ClothingController")
local gameManger = require("GameManager")
local audioManager = require("AudioManager")

function CreateClothingItemButton(itemID: string)
    local _item = VisualElement.new()
    _item:AddToClassList("clothing-button")

    local _image = UIImage.new()
    _image:LoadItemPreview("avatar_item", itemID)

    _item:Add(_image)

    clothes_container:Add(_item)

    _item:RegisterPressCallback(function()
        clothingController.RemoveExtraItem(itemID)
        audioManager.PlayClothSound()
    end)

    return _item
end

function UpdateSelectedItems(selectedItems: {})
    clothes_container:Clear()
    for _, item in ipairs(selectedItems) do
        if item.id == "body-flesh" then continue end
        CreateClothingItemButton(item.id)
    end
end

function SyncToState(newState : number)
    if newState == 1 then
        clothes_container:EnableInClassList("hidden", false)
        clothes_container:Clear()
    end
end

function self:Start()
    SyncToState(gameManger.gameState.value)
    gameManger.gameState.Changed:Connect(function(newState)
        SyncToState(newState)
    end)
    gameManger.FirstRoundEvent:Connect(function()
        clothes_container:EnableInClassList("hidden", true)
    end)
end