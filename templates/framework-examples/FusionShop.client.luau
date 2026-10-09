--!strict
-- Fusion 0.3 example. This file intentionally uses the versioned 0.3 scope API.
-- Place this LocalScript in StarterPlayerScripts; install Fusion under ReplicatedStorage/Packages/Fusion.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local FusionModule = Packages:WaitForChild("Fusion")
assert(FusionModule:IsA("ModuleScript"), "ReplicatedStorage.Packages.Fusion must be a ModuleScript")
local Fusion = require(FusionModule)

local remotes = ReplicatedStorage:WaitForChild("ShopRemotes")
local SnapshotRequest = remotes:WaitForChild("SnapshotRequest") :: RemoteEvent
local SnapshotResult = remotes:WaitForChild("SnapshotResult") :: RemoteEvent
local PurchaseRequest = remotes:WaitForChild("PurchaseRequest") :: RemoteEvent
local PurchaseResult = remotes:WaitForChild("PurchaseResult") :: RemoteEvent

local ITEM_ID = "starter_blade"
local ITEM_PRICE = 40
local RESPONSE_TIMEOUT_SECONDS = 12

local REASON_MESSAGES: { [string]: string } = {
	PURCHASED = "Demo ownership recorded for this server.",
	NOT_ENOUGH_COINS = "Not enough coins.",
	ALREADY_OWNED = "You already own this item.",
	UNKNOWN_ITEM = "That item is no longer available.",
	INVALID_REQUEST = "The request was invalid.",
	COOLDOWN = "Please wait a moment and try again.",
}

local function asRecord(value: unknown): { [string]: unknown }?
	if typeof(value) ~= "table" then
		return nil
	end
	return value :: { [string]: unknown }
end

local function isNonNegativeNumber(value: unknown): boolean
	return typeof(value) == "number" and value == value and value >= 0 and value < math.huge
end

local function ownsItem(record: { [string]: unknown }): boolean
	local rawOwned = record.owned
	if typeof(rawOwned) ~= "table" then
		return false
	end
	local owned = rawOwned :: { [string]: unknown }
	return owned[ITEM_ID] == true
end

local function statusMessage(ok: boolean, reason: unknown): string
	if ok then
		if typeof(reason) == "string" then
			return REASON_MESSAGES[reason] or "Purchase complete."
		end
		return "Purchase complete."
	end
	if typeof(reason) == "string" then
		return REASON_MESSAGES[reason] or "Purchase declined by the server."
	end
	return "Purchase declined by the server."
end

local scope = Fusion.scoped(Fusion)
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local loaded = scope:Value(false)
local coins = scope:Value(0)
local owned = scope:Value(false)
local pending = scope:Value(false)
local isOpen = scope:Value(true)
local message = scope:Value("Loading shop…")

local canPurchase = scope:Computed(function(use)
	return use(loaded) and not use(pending) and not use(owned) and use(coins) >= ITEM_PRICE
end)
local canRefresh = scope:Computed(function(use)
	return not use(pending)
end)

local purchaseText = scope:Computed(function(use)
	if not use(loaded) then
		return "Loading…"
	elseif use(pending) then
		return "Processing…"
	elseif use(owned) then
		return "Already owned"
	elseif use(coins) < ITEM_PRICE then
		return "Need 40 coins"
	end
	return "Buy Starter Blade · 40 coins"
end)

local balanceText = scope:Computed(function(use)
	if not use(loaded) then
		return "Coins: …"
	end
	return `Coins: {use(coins)}`
end)

local purchaseColor = scope:Spring(scope:Computed(function(use)
	if use(canPurchase) then
		return Color3.fromRGB(59, 133, 255)
	end
	return Color3.fromRGB(70, 78, 96)
end), 24, 0.85)

local active = true
local nextRequestId = 0
local pendingRequestId: number? = nil
local timeoutThread: thread? = nil
local lastSnapshotRequestAt: number? = nil

local function cancelTimeout()
	if timeoutThread ~= nil then
		pcall(task.cancel, timeoutThread)
		timeoutThread = nil
	end
end

table.insert(scope, script.Destroying:Connect(function()
	active = false
	pendingRequestId = nil
	cancelTimeout()
	scope:doCleanup()
end))

local function requestSnapshot()
	if not active or pendingRequestId ~= nil then
		return
	end
	local now = os.clock()
	if lastSnapshotRequestAt ~= nil and now - lastSnapshotRequestAt < 0.6 then
		return
	end
	lastSnapshotRequestAt = now
	message:set(if Fusion.peek(loaded) then "Refreshing shop state…" else "Loading shop state…")
	SnapshotRequest:FireServer()
end

local function requestPurchase()
	if not active or not Fusion.peek(canPurchase) or pendingRequestId ~= nil then
		return
	end

	nextRequestId = (nextRequestId % 2_000_000_000) + 1
	local requestId = nextRequestId
	pendingRequestId = requestId
	pending:set(true)
	message:set("Waiting for the server…")

	timeoutThread = task.delay(RESPONSE_TIMEOUT_SECONDS, function()
		if not active or pendingRequestId ~= requestId then
			return
		end
		pendingRequestId = nil
		timeoutThread = nil
		pending:set(false)
		message:set("No reply yet. Refresh your state before retrying.")
	end)

	-- Send intent only. The server owns the price, balance check, and item grant.
	PurchaseRequest:FireServer({ requestId = requestId, itemId = ITEM_ID })
