--!strict
-- Demonstration only: balances and ownership are in-memory and reset on server restart.
-- Replace these tables with the experience's existing server-side profile/economy service.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local STARTING_COINS = 100
local MAX_REQUEST_ID = 2_147_483_647
local PURCHASE_COOLDOWN_SECONDS = 0.4
local SNAPSHOT_COOLDOWN_SECONDS = 0.5
local ITEM_ID = "starter_blade"
local ITEM_PRICE = 40

type OwnedItems = { [string]: boolean }

local function getOrCreateFolder(parent: Instance, name: string): Folder
	local existing = parent:FindFirstChild(name)
	if existing ~= nil then
		assert(existing:IsA("Folder"), name .. " must be a Folder")
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function getOrCreateRemoteEvent(parent: Instance, name: string): RemoteEvent
	local existing = parent:FindFirstChild(name)
	if existing ~= nil then
		assert(existing:IsA("RemoteEvent"), name .. " must be a RemoteEvent")
		return existing
	end

	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = parent
	return remote
end

local remoteFolder = getOrCreateFolder(ReplicatedStorage, "ShopRemotes")
local snapshotRequest = getOrCreateRemoteEvent(remoteFolder, "SnapshotRequest")
local snapshotResult = getOrCreateRemoteEvent(remoteFolder, "SnapshotResult")
local purchaseRequest = getOrCreateRemoteEvent(remoteFolder, "PurchaseRequest")
local purchaseResult = getOrCreateRemoteEvent(remoteFolder, "PurchaseResult")

local balanceByPlayer: { [Player]: number } = {}
local ownedByPlayer: { [Player]: OwnedItems } = {}
local lastPurchaseAt: { [Player]: number } = {}
local lastSnapshotAt: { [Player]: number } = {}

local function ensurePlayer(player: Player)
	if balanceByPlayer[player] == nil then
		balanceByPlayer[player] = STARTING_COINS
		ownedByPlayer[player] = {}
	end
end

local function copyOwnedItems(player: Player): OwnedItems
	local copy: OwnedItems = {}
	for itemId, isOwned in pairs(ownedByPlayer[player] or {}) do
		if isOwned then
			copy[itemId] = true
		end
	end
	return copy
end

local function sendSnapshot(player: Player)
	ensurePlayer(player)
	snapshotResult:FireClient(player, {
		coins = balanceByPlayer[player] or 0,
		owned = copyOwnedItems(player),
	})
end

local function sendPurchaseResult(player: Player, requestId: number, ok: boolean, reason: string)
	purchaseResult:FireClient(player, {
		requestId = requestId,
		ok = ok,
		reason = reason,
		coins = balanceByPlayer[player] or 0,
		owned = copyOwnedItems(player),
	})
end

local function isValidRequestId(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value % 1 == 0
		and value >= 1
		and value <= MAX_REQUEST_ID
end

for _, player in Players:GetPlayers() do
	ensurePlayer(player)
end
Players.PlayerAdded:Connect(ensurePlayer)

snapshotRequest.OnServerEvent:Connect(function(player: Player)
	ensurePlayer(player)
	local now = os.clock()
	local lastSent = lastSnapshotAt[player]
	if lastSent ~= nil and now - lastSent < SNAPSHOT_COOLDOWN_SECONDS then
		return
	end
	lastSnapshotAt[player] = now
	sendSnapshot(player)
end)

purchaseRequest.OnServerEvent:Connect(function(player: Player, rawPayload: unknown)
	ensurePlayer(player)
	if typeof(rawPayload) ~= "table" then
		return
	end

	local payload = rawPayload :: { [string]: unknown }
	local rawRequestId = payload.requestId
	if not isValidRequestId(rawRequestId) then
		return
	end
	local requestId = rawRequestId :: number
	local now = os.clock()
	local lastRequestAt = lastPurchaseAt[player]
	if lastRequestAt ~= nil and now - lastRequestAt < PURCHASE_COOLDOWN_SECONDS then
		sendPurchaseResult(player, requestId, false, "COOLDOWN")
		return
	end
	lastPurchaseAt[player] = now

	local itemId = payload.itemId
	if typeof(itemId) ~= "string" or #itemId < 1 or #itemId > 32 then
		sendPurchaseResult(player, requestId, false, "INVALID_REQUEST")
		return
	end
	if itemId ~= ITEM_ID then
		sendPurchaseResult(player, requestId, false, "UNKNOWN_ITEM")
		return
	end

	local ownedItems = ownedByPlayer[player]
	local currentBalance = balanceByPlayer[player] or 0
	if ownedItems == nil then
		return
	elseif ownedItems[itemId] then
		-- Duplicate/retried requests cannot charge for an already-owned demo item.
		sendPurchaseResult(player, requestId, false, "ALREADY_OWNED")
	elseif currentBalance < ITEM_PRICE then
		sendPurchaseResult(player, requestId, false, "NOT_ENOUGH_COINS")
	else
		-- The server chooses the price and grants ownership; the client sends neither.
		balanceByPlayer[player] = currentBalance - ITEM_PRICE
		ownedItems[itemId] = true
		sendPurchaseResult(player, requestId, true, "PURCHASED")
	end
end)

Players.PlayerRemoving:Connect(function(player: Player)
	balanceByPlayer[player] = nil
	ownedByPlayer[player] = nil
	lastPurchaseAt[player] = nil
	lastSnapshotAt[player] = nil
end)
