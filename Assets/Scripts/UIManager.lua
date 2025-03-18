--!Type(Module)

--!SerializeField
local ButtonsObject : GameObject = nil
--!SerializeField
local InventoryObject : GameObject = nil
--!SerializeField
local LeaderboardObject : GameObject = nil
--!SerializeField
local OverlayObject : GameObject = nil
--!SerializeField
local VotingObject : GameObject = nil
--!SerializeField
local ShopObject : GameObject = nil
--!SerializeField
local WorldHudObject : GameObject = nil
--!SerializeField
local InteractionObject : GameObject = nil
--!SerializeField
local EmotesObject : GameObject = nil
--!SerializeField
local RankingObject : GameObject = nil
--!SerializeField
local selectedClothingObject : GameObject = nil

local Utils = require("Utils")
local gameManager = require("GameManager")
local playerTracker = require("PlayerTracker")

local characterController = require("JoystickCharacterControllerOverride")


local EmojiIncReq = Event.new("EmojiIncRequest")
local EmojiBurstEvent = Event.new("EmojiBurstEvent")

ButtonsUI = nil
InventoryUI = nil
LeaderboardUI = nil
OverlayUI = nil
VoteUI = nil
ShopUI = nil
WorldHUD = nil
InteractionUI = nil
emotesUI = nil
RankingUI = nil

uiMap = {
    Buttons = ButtonsObject,
    Inventory = InventoryObject,
    Leaderboard = LeaderboardObject,
    Overlay = OverlayObject,
    Voting = VotingObject,
    Shop = ShopObject,
    WorldHUD = WorldHudObject,
    Interaction = InteractionObject,
    Emotes = EmotesObject,
    SelectedClothing = selectedClothingObject,
    Ranking = RankingObject
}

ranksData = 
{
    {title = "New Model", value = 0},
    {title = "Rising Star", value = 100},
    {title = "Aspiring Model", value = 200},
    {title = "Fashionista", value = 300},
    {title = "Glamourista", value = 400},
    {title = "Fashion Maven", value = 600},
    {title = "Runway Queen", value = 800},
    {title = "Trend Setter", value = 1000},
    {title = "Runway Diva", value = 1200},
    {title = "Top Model", value = 1300},
    {title = "Glamour Elite", value = 1400},
    {title = "Fashion Mogul", value = 1500},
    {title = "Supernova", value = 1600},
    {title = "Fashion Legend", value = 1800},
    {title = "Fashion Goddess", value = 2000}
}

function GetRank(score)
    local rankTitle = ""
    for each, entry in ipairs(ranksData) do
        if score >= entry.value then
            rankTitle = entry.title
        end
    end
    print("Rank Title: " .. rankTitle)
    return rankTitle
end

-- Function to disable a button based on the type and option provided
DisableButton = function(buttonType: string, option: boolean)
    if typeof(option) == "boolean" then
        if ButtonsObject then
            if buttonType == "Ready" then
                ButtonsUI.DisableReadyButton(option)
            elseif buttonType == "DressUp" then
                ButtonsUI.DisableDressedUpButton(option)
            else
                print("[DisableButton] Invalid button type")
            end
        else
            print("[DisableButton] ButtonsObject is not set")
        end
    else
        print("[DisableButton] Invalid option")
    end
end

-- Function to show the Ranking UI
--[[
ShowRanking = function()
    if RankingUI then
        RankingUI.ToggleVisible()
    else
        print("[ShowRanking] RankingUI is not set")
    end
end
]]--

-- Function to show the Inventory UI
ToggleInventory = function()
    if InventoryUI then
        InventoryUI.ToggleVisible()
    else
        print("[ShowInventory] InventoryUI is not set")
    end
end

ToggleUI = function(ui: string, visible: boolean)
    local uiComponent = uiMap[ui]
    if uiComponent == nil then
        print("[ToggleUI] UI component not found: " .. ui)
        return
    end

    if visible then
        Utils.ActivateObject(uiComponent)
    else
        Utils.DeactivateObject(uiComponent)
    end
end

ToggleUIs = function(uiList, visible: boolean)
    for _, ui in ipairs(uiList) do
        ToggleUI(ui, visible)
    end
end

ToggleAll = function(visible: boolean, except)
    for ui, component in pairs(uiMap) do
        if except and except[ui] then
            continue
        end

        if visible then
            Utils.ActivateObject(component)
        else
            Utils.DeactivateObject(component)
        end
    end
end