end

table.insert(scope, SnapshotResult.OnClientEvent:Connect(function(rawPayload: unknown)
	if not active then
		return
	end
	local payload = asRecord(rawPayload)
	if payload == nil or not isNonNegativeNumber(payload.coins) then
		return
	end

	coins:set(payload.coins :: number)
	owned:set(ownsItem(payload))
	loaded:set(true)
	if pendingRequestId == nil then
		message:set("Shop state synchronized.")
	end
end))

table.insert(scope, PurchaseResult.OnClientEvent:Connect(function(rawPayload: unknown)
	if not active then
		return
	end
	local payload = asRecord(rawPayload)
	if payload == nil
		or typeof(payload.requestId) ~= "number"
		or typeof(payload.ok) ~= "boolean"
		or not isNonNegativeNumber(payload.coins)
	then
		return
	end

	local requestId = payload.requestId :: number
	if requestId ~= pendingRequestId then
		return -- Ignore late replies for an older request.
	end

	cancelTimeout()
	pendingRequestId = nil
	pending:set(false)
	coins:set(payload.coins :: number)
	owned:set(ownsItem(payload))
	message:set(statusMessage(payload.ok :: boolean, payload.reason))
end))

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

scope:New "ScreenGui" {
	Name = "AdvancedShopFusion",
	ResetOnSpawn = false,
	DisplayOrder = 30,
	IgnoreGuiInset = false,
	Parent = playerGui,
	[Children] = {
		scope:New "Frame" {
			Name = "ShopPanel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.52),
			Size = UDim2.new(0.92, 0, 0, 248),
			BackgroundColor3 = Color3.fromRGB(24, 29, 42),
			BorderSizePixel = 0,
			Visible = isOpen,
			[Children] = {
				scope:New "UISizeConstraint" {
					MaxSize = Vector2.new(440, 280),
					MinSize = Vector2.new(0, 230),
				},
				scope:New "UICorner" {
					CornerRadius = UDim.new(0, 14),
				},
				scope:New "TextLabel" {
					Name = "Title",
					Position = UDim2.fromOffset(18, 16),
					Size = UDim2.new(1, -36, 0, 32),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					Text = "FIELD SUPPLY",
					TextColor3 = Color3.fromRGB(242, 245, 255),
					TextSize = 20,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
				scope:New "TextLabel" {
					Name = "Balance",
					Position = UDim2.fromOffset(18, 58),
					Size = UDim2.new(1, -36, 0, 28),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = balanceText,
					TextColor3 = Color3.fromRGB(159, 213, 255),
					TextSize = 16,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
				scope:New "TextLabel" {
					Name = "Status",
					Position = UDim2.fromOffset(18, 94),
					Size = UDim2.new(1, -36, 0, 38),
					BackgroundTransparency = 1,
					Font = Enum.Font.Gotham,
					Text = message,
					TextColor3 = Color3.fromRGB(194, 200, 214),
					TextSize = 13,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
				scope:New "TextButton" {
					Name = "BuyButton",
					Position = UDim2.fromOffset(18, 142),
					Size = UDim2.new(1, -36, 0, 48),
					BackgroundColor3 = purchaseColor,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Active = canPurchase,
					Selectable = true,
					Font = Enum.Font.GothamBold,
					Text = purchaseText,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					TextWrapped = true,
					[OnEvent "Activated"] = function()
						requestPurchase()
					end,
					[Children] = {
						scope:New "UICorner" {
							CornerRadius = UDim.new(0, 10),
						},
					},
				},
				scope:New "TextButton" {
					Name = "RefreshButton",
					Position = UDim2.fromOffset(18, 200),
					Size = UDim2.new(1, -36, 0, 30),
					BackgroundTransparency = 1,
					AutoButtonColor = true,
					Active = canRefresh,
					Selectable = true,
					Font = Enum.Font.GothamMedium,
					Text = "Refresh balance and ownership",
					TextColor3 = Color3.fromRGB(174, 185, 210),
					TextSize = 12,
					[OnEvent "Activated"] = requestSnapshot,
				},
			},
		},
		scope:New "TextButton" {
			Name = "ShopToggle",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -18, 0, 18),
			Size = UDim2.fromOffset(120, 42),
			BackgroundColor3 = Color3.fromRGB(35, 44, 63),
			BorderSizePixel = 0,
			AutoButtonColor = true,
			Font = Enum.Font.GothamBold,
			Text = scope:Computed(function(use)
				return if use(isOpen) then "Hide shop" else "Open shop"
			end),
			TextColor3 = Color3.fromRGB(242, 245, 255),
			TextSize = 13,
			[OnEvent "Activated"] = function()
				isOpen:set(not Fusion.peek(isOpen))
			end,
			[Children] = {
				scope:New "UICorner" {
					CornerRadius = UDim.new(0, 10),
				},
			},
		},
	},
}

requestSnapshot()
