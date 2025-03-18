--!Type(Client)

function self:Start()
    local character = self.gameObject:GetComponent(Character)
    if character.player == client.localPlayer then
        --character.renderLayer = LayerMask.NameToLayer("localCharacter");
    else
        character.renderLayer = LayerMask.NameToLayer("Character");
    end
end