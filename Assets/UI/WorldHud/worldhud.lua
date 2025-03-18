--!Type(UI)

--!Bind
local _ShopButton : VisualElement = nil
--!Bind
local _InventoryButton : VisualElement = nil

local gameManager = require("GameManager")
local playerTracker = require("PlayerTracker")
local UIManager = require("UIManager")


_ShopButton:RegisterPressCallback(function()
    UIManager.ButtonPressed("Shop")
end, true, true, true)

_InventoryButton:RegisterPressCallback(function()
    UIManager.ButtonPressed("Inventory")
end, true, true, true)


