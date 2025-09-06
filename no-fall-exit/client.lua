local wasInVehicle = false
local protectionActiveUntil = 0

CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			wasInVehicle = true
		else
			if wasInVehicle then
				local veh = GetVehiclePedIsIn(ped, true)
				local speed = 0.0
				if veh ~= 0 then
					speed = GetEntitySpeed(veh)
				end

				if IsPedJumpingOutOfVehicle(ped) or IsEntityInAir(ped) or speed > 2.0 then
					SetPedCanRagdoll(ped, false)
					SetPedRagdollOnCollision(ped, false)
					SetEntityInvincible(ped, true)
					protectionActiveUntil = GetGameTimer() + 3000

					while (IsEntityInAir(ped) or IsPedFalling(ped) or IsPedRagdoll(ped)) and GetGameTimer() < protectionActiveUntil do
						Wait(0)
						ped = PlayerPedId()
						SetPedCanRagdoll(ped, false)
						SetPedRagdollOnCollision(ped, false)
					end

					ClearPedTasksImmediately(ped)
					TaskStandStill(ped, 0)
					SetEntityInvincible(ped, false)
					SetPedCanRagdoll(ped, true)
					SetPedRagdollOnCollision(ped, true)
				end

				wasInVehicle = false
			else
				if protectionActiveUntil > GetGameTimer() then
					SetPedCanRagdoll(ped, false)
					SetPedRagdollOnCollision(ped, false)
				else
					SetPedCanRagdoll(ped, true)
					SetPedRagdollOnCollision(ped, true)
				end
			end
		end
	end
end)

