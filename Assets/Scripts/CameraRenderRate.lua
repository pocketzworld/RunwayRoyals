--!Type(Client)

--!SerializeField
local framesBetweenRenders : number = 2  -- Assuming 60 frames per second as default
local camera : Camera = self.gameObject:GetComponent(Camera)

canRender = true

function self:Awake()
    camera.enabled = false
    Timer.Every(framesBetweenRenders/60,
        function()
            if not canRender then return end
            camera:Render()
        end
    )
end

function ClearRender()
    self.transform.rotation = Quaternion.Euler(90, 0, -90)
    camera:Render()
    canRender = false
end

function ResumeRender()
    self.transform.rotation = Quaternion.Euler(0, 90, 0)
    canRender = true
end