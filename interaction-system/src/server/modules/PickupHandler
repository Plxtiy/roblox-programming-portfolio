-- // Plxtiy Scripted 
-- // Date: 10/6/2026

local ServerStorage = game:GetService("ServerStorage")
local PickupHandler = {}

function PickupHandler.Interact(pickup, player)
	-- Prevent the same pickup from being claimed twice.
	if pickup:GetAttribute("Collected") then
		return false
	end

	local toolName = pickup:GetAttribute("ToolName")

	if typeof(toolName) ~= "string" or toolName == "" then
		warn("Pickup needs a ToolName attribute:", pickup.Name)
		return false
	end

	local toolsFolder = ServerStorage:FindFirstChild("InteractionTools")
	local template = toolsFolder and toolsFolder:FindFirstChild(toolName)

	if not template or not template:IsA("Tool") then
		warn("No Tool template found for pickup:", toolName)
		return false
	end

	local backpack = player:FindFirstChildOfClass("Backpack")

	local tool = template:Clone()

	-- Claim it before giving the item to the player.
	pickup:SetAttribute("Collected", true)
	tool.Parent = backpack

	pickup:Destroy()
	return true
end

return PickupHandler
