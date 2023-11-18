local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RStorage = game:GetService("ReplicatedStorage")

local GameEvent = RStorage:WaitForChild("Event")

local function FetchClosestEnemyPlane()
	if Player.Character and Player.Character.PrimaryPart then
		local PlayerTeam = tostring(Player.Team.Name)
		
		local ClosestPlane --Instance
		local Magnitude = math.huge
		for _, v in pairs(workspace:GetChildren()) do 
			if v.Name == "Bomber" or v.Name == "Torpedo Bomber" or v.Name == "Large Bomber" and v:FindFirstChild("Seat") and Player.Character.PrimaryPart then
				local Plane = v
				local OwnerTeam = Plane:WaitForChild("Team", 2)
				
				if OwnerTeam ~= nil and OwnerTeam:IsA("StringValue") then
					if OwnerTeam.Value ~= PlayerTeam then 
						local Distance = (Vector3.new(Player.Character.PrimaryPart.Position.X, 10, Player.Character.PrimaryPart.Position.Z) - Vector3.new(Plane.Seat.Position.X, 10, Plane.Seat.Position.Z)).Magnitude
						if Distance < Magnitude then 
							Magnitude = Distance
							ClosestPlane = Plane
						end
					end
				end
			end
		end
		return ClosestPlane
	end
	return nil
end

_G.IsShooting = false
local MT = getrawmetatable(game)
local Old = MT.__namecall
setreadonly(MT, false)
MT.__namecall = newcclosure(function(Remote, ...) 
    local Args = {...}
    local Method = getnamecallmethod()
    if Remote.Name == "Event" and Method == "FireServer" then
        if Args[1] ~= nil and Args[1] == "shoot" and Args[2][1] ~= nil and typeof(Args[2][1]) == "boolean" and Args[2][1] == true then 
			GameEvent[Method](Remote, "shoot", {[1] = true})
			_G.IsShooting = true
			coroutine.resume(coroutine.create(function()
				while _G.IsShooting == true do 
					local Closest = FetchClosestEnemyPlane()
					if Closest ~= nil then
						GameEvent[Method]( Remote, "aim", {[1] = Closest.Seat.Position + (Closest.Seat.Velocity * (Player:GetNetworkPing() / 100 * 18) ) } )
						task.wait(0.1)
					end
				end
			end))
		elseif Args[1] ~= nil and Args[1] == "shoot" and Args[2][1] ~= nil and typeof(Args[2][1]) == "boolean" and Args[2][1] == false then
			_G.IsShooting = false		
			return GameEvent[Method](Remote, "shoot", {[1] = false})
		end
    end
    return Old(Remote, ...)
end)
setreadonly(MT, true)
