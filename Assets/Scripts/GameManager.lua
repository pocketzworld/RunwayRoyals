--!Type(Module)

--!SerializeField
local mainCam: GameObject = nil
--!SerializeField
local TVCam: GameObject = nil


--!SerializeField
local DressingRoom: Transform = nil

--!SerializeField
local RunwayA: Transform = nil
--!SerializeField
local RunwayB: Transform = nil
--!SerializeField
local crowdPoints: {Transform} = nil
--!SerializeField
local podiumMesh: GameObject = nil

--!SerializeField
local GoldPoint: Transform = nil
--!SerializeField
local SilverPoint: Transform = nil
--!SerializeField
local BronzePoint: Transform = nil

--!SerializeField
local FireWorks: ParticleSystem = nil
--!SerializeField
local Confetti: ParticleSystem = nil
--!SerializeField
local Paparatzzi1: ParticleSystem = nil
--!SerializeField
local Paparatzzi2: ParticleSystem = nil
--!SerializeField
local Paparatzzi3: ParticleSystem = nil
--!SerializeField
local Paparatzzi4: ParticleSystem = nil
--!SerializeField
local rewardParticles : {ParticleSystem} = nil

local PedestalPoints = {
    GoldPoint,
    SilverPoint,
    BronzePoint
}

local PaparatziParts = {
    Paparatzzi1,
    Paparatzzi2,
    Paparatzzi3,
    Paparatzzi4
}

local camScript = nil
local camAnim = nil
local tvCamScript = nil

local TenSecondsEvent = Event.new("TenSecondsEvent")
FirstRoundEvent = Event.new("FirstRoundEvent")
nextRoundEvent = Event.new("NextRoundEvent")
endGameEvent = Event.new("EndGameEvent")

local submitVoteReq = Event.new("SubmitVoteRequest")
local gameTimerValue = IntValue.new("GameTimerValue", 0)

-- Game state
gameState = NumberValue.new("GameState", 0)
gameStateData = TableValue.new("GameStateData", {
    currentPlayer = nil,
    lastPlayer = nil,
    startTime = 10, -- seconds
    dressUpTime = 180, -- seconds
    roundTime = 15, -- seconds
    victoryTime = 15, -- seconds
    theme = "Fashion"
})
local roundTimer = nil
local uiTimer = nil

local playerIsContestant = false

local firstRound = true

local winners = {}

local SessionLeaderboardPlayers = TableValue.new("LeaderboardPlayers")

playerTracker = require("PlayerTracker")
uiManager = require("UIManager")
camManager = require("CameraManager")
audioManager = require("AudioManager")
themes = require("Themes")
utils = require("Utils")
clothingCollections = require("ClothingCollections")
clothingController = require("ClothingController")
cashSpawner = require("CashSpawner")

local characterController = require("JoystickCharacterControllerOverride")

-------------------- CLIENT --------------------

function ItemIsInTable(item, table)
    for i, v in table do
        if v == item then
            return true
        end
    end
    return false
end

function SyncToState(newState: number)
    if newState == 0 then
        tvCamScript.ClearRender()
        uiManager.ToggleUI("WorldHUD", false)
        uiManager.OverlayUI.SetTitle("Starting")
        firstRound = true
    elseif newState == 1 then
        print("State 1")
        tvCamScript.ClearRender()
        uiManager.ToggleUI("WorldHUD", true)
        playerIsContestant = true
        --Play the Dress Up Sound
        audioManager.PlayDressUpSound()
        camAnim:SetBool("Fade", true)
        Timer.After(0.5, function()
            camManager.SetState(0) -- Set the camera to Local Visibility
            camAnim:SetBool("Fade", false) -- Fade the camera back in

            --Teleport the player to the Dress Up Area
            playerTracker.TeleportPlayer(DressingRoom.position)
            -- Set Camera Rot
            camScript.SetRotation(0,10)

            -- Update the UI
            uiManager.OverlayUI.SetTitle(gameStateData.value.theme)
            uiManager.OverlayUI.SetContestantName("Dress Up!")
        end)

    elseif newState == 2 then
        print("State 2")
        tvCamScript.ResumeRender()
        uiManager.ToggleUI("WorldHUD", false)
        -- Start the paparazzi particles and sounds
        characterController.ToggleThumbstick(false)
        characterController.enabled = false
        audioManager.PlayCameraFlashSmall()
        for i, v in ipairs(PaparatziParts) do
            v:Play(true)
        end

        -- Set the camera to Full Visibility
        if gameStateData.value.currentPlayer then
            if gameStateData.value.currentPlayer ~= client.localPlayer then
                gameStateData.value.currentPlayer.character.renderLayer = LayerMask.NameToLayer("OnTV")
            end
        end

    elseif newState == 3 then
        print("State 3")
        tvCamScript.ClearRender()
        uiManager.ToggleUI("WorldHUD", false)
        -- If a player joins during the Victory scene hide the Ready Button
        uiManager.OverlayUI.SetContestantName("New Game in...")
        Timer.After(1, function()
            for i, v in ipairs(rewardParticles) do
                v:Play(true)
            end
        end)
    end
