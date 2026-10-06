-- // Plxtiy Scripted 
-- // Date: 10/6/2026

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("InteractionConfig"))
local handlersFolder = script.Parent:WaitForChild("InteractionHandlers")

local DoorHandler = require(handlersFolder:WaitForChild("DoorHandler"))
local PickupHandler = require(handlersFolder:WaitForChild("PickupHandler"))

local registered = {}
local lastInteraction = {}

-- Each interaction type defines its label and behavior.
local handlers = {
	Door = {
		ActionText = "Open / Close",

		Interact = function(object, player)
			return DoorHandler.Interact(object, Config)
		end,
	},

	Pickup = {
		ActionText = "Pick Up",

		Interact = function(object, player)
			return PickupHandler.Interact(object, player)
		end,
	},
}

local function unregisterObject(object)
	local entry = registered[object]

	if not entry then
		return
	end

	registered[object] = nil

	entry.TriggerConnection:Disconnect()
	entry.DestroyConnection:Disconnect()
	entry.Prompt:Destroy()
end

local function registerObject(object)
	if registered[object] then
		return
	end

	local interactionType = object:GetAttribute("InteractionType")
	local handler = handlers[interactionType]

	if not handler then
		warn("Unknown InteractionType on:", object.Name)
		return
	end

	local promptPart

	if object:IsA("Model") then
		promptPart = object.PrimaryPart
	elseif object:IsA("BasePart") then
		promptPart = object
	end

	if not promptPart then
		warn("Interactable needs a BasePart or Model with Primary Part:", object.Name)
		return
	end

	if interactionType == "Door" and not object:IsA("Model") then
		warn("Door interactions require a Model:", object.Name)
		return
	end

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "InteractionPrompt"
	prompt.ActionText = handler.ActionText
	prompt.ObjectText = object.Name
	prompt.KeyboardKeyCode = Config.Prompt.KeyboardKeyCode
	prompt.HoldDuration = Config.Prompt.HoldDuration
	prompt.RequiresLineOfSight = Config.Prompt.RequiresLineOfSight
	prompt.MaxActivationDistance = Config.MaxDistance
	prompt.Parent = promptPart

	local triggerConnection = prompt.Triggered:Connect(function(player)
		if not prompt.Enabled or not object:IsDescendantOf(workspace) then
			return
		end

		if not CollectionService:HasTag(object, Config.Tag) then
			return
		end

		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not humanoid or humanoid.Health <= 0 or not root then
			return
		end

		local distance = (root.Position - promptPart.Position).Magnitude

		if distance > Config.MaxDistance then
			return
		end

		local now = os.clock()
		local previous = lastInteraction[player]

		if previous and now - previous < Config.Cooldown then
			return
		end

		lastInteraction[player] = now
		handler.Interact(object, player)
	end)

	local destroyConnection = object.Destroying:Connect(function()
		unregisterObject(object)
	end)

	registered[object] = {
		Prompt = prompt,
		TriggerConnection = triggerConnection,
		DestroyConnection = destroyConnection,
	}
end

CollectionService:GetInstanceAddedSignal(Config.Tag):Connect(registerObject)
CollectionService:GetInstanceRemovedSignal(Config.Tag):Connect(unregisterObject)

for _, object in CollectionService:GetTagged(Config.Tag) do
	registerObject(object)
end

Players.PlayerRemoving:Connect(function(player)
	lastInteraction[player] = nil
end)
