--!Type(UI)

--!SerializeField
local ItemIcons: {Texture} = nil

--!Bind
local Slot_Content: VisualElement = nil

local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

local SpinTween = Tween:new(
    0,
    90,
    1,
    false,
    false,
    Easing.slotEaseInOut,
    function(value, t)
        Slot_Content.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.Percent(value)))
    end,
    function()
        Slot_Content.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.Percent(90)))
    end
)

function CreateItem(itemID: number)
    local _item = Image.new()
    _item:AddToClassList("Slot__Item")

    _item.image = ItemIcons[itemID]

    Slot_Content:Add(_item)
end

function Spin(prizeID: number)
    Slot_Content:Clear()

    for i=1, 10 do 
        if i == 1 then
            CreateItem(prizeID)
        else
            CreateItem(math.random(1, #ItemIcons))
        end
    end

    SpinTween:start()
end

Slot_Content:RegisterPressCallback(function()
    Spin(math.random(1, #ItemIcons))
end)