--!Type(Module)

--!SerializeField
local selectdClothesUIObject: GameObject = nil

local selectedClothesUI = nil

local SetOutfitRequest = Event.new("SetOutfitRequest")
local setOutfitResponse = Event.new("SetOutfitResponse")

local playEmoteRequest = Event.new("PlayEmoteRequest")
local playEmoteResponse = Event.new("PlayEmoteResponse")

local ClearOutfitsEvent = Event.new("ClearOutfitsEvent")
local RestoreOutfitEvent = Event.new("RestoreOutfitEvent")

local GetDressupOutfitsRequest = Event.new("GetDressupOutfitsRequest")
local GetDressupOutfitsResponse = Event.new("GetDressupOutfitsResponse")

export type LocalClothingItem = {
    id : string,
    color : number
}

gameManager = require("GameManager")

players = {}
playerCount = IntValue.new("playerCount", 0)

------------ Player Tracking ------------
function TrackPlayers(game, characterCallback)
    game.PlayerConnected:Connect(function(player)
        players[player] = {
            player = player,
            playerOutfit = TableValue.new("PlayerOutfit" .. player.user.id, {{id = "body-flesh", color = 17}}),
        }

        player.CharacterChanged:Connect(function(player, character) 
            local playerinfo = players[player]
            if (character == nil) then
                return
            end 

            if characterCallback then
                characterCallback(playerinfo)
            end
        end)
    end)

    game.PlayerDisconnected:Connect(function(player)
        players[player] = nil
    end)
end

--[[
----------------------- Client -----------------------
--]]

--[[
    Get the current outfit of a character or the local player returning a CharacterOutfit type
--]]
function GetCurrentOutfit(character) : CharacterOutfit
    character = character or client.localPlayer.character
    local _items = {}
    
    for _, outfit in ipairs(character.outfits) do
        for _, clothing in ipairs(outfit.clothing) do
            table.insert(_items, {id = clothing.id, color = clothing.color})
        end
    end

    local _outfitIDs = {}
    for _, clothing in ipairs(_items) do
        table.insert(_outfitIDs, clothing.id)
    end

    local _newFit = CharacterOutfit.CreateInstance(_outfitIDs, nil)
    for i = 1, #_newFit.clothing do
        _newFit.clothing[i].color = _items[i].color
    end

    return _newFit
end

--[[
    Rasterize the outfit from the outfit table returning a CharacterOutfit type
--]]
function RasterizeOutfit(outfit)

    local _outfitIds = {}
    for _, clothing in ipairs(outfit) do
        table.insert(_outfitIds, clothing.id)
    end

    local _newFit = CharacterOutfit.CreateInstance(_outfitIds, nil)
    for i = 1, #_newFit.clothing do
        _newFit.clothing[i].color = outfit[i].color
    end

    return _newFit
end

--[[
    Convert an Outfit returned from the Closet to a localClothingItem sendable through server events
--]]
function SerializeOutfit(outfit)
    local _outfit = {}
    for _, clothing in ipairs(outfit.clothing) do
        local _newClothing : LocalClothingItem = {id = clothing.id, color = clothing.color}
        table.insert(_outfit, _newClothing)
    end

    return _outfit
end

--[[
    Get the current outfit of a player
--]]
function GetPlayerFit(player)
    local _playerFit = GetCurrentOutfit(player.character)
    return _playerFit
end

function ShowCloset(collection, title)
    UI:OpenCloset(client.localPlayer, title, ExitCloset, collection, false, GetCurrentOutfit(), "SAVE", true)
end

--[[
    Check if the Item is currently on the player
--]]
function ItemisOnPlayer(itemID: string)
    for _, existingItem in ipairs(players[client.localPlayer].playerOutfit.value) do
        if existingItem.id == itemID then
            --print("Item already exists")
            return true
        end
    end
    return false
end

--[[
    Add each clothing selected in the closet after closing the closet
--]]
function ExitCloset(outfit)
    local _serializedOutfit = SerializeOutfit(outfit)

    for each, item in ipairs(_serializedOutfit) do
        print(item.id, item.color)
    end

    AddExtraItems(_serializedOutfit)
end

--[[
    Add Multiple Items at once
--]]
function AddExtraItems(items)
    local _ExtraITEMS = {}

    for _, item in ipairs(items) do
        table.insert(_ExtraITEMS, item)
    end

    local _rasterizedOutfit = RasterizeOutfit(_ExtraITEMS)

    OutfitSaved(_rasterizedOutfit)
    selectedClothesUI.UpdateSelectedItems(_ExtraITEMS)