ButtonPressed = function(btn)
    if btn == "Leaderboard" then
        characterController.ToggleThumbstick(false)
        ToggleAll(false)
        ToggleUI("Leaderboard", true)

        -- Do whatever you want to do when the Leaderboard button is pressed
        local LeaderboardUI = LeaderboardObject.gameObject:GetComponent(ranking)
        LeaderboardUI.OpenLeaderboard()

    elseif btn == "Inventory" then
        characterController.ToggleThumbstick(false)
        ToggleAll(false)
        ToggleUI("Inventory", true)

        -- Do whatever you want to do when the Inventory button is pressed
        local InventoryUI = InventoryObject.gameObject:GetComponent(inventory)
        local playerInventory = playerTracker.GetPlayerInventory()
        InventoryUI.UpdateInventory(playerInventory)
    elseif btn == "Shop" then
        characterController.ToggleThumbstick(false)
        ToggleAll(false)
        ToggleUI("Shop", true)

        local ShopUI = ShopObject.gameObject:GetComponent(Shop)
        ShopUI.OpenShop()

    elseif btn == "Close" then
        -- This works for all UIs (leaderboard, inventory, etc.)
        ToggleAll(false)
        ToggleUIs({ "Buttons", "Overlay", "Voting", "Interaction", "SelectedClothing", "Emotes" }, true)
        VoteUI.UpdateOwnedEmojis()
        VoteUI.PopulateEmojiBar()
        if gameManager.gameState.value ~= 2 and gameManager.gameState.value ~= 3  then characterController.ToggleThumbstick(true) end
        if gameManager.gameState.value == 1 then ToggleUI("WorldHUD", true) end
    elseif btn == "Ranking" then
        characterController.ToggleThumbstick(false)
        ToggleAll(false)
        ToggleUI("Ranking", true)
    end

    --print("Button Pressed: " .. btn)
end

UpdateCash = function()
    local ShopUI = ShopObject.gameObject:GetComponent(Shop)
    if ShopUI ~= nil then if ShopUI.UpdateCashUI ~= nil then ShopUI.UpdateCashUI() else print("No ShopUI") end end
end

OpenShopPage = function(page : string, itemID : string)
    ToggleAll(false)
    ToggleUI("Shop", true)

    local ShopUI = ShopObject.gameObject:GetComponent(Shop)
    ShopUI.OpenShop()
    ShopUI.ButtonPressed(page)
    ShopUI.ShowItemInfo(itemID)
end

function CreateInteractButton(cb, text)
    print("Creating Interact Button")
    InteractionUI.CreateButton(cb, text)
end

function DestroyInteractButton()
    print("Destroying Interact Button")
    InteractionUI.DestroyButton()
end

function SetInteractButtonVisible(visible)
    InteractionUI.SetVisible(visible)
end

function self:ClientAwake()

    ButtonsUI = ButtonsObject.gameObject:GetComponent(DevButtons)
    OverlayUI = OverlayObject.gameObject:GetComponent(MinigameHud)
    VoteUI = VotingObject.gameObject:GetComponent(VotingGUI)
    WorldHUD = WorldHudObject.gameObject:GetComponent(worldhud)
    InteractionUI = InteractionObject.gameObject:GetComponent(InteractionButton)
    emotesUI = EmotesObject.gameObject:GetComponent(EmotesUI)
    RankingUI = RankingObject.gameObject:GetComponent(RankingTitles)

    local HeartCounter = 0
    local FireCounter = 0
    local ClapCounter = 0
    local TomatoCounter = 0
    local BlackHeartCounter = 0
    local WhiteHeartCounter = 0
    local SparkleCounter = 0
    local DollarCounter = 0
    local GoldCounter = 0
    local StarCounter = 0
    local ImpCounter = 0
    local EyesCounter = 0
    local HeartEyeCounter = 0

    local EmojiTimer = nil

    function AddEmoji(ID)
        if ID == 1 then
            HeartCounter = HeartCounter + 1
        elseif ID == 2 then
            FireCounter = FireCounter + 1
        elseif ID == 3 then
            ClapCounter = ClapCounter + 1
        elseif ID == 4 then
            TomatoCounter = TomatoCounter + 1
        elseif ID == 5 then
            BlackHeartCounter = BlackHeartCounter + 1
        elseif ID == 6 then
            WhiteHeartCounter = WhiteHeartCounter + 1
        elseif ID == 7 then
            SparkleCounter = SparkleCounter + 1
        elseif ID == 8 then
            StarCounter = StarCounter + 1
        elseif ID == 9 then
            DollarCounter = DollarCounter + 1
        elseif ID == 10 then
            GoldCounter = GoldCounter + 1
        elseif ID == 11 then
            ImpCounter = ImpCounter + 1
        elseif ID == 12 then
            EyesCounter = EyesCounter + 1
        elseif ID == 13 then
            HeartEyeCounter = HeartEyeCounter + 1
        end

        --print(tostring(HeartCounter) .. " " .. tostring(FireCounter) .. " " .. tostring(ClapCounter) .. " " .. tostring(TomatoCounter))
    end

    EmojiTimer = Timer.Every(1, function()
        if HeartCounter > 0 then
            EmojiIncReq:FireServer(1, HeartCounter)
            HeartCounter = 0
        end
        if FireCounter > 0 then
            EmojiIncReq:FireServer(2, FireCounter)
            FireCounter = 0
        end
        if ClapCounter > 0 then
            EmojiIncReq:FireServer(3, ClapCounter)
            ClapCounter = 0
        end
        if TomatoCounter > 0 then
            EmojiIncReq:FireServer(4, TomatoCounter)
            TomatoCounter = 0
        end
        if BlackHeartCounter > 0 then
            EmojiIncReq:FireServer(5, BlackHeartCounter)
            BlackHeartCounter = 0
        end
        if WhiteHeartCounter > 0 then
            EmojiIncReq:FireServer(6, WhiteHeartCounter)
            WhiteHeartCounter = 0
        end
        if SparkleCounter > 0 then
            EmojiIncReq:FireServer(7, SparkleCounter)
            SparkleCounter = 0
        end
        if StarCounter > 0 then
            EmojiIncReq:FireServer(8, StarCounter)
            StarCounter = 0
        end
        if DollarCounter > 0 then
            EmojiIncReq:FireServer(9, DollarCounter)
            DollarCounter = 0
        end
        if GoldCounter > 0 then
            EmojiIncReq:FireServer(10, GoldCounter)
            GoldCounter = 0
        end
        if ImpCounter > 0 then
            EmojiIncReq:FireServer(11, ImpCounter)
            ImpCounter = 0
        end
        if EyesCounter > 0 then
            EmojiIncReq:FireServer(12, EyesCounter)
            EyesCounter = 0
        end
        if HeartEyeCounter > 0 then
            EmojiIncReq:FireServer(13, HeartEyeCounter)
            HeartEyeCounter = 0
        end

    end)

    EmojiBurstEvent:Connect(function(ID, count)
        VoteUI.PlayParticle(ID, count)
    end)
