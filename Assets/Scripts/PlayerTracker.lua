--!SerializeField
local Spawns: Transform = nil

players = {} -- a table variable to store current players  and info
readyPlayers = {}
activePlayerCount = 0

currentRound = 1

local LifetimeLeaderboardPlayers = TableValue.new("LifetimeLeaderboardPlayers")

local getTokenRequest = Event.new("GetTokenRequest")
local incrementTokenRequest = Event.new("IncrementTokenRequest")

local changeParticleRequest = Event.new("ChangeParticleRequest")

local teleportReq = Event.new("TeleportRequest")
local teleportEvent = Event.new("TeleportEvent")

local moveRequest = Event.new("MoveRequest")
local moveEvent = Event.new("MoveEvent")

local gameManager = require("GameManager")
local uiManager = require("UIManager")
local utils = require("Utils")

local pNotify = require("pNotify")

local characterController = require("JoystickCharacterControllerOverride")

-- Function to remove a player from the list of ready players
function RemoveReadyPlayer(player)
    local index = nil
    for i, v in ipairs(readyPlayers) do
        if v == player then
            index = i
            break
        end
    end
    if index then
        table.remove(readyPlayers, index)
    end

    ----print ready players
    for i, v in ipairs(readyPlayers) do
        --print(v.name)
    end
end

