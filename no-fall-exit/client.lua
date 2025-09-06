local wasInVehicle = false

local function preventRagdollAndStand(playerPed)
	if not DoesEntityExist(playerPed) then return end

	SetPedCanRagdoll(playerPed, false)
	ResetPedRagdollTimer(playerPed)
	ClearPedSecondaryTask(playerPed)
	ClearPedTasksImmediately(playerPed)

	local playerCoords = GetEntityCoords(playerPed)
	local foundGround, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, false)
	if foundGround then
		SetEntityCoordsNoOffset(playerPed, playerCoords.x, playerCoords.y, groundZ, true, true, true)
	end

	TaskStandStill(playerPed, 500)

	local holdUntil = GetGameTimer() + 1000
	while GetGameTimer() < holdUntil do
		ResetPedRagdollTimer(playerPed)
		Wait(0)
	end

	SetPedCanRagdoll(playerPed, true)
end

CreateThread(function()
	while true do
		Wait(0)

		local playerPed = PlayerPedId()
		if not DoesEntityExist(playerPed) then goto continue end

		-- Make it harder to get knocked off bikes; helps staying upright
		SetPedCanBeKnockedOffVehicle(playerPed, 1) -- 1 = KNOCKOFFVEHICLE_NEVER

		if IsPedInAnyVehicle(playerPed, false) then
			wasInVehicle = true
		else
			if wasInVehicle then
				wasInVehicle = false
				preventRagdollAndStand(playerPed)
			end
		end

		::continue::
	end
end)

