--!strict
-- Responsive UI teaching template, not a finished game screen.
-- Place as a LocalScript in StarterPlayerScripts for this demonstration.
-- Preview on real target viewports and replace demo colors/copy to match the game.

local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui") :: PlayerGui
local guiName = "RobloxStudioProResponsivePanelExample"

-- Avoid silently deleting an existing screen or duplicating this demo.
if playerGui:FindFirstChild(guiName) then
	warn(("%s already exists; remove the old demo explicitly before rerunning."):format(guiName))
	return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 5

local openButton = Instance.new("TextButton")
openButton.Name = "OpenPanelButton"
openButton.AnchorPoint = Vector2.new(0, 0)
openButton.Position = UDim2.new(0, 16, 0, 16)
openButton.Size = UDim2.new(0, 148, 0, 48)
openButton.BackgroundColor3 = Color3.fromRGB(62, 118, 245)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Text = "Open example"
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamSemibold
openButton.Selectable = true

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openButton

local openTextLimit = Instance.new("UITextSizeConstraint")
openTextLimit.MinTextSize = 14
openTextLimit.MaxTextSize = 18
openTextLimit.Parent = openButton

local panel = Instance.new("Frame")
panel.Name = "ExamplePanel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.new(0.9, 0, 0.78, 0)
panel.BackgroundColor3 = Color3.fromRGB(25, 29, 40)
panel.Visible = true
panel.ClipsDescendants = true

local panelBounds = Instance.new("UISizeConstraint")
panelBounds.MaxSize = Vector2.new(560, 420)
panelBounds.Parent = panel

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 16)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(77, 89, 113)
panelStroke.Thickness = 1
panelStroke.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.new(0, 18, 0, 14)
title.Size = UDim2.new(1, -76, 0, 42)
title.BackgroundTransparency = 1
title.Text = "Responsive panel"
title.TextColor3 = Color3.fromRGB(245, 247, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local titleTextLimit = Instance.new("UITextSizeConstraint")
titleTextLimit.MinTextSize = 18
titleTextLimit.MaxTextSize = 26
titleTextLimit.Parent = title

title.Parent = panel

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Position = UDim2.new(1, -14, 0, 14)
closeButton.Size = UDim2.new(0, 42, 0, 42)
closeButton.BackgroundColor3 = Color3.fromRGB(48, 55, 70)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "Close"
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamMedium
closeButton.Selectable = true

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

local closeTextLimit = Instance.new("UITextSizeConstraint")
closeTextLimit.MinTextSize = 12
closeTextLimit.MaxTextSize = 16
closeTextLimit.Parent = closeButton

closeButton.Parent = panel

local body = Instance.new("TextLabel")
body.Name = "Body"
body.Position = UDim2.new(0, 18, 0, 68)
body.Size = UDim2.new(1, -36, 1, -154)
body.BackgroundTransparency = 1
body.Text = "Centered, size-bounded demo. Replace this copy, then verify every supported viewport and input mode."
body.TextColor3 = Color3.fromRGB(210, 216, 230)
body.TextWrapped = true
body.TextXAlignment = Enum.TextXAlignment.Left
body.TextYAlignment = Enum.TextYAlignment.Top
body.TextScaled = true
body.Font = Enum.Font.Gotham

local bodyTextLimit = Instance.new("UITextSizeConstraint")
bodyTextLimit.MinTextSize = 14
bodyTextLimit.MaxTextSize = 18
bodyTextLimit.Parent = body

body.Parent = panel

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Position = UDim2.new(0, 18, 1, -78)
status.Size = UDim2.new(1, -36, 0, 24)
status.BackgroundTransparency = 1
status.Text = "Demo only — no server action connected."
status.TextColor3 = Color3.fromRGB(184, 194, 214)
status.TextScaled = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.Gotham

local statusTextLimit = Instance.new("UITextSizeConstraint")
statusTextLimit.MinTextSize = 11
statusTextLimit.MaxTextSize = 14
statusTextLimit.Parent = status

status.Parent = panel

local actionButton = Instance.new("TextButton")
actionButton.Name = "DemoActionButton"
actionButton.AnchorPoint = Vector2.new(0.5, 1)
actionButton.Position = UDim2.new(0.5, 0, 1, -14)
actionButton.Size = UDim2.new(1, -36, 0, 48)
actionButton.BackgroundColor3 = Color3.fromRGB(62, 118, 245)
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.Text = "Try a local demo action"
actionButton.TextScaled = true
actionButton.Font = Enum.Font.GothamSemibold
actionButton.Selectable = true

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 10)
actionCorner.Parent = actionButton

local actionTextLimit = Instance.new("UITextSizeConstraint")
actionTextLimit.MinTextSize = 13
actionTextLimit.MaxTextSize = 17
actionTextLimit.Parent = actionButton

actionButton.Parent = panel

openButton.Activated:Connect(function()
	panel.Visible = true
end)

closeButton.Activated:Connect(function()
	panel.Visible = false
end)

actionButton.Activated:Connect(function()
	status.Text = "Local UI event received. Connect real gameplay through a validated server contract."
end)

openButton.Parent = screenGui
panel.Parent = screenGui
screenGui.Parent = playerGui