end

--[[
    Add a single Clothing Item to the Player as an Extra item
--]]
function AddExtraItem(item)
    print("Adding Extra Item", item)
    if ItemisOnPlayer(item) then return end

    --print("Adding Extra Item")
    local _ExtraITEMS = players[client.localPlayer].playerOutfit.value
    table.insert(_ExtraITEMS, {id = item, color = 1})

    local _rasterizedOutfit = RasterizeOutfit(_ExtraITEMS)
    
    --print("Added Extra Item", item)
    OutfitSaved(_rasterizedOutfit)
    selectedClothesUI.UpdateSelectedItems(_ExtraITEMS)
end

--[[
    Remove a single Clothing Item from the Player as an Extra item
--]]
function RemoveExtraItem(item)
    if not ItemisOnPlayer(item) then return end
    -- Remove the item from the player
    local _currentItems = players[client.localPlayer].playerOutfit.value

    for i, existingItem in ipairs(_currentItems) do
        if existingItem.id == item then
            table.remove(_currentItems, i)
            break
        end
    end

    local _rasterizedOutfit = RasterizeOutfit(_currentItems)
    
    print("Removed Extra Item")
    OutfitSaved(_rasterizedOutfit)
    selectedClothesUI.UpdateSelectedItems(_currentItems)

end

--[[
    Play an Emote on the player
--]]
function PlayEmote(emoteID)
    playEmoteRequest:FireServer(emoteID)
end

function GetDressUpOutfits(changeLocalPlayer)
    GetDressupOutfitsRequest:FireServer(changeLocalPlayer)
end

function self:ClientAwake()

    --setOutfitResponse:Connect(function(player, outfit)
    --    local _rasterizedOutfit = RasterizeOutfit(outfit)
    --    player.character:SetOutfit(_rasterizedOutfit)
    --end)

    function OnCharacterInstantiate(playerinfo)
        local player = playerinfo.player
        local character = player.character

        playerinfo.playerOutfit.Changed:Connect(function(newOutfit, oldOutfit)
            player.character:SetOutfit(RasterizeOutfit(newOutfit))         
        end)
    end
    TrackPlayers(client, OnCharacterInstantiate)

    playEmoteResponse:Connect(function(player, emoteID)
        local character = player.character
        character:PlayEmote(emoteID, false, nil)
    end)

    RestoreOutfitEvent:Connect(function()
        for player, playerInfo in pairs(players) do
            player.character:ResetOutfit()
        end
    end)

    ClearOutfitsEvent:Connect(function()
        for player, playerInfo in pairs(players) do
            player.character:SetOutfit(RasterizeOutfit(playerInfo.playerOutfit.value))
        end
    end)

    GetDressupOutfitsResponse:Connect(function(requestingPlayer, changeRequestingPlayer)
        for player, playerInfo in pairs(players) do
            if not changeRequestingPlayer and player == requestingPlayer then continue end
            player.character:SetOutfit(RasterizeOutfit(playerInfo.playerOutfit.value))
        end
    end)

end

function self:ClientStart()
    selectedClothesUI = selectdClothesUIObject:GetComponent(SelectedClothesHud)
end

function OutfitSaved(_outfit)
    local newFit = SerializeOutfit(_outfit)

    SetOutfitRequest:FireServer(newFit)
end

function GetPlayersTable()
    return players
end

--[[
----------------------- SERVER -----------------------
--]]

function self:ServerAwake()

    TrackPlayers(server)

    SetOutfitRequest:Connect(function(player, outfit)
        --setOutfitResponse:FireAllClients(player, outfit)

        if #outfit == 0 then
            outfit = {{id = "body-flesh", color = 0}}
        end

        local playerInfo = players[player]
        playerInfo.playerOutfit.value = outfit

    end)

    playEmoteRequest:Connect(function(player, emoteID)
        playEmoteResponse:FireAllClients(player, emoteID)
    end)

    GetDressupOutfitsRequest:Connect(function(player, changeLocalPlayer)
        GetDressupOutfitsResponse:FireAllClients(player, changeLocalPlayer)
    end)
end

function ServerClearOutfits()
    for _, playerInfo in pairs(players) do
        playerInfo.playerOutfit.value = {{id = "body-flesh", color = 17}}
    end
    ClearOutfitsEvent:FireAllClients()
end

function ServerRestoreOutfits()
    RestoreOutfitEvent:FireAllClients()
end