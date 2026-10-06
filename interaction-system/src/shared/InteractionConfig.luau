-- // Plxtiy Scripted 
-- // Date: 10/6/2026

local InteractionConfig = {
	Tag = "Interactable", -- Anything with this Tag will be picked up by script.
	
	MaxDistance = 10,
	Cooldown = 0.5, 
	
	Prompt = {
		KeyboardKeyCode = Enum.KeyCode.E, -- Change "E" to whatever key you want it to be. 
		HoldDuration = 0, -- How long the ProximityPrompt needs to be held.
		RequiresLineOfSight = true,
	},
	
	Door = {
		OpenAngle = 90, -- How wide the door opens. 
		TweenDuration = 0.6, -- This can be changed. 
	}
	
}

return InteractionConfig
