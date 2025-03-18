--!Type(Module)

function self:ServerStart()

    local newScene = server.LoadSceneAdditive(1)

    server.PlayerConnected:Connect(function(player)
        Timer.After(5, function()
            server.MovePlayerToScene(player, newScene)
        end)
    end)    
end