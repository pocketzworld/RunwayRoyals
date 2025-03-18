--!Type(Module)

--!SerializeField
local pickupObjects: {GameObject} = {}

export type ClothingStockThemeData = {
    Shirts: {string},
    Pants: {string},
    Shoes: {string},
    Accessories: {string},
    Hair: {string},
    Faces: {string}
}

export type ClothingStockData = {
    {ClothingStockThemeData}
}

local ClothingSetTable = TableValue.new("ClothingSetTable", {["themes"] = {"theme1","theme2"}, ["clothes"] = {Shirts = {""}, Pants = {""}, Shoes = {""}, Accessories = {""}, Hair = {""}, Faces = {""}}})

local ClothingCollections = {["HairCollection"] = {}, ["FacesCollection"] = {}}

local gameManger = require("GameManager")
local themes = require("Themes")
local clothingController = require("ClothingController")

local pickupRenders = {}
local angleThreshold = 60

local camera = nil

function ReturnClothingCollection(collectionName: string): {CharacterClothing}

    print(#ClothingCollections[collectionName])
    local _collection: {CharacterClothing} = {}
    for i, item in ipairs(ClothingCollections[collectionName]) do
        local _clotingItem = CharacterClothing.new(item)
        table.insert(_collection, _clotingItem)
        --print("Added item to collection: " .. item)
    end

    return _collection
end

function InitializeItems(themeID)
    themeID = themeID or "Theme1"

    print("Initializing Items for Theme: " .. themeID)

    if ClothingSetTable.value.clothes == nil then
        print("No Clothing Collections found")
        return
    end

    local ItemCollection = ClothingSetTable.value.clothes

    local shirtPickups = {}
    local pantsPickups = {}
    local shoesPickups = {}
    local accessoriesPickups = {}

    for i, pickupObject in ipairs(pickupObjects) do
        local pickupScript = pickupObject:GetComponent(ClothingPickupWorld)
        local pickupType = pickupScript.GetType()
        if pickupType == "shirt" then
            table.insert(shirtPickups, pickupScript)
        elseif pickupType == "pants" then
            table.insert(pantsPickups, pickupScript)
        elseif pickupType == "shoes" then
            table.insert(shoesPickups, pickupScript)
        elseif pickupType == "accessories" then
            table.insert(accessoriesPickups, pickupScript)
        end
    end

    for i, shirtPickup in ipairs(shirtPickups) do
        if i > #ItemCollection.Shirts then
            i = math.random(1, #ItemCollection.Shirts)
        end
        shirtPickup.SetItem(ItemCollection.Shirts[i])
    end

    for i, pantsPickup in ipairs(pantsPickups) do
        if i > #ItemCollection.Pants then
            i = math.random(1, #ItemCollection.Pants)
        end
        pantsPickup.SetItem(ItemCollection.Pants[i])
    end

    for i, shoesPickup in ipairs(shoesPickups) do
        if i > #ItemCollection.Shoes then
            i = math.random(1, #ItemCollection.Shoes)
        end
        shoesPickup.SetItem(ItemCollection.Shoes[i])
    end

    for i, accessoriesPickup in ipairs(accessoriesPickups) do
        if i > #ItemCollection.Accessories then
            i = math.random(1, #ItemCollection.Accessories)
        end
        accessoriesPickup.SetItem(ItemCollection.Accessories[i])
    end

    ClothingCollections.HairCollection = ItemCollection.Hair
    ClothingCollections.FacesCollection = ItemCollection.Faces

end

function SyncToState(newState)
    local changeLocalPlayer = newState == 1
    if newState == 1 or newState == 2 then -- dressing up or voting
        InitializeItems(gameManger.gameStateData.value.theme)
        clothingController.GetDressUpOutfits(changeLocalPlayer)
    end
end

function self:ClientStart()
    --ClothingSetTable.Changed:Connect(function(clothingSelections)
    --    InitializeItems()
    --end)
    SyncToState(gameManger.gameState.value)
    gameManger.gameState.Changed:Connect(function(newState)
        SyncToState(newState)
    end)

    for i, obj in ipairs(pickupObjects) do
        table.insert(pickupRenders, obj:GetComponent(MeshRenderer))
    end
    camera = Camera.main
end

function isLookingAtbject(object) : boolean
    local objectPosition = object.transform.position
    local cameraPosition = camera.gameObject.transform.position
    local cameraForward = camera.gameObject.transform.forward
    local objectDirection = objectPosition - cameraPosition
    local angle = Vector3.Angle(cameraForward, objectDirection)

    -- check max distance
    if objectDirection.magnitude > 100 then
        return false
    end

    return angle < angleThreshold
end

function self:Update()
    for i, render in ipairs(pickupRenders) do
        if isLookingAtbject(render.gameObject) then
            render.enabled = true
        else
            render.enabled = false
        end
    end
end

----------- Server ------------

function FetchClothingSetFromStorage()
    print("Fetching Clothing Set from Storage")
    Storage.GetValue("ClothingInventory", function(value)
        if not value then print("No Clothing Set found")
            Storage.SetValue("ClothingInventory", ClothingSetTable.value)
            return
        end
        ClothingSetTable.value = value
        themes.themes = {}
        themes.currentIndex = 1

        for i, theme in ipairs(ClothingSetTable.value.themes) do
            table.insert(themes.themes, theme)
        end
        themes.ShuffleThemes()
    end)
end

function self:ServerStart()
    FetchClothingSetFromStorage()
end