function findValueInTable(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
    return nil  -- Return nil if the value is not found
end

-- Function to track players in the game
local function TrackPlayers(game, characterCallback)
    game.PlayerConnected:Connect(function(player) -- When a player joins a scene add them to the players table
        activePlayerCount = activePlayerCount + 1
        if players[player] == nil then
            players[player] = {
                player = player,
                playerScore = IntValue.new("playerScore" .. tostring(player.id), 0),
                playerParticle = IntValue.new("playerParticle" .. tostring(player.id), 0),
                playerOnStage = BoolValue.new("playerOnStage" .. tostring(player.id), false),
                playerInventory = TableValue.new("playerInventory" .. tostring(player.id)),
                playerLifetimeScore = IntValue.new("playerLifetimeScore" .. tostring(player.id), 0),
                Tokens = IntValue.new("PlayerTokens" .. tostring(player.id), 0)
            }
        end

        -- Connect to the event when the player's character changes (e.g., respawn)
        player.CharacterChanged:Connect(function(player, character)
            local playerinfo = players[player]
            -- If character is nil, do nothing
            if (character == nil) then
                return
            end 

            -- If a character callback function is provided, call it with the player information
            if characterCallback then
                characterCallback(playerinfo)
            end
        end)
    end)

    game.PlayerDisconnected:Connect(function(player) -- Remove player from the current table if they disconnect
        activePlayerCount = activePlayerCount - 1
        players[player] = nil

        if game == server then
            -- If the player has not gone yet just remove them without decreasing the current round
            playerIndex = findValueInTable(readyPlayers, player)
            if playerIndex then
                if playerIndex <= currentRound then
                    --currentRound = math.max(currentRound - 1, 1)
                    currentRound = currentRound - 1
                end
                RemoveReadyPlayer(player)
            end
            --print("Player disconnected. Current Round: " .. tostring(currentRound))
        end
        
    end)
end

function GetTokens(player)
    return players[player].Tokens.value
end

function PromtTokenPurchase(id)
    id = id or "runway_classic_token"

    --print("Payments: " .. tostring(Payments))
    Payments:PromptPurchase(id, function(paid)
        if paid then
            -- Player has purchased the product, server PurchaseHandler will be called soon
            -- Do not give the product here, as the server may not have processed the purchase yet
            print(client.localPlayer.name .. " Purchase successful!")
        else
            -- Purchase failed, player closed the purchase dialog or something went wrong
            print(client.localPlayer.name .. " Purchase failed! " .. tostring(paid))
        end
    end)
end

--[[
    Client
]]

function self:ClientAwake()

    TeleportPlayer("spawn")

    function OnCharacterInstantiate(playerinfo)
        local player = playerinfo.player
        local character = player.character
        local particleController = character.gameObject:GetComponent(PlayerParticleController)

        getTokenRequest:FireServer()

        player.character.transform:GetChild(1).gameObject:GetComponent(Nameplate).UpdateTitle(playerinfo.playerLifetimeScore.value)
        playerinfo.playerLifetimeScore.Changed:Connect(function(newVal, oldVal)
            -- Update Player Tag UI
            player.character.transform:GetChild(1).gameObject:GetComponent(Nameplate).UpdateTitle(newVal)
        end)

        -- Handle the player's score changing
        playerinfo.playerScore.Changed:Connect(function(newVal, oldVal)
            if player == client.localPlayer then
                -- Update the local player's score
                -- #UPDATED: No need to update the localplayer score since the ranking UI is not visible by default
                --uiManager.RankingUI.UpdateLocalPlayer(newVal)
            end
        end)

        --Handle the player's on stage state
        playerinfo.playerOnStage.Changed:Connect(function(newVal, oldVal)
            --print("Player " .. player.name ..  " is on stage: " .. tostring(newVal))
            if newVal == true then -- Player On Stage
                -- Play This Players Particle Effect
                particleController.ToggleParticles(true)
            else
                -- Stop This Players Particle Effect
                particleController.ToggleParticles(false)
            end
        end)

        -- Handle the player's particle changing
        playerinfo.playerParticle.Changed:Connect(function(newVal, oldVal)
            --print("Player" .. player.name ..  " has a particle value of " .. tostring(playerinfo.playerParticle.value))
            -- Spawn the particle effect
            particleController.SpawnParticle(newVal)
            if playerinfo.playerOnStage.value == true then
                -- Play This Players Particle Effect
                particleController.ToggleParticles(true)
            end
        end)

        -- Handle the player's score changing
        --[[
        playerinfo.Tokens.Changed:Connect(function(newVal, oldVal)
            if player ~= client.localPlayer then return end
            --Update Token UI
            uiManager.UpdateCash()

            -- Notify the player of the token change
            -- If oldval was zero then the player just joined the game
            if oldVal == 0 then
                pNotify.Notify({
                    type = "success",
                    title = "Welcome to Runway Royals!",
                    text = "You have " .. tostring(newVal) .. " Cash!",
                    timeout = 2,
                    autoHide = true,
                    audio = true,
                    audioShader = "alertSound",
                    scope = "local",
                    player = client.localPlayer
                })
            else
                if newVal > oldVal then
                    pNotify.Notify({
                        type = "success",
                        title = "Cash Received!",
                        text = "You have received " .. tostring(newVal-oldVal) .. " Cash!",
                        timeout = 2,
                        autoHide = true,
                        audio = true,
                        audioShader = "alertSound",
                        scope = "local",
                        player = client.localPlayer
                    })
                elseif newVal < oldVal then
                    pNotify.Notify({
                        type = "success",
                        title = "Cash Spent!",
                        text = "You have spent " .. tostring(oldVal-newVal) .. " Cash!",
                        timeout = 2,
                        autoHide = true,
                        audio = true,
                        audioShader = "alertSound",
                        scope = "local",
                        player = client.localPlayer
                    })
                end
            end
        end)
        --]]
        

        -- Handle the player's inventory changing
        -- #UPDATED: Hidden by default since the inventory UI is not visible by default
        --[[
        if player == client.localPlayer then
            playerinfo.playerInventory.Changed:Connect(function(newInventory, oldInventory)
            end)
        end
        --]]

    end
    
    teleportEvent:Connect(function(player, pos)
        player.character:Teleport(pos)
        player.character.transform.rotation = Quaternion.LookRotation(Vector3.forward * -1, Vector3.up)
    end)

    moveEvent:Connect(function(player, point)
		local character = player.character
		player.character:MoveTo(point)
	end)

    TrackPlayers(client, OnCharacterInstantiate)
end

function GetLifeTimeLeaderboardPlayers()
    return LifetimeLeaderboardPlayers.value
end

function GetPlayerInventory()
    return players[client.localPlayer].playerInventory.value
end

function ChangePlayerParticleRequest(partID)
    changeParticleRequest:FireServer(partID)
end

function GetPlayerParticle()
    return players[client.localPlayer].playerParticle.value
end

function TeleportPlayer(Pos)
    if Pos == "spawn" then
        local Points = {}
            for i = 1, Spawns.childCount-1 do
                table.insert(Points, Spawns:GetChild(i))
            end
            local randomSpawn = Points[math.random(1,#Points)]
            local offsetX = math.random(-1, 1)
            local offsetZ = math.random(-1, 1)
            local newPoint = randomSpawn.position + Vector3.new(offsetX, 0, offsetZ)
            Pos = newPoint
    end
    --teleportReq:FireServer(Pos)
    characterController.SetLocalPlayerPosition(Pos)

end

function MovePlayer(point)
    moveRequest:FireServer(point)
end

function GetPlayers()
    return players
end

--[[
    Server
]]

local topScoreTable = {}

function SortScores()
    -- Create a sortable list of players with score
    local sortableScores = {}
    for player, playerInfo in pairs(players) do
        if playerInfo.playerScore.value > 0 then
            table.insert(sortableScores, {player = playerInfo.player, playerScore = playerInfo.playerScore.value})
        end
    end

    -- Sort the list by score in descending order
    table.sort(sortableScores, function(a, b)
        return a.playerScore > b.playerScore
    end)

    -- Extract the top scores (up to the number of players available)
    local numPlayers = #sortableScores
    local topScoresCount = math.min(numPlayers, 5) ----------------- Change this to the number of top scores you want to sort

    local topScores = {}
    local iTopScores = {}
    for i = 1, topScoresCount do
        topScores[sortableScores[i].player] = sortableScores[i]
        table.insert(iTopScores, sortableScores[i])
    end

    --for i, v in ipairs(iTopScores) do
        ----print(tostring(i) .. ": " .. v.player.name .. " : " .. v.playerScore.value)
    --end

    -- TopScores is a dictionary with player as key and playerInfo as value
    -- playerInfo is a {player, playerScore} table

    -- iTopScores is the index sorted list of playerInfo in order of score
    -- e.g. iTopScores[1] = {NautisShadrick : player, 25 : playerScore}      
    --NOTE: playerScore is a IntValue, so playerscore.value is the actual score

    return topScores, iTopScores;
end

function UpdatePlayerScore(player)
    Storage.GetPlayerValue(player, "HighScore", function(value)
        if value == nil then value = 0 end
        players[player].playerLifetimeScore.value = value
    end)
end

function SortScoresLifetime()
    -- Create a sortable list of players with score
    local sortableScores = {}
    for playerName, playerInfo in topScoreTable do
        table.insert(sortableScores, {name = playerInfo.name, score = playerInfo.score})
    end

    -- Sort the list by score in descending order
    table.sort(sortableScores, function(a, b)
        return a.score > b.score
    end)

    -- Extract the top scores (up to the number of players available)
    local numPlayers = #sortableScores
    local topScoresCount = math.min(numPlayers, 10)

    local topScores = {}
    local iTopScores = {}
    for i = 1, topScoresCount do
        topScores[sortableScores[i].name] = sortableScores[i]
        table.insert(iTopScores, sortableScores[i])
    end

    return topScores, iTopScores;
end

function IncrementRound()
    currentRound = currentRound + 1
end

-- Get the next player in the list of ready players
function getNextPlayer()
    local nextPlayer = nil
    if currentRound < 1 then currentRound = 1 end
    nextPlayer = readyPlayers[currentRound]

    if nextPlayer == nil then
        currentRound = 1
    end

    --print("Current Round: " .. tostring(currentRound))

    -- Return the next player
    return nextPlayer
end

function getReadyPlayersTable()
    return readyPlayers
end

-- Clear the list of ready players
function clearReadyPlayers()
    readyPlayers = {}
end

-- Reset the scores of all players
function ResetPlayerScores()
    for player, playerInfo in pairs(players) do
        playerInfo.playerScore.value = 0
    end
end

-- Function to add a score to a player
function AddScoreServer(contestant, rating)
    -- If the contestant quits the game, do nothing
    if players[contestant] then

        -- Add the rating to the player's score
        players[contestant].playerScore.value = players[contestant].playerScore.value + rating
        --print(contestant.name .. " has a score of " .. tostring(players[contestant].playerScore.value))

        -- Add the rating to the player's lifetime score
        Storage.IncrementPlayerValue(contestant ,"HighScore", rating, function()
            Storage.GetPlayerValue(contestant, "HighScore", function(value) -- Get the player's lifetime score from storage
                if value == nil then value = 0 end
        
                topScoreTable[contestant.name] = { -- Update the topScoreTable with the new score keyed by player name
                    name = contestant.name,
                    score = value
                }
                
                local topScoresLifetime, iTopScoresLifetime = SortScoresLifetime() -- Sort the scores
        
                local leaderboardChanged = false
                Storage.UpdateValue("TopScores", function(newScores) -- Update the leaderboard in storage
                    leaderboardChanged = newScores == nil or not utils.is_table_equal(newScores, topScoresLifetime, false)
                    return if leaderboardChanged then topScoresLifetime else nil
                end,
                function()
                    if(leaderboardChanged) then
                        LifetimeLeaderboardPlayers.value = iTopScoresLifetime -- Update the leaderboard TableValue with the sorted scores
                    end
                end)

                players[contestant].playerLifetimeScore.value = value -- Update the player's lifetime score fromn storage
        
            end)
        end) -- Increment the player's lifetime score in storage
    end
end

-- Stop all Player Particles and Effect
function DeselectParticles(player)
    for player, playerInfo in players do
        playerInfo.playerParticle.value = 0
    end
end

function SetOnStage(player, value : boolean)
    players[player].playerOnStage.value = value
end

function GetPlayerTokensServer(player)
    Inventory.GetPlayerItem(player, "Tokens", function(item)
        if item == nil then
            players[player].Tokens.value = 0
        else
            players[player].Tokens.value = item.amount
        end
    end)
end

function self:ServerAwake()
    -- Track players on the server, with no callback
    TrackPlayers(server)

    -- Fetch the top scores from storage
    Storage.GetValue("TopScores", function(value)
        if value == nil then return end
        local HighScores = value
        for k, v in pairs(HighScores) do -- Add each Highscore to the topScoreTable keyed by player name
            topScoreTable[v.name] = {
                name = v.name,
                score = v.score
            }
        end

        if topScoreTable == nil then return end -- If there are no scores, return

        local topScoresLifetime, iTopScoresLifetime = SortScoresLifetime() -- Sort the scores
        LifetimeLeaderboardPlayers.value = iTopScoresLifetime -- Update the leaderboard TableValue with the sorted scores

    end)

    teleportReq:Connect(function(player, pos)
        player.character.transform.position = pos
        teleportEvent:FireAllClients(player, pos)
    end)

    moveRequest:Connect(function(player, point)
	    if not player.character then
			return
		end
		player.character.transform.position = point
		moveEvent:FireAllClients(player, point)
	end)

    changeParticleRequest:Connect(function(player, partID)
        if players[player].playerParticle.value == partID then
            players[player].playerParticle.value = 0
        else
            players[player].playerParticle.value = partID
        end
    end)

    -- Register the PurchaseHandler function to be called when a purchase is made
    Payments.PurchaseHandler = ServerHandlePurchase

    getTokenRequest:Connect(GetPlayerTokensServer)

    server.PlayerConnected:Connect(function(player)

        UpdatePlayerScore(player)

        if gameManager.gameState.value == 2 then 
            print("Player " .. player.name .. " is readyand joined the server during gameplay")
            return
        end

        print("Player " .. player.name .. " is readyand joined the server during dressup")
        -- Check if the player is already in the active players list
        local playerExists = false
        for i, v in ipairs(readyPlayers) do
            if v == player then
                playerExists = true
            end
        end
        -- If the player is not in the active players list, add them
        if not playerExists then
            table.insert(readyPlayers, player)
        end

    end)
end
------- Player Inventory Functions -------

function UpdatePlayerInventoryNetworkValue(player, items)
    players[player].playerInventory.value = items
end

----------------- Server Purchase Handler -----------------
function IncrementTokensServer(player, amount)
    --print("Incrementing tokens for player " .. player.name .. " by " .. tostring(amount))
    if amount < 0 then
        -- TAKE TOKENS
        local transaction = InventoryTransaction.new()
        :TakePlayer(player, "Tokens", math.abs(amount))
        Inventory.CommitTransaction(transaction, function()
            players[player].Tokens.value = players[player].Tokens.value + amount
        end)

    elseif amount > 0 then
        -- GIVE TOKENS
        local transaction = InventoryTransaction.new()
        :GivePlayer(player, "Tokens", math.abs(amount))
        Inventory.CommitTransaction(transaction, function()
            players[player].Tokens.value = players[player].Tokens.value + amount
        end)

    else
        return
    end
end

function PrintPurchasesForPlayer(player: Player)
    local limit = 100
    local productId = nil
    local cursorId = nil
    
    --print("(Server) Getting purchases for player " .. tostring(player))
    Payments.GetPurchases(player, productId, limit, cursorId, function(purchases, nextCursorId, getPurchasesErr)
        if getPurchasesErr ~= PaymentsError.None then
            error("(Server) Failed to get player purchases: " .. getPurchasesErr)
            return
        end
        --print("(Server) Player purchases:")
        for _, purchase in ipairs(purchases) do
            --print("Purchase ID: " .. tostring(purchase.id))
            --print("Product ID: " .. tostring(purchase.product_id))
            --print("User ID: " .. tostring(purchase.user_id))
            --print("Purchase Date: " .. tostring(purchase.purchase_date))
        end
    end)
end

function ServerHandlePurchase(purchase, player: Player)
    local productId = purchase.product_id
    --print("(Server) Purchase made by player " .. tostring(player) .. " for product " .. tostring(productId))
    
    local itemToGive = nil
    if productId == "runway_classic_token" then
        itemToGive = "runway_classic_token"
    elseif productId == "runway_classic_token_sevenfifty" then
        itemToGive = "runway_classic_token_sevenfifty"
    elseif productId == "runway_classic_token_seventeenhundred" then
        itemToGive = "runway_classic_token_seventeenhundred"
    else
        Payments.AcknowledgePurchase(purchase, false) -- Reject the purchase, it will be retried at a later time and eventually refunded
        print("(Server) Purchase for unknown product ID: " .. productId .. " by player " .. tostring(player))
        return
    end

    Payments.AcknowledgePurchase(purchase, true, function(ackErr: PaymentsError)
        if ackErr ~= PaymentsError.None then
            error("(Server) Something went wrong while acknowledging purchase: " .. ackErr)
            return
        end
        print("(Server) Purchase acknowledged" .. tostring(player) .. " for product " .. tostring(productId))
        --PrintPurchasesForPlayer(player)
        
        if itemToGive == "runway_classic_token" then
            IncrementTokensServer(player, 100)
        elseif itemToGive == "runway_classic_token_sevenfifty" then
            IncrementTokensServer(player, 750)
        elseif itemToGive == "runway_classic_token_seventeenhundred" then
            IncrementTokensServer(player, 1700)
        end

    end)
end