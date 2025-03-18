--!Type(Client)

--!SerializeField 
local testID: string = "shirt-n_hrideasfundedudc2024dragonkeepernightlifeshirt"

local clothingController = require("ClothingController")

function self:ClientAwake()
    local tapHandler = self.gameObject:GetComponent(TapHandler)
    tapHandler.Tapped:Connect(function()
        print("Picked UP")
        clothingController.AddExtraItem(testID)
    end)
end