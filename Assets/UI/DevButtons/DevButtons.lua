--!Type(UI)

--Bind
local _ReadyUpButton : UILuaView = nil
--!Bind
local joinGameButton : VisualElement = nil
--!Bind
local dressedUpButton : VisualElement = nil
--!Bind
local joinGamelabel : UILabel = nil
--!Bind
local dressedUpLabel: UILabel = nil

--!Bind
local _dropdownMenu : VisualElement = nil
--!Bind
local _InfoButton : VisualElement = nil

--!Bind
local _LeaderboardItem : VisualElement = nil
--!Bind
local _InventoryItem : VisualElement = nil
--!Bind
local _Shop : VisualElement = nil

local gameManager = require("GameManager")
local playerTracker = require("PlayerTracker")
local UIManager = require("UIManager")

local finishButtonUsed = false


-- Function to disable the Ready Button (dev button)
DisableReadyButton = function(option: boolean)
    if option == true then
        joinGameButton:AddToClassList("disabled")
    else
        joinGameButton:EnableInClassList("enabled", false)
        joinGameButton:RemoveFromClassList("disabled")

        joinGamelabel:SetPrelocalizedText("Join", true)
    end
end

-- Function to disable the Dressed Up Button (dev button)
DisableDressedUpButton = function(option: boolean)
    if option == true then
        dressedUpButton:AddToClassList("disabled")
    else
        finishButtonUsed = false
        dressedUpButton:EnableInClassList("enabled", false)
        dressedUpButton:RemoveFromClassList("disabled")
    end
end

function HideDropDownMenu()
    _dropdownMenu:AddToClassList("hidden")
end

joinGamelabel:SetPrelocalizedText("Join", true)
dressedUpLabel:SetPrelocalizedText("Submit", true)

DisableDressedUpButton(true)