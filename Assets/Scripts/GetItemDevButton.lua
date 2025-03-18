--!Type(ClientAndServer)

--!SerializeField
local GiveItem : boolean = true
--!SerializeField
local Item : string = ""

local metas = require("InventoryMetaData")
local inventoryManager = require("PlayerInventoryManager")


function self:ClientAwake()
    local tap = self.gameObject:GetComponent(TapHandler)

    tap.Tapped:Connect(function()
        if GiveItem then
            inventoryManager.GiveItem(Item, 1)
            print(Item)
        else
            inventoryManager.TakeItem(Item, 1)
        end
    end)
end