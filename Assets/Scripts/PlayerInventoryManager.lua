--!Type(Module)

local giveItemReq = Event.new("GiveItemRequest")
local takeItemReq = Event.new("TakeItemRequest")

local purchaseItemReq = Event.new("PurchaseItemRequest")

local playerTracker = require("PlayerTracker")
local inventoryMetaData = require("InventoryMetaData")
local ItemMetas = inventoryMetaData.ItemMetas

----------------- Client -----------------
function GiveItem(id: string, amount: number)
    giveItemReq:FireServer(id, amount)
end

function TakeItem(id: string, amount: number)
    takeItemReq:FireServer(id, amount)
end

function PurchaseItem(id : string)
    purchaseItemReq:FireServer(id)
end

function self:ClientStart()
end

----------------- Server -----------------

function self:ServerStart()
    giveItemReq:Connect(function(player: Player, id: string, amount: number)
        GivePlayerItem(player, id, amount)
    end)
    takeItemReq:Connect(function(player: Player, id: string, amount: number)
        TakePlayerItem(player, id, amount)
    end)


    purchaseItemReq:Connect(function(player, id)
        local price = 999999

        local itemMeta = ItemMetas[id]
        if itemMeta then
            price = itemMeta.price
        else
            local clothesData = inventoryMetaData.clothesShopData.value
            for index, item in clothesData do
                if item.id == id then
                    price = item.cost
                    break
                end
            end
        end

        print("Purchasing item " .. id .. " for " .. price .. " tokens")

        local take_transaction = InventoryTransaction.new()
        :TakePlayer(player, "Tokens", price)    
        :GivePlayer(player, id, 1)
        Inventory.CommitTransaction(take_transaction, function()
            GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
            playerTracker.GetPlayerTokensServer(player)
        end)

    end)

    server.PlayerConnected:Connect(function(player)
        GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
    end)

end

function UpdatePlayerInventory(player, items)
    print("Sending " .. tostring(#items) .. " items to " .. player.name)
    --Convert the items to a format that can be sent to the client
    local newInv = {}
    for index, item in items do
        newInv[index] = {
            id = item.id,
            amount = item.amount
        }
    end

    --Set the players Items on Server via Player Tracker
    playerTracker.UpdatePlayerInventoryNetworkValue(player, newInv)
end

function GivePlayerItem(player : Player, itemId : string, amount : number)
    local transaction = InventoryTransaction.new()
    :GivePlayer(player, itemId, amount)
    Inventory.CommitTransaction(transaction)

    GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
end
function TakePlayerItem(player : Player, itemId : string, amount : number)
    local transaction = InventoryTransaction.new()
    :TakePlayer(player, itemId, amount)
    Inventory.CommitTransaction(transaction)

    GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
end

function GetAllPlayerItems(player, limit, cursorId, accumulatedItems, callback)
    accumulatedItems = accumulatedItems or {}
    
    Inventory.GetPlayerItems(player, limit, cursorId, function(items, newCursorId, errorCode)
        if items == nil then
            print("Got error " .. InventoryError[errorCode] .. " while getting items")
            return
        end

        -- Add fetched items to the accumulatedItems table
        
        for index, item in items do
            table.insert(accumulatedItems, item)
        end

        if newCursorId ~= nil then
            -- Continue fetching the next batch of items
            GetAllPlayerItems(player, limit, newCursorId, accumulatedItems, UpdatePlayerInventory)
        else
            -- No more items to fetch, call the callback with the accumulated items
            print("Done fetching all items for player " .. player.name .. " with " .. #accumulatedItems .. " items")
            for each, item in accumulatedItems do
                --print(item.id .. " " .. item.amount)
            end
            callback(player, accumulatedItems)
        end
    end)
end