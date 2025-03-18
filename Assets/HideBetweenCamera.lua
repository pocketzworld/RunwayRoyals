--!Type(Client)

local mainCam = Camera.main
local player = client.localPlayer

local meshRender = nil

function self:Update()

    local direction = ((player.character.transform.position + Vector3.new(0,0,0)) - mainCam.transform.position).normalized

    -- Hide self when between Cam an player
    local ray = Ray.new(mainCam.transform.position, direction)
    local success, hit = Physics.Raycast(ray, 100, 1)

    if success and hit.transform then

        if meshRender and meshRender.enabled == false then meshRender.enabled = true end

        if hit.transform.gameObject.tag == "SeeThrough" then
            meshRender = hit.transform.gameObject:GetComponent(MeshRenderer)
            if meshRender.enabled then
                meshRender.enabled = false
            end
        else
            if meshRender.enabled == false then
                meshRender.enabled = true
            end
        end
    else
        if meshRender.enabled == false then
            meshRender.enabled = true
        end
    end

end