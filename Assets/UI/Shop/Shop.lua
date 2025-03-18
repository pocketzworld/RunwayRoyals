--!Type(UI)

--!SerializeField
local testImage : Texture = nil -- Test image for the shop UI

--!Bind
local cash_text : Label = nil -- Cash text for the shop UI
--!Bind
local add_cash_button : VisualElement = nil -- Add cash button for the shop UI
--!Bind
local _ShopContent : UIScrollView = nil -- Important do not remove

--!Bind
local _itemInfo : VisualElement = nil -- Important do not remove
--!Bind
local _ItemInfoContent : VisualElement = nil -- Important do not remove

--!Bind
local _closeButton : VisualElement = nil -- Close button for the shop UI
--!Bind
local _closeInfoButton : VisualElement = nil -- Close button for the item info UI

--!Bind
local _ClothesButton : VisualElement = nil -- Clothes button for the shop UI
--!Bind
local _AurasButton : VisualElement = nil -- Auras button for the shop UI
--!Bind
local _ReactionsButton : VisualElement = nil -- Reactions button for the shop UI
--!Bind
local _DealsButton : VisualElement = nil -- Backgrounds button for the shop UI

local UIManager = require("UIManager")
local inventoryMetaData = require("InventoryMetaData")
local playerTracker = require("PlayerTracker")
local inventoryManager = require("PlayerInventoryManager")
local Utils = require("Utils")
local ItemMetas = inventoryMetaData.ItemMetas

local state = 3 -- 0 = Emotes, 1 = Reactions, 2 = Deals, 3 = Clothes

local Clothes = {
}

-- Auras Sorted by Price
local Auras = {
  -- Affordable - 99g
  {id = "Sparkles_White"},
  {id = "Confetti_Player"},
  {id = "Hearts_Red"},
  {id = "Hearts_Pink"},
  
  -- Mid - 299g
  {id = "Sparkles_Pink"},
  {id = "Sparkles_Purple"},
  {id = "Sparkles_Blue"},
  {id = "Sparkles_Green"},
  {id = "Feathers_Black"},
  {id = "Bows_Pastel"},
  {id = "Snowflakes"},
  {id = "Stars_Gold"},
  {id = "Hearts_Purple"},
  {id = "Hearts_Black"},
  
  -- Max - 499g
  {id = "Butterfly_Aura"},
  {id = "Hearts_Pastel"},
  {id = "Hearts_White"},
  {id = "Sparkles_Yellow"},
  {id = "Bats"},
  {id = "Cash"},
  {id = "Feathers_Colorfull"},
  {id = "Stars_Pastel"}
}

local Reactions = {
  {id = "Tomato_React"},
  {id = "Heart_Eyes_React"},
  {id = "Sparkle_React"},
  {id = "Black_Heart_React"},
  {id = "White_Heart_React"},
  {id = "Star_React"},
  {id = "Eyes_React"},
  {id = "Imp_React"}
}

local emotes ={
  {id = "emoji-angry"      },
  {id = "emoji-crying"     },
  {id = "emote-snake"      },
  {id = "emote-splitsdrop" },
  {id = "dance-handsup"    },
  {id = "emoji-gagging"    },
  {id = "idle_layingdown2" },
  {id = "emote-punkguitar" },
  {id = "emote-robot"      },
  {id = "dance-breakdance" },
  {id = "emote-embarrassed"},
  {id = "emote-shrink"     },
  {id = "emote-handstand"  },
}

local Deals = {
  {id = "runway_classic_token"},
  {id = "runway_classic_token_sevenfifty"},
  {id = "runway_classic_token_seventeenhundred"}
}

-- Register a callback to close the shop UI
_closeButton:RegisterPressCallback(function()
  --self.gameObject:SetActive(false)
  UIManager.ButtonPressed("Close")
end, true, true, true)

-- Register a callback to close the item info UI
_closeInfoButton:RegisterPressCallback(function()
  _itemInfo:AddToClassList("hidden")
end, true, true, true)

-- Register a callback to add cash to the player
add_cash_button:RegisterPressCallback(function()
  ButtonPressed("deals")
end, true, true, true)

function UpdateCashUI()
  local cash = playerTracker.GetTokens(client.localPlayer)
  cash_text.text = tostring(cash)--(cash > 999 and string.format("%.1fk", cash / 1000) or tostring(cash))
end

