-- // Plxtiy Scripted 
-- // Date: 10/6/2026

local TweenService = game:GetService("TweenService")

local DoorHandler = {}
local doorStates = setmetatable({}, { __mode = "k" })

function DoorHandler.Interact(door, config)
	if not door:IsA("Model") or not door.PrimaryPart then
		warn("Door must be a Model with a PrimaryPart:", door.Name)
		return false
	end

	local state = doorStates[door]

	if not state then
		state = {
			ClosedPivot = door:GetPivot(),
			IsOpen = false,
			IsMoving = false,
		}

		doorStates[door] = state
	end

	-- Ignore interactions while the door is moving.
	if state.IsMoving then
		return false
	end

	state.IsMoving = true

	local opening = not state.IsOpen
	local targetPivot = state.ClosedPivot

	if opening then
		targetPivot = state.ClosedPivot * CFrame.Angles(
			0,
			math.rad(config.Door.OpenAngle),
			0
		)
	end

	-- Tween a CFrame value, then apply it to the model.
	local pivotValue = Instance.new("CFrameValue")
	pivotValue.Value = door:GetPivot()

	local connection = pivotValue:GetPropertyChangedSignal("Value"):Connect(function()
		if door.Parent then
			door:PivotTo(pivotValue.Value)
		end
	end)

	local tween = TweenService:Create( -- Creates tween for door using Config module for duration value.
		pivotValue,
		TweenInfo.new(
			config.Door.TweenDuration,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.InOut
		),
		{ Value = targetPivot }
	)

	tween.Completed:Once(function()
		connection:Disconnect()
		pivotValue:Destroy()

		state.IsOpen = opening
		state.IsMoving = false
	end)

	tween:Play()
	return true
end

return DoorHandler
