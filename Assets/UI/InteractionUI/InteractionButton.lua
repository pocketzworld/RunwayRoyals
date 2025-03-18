--!Type(UI)

--!Bind
local interact_root: UILuaView = nil

function CreateButton(cb, text)
    interact_root:Clear()
    local interact_button = Label.new()
    interact_button:AddToClassList("interact__button")
    interact_button.text = text or "Open"
    interact_button:RegisterPressCallback(cb)

    interact_root:Add(interact_button)
end

DestroyButton = function()
    interact_root:Clear()
end

function SetVisible(visible)
    interact_root.style.display = visible and DisplayStyle.Flex or DisplayStyle.None
end