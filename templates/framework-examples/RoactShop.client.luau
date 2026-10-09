--!strict
-- Roact 1.x example for an existing Roact project. Upstream marks Roact deprecated.
-- Place this LocalScript in StarterPlayerScripts and install Roact at ReplicatedStorage/Packages/Roact.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local RoactModule = Packages:WaitForChild("Roact")
assert(RoactModule:IsA("ModuleScript"), "ReplicatedStorage.Packages.Roact must be a ModuleScript")
local Roact = require(RoactModule)

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

local ShopPanel = Roact.Component:extend("AdvancedShopPanel")

function ShopPanel:init()
	self._mounted = false
	self._nextRequestId = 0
	self._pendingRequestId = nil
	self._timeoutThread = nil
	self._lastSnapshotRequestAt = nil
	self._connections = {}
	self:setState({
		loaded = false,
		coins = 0,
		owned = false,
		pending = false,
		message = "Loading shop…",
	})
end

function ShopPanel:cancelTimeout()
	if self._timeoutThread ~= nil then
		pcall(task.cancel, self._timeoutThread)
		self._timeoutThread = nil
	end
end

function ShopPanel:requestSnapshot()
	if not self._mounted or self._pendingRequestId ~= nil then
		return
	end
	local now = os.clock()
	if self._lastSnapshotRequestAt ~= nil and now - self._lastSnapshotRequestAt < 0.6 then
		return
	end
	self._lastSnapshotRequestAt = now
	self:setState({ message = if self.state.loaded then "Refreshing shop state…" else "Loading shop state…" })
	SnapshotRequest:FireServer()
end

function ShopPanel:requestPurchase()
	if not self._mounted
		or not self.state.loaded
		or self.state.pending
		or self.state.owned
		or self.state.coins < ITEM_PRICE
		or self._pendingRequestId ~= nil
	then
		return
	end

	self._nextRequestId = (self._nextRequestId % 2_000_000_000) + 1
	local requestId = self._nextRequestId
	self._pendingRequestId = requestId
	self:setState({ pending = true, message = "Waiting for the server…" })

	self._timeoutThread = task.delay(RESPONSE_TIMEOUT_SECONDS, function()
		if not self._mounted or self._pendingRequestId ~= requestId then
			return
		end
		self._pendingRequestId = nil
		self._timeoutThread = nil
		self:setState({
			pending = false,
			message = "No reply yet. Refresh your state before retrying.",
		})
	end)

	-- Send intent only. The server owns the price, balance check, and item grant.
	PurchaseRequest:FireServer({ requestId = requestId, itemId = ITEM_ID })
end

function ShopPanel:didMount()
	self._mounted = true

	table.insert(self._connections, SnapshotResult.OnClientEvent:Connect(function(rawPayload: unknown)
		if not self._mounted then
			return
		end
		local payload = asRecord(rawPayload)
		if payload == nil or not isNonNegativeNumber(payload.coins) then
			return
		end
		local coins = payload.coins :: number
		local itemOwned = ownsItem(payload)

		task.defer(function()
			if not self._mounted then
				return
			end
			self:setState({
				loaded = true,
				coins = coins,
				owned = itemOwned,
				message = if self._pendingRequestId == nil then "Shop state synchronized." else self.state.message,
			})
		end)
	end))

	table.insert(self._connections, PurchaseResult.OnClientEvent:Connect(function(rawPayload: unknown)
		if not self._mounted then
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
		if requestId ~= self._pendingRequestId then
			return -- Ignore late replies for an older request.
		end
		local ok = payload.ok :: boolean
		local coins = payload.coins :: number
		local itemOwned = ownsItem(payload)
		local message = statusMessage(ok, payload.reason)

		task.defer(function()
			if not self._mounted or self._pendingRequestId ~= requestId then
				return
			end
			self:cancelTimeout()
			self._pendingRequestId = nil
			self:setState({
				loaded = true,
				coins = coins,
				owned = itemOwned,
				pending = false,
				message = message,
			})
		end)
	end))

	self:requestSnapshot()
