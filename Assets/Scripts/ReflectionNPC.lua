--!Type(Client)

local npcChar = nil
local localChar = nil

function self:Start()
    npcChar = self.gameObject:GetComponent(Character)
    npcChar.renderLayer = LayerMask.NameToLayer("Reflection");
    npcChar.renderScale = Vector3.new(-1, 1, 1)

    localChar = client.localPlayer.character
    npcChar:CopyOutfit(localChar)
    localChar.OutfitChanged:Connect(function()
        npcChar:CopyOutfit(localChar)
    end)

end
function self:LateUpdate()
    if Vector3.Distance(npcChar.destination, client.localPlayer.character.destination) > .1 and Vector3.Distance(npcChar.destination, client.localPlayer.character.destination) < 25 then
        npcChar:MoveTo(client.localPlayer.character.destination)
    end
    npcChar.transform.rotation = Quaternion.LookRotation(client.localPlayer.character.transform.forward * -1, Vector3.up)
end