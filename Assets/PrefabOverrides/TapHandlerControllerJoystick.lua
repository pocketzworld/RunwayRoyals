--[[

	Copyright (c) 2024 Pocket Worlds

	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely.

--]]

--!Type(Module)

local tapMask = 0
if client then
	tapMask = bit32.bor(
    	bit32.lshift(1, LayerMask.NameToLayer("Default")),
    	--bit32.lshift(1, LayerMask.NameToLayer("Character")),
    	bit32.lshift(1, LayerMask.NameToLayer("Tappable")),
		bit32.lshift(1, LayerMask.NameToLayer("CharacterTrigger"))
	)
end

---
--- Perform a raycast into the world from the camera using a screen position
---
local function RayCast(position : Vector2)
	local camera = scene.mainCamera
	if not camera or not camera.isActiveAndEnabled then return false end

	-- Create a ray from the screen position
	local ray = camera:ScreenPointToRay(Vector3.new(position.x, position.y, 0))

	-- If this is an imported 2D room, use the iso room raycast implementation
	if client.isoRoomContext ~= nil then
		return client.isoRoomContext:Raycast(ray, tapMask)
	end
	-- Cast a ray from the camera into the world
	return Physics.Raycast(ray, 1000, tapMask)
end

---
---
--- Searches the parent hierarchy of the given transform for a tap handler component
---
local function GetTapHandler (transform : Transform) : TapHandler?
	while transform do
		local tapHandler = transform:GetComponent(TapHandler)
		if tapHandler and tapHandler.enabled then
			return tapHandler
		end

		transform = transform.parent
	end

	return nil
end

---
--- Handles a tap event
---
local function HandleTap(tap : TapEvent)
	--print("Handle Tap")
	-- Cast a ray from the camera into the world
	local success, hit = RayCast(tap.position)
	if not success or not hit.collider then print("Not Success") return end

	-- Check for a handler
	local handler = GetTapHandler(hit.collider.transform)

	if handler then
		--print("Performing tap")
		handler:Perform(hit.point)
	end
end

---
--- Handle client awake
---
function self:ClientAwake()
	Input.Tapped:Connect(HandleTap)
end