end

function ShopPanel:willUnmount()
	self._mounted = false
	self._pendingRequestId = nil
	self:cancelTimeout()
	for _, connection in self._connections do
		connection:Disconnect()
	end
	table.clear(self._connections)
end

function ShopPanel:render()
	local state = self.state
	local canPurchase = state.loaded and not state.pending and not state.owned and state.coins >= ITEM_PRICE
	local purchaseText = if not state.loaded
		then "Loading…"
		elseif state.pending
		then "Processing…"
		elseif state.owned
		then "Already owned"
		elseif state.coins < ITEM_PRICE
		then "Need 40 coins"
		else "Buy Starter Blade · 40 coins"

	return Roact.createElement("ScreenGui", {
		Name = "AdvancedShopRoact",
		ResetOnSpawn = false,
		DisplayOrder = 30,
	}, {
		Panel = Roact.createElement("Frame", {
			Name = "ShopPanel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.52),
			Size = UDim2.new(0.92, 0, 0, 248),
			BackgroundColor3 = Color3.fromRGB(24, 29, 42),
			BorderSizePixel = 0,
		}, {
			SizeLimit = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(440, 280),
				MinSize = Vector2.new(0, 230),
			}),
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 14),
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 16),
				PaddingBottom = UDim.new(0, 16),
				PaddingLeft = UDim.new(0, 18),
				PaddingRight = UDim.new(0, 18),
			}),
			Title = Roact.createElement("TextLabel", {
				Name = "Title",
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				Text = "FIELD SUPPLY",
				TextColor3 = Color3.fromRGB(242, 245, 255),
				TextSize = 20,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			Balance = Roact.createElement("TextLabel", {
				Name = "Balance",
				Position = UDim2.fromOffset(0, 42),
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = if state.loaded then `Coins: {state.coins}` else "Coins: …",
				TextColor3 = Color3.fromRGB(159, 213, 255),
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			Status = Roact.createElement("TextLabel", {
				Name = "Status",
				Position = UDim2.fromOffset(0, 78),
				Size = UDim2.new(1, 0, 0, 38),
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				Text = state.message,
				TextColor3 = Color3.fromRGB(194, 200, 214),
				TextSize = 13,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			BuyButton = Roact.createElement("TextButton", {
				Name = "BuyButton",
				Position = UDim2.fromOffset(0, 126),
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundColor3 = if canPurchase then Color3.fromRGB(59, 133, 255) else Color3.fromRGB(70, 78, 96),
				BorderSizePixel = 0,
				AutoButtonColor = canPurchase,
				Active = canPurchase,
				Selectable = true,
				Font = Enum.Font.GothamBold,
				Text = purchaseText,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				TextWrapped = true,
				[Roact.Event.Activated] = function()
					-- Deferral avoids a synchronous setState during Roact reconciliation.
					task.defer(function()
						if self._mounted then
							self:requestPurchase()
						end
					end)
				end,
			}, {
				Corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
			}),
			RefreshButton = Roact.createElement("TextButton", {
				Name = "RefreshButton",
				Position = UDim2.fromOffset(0, 184),
				Size = UDim2.new(1, 0, 0, 34),
				BackgroundTransparency = 1,
				AutoButtonColor = true,
				Active = not state.pending,
				Selectable = true,
				Font = Enum.Font.GothamMedium,
				Text = "Refresh balance and ownership",
				TextColor3 = Color3.fromRGB(174, 185, 210),
				TextSize = 12,
				[Roact.Event.Activated] = function()
					task.defer(function()
						if self._mounted then
							self:requestSnapshot()
						end
					end)
				end,
			}),
		}),
	})
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local handle = Roact.mount(Roact.createElement(ShopPanel), playerGui, "AdvancedShopRoact")

local destroyConnection: RBXScriptConnection?
destroyConnection = script.Destroying:Connect(function()
	if destroyConnection ~= nil then
		destroyConnection:Disconnect()
		destroyConnection = nil
	end
	Roact.unmount(handle)
end)
