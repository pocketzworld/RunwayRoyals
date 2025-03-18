--!Type(UI)

--!Bind
local _rankTitleContainer : UIScrollView = nil
--!Bind
local _closeButton : VisualElement = nil

local uiManager = require("UIManager")

function CreateEntry(entry)
    local entryContainer = VisualElement.new()
    entryContainer:AddToClassList("entryContainer")

    local entryTitle = Label.new()
    entryTitle.text = entry.title
    entryTitle:AddToClassList("entryTitle")

    local entryValue = Label.new()
    entryValue.text = entry.value
    entryValue:AddToClassList("entryValue")

    local entryIcon = VisualElement.new()
    entryIcon:AddToClassList("entryIcon")

    entryContainer:Add(entryTitle)
    entryContainer:Add(entryValue)
    entryContainer:Add(entryIcon)

    _rankTitleContainer:Add(entryContainer)
    return entryContainer
end

_closeButton:RegisterPressCallback(function()
    uiManager.ButtonPressed("Close")
end)

function self:Start()
    for each, entry in ipairs(uiManager.ranksData) do
        CreateEntry(entry)
    end
    self.gameObject:SetActive(false)
end