--!Type(UI)

--!Bind
local nameLabel : UILabel = nil
--!Bind
local titleLabel : Label = nil

local uiManager = require("UIManager")

nameLabel:SetPrelocalizedText("abcdefghijklmnopqrstuvwxyz", true)

function self:Start()
    Timer.After(0.5, function()
        local myCharacter = self.transform.parent.gameObject:GetComponent(Character)
        local myPlayer = myCharacter.player
        nameLabel:SetPrelocalizedText(myPlayer.name, true)
    
        if myPlayer == client.localPlayer then
            nameLabel:AddToClassList("hidden")
        end
    end)
end

function UpdateTitle(score)
    local myRank = uiManager.GetRank(score)
    titleLabel.text = myRank
end