end

function self:ServerAwake()

    local HeartCounterServer = 0
    local FireCounterServer = 0
    local ClapCounterServer = 0
    local TomatoCounterServer = 0
    local BlackHeartCounterServer = 0
    local WhiteHeartCounterServer = 0
    local SparkleCounterServer = 0
    local DollarCounterServer = 0
    local GoldCounterServer = 0
    local StarCounterServer = 0
    local ImpCounterServer = 0
    local EyesCounterServer = 0
    local HeartEyeCounterServer = 0

    EmojiTimerServer = nil


    EmojiIncReq:Connect(function(player, ID, count)
        if ID == 1 then
            HeartCounterServer = HeartCounterServer + count
        elseif ID == 2 then
            FireCounterServer = FireCounterServer + count
        elseif ID == 3 then
            ClapCounterServer = ClapCounterServer + count
        elseif ID == 4 then
            TomatoCounterServer = TomatoCounterServer + count
        elseif ID == 5 then
            BlackHeartCounterServer = BlackHeartCounterServer + count
        elseif ID == 6 then
            WhiteHeartCounterServer = WhiteHeartCounterServer + count
        elseif ID == 7 then
            SparkleCounterServer = SparkleCounterServer + count
        elseif ID == 8 then
            StarCounterServer = StarCounterServer + count
        elseif ID == 9 then
            DollarCounterServer = DollarCounterServer + count
        elseif ID == 10 then
            GoldCounterServer = GoldCounterServer + count
        elseif ID == 11 then
            ImpCounterServer = ImpCounterServer + count
        elseif ID == 12 then
            EyesCounterServer = EyesCounterServer + count
        elseif ID == 13 then
            HeartEyeCounterServer = HeartEyeCounterServer + count
        end
    end)

    EmojiTimerServer = Timer.Every(1, function()
        if HeartCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(1, HeartCounterServer)
            HeartCounterServer = 0
        end
        if FireCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(2, FireCounterServer)
            FireCounterServer = 0
        end
        if ClapCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(3, ClapCounterServer)
            ClapCounterServer = 0
        end
        if TomatoCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(4, TomatoCounterServer)
            TomatoCounterServer = 0
        end
        if BlackHeartCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(5, BlackHeartCounterServer)
            BlackHeartCounterServer = 0
        end
        if WhiteHeartCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(6, WhiteHeartCounterServer)
            WhiteHeartCounterServer = 0
        end
        if SparkleCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(7, SparkleCounterServer)
            SparkleCounterServer = 0
        end
        if StarCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(8, StarCounterServer)
            StarCounterServer = 0
        end
        if DollarCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(9, DollarCounterServer)
            DollarCounterServer = 0
        end
        if GoldCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(10, GoldCounterServer)
            GoldCounterServer = 0
        end
        if ImpCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(11, ImpCounterServer)
            ImpCounterServer = 0
        end
        if EyesCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(12, EyesCounterServer)
            EyesCounterServer = 0
        end
        if HeartEyeCounterServer > 0 then
            EmojiBurstEvent:FireAllClients(13, HeartEyeCounterServer)
            HeartEyeCounterServer = 0
        end
    end)
end