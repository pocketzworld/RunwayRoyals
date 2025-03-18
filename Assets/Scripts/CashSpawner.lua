--!Type(Module)

collectRequest = Event.new("CollectRequest")
resetCashEvent = Event.new("ResetCash")
local playerTracker = require("PlayerTracker")

--!SerializeField
local cashprefab : GameObject = nil

local cashPoints = {
    Vector3.new(-35.03, 0, 32.04),
    Vector3.new(-27.98, 0, 1.99),
    Vector3.new(-33.42, 0.74999994, -17.479996),
    Vector3.new(1.8, 0, 18.29),
    Vector3.new(6.18, 0, -0.85),
    Vector3.new(-11.04, 0, 4.23),
    Vector3.new(-32.67, 0.74999994, -5.48),
    Vector3.new(-24.88, 0, 30.4),
    Vector3.new(7.12, 0, -15.19),
    Vector3.new(-32.71, 0, 13.97),
    Vector3.new(-3.66, 0, -16.03),
    Vector3.new(-35.43, 0, 25.99),
    Vector3.new(-18.919998, 0.74999994, -3.73),
    Vector3.new(-22.86, 0, 3.95),
    Vector3.new(-26.73, 0, 10.32),
    Vector3.new(-27.64, 0, 19.99),
    Vector3.new(-8.02, 0, -12.42),
    Vector3.new(12.86, 0, 0.39),
    Vector3.new(20.43, 0, -3.17),
    Vector3.new(5.5, 0, 19.31),
    Vector3.new(0.34, 0, 21.31),
    Vector3.new(-24.66, 0, 23.73),
    Vector3.new(-32.85, 0.74999994, -11.48),
    Vector3.new(-25.64, 0.74999994, -12.25),
    Vector3.new(-7.04, 0, 5.26),
    Vector3.new(0.75, 0, -11.58),
    Vector3.new(-0.06, 0, 15.39),
    Vector3.new(-32.63, 0, 20.51),
    Vector3.new(-16.72, 0, 1.99),
    Vector3.new(13.71, 0, -6.42),
    Vector3.new(20.8, 0, 1.08),
    Vector3.new(10.55, 0, -3.12),
    Vector3.new(-0.27, 0, 7.75),
    Vector3.new(-22.419998, 0.74999994, -7.73),
    Vector3.new(-31.11, 0, 33.78),
    Vector3.new(5.7, 0, -8.42),
    Vector3.new(24.03, 0, -6.51),
    Vector3.new(-28.79, 0.74999994, -8.17),
    Vector3.new(19.89, 0, -9.23),
    Vector3.new(-33.73, 0, 6.31),
    Vector3.new(-10.02, 0, 8.91),
    Vector3.new(4.18, 0, 11.08),
    Vector3.new(-5.26, 0, -7.79),
    Vector3.new(-8.29, 0, -1.33),
    Vector3.new(-21.919998, 0.74999994, -15.23),
    Vector3.new(5.36, 0, 21.76),
    Vector3.new(16.77, 0, -4.6),
    Vector3.new(-36.62, 0, 2.61),
    Vector3.new(-6.74, 0, 20.42),
    Vector3.new(-5.45, 0, 17.53),
    Vector3.new(-25.81, 0, 15.75),
    Vector3.new(-29.91, 0, 27.51),
    Vector3.new(-36.62, 0, 9.38),
    Vector3.new(7.57, 0, 5.79),
    Vector3.new(-5.43, 0, 11.44),
    Vector3.new(-17.92, 0, 8.49)
}

local cashItems = {}
local availablePoints = {}

local collectedCashPerPlayer = {}

function isInTable(item, table)
    for i, value in ipairs(table) do
        if value == item then
            return true
        end
    end
    return false
end

function ShuffleCash()
    math.randomseed(os.time())
    collectedCashPerPlayer = {}
    availablePoints = {}
    local newCashPositions = {}

    for i, point in ipairs(cashPoints) do
        table.insert(availablePoints, {point, i})
    end

    for each, cash in ipairs(cashItems) do
        local newPosData = availablePoints[math.random(1, #availablePoints)]
        local newPos = newPosData[1] + Vector3.new(26.46,0,76.11) + Vector3.new(math.random()*math.random(-1,1), 0, math.random()*math.random(-1,1))
        local posIndex = newPosData[2]
        cash.transform.position = newPos

        table.remove(availablePoints, posIndex)

        table.insert(newCashPositions, {cash, newPos})
    end

    resetCashEvent:FireAllClients(newCashPositions)

end

function self:ServerAwake()
    for i = 1, 10 do
        local cash = GameObject.Instantiate(cashprefab)
        cash:GetComponent(CashItemScript).cashSpawner = self
        table.insert(cashItems, cash)
    end
    ShuffleCash()

    collectRequest:Connect(function(player, object)
        if not collectedCashPerPlayer[player] then
            collectedCashPerPlayer[player] = {}
        end
        if isInTable(object, collectedCashPerPlayer[player]) then
            return
        end

        table.insert(collectedCashPerPlayer[player], object)
        playerTracker.IncrementTokensServer(player, 1)
    end)

    server.PlayerDisconnected:Connect(function(player)
        collectedCashPerPlayer[player] = nil
    end)
end