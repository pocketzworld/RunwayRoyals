--!Type(Module)

--!SerializeField
local FreeCam: GameObject = nil

--!SerializeField
local FullVisibility: LayerMask = nil
--!SerializeField
local LocalVisibility: LayerMask = nil

--!SerializeField
local FullVisibilityTouch: LayerMask = nil
--!SerializeField
local LocalVisibilityTouch: LayerMask = nil

local playerCharControllerJoystick = require("JoystickCharacterControllerOverride")

local uiManager = require("UIManager")

-- Function to set the culling mask of the main camera
function SetState(state)
    if state == 1 then -- Full visibility
        uiManager.SetInteractButtonVisible(false)
    else -- Local visibility
        uiManager.SetInteractButtonVisible(true)
    end
end

local camScript = nil

function self:ClientStart()
    camScript = FreeCam:GetComponent(ThirdPersonCameraOverride)
end

function SetTarget(player)
    camScript.targetPlayer = player
    if player then camScript.zoom = 9 end
end