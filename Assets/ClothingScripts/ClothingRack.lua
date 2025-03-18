--!Type(Client)

--!SerializeField
local title: string = ""
--!SerializeField 
local clothingCollection: string = ""

local clothingController = require("ClothingController")
local clothingCollections = require("ClothingCollections")

local uiManager = require("UIManager")

function self:ClientAwake()
    local tapHandler = self.gameObject:GetComponent(TapHandler)
    tapHandler.Tapped:Connect(function()
        clothingController.ShowCloset(clothingCollections.ReturnClothingCollection(clothingCollection), title)
    end)
    
    --function self:OnTriggerEnter(collider: Collider)
    --    print("TRIGGER ENTER")
    --    if collider.gameObject == client.localPlayer.character.gameObject then
    --        print("TRIGGER ENTERED BY PLAYER")
    --        uiManager.CreateInteractButton(function()
    --            clothingController.ShowCloset(clothingCollections.ReturnClothingCollection(clothingCollection), title)
    --        end,title)
    --    end
    --end

    --function self:OnTriggerExit(collider: Collider)
    --    print("TRIGGER EXIT")
    --    if collider.gameObject == client.localPlayer.character.gameObject then
    --        print("TRIGGER EXITED BY PLAYER")
    --        uiManager.DestroyInteractButton()
    --    end
    --end

end