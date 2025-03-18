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
		return client.isoRoomContext:Raycast(ray, options.tapMask)
	end
	-- Cast a ray from the camera into the world
	return Physics.Raycast(ray, 1000, options.tapMask)
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
	-- If the player controller is disabled then do not handle taps
	if not options.enabled then return end

	-- If the local player does not have a character then do not handle taps
	if not client.localPlayer then return end
	local character = client.localPlayer.character
	if not character then return end

	-- Cast a ray from the camera into the world
	local success, hit = RayCast(tap.position)
	if not success or not hit.collider then return end

	-- Check for a handler
	local handler = GetTapHandler(hit.collider.transform)

	if handler then
		handler:Perform(tapPosition)
	end
end

---
--- Handle client awake
---
function self:ClientAwake()
	Input.Tapped:Connect(HandleTap)
end
