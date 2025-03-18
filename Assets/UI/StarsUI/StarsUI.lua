--!Type(UI)

--!Bind
local stars_container : VisualElement = nil
--!Bind
local stars_amount : Label = nil

local uiManager = require("UIManager")
local playerTracker = require("PlayerTracker")

function self:Start()
    stars_container:RegisterPressCallback(function()
        uiManager.ButtonPressed("Ranking")
    end)

    stars_amount.text = playerTracker.players[client.localPlayer].playerLifetimeScore.value
    playerTracker.players[client.localPlayer].playerLifetimeScore.Changed:Connect(function(newVal, oldVal)
        stars_amount.text = newVal
    end)
end