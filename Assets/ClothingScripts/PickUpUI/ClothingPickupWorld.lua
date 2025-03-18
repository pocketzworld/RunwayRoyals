--!Type(UI)


--!SerializeField
local easingCurve: AnimationCurve = nil
--!SerializeField
local type: string = ""

--!Bind
local icon: UIImage = nil

--!SerializeField 
local ItemID: string = ""

local audioManager = require("AudioManager")
local clothingController = require("ClothingController")

local tapHandler


local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

local startScale = self.transform.localScale

local bounceTween = Tween:new(
    -1,
    1,
   .3,
    false,
    false,
    function(t)
        --- Evaluate the easing curve
        return easingCurve:Evaluate(t)
    end,
    function(value, t)
        self.transform.localScale = startScale * value
    end,
    function()
        self.transform.localScale = startScale
    end
)

function self:ClientAwake()
    startScale = self.transform.localScale
    tapHandler = self.gameObject:GetComponent(TapHandler)
    tapHandler.Tapped:Connect(function()
        clothingController.AddExtraItem(ItemID)
        if bounceTween then bounceTween:stop() end
        bounceTween:start()
        audioManager.PlayClothSound()
    end)
end

function GetType()
    return type
end

function SetItem(itemID: string)
    ItemID = itemID
    icon:LoadItemPreview("avatar_item", itemID)
end