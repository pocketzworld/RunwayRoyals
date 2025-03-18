--!Type(UI)

--!Bind
local RankingRoot: UILuaView = nil

--!Bind
local _localname : UILabel = nil
--!Bind
local _localscore : UILabel = nil

--!Bind
local _content : VisualElement = nil
--!Bind
local _ranklist : UIScrollView = nil

--[[ BUTTONS ]]--

--!Bind
local _closeButton : VisualElement = nil
--!Bind
local _sessionButton : VisualElement = nil
--!Bind
local _allTimeButton : VisualElement = nil

local gameManager = require("GameManager")
local Utils = require("Utils")

local playerTracker = require("PlayerTracker")
local ui = require("UIManager")
local maxPlayers = 10

local state : number = 0 -- 0 = session lb, 1 = all time lb

function ToggleVisible()
  RankingRoot:ToggleInClassList("hidden")
end

-- Function to make life easier :P
function ButtonPressed(btn: string)
  if btn == "close" then
    --ToggleVisible()
    ui.ButtonPressed("Close")
    return true
  elseif btn == "session" then
    if state == 0 then return end -- Already in session lb
    state = 0
    return true
  elseif btn == "alltime" then
    if state == 1 then return end -- Already in all time lb
    state = 1
    return true
  end
end

-- Function to update the local player
function UpdateLocalPlayer(myScore : number)
  local player = client.localPlayer

  _localname:SetPrelocalizedText(player.name)
  _localscore:SetPrelocalizedText(tostring(myScore))
end

-- Function to update the leaderboard
function UpdateLeaderboard(players)
  -- Clear the previous leaderboard entries
  _ranklist:Clear()

  local playersCount = #players
  if playersCount > maxPlayers then playersCount = maxPlayers end -- Ensure only the top 10 players are shown

  for i = 1, playersCount do

    local _rankItem = VisualElement.new()
    _rankItem:AddToClassList("rank-item")

    local entry = players[i]

    local name = entry.name
    local score = entry.score

    local _rankLabel = UILabel.new()
    _rankLabel:SetPrelocalizedText(Utils.GetPositionSuffix(i))
    _rankLabel:AddToClassList("rank-label")

    local _nameLabel = UILabel.new()
    _nameLabel:SetPrelocalizedText(name)
    _nameLabel:AddToClassList("name-label")

    local _scoreLabel = UILabel.new()
    _scoreLabel:SetPrelocalizedText(tostring(score))
    _scoreLabel:AddToClassList("score-label")

    _rankItem:Add(_rankLabel)
    _rankItem:Add(_nameLabel)
    _rankItem:Add(_scoreLabel)

    _ranklist:Add(_rankItem)
  end
end

-- Functino to update the leaderboard per the current state
function OpenLeaderboard()
  if state == 0 then
    if gameManager.GetSessionLeaderboardPlayers() == nil then _ranklist:Clear(); return end
    UpdateLeaderboard(gameManager.GetSessionLeaderboardPlayers())

  elseif state == 1 then
    if playerTracker.GetLifeTimeLeaderboardPlayers() == nil then _ranklist:Clear(); return end
    UpdateLeaderboard(playerTracker.GetLifeTimeLeaderboardPlayers())
  end
end

-- Register a callback to close the ranking UI
_closeButton:RegisterPressCallback(function()
  ButtonPressed("close")
end, true, true, true)

_sessionButton:RegisterPressCallback(function()
  local success = ButtonPressed("session")
  if success then
    Utils.AddRemoveClass(_sessionButton, "active", true)
    Utils.AddRemoveClass(_allTimeButton, "active", false)

    --Update the leaderboard with the session leaderboard
    local SessionPlayers = gameManager.GetSessionLeaderboardPlayers()
    if SessionPlayers == nil then _ranklist:Clear(); return end
    UpdateLeaderboard(SessionPlayers)
    
  end
end, true, true, true)

_allTimeButton:RegisterPressCallback(function()
  local success = ButtonPressed("alltime")
  if success then
    Utils.AddRemoveClass(_sessionButton, "active", false)
    Utils.AddRemoveClass(_allTimeButton, "active", true)

    local lifeTimePlayers = playerTracker.GetLifeTimeLeaderboardPlayers()
    if lifeTimePlayers == nil then _ranklist:Clear(); return end
    UpdateLeaderboard(lifeTimePlayers)
  end
end, true, true, true)