end

function self:ClientStart()


    podiumMesh:SetActive(gameState.value == 3)
    camAnim = mainCam.gameObject:GetComponent(Animator)
    camScript = mainCam.gameObject:GetComponent(ThirdPersonCameraOverride)
    tvCamScript = TVCam.gameObject:GetComponent(CameraRenderRate)

    gameTimerValue.Changed:Connect(function(newVal, oldVal)
        uiManager.OverlayUI.SetTimer(newVal, oldVal)
        if newVal > 0 and newVal < 10 then
            audioManager.PlayTickSound()
        end

        if newVal == 0 then
            audioManager.PlayTeleportSound()
        end
    end)

    TenSecondsEvent:Connect(audioManager.PlayAlertSound)
    uiManager.OverlayUI.SetTitle("Waiting For Players")

    FirstRoundEvent:Connect(function()
        --Disable the Dressed Up Button
        uiManager.DisableButton("DressUp", true)
        uiManager.ToggleUI("SelectedClothing", false)

        -- Fade the camera to black
        if playerIsContestant then
            Timer.After(1, function() camAnim:SetBool("Fade", true) end)
            Timer.After(1.25, function()
                camAnim:SetBool("Fade", false)
            end)
        end

        --Play the Showtime Sound
        audioManager.PlayShowtimeSound()

        -- Start the paparazzi particles and sounds
        audioManager.PlayCameraFlashSmall()
        for i, v in ipairs(PaparatziParts) do
            v:Play(true)
        end

        characterController.ToggleThumbstick(false)
        characterController.enabled = false
    end)

    nextRoundEvent:Connect(function(currentPlayer, lastPlayer, theme)
        characterController.movementEnabled = false
        Timer.After(1, function()

            --slow the player down for the runway
            currentPlayer.character.speed = 3.5
            -- Set Camera Rot
            camScript.SetRotation(90,10)

            if not firstRound then
                --Next Round Sound
                audioManager.PlayNextModelSound()
            end

            firstRound = false

            camManager.SetState(1) -- Set the camera to Full Visibility

            -- Teleport the last player back to Zero
            if client.localPlayer == lastPlayer then
                playerTracker.TeleportPlayer("spawn")
            end

            -- Teleport the player to the runway
            --if camScript then --camScript.CenterOn(RunwayB.position) end
            uiManager.emotesUI.Toggle(false)
            -- You are the Current Contestant
            if client.localPlayer == currentPlayer then
                playerTracker.TeleportPlayer(RunwayA.position)            
                playerTracker.MovePlayer(RunwayB.position)
                Timer.After(2, function() uiManager.emotesUI.Toggle(true) end)
            end
            uiManager.OverlayUI.SetUserThumbnail(currentPlayer)

            -- Set them to the Camera Layer
            if currentPlayer.character ~= client.localPlayer.character then currentPlayer.character.renderLayer = LayerMask.NameToLayer("OnTV") end


            -- Clear the vote rating history
            uiManager.VoteUI.NextRoundUI(client.localPlayer == currentPlayer)
            uiManager.OverlayUI.SetContestantName(currentPlayer.name)
            uiManager.OverlayUI.HideUserThumbnail(false)
            uiManager.OverlayUI.SetTitle(theme)

            -- Attach the Camera to the Player
            camManager.SetTarget(currentPlayer)
        end)
    end)

    endGameEvent:Connect(function(iTopScores, lastPlayer, victoryTime)
        uiManager.emotesUI.Toggle(false)
        podiumMesh:SetActive(true)

        winners = {}

        uiManager.ToggleUI("Emotes", false)

        -- Teleport the last player back to Zero
        if client.localPlayer == lastPlayer then
            playerTracker.TeleportPlayer("spawn")
        end

        -- End the paparazzi particles and sounds
        audioManager.StopCameraFlashSmall()
        for i, v in ipairs(PaparatziParts) do
            v:Stop(true)
        end

        -- Teleport the Top 3 to the Pedestals
        --camScript.CenterOn(PedestalPoints[1].position)
        camAnim:SetTrigger("Flash")
        audioManager.PlayCameraFlashFinal()
        
        if iTopScores[1] then
            if iTopScores[1].player then
                uiManager.OverlayUI.SetUserThumbnail(iTopScores[1].player)
                camManager.SetTarget(iTopScores[1].player)
            end
        end

        for i, v in ipairs(iTopScores) do
            if i <= 3 then
                table.insert(winners, v.player)
                v.player.character.gameObject:GetComponent(NavMeshAgent).enabled = false
                if client.localPlayer == v.player then
                    characterController.movementEnabled = false
                    playerTracker.TeleportPlayer(PedestalPoints[i].position)
                end
            else
                break
            end
        end

        local crowdIndex = 0
        for player, playerinfo in pairs(playerTracker.GetPlayers()) do
            player.character.renderLayer = LayerMask.NameToLayer("Character")
            player.character.speed = 6
            if not ItemIsInTable(player, winners) then
                crowdIndex = crowdIndex + 1
                if crowdIndex > #crowdPoints then
                    crowdIndex = math.random(1, #crowdPoints)
                end
                if client.localPlayer == player then
                    playerTracker.TeleportPlayer(crowdPoints[crowdIndex].position)
                end
            end
        end

        -- Hide the voting UI
        uiManager.VoteUI.HideStars()

        -- Announce the winner
        uiManager.OverlayUI.SetTitle("Winner")
        if iTopScores[1] then
            uiManager.OverlayUI.SetContestantName(iTopScores[1].player.name)
        end

        -- Play the Fireworks and Confetti
        FireWorks:Play(true)
        Confetti:Play(true)
        uiManager.VoteUI.HideEmojis(false)

        -- Teleport Everyone back to Zero after 5 seconds
        Timer.After(victoryTime, function()
            uiManager.OverlayUI.SetTitle("Waiting For Players")
            uiManager.OverlayUI.SetContestantName("Intermission")
            uiManager.OverlayUI.SetTimer(-2)
            uiManager.OverlayUI.HideUserThumbnail(true)

            uiManager.VoteUI.HideEmojis()

            playerTracker.TeleportPlayer("spawn")
            characterController.movementEnabled = true
            characterController.ToggleThumbstick(true)
            characterController.enabled = true

            winners = {}
            --camScript.CenterOn(Vector3.new(0, 0, 0))
            FireWorks:Stop(true)
            Confetti:Stop(true)

            --Detach the Camera from the Player
            camManager.SetTarget(nil)
            uiManager.ButtonPressed("Leaderboard")

            podiumMesh:SetActive(false)

        end)
    end)

    SyncToState(gameState.value)
    gameState.Changed:Connect(function(newState)
        SyncToState(newState)
    end)

    client.PlayerDisconnected:Connect(function(player) -- Remove player from the current table if they disconnect

        local index = nil
        for i, v in ipairs(winners) do
            if v == player then
                index = i
                print("FOUND")
                break
            end
        end
        if index then
            table.remove(winners, index)
        end

        for k, v in winners do
            print(v.name)
        end
    end)

end

function GetSessionLeaderboardPlayers()
    return SessionLeaderboardPlayers.value
end

function FinishDressingRequest()
    finishDressingReq:FireServer()
end

function SubmitVote(rating)
    -- Submit the vote to the player tracker
    submitVoteReq:FireServer(rating)
end
-------------------- SERVER --------------------

local currentRoundVotes = {}

function StartGameServer()
    print(gameState.value)
    -- Check if the game is already running
    if gameState.value ~= 0 then
        return
    end
    -- Get Cloudbased Timer Values for next game
    GetCloudTimes()

    -- Wait 5 seconds before starting the game
    gameTimerValue.value = gameStateData.value.startTime -- Set the timer to the start time
    Timer.After(gameStateData.value.startTime, function()
        -- Start the game
        StartDressup()
    end)
end

function GetCurrentPlayer()
    return gameStateData.value.currentPlayer
end

function GetGameState()
    return gameState.value
end

function GetTotallVotes()
    local totalVotes = 0
    for player, rating in pairs(currentRoundVotes) do
        totalVotes = totalVotes + rating
    end
    return totalVotes
end

function endGame(lastPlayer)

    -- Determine the winner
    local topScores, iTopScores = playerTracker.SortScores()
    --print("[GM Server] The winner is: " .. iTopScores[1].player.name)

    -- Award cash to the top three players
    local topThree = {}
    for i, v in ipairs(iTopScores) do
        -- Award 15 to the top player, 10 to the second, and 5 to the third
        local cash = 0
        if i == 1 then
            cash = 15
        elseif i == 2 then
            cash = 10
        elseif i == 3 then
            cash = 5
        end
        if cash > 0 then
            print("Awarding " .. cash .. " to " .. v.player.name)
            playerTracker.IncrementTokensServer(v.player, cash)
        end
    end

    -- Create the leaderboard players Table
    -- {playername, score}
    local sessionLeaderboardPlayers = {}
    for i, v in ipairs(iTopScores) do
        table.insert(sessionLeaderboardPlayers, {name = v.player.name, score = v.playerScore})
        print(v.player.name .. " : " .. tostring(v.playerScore))
    end
    SessionLeaderboardPlayers.value = sessionLeaderboardPlayers

    gameState.value = 3
    endGameEvent:FireAllClients(iTopScores, lastPlayer, gameStateData.value.victoryTime)

    -- Wait for the victory time before teleporting everyone back to Zero
    gameTimerValue.value = gameStateData.value.victoryTime -- Set the timer to the victory time
    Timer.After(gameStateData.value.victoryTime, function()

        -- Stop the game
        gameState.value = 0
        --StopMusic
        audioManager.RoundMusicPlaying.value = false

        -- Get Cloudbased Timer Values for next game
        GetCloudTimes()

        --Restore Outfits
        clothingController.ServerRestoreOutfits()

        -- Restart the game
        StartGameServer()
    end)

    
    -- Add players in players table to ready players if they are not in there yet
    for player, playerinfo in playerTracker.players do
        print("Checking player: " .. player.name)
            -- Check if the player is already in the active players list
        local playerExists = false
        for i, v in ipairs(playerTracker.readyPlayers) do
            print(i, typeof(v), v.name)
            if v == player then
                playerExists = true
            end
        end
        -- If the player is not in the active players list, add them
        print("Player Exists: " .. tostring(playerExists))
        if not playerExists then
            table.insert(playerTracker.readyPlayers, player)
        end
    end

end

function endRound()
    -- Increment the round
    playerTracker.IncrementRound()
    -- Move on to the next round
    startNextRound()
end

function startNextRound()

    local _tempStateData = gameStateData.value
    -- Get the last player
    _tempStateData.lastPlayer = gameStateData.value.currentPlayer
    gameStateData.value = _tempStateData
    -- Check if rhwew was a last player
    if gameStateData.value.lastPlayer then
        -- Assign last player their total votes
        playerTracker.AddScoreServer(gameStateData.value.lastPlayer, GetTotallVotes())
        -- Set the last player's OnStage status as False for the Particle Effect
        playerTracker.SetOnStage(gameStateData.value.currentPlayer, false)
        -- Clear the votes
        currentRoundVotes = {}
    end

    -- Get the next player
    _tempStateData = gameStateData.value
    _tempStateData.currentPlayer = playerTracker.getNextPlayer()
    gameStateData.value = _tempStateData
    -- If there are no more players, end the game
    if gameStateData.value.currentPlayer == nil then
        endGame(gameStateData.value.lastPlayer)
        return
    end

    -- Set the current player's OnStage status as True for the Particle Effect
    playerTracker.SetOnStage(gameStateData.value.currentPlayer, true)

    -- Announce the next round
    nextRoundEvent:FireAllClients(gameStateData.value.currentPlayer, gameStateData.value.lastPlayer, gameStateData.value.theme)

    -- Start the round timer
    gameTimerValue.value = gameStateData.value.roundTime
    roundTimer = Timer.After(gameStateData.value.roundTime, function()
        -- End the round
        endRound()
    end)
end

function StartDressup()
    -- Check if the game is already running
    if gameState.value == 1 then return end

    cashSpawner.ShuffleCash()

    -- Clear the player scores
    playerTracker.ResetPlayerScores()

    -- Pick a theme
    local _tempStateData = gameStateData.value
    _tempStateData.theme = themes.GetTheme()
    gameStateData.value = _tempStateData

    -- Start the Dressup Rounds
    gameState.value = 1
    print("setting gamestate value to", gameState.value)

    gameTimerValue.value = gameStateData.value.dressUpTime
    roundTimer = Timer.After(gameStateData.value.dressUpTime, function()
        -- Start the first round
        StartRounds()
    end)

    -- Clear Outfits
    clothingController.ServerClearOutfits()

end

function StartRounds()
    -- Check if the game is already running
    if gameState.value == 2 then return end

    -- Start the Music
    audioManager.RoundMusicPlaying.value = true

    -- Stop the Dressup Timer if irt is still running
    if roundTimer then
        roundTimer:Stop()
        roundTimer = nil
    end

    -- Start the Judging Rounds
    gameState.value = 2
    FirstRoundEvent:FireAllClients()
    startNextRound()
end

--Get Current Times from Storage
local GameTimeSet = {
    startTime = gameStateData.value.startTime, -- seconds
    dressUpTime = gameStateData.value.dressUpTime, -- seconds
    roundTime = gameStateData.value.roundTime, -- seconds
    victoryTime = gameStateData.value.victoryTime -- seconds
}
function GetCloudTimes()

    if gameState.value == 1 or gameState.value == 2 or gameState.value == 3 then return end -- DO NOT CHANGE MID GAME

    Storage.GetValue("GameTimeSet", function(value)

        -- No Stored Times, Store Defaults
        if value == nil then  
            Storage.SetValue("GameTimeSet", GameTimeSet, function(errorCode)
                if errorCode == 0 then
                    print("Game Times Stored")
                end
            end)

            return
        end
        
        -- Values did not change so return
        if utils.is_table_equal(GameTimeSet, value, false) then print("No Change to Times"); return end

        -- Values Changed so Update
        GameTimeSet.startTime = value.startTime
        GameTimeSet.dressUpTime = value.dressUpTime
        GameTimeSet.roundTime = value.roundTime
        GameTimeSet.victoryTime = value.victoryTime

        local _tempData = gameStateData.value
        _tempData.startTime = GameTimeSet.startTime
        _tempData.dressUpTime = GameTimeSet.dressUpTime
        _tempData.roundTime = GameTimeSet.roundTime
        _tempData.victoryTime = GameTimeSet.victoryTime
        gameStateData.value = _tempData

    end)
end

function self:ServerStart()

    -- Start the game
    StartGameServer()

    -- Get Cloudbased Timer Values for next game
    GetCloudTimes()

    -- Update the Timer UI every second
    uiTimer = Timer.Every(1, function()
        gameTimerValue.value = gameTimerValue.value - 1
        if gameState.value == 1 then
            if gameTimerValue.value == 10 then
                TenSecondsEvent:FireAllClients()
            end
        end
    end)

    submitVoteReq:Connect(function(player, rating)
        if gameState.value == 2 then
            currentRoundVotes[player] = rating
        end
    end)

    game.PlayerDisconnected:Connect(function(player) -- Remove player from the current table if they disconnect
        if gameStateData.value.currentPlayer == player then
            local _tempStateData = gameStateData.value
            _tempStateData.currentPlayer = nil
            gameStateData.value = _tempStateData
        end
    end)
end