--!Type(UI)

--!Bind
local _InventoryContent : UIScrollView = nil -- Important do not remove

--!Bind
local _itemInfo : VisualElement = nil -- Important do not remove
--!Bind
local _ItemInfoContent : VisualElement = nil -- Important do not remove

local clothingController = require("ClothingController")

local inventoryManager = require("PlayerInventoryManager")

local UIManager = require("UIManager")
local playerTracker = require("PlayerTracker")
local inventoryMetaData = require("InventoryMetaData")
local ItemMetas = inventoryMetaData.ItemMetas

local inventoryItems = {}

--[[
Changable variables
modify/change/add/remove variables as needed
]]

--!Bind
local _closeButton : VisualElement = nil -- Close button for the inventory UI
--!Bind
local _closeInfoButton : VisualElement = nil -- Close button for the item info UI

local currentItems = {}

-- Register a callback to close the inventory UI
_closeButton:RegisterPressCallback(function()
  --self.gameObject:SetActive(false)
  UIManager.ButtonPressed("Close")
end, true, true, true)

-- Function to create an item in the inventory
function CreateItem(itemID)
  local item = VisualElement.new()
  item:AddToClassList("inventory__item")

  local _itemIcon = VisualElement.new()
  _itemIcon:AddToClassList("inventory__item-icon")

  local _itemImage = UIImage.new()
  _itemImage:AddToClassList("inventory__item__icon__image")
  _itemImage:LoadItemPreview("avatar_item", itemID)
  _itemIcon:Add(_itemImage)

  item:Add(_itemIcon)

  _InventoryContent:Add(item)
  table.insert(inventoryItems, item)
  return item
end

-- Register a callback to close the item info UI
_closeInfoButton:RegisterPressCallback(function()
  _itemInfo:AddToClassList("hidden")
end, true, true, true)

function ToggleVisible()
  self.gameObject:SetActive(not self.gameObject.activeSelf)
end

function UpdateInventory(items)
  _InventoryContent:Clear()
  inventoryItems = {}

  for i, item in ipairs(items) do

    local isInMetaData = false
    for _, meta in ItemMetas do
      if _ == item.id or item.id == "Tokens" then
        isInMetaData = true
        break
      end
    end

    if not isInMetaData then
      local itemButton = CreateItem(item.id)
      itemButton:RegisterPressCallback(function()
        -- EQUIPTHEITEM
        clothingController.AddExtraItem(item.id)
      end, true, true, true)
      itemButton:RegisterLongPressCallback(function()
        --Show Item Info Card
      end, true, true, true)
    end

  end

  -- Temporary code to add a plus icon to the inventory (to be updated)
  -- Plus icon is used to open the shop directly from the inventory
  local plusIcon = VisualElement.new()
  plusIcon:AddToClassList("inventory__item")

  local _plusIcon = VisualElement.new()
  _plusIcon:AddToClassList("inventory__item-icon-plus")

  local _plusImage = UIImage.new()
  _plusImage:AddToClassList("inventory__item__icon__image")
  _plusIcon:Add(_plusImage)

  plusIcon:Add(_plusIcon)
  _InventoryContent:Add(plusIcon)

  plusIcon:RegisterPressCallback(function()
    UIManager.ButtonPressed("Shop")
  end, true, true, true)

end