-- Function to create an item in the shop
function CreateItem(price: number, image: Texture|string, useGold:boolean, itemID: string, is_purchased : boolean, isClothing)
  useGold = useGold or false
  isClothing = isClothing or false

  local _ShopItem = VisualElement.new()
  _ShopItem:AddToClassList("shop__item")

  local _shopIcon = VisualElement.new()
  _shopIcon:AddToClassList("shop__item-icon")

  local _shopImage = UIImage.new()
  _shopImage:AddToClassList("shop__item-icon__image")

  if image == "fetch" then
    _shopImage:LoadItemPreview(isClothing and "avatar_item" or "emote", itemID)
  else 
    _shopImage.image = image
  end
  _shopIcon:Add(_shopImage)

  _ShopItem:Add(_shopIcon)

  local _shopPrice = VisualElement.new()
  _shopPrice:AddToClassList("shop__item-price")

  local _shopPriceIcon = Image.new()
  if not useGold then _shopPriceIcon:AddToClassList("shop__item-price__icon") else _shopPriceIcon:AddToClassList("package__item-price__icon") end
  if not is_purchased then _shopPrice:Add(_shopPriceIcon) end

  local _shopPriceText = Label.new()
  _shopPriceText:AddToClassList("shop__item-price__label")
  _shopPriceText.text = is_purchased and "Purchased" or tostring(price)
  _shopPrice:Add(_shopPriceText)

  _ShopItem:Add(_shopPrice)

  _ShopContent:Add(_ShopItem)
  return _ShopItem
end

function CreateItemInfoPage(name: string, price: number, description: string, image: Texture|string, is_purchased: boolean, id: string, useGold, isClothing)  
  useGold = useGold or false
  isClothing = isClothing or false

  local category = (image == "fetch" and isClothing and "avatar_item") or (image == "fetch" and "emote") or "metad_data"

  _itemInfo:RemoveFromClassList("hidden")
  _ItemInfoContent:Clear()

  local _ItemInfoIcon = VisualElement.new()
  if category == "avatar_item" then _ItemInfoIcon:AddToClassList("shop__item__info-icon_avatar") else _ItemInfoIcon:AddToClassList("shop__item__info-icon") end
  local _ItemInfoImage = UIImage.new()

  if image == "fetch" then
    _ItemInfoImage:LoadItemPreview(category, id)
  else 
    _ItemInfoImage.image = image
  end


  --[[
  local _ItemInfoAmount = VisualElement.new()
  _ItemInfoAmount:AddToClassList("shop__item__info-amount")

  local _ItemInfoAmountText = UILabel.new()
  _ItemInfoAmountText:AddToClassList("shop__item__info__amount-label")
  _ItemInfoAmountText:SetPrelocalizedText(tostring(amount))
  _ItemInfoAmount:Add(_ItemInfoAmountText)
  --]]

  _ItemInfoIcon:Add(_ItemInfoImage)
  --_ItemInfoIcon:Add(_ItemInfoAmount)

  local _ItemInfoName = VisualElement.new()
  _ItemInfoName:AddToClassList("shop__item__info-name")

  local _ItemInfoNameText = UILabel.new()
  _ItemInfoNameText:AddToClassList("shop__item__info__name-label")
  _ItemInfoNameText:SetPrelocalizedText(name)
  _ItemInfoName:Add(_ItemInfoNameText)

  local _ItemInfoDescription = VisualElement.new()
  _ItemInfoDescription:AddToClassList("shop__item__info-description")

  local _ItemInfoDescriptionText = UILabel.new()
  _ItemInfoDescriptionText:AddToClassList("shop__item__info__description-label")
  _ItemInfoDescriptionText:SetPrelocalizedText(description)
  _ItemInfoDescription:Add(_ItemInfoDescriptionText)

  _ItemInfoContent:Add(_ItemInfoIcon)
  _ItemInfoContent:Add(_ItemInfoName)
  if category ~= "avatar_item" then _ItemInfoContent:Add(_ItemInfoDescription) end

  if not is_purchased then
    local _BuyButton = VisualElement.new()
    _BuyButton:AddToClassList("shop__item__info-buy")

    _BuyButtonText = UILabel.new()
    _BuyButtonText:AddToClassList("shop__item__info__buy-label")
    _BuyButtonText:SetPrelocalizedText("Buy")

    local _ItemPrice = VisualElement.new()
    _ItemPrice:AddToClassList("shop__item__info-price")
  
    local _ItemPriceIcon = Image.new()
    _ItemPriceIcon:AddToClassList("shop__item__info-price__icon")
    if not useGold then _ItemPriceIcon:AddToClassList("shop__item__info-price__icon") else _ItemPriceIcon:AddToClassList("package__item__info-price__icon") end
    _ItemPrice:Add(_ItemPriceIcon)
  
    local _ItemPriceText = UILabel.new()
    _ItemPriceText:AddToClassList("shop__item__info__price-label")
    _ItemPriceText.text = tostring(price)
    _ItemPrice:Add(_ItemPriceText)

    _BuyButton:Add(_BuyButtonText)
    _BuyButton:Add(_ItemPrice)

    _ItemInfoContent:Add(_BuyButton)

    if useGold then -- Get the Product Popup instead of use Cash
      _BuyButton:RegisterPressCallback(function()
        -- Open World Product Prmopt
        playerTracker.PromtTokenPurchase(id)
      end, true, true, true)
    else -- Use Cash to buy the item
      _BuyButton:RegisterPressCallback(function()
        -- Purchase Item
        inventoryManager.PurchaseItem(id)

        if playerTracker.GetTokens(client.localPlayer) >= price then
          -- remove buy button and replace with purchased
          -- Note: Do not remove this button unless the purchase is successful (Another way is if we check for the user balance and disable the button if they don't have enough cash to purchase the item)
          _ItemInfoContent:Remove(_BuyButton)
          CreatePurhcasedButton()
        end
      end, true, true, true)
    end
  else
    -- Display purchased
    CreatePurhcasedButton()
  end
    
end

function CreatePurhcasedButton()
  local _Purchased = VisualElement.new()
  _Purchased:AddToClassList("shop__item__info-purchased")

  _PurchasedText = UILabel.new()
  _PurchasedText:AddToClassList("shop__item__info__purchased-label")
  _PurchasedText:SetPrelocalizedText("Purchased")

  _Purchased:Add(_PurchasedText)

  _ItemInfoContent:Add(_Purchased)
end

-- This is for showing a specific Item, specifcally for when you click a locked Reaction
function ShowItemInfo(itemID: string, cost, displayName)
  if ItemMetas[itemID] then
    -- Create Item Meta Data based on ID
    local itemMeta = ItemMetas[itemID]

    local itemPrice = itemMeta.price
    local itemImage = itemMeta.image
    local itemDescription = itemMeta.description
    local itemName = itemMeta.name
    local itemType = itemMeta.itemType
    local effectId = itemMeta.effectId
    
    --Show Item Info
    local is_purchased = false

    --print the inventory keys
    for key, value in playerTracker.players[client.localPlayer].playerInventory.value do
      if value.id == itemID then
        is_purchased = true
        break
      end
    end

    CreateItemInfoPage(itemName, itemPrice, itemDescription, itemImage, is_purchased, itemID)

  else -- Assume is clothing as it is not in the MetaData tables
    local is_purchased = false

    --print the inventory keys
    for key, value in playerTracker.players[client.localPlayer].playerInventory.value do
      if value.id == itemID then
        is_purchased = true
        break
      end
    end

    CreateItemInfoPage(displayName, cost, "", "fetch", is_purchased, itemID)
  end
end

function PopulateShop(items)
  _ShopContent:Clear()
  if items == nil then return end

  -- Create a new temp table to hold all of the items sorted by purchased ones last
  local sortedItems = {}
  for i, item in ipairs(items) do
    local is_purchased = false
    --print the inventory keys
    for key, value in playerTracker.players[client.localPlayer].playerInventory.value do
      if value.id == item.id then
        is_purchased = true
        break
      end
    end

    table.insert(sortedItems, {item = item, is_purchased = is_purchased})
  end

  -- Sort the items by purchased
  table.sort(sortedItems, function(a, b) return b.is_purchased and not a.is_purchased end)

  local refinedTable = {}
  for i, item in ipairs(sortedItems) do
    table.insert(refinedTable, item.item)
  end

  local tableToUse = {}
  if state == 3 then
    tableToUse = items
  else
    tableToUse = refinedTable
  end

  for i, item in ipairs(tableToUse) do

    --Show Item Info
    local is_purchased = false
    --print the inventory keys
    for key, value in playerTracker.players[client.localPlayer].playerInventory.value do
      if value.id == item.id then
        is_purchased = true
        break
      end
    end

    if ItemMetas[item.id] then
      -- Create Item Meta Data based on ID
      local itemMeta = ItemMetas[item.id]
  
      local itemPrice = itemMeta.price
      local itemImage = itemMeta.image
      local itemDescription = itemMeta.description
      local itemName = itemMeta.name
      local itemType = itemMeta.itemType
      local effectId = itemMeta.effectId
      local useGold = itemType == "deal"
      
      local item_button = CreateItem(itemPrice, itemImage, useGold, item.id, is_purchased, false)
    
      item_button:RegisterPressCallback(function()
        CreateItemInfoPage(itemName, itemPrice, itemDescription, itemImage, is_purchased, item.id, useGold, false)
      end, true, true, true)
  
    else -- Assume is clothing as it is not in the MetaData tables
    

      local item_button = CreateItem(item.cost, "fetch", false, item.id, is_purchased, true)
      item_button:RegisterPressCallback(function()
        CreateItemInfoPage(item.displayName, item.cost, "", "fetch", is_purchased, item.id, false, true)
      end, true, true, true)


    end

  end
end

function OpenShop()
  Clothes = inventoryMetaData.clothesShopData.value
  _ShopContent:Clear()

  local cash = playerTracker.GetTokens(client.localPlayer)
  cash_text.text = tostring(cash)-- (cash > 999 and string.format("%.1fk", cash / 1000) or tostring(cash))

  _itemInfo:AddToClassList("hidden")
  -- Populate the shop per the state
  if state == 0 then
    PopulateShop(emotes)
  elseif state == 1 then
    PopulateShop(Reactions)
  elseif state == 2 then
    PopulateShop(Deals)
  elseif state == 3 then
    PopulateShop(Clothes)
  else
    return
  end
end

-- Function to make life easier :P
function ButtonPressed(btn: string)
  if btn == "close" then
    --ToggleVisible()
    UIManager.ButtonPressed("Close")
    return true
  elseif btn == "clothes" then
    if state == 3 then return end -- Already in clothes
    state = 3
    Utils.AddRemoveClass(_ClothesButton, "active", true)
    Utils.AddRemoveClass(_AurasButton, "active", false)
    Utils.AddRemoveClass(_ReactionsButton, "active", false)
    Utils.AddRemoveClass(_DealsButton, "active", false)
    PopulateShop(Clothes)
    return true
  elseif btn == "auras" then
    if state == 0 then return end -- Already in auras
    state = 0
    Utils.AddRemoveClass(_AurasButton, "active", true)
    Utils.AddRemoveClass(_ReactionsButton, "active", false)
    Utils.AddRemoveClass(_DealsButton, "active", false)
    Utils.AddRemoveClass(_ClothesButton, "active", false)
    PopulateShop(emotes)
    return true
  elseif btn == "reactions" then
    if state == 1 then return end -- Already in reactions
    state = 1
    Utils.AddRemoveClass(_AurasButton, "active", false)
    Utils.AddRemoveClass(_ReactionsButton, "active", true)
    Utils.AddRemoveClass(_DealsButton, "active", false)
    Utils.AddRemoveClass(_ClothesButton, "active", false)
    PopulateShop(Reactions)
    return true
  elseif btn == "deals" then
    if state == 2 then return end -- Already in deals
    state = 2
    Utils.AddRemoveClass(_AurasButton, "active", false)
    Utils.AddRemoveClass(_ReactionsButton, "active", false)
    Utils.AddRemoveClass(_DealsButton, "active", true)
    Utils.AddRemoveClass(_ClothesButton, "active", false)
    PopulateShop(Deals)
    return true
  end
end

_ClothesButton:RegisterPressCallback(function()
  local success = ButtonPressed("clothes")
end, true, true, true)

_AurasButton:RegisterPressCallback(function()
  local success = ButtonPressed("auras")
end, true, true, true)

_ReactionsButton:RegisterPressCallback(function()
  local success = ButtonPressed("reactions")
end, true, true, true)

_DealsButton:RegisterPressCallback(function()
  local success = ButtonPressed("deals")
end, true, true, true)

function self:ClientStart()
  inventoryMetaData.clothesShopData.Changed:Connect(function(newData)
    Clothes = newData
  end)
  playerTracker.players[client.localPlayer].Tokens.Changed:Connect(function(newTokens)
    OpenShop()
  end)
  playerTracker.players[client.localPlayer].playerInventory.Changed:Connect(function(newInventory)
    OpenShop()
  end)
end
