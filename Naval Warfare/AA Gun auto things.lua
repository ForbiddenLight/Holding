local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RStorage = game:GetService("ReplicatedStorage")
local PlayerInput = game:GetService("UserInputService")

_G.Type = "Planes"
if _G.TypeChanger then 
	_G.TypeChanger:Disconnect()
end

_G.TypeChanger = PlayerInput.InputBegan:Connect(function(Key, Process)
	if Key.KeyCode == Enum.KeyCode.L and not Process then 
		local Type = tostring(_G.Type)
		
		if Type == "Planes" then 
			Type = "Players"
		elseif Type == "Players" then 
			Type = "Planes"
		end
		_G.Type = Type
	end
end)

local GameEvent = RStorage:WaitForChild("Event")

local function FetchClosest()
	if Player.Character and Player.Character.PrimaryPart then
		local PlayerTeam = tostring(Player.Team.Name)
		
		if Type == "Planes" then 
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
			return ClosestPlane.MainBody
		elseif Type == "Players" then 
			local ClosestPlayer --Instance
			local Magnitude = math.huge
			for _, v in pairs(Players:GetPlayers()) do 
				if Player.Character and Player.Character.PrimaryPart and v.Character and v.Character.PrimaryPart then
					local Target = v
					local Char = Target.Character
					local OwnerTeam = tostring(Target.Team.Name)
					
					if OwnerTeam ~= nil then
						if OwnerTeam ~= PlayerTeam then 
							local Distance = (Vector3.new(Player.Character.PrimaryPart.Position.X, 10, Player.Character.PrimaryPart.Position.Z) - Vector3.new(Char.PrimaryPart.Position.X, 10, Char.PrimaryPart.Position.Z)).Magnitude
							if Distance < Magnitude then 
								Magnitude = Distance
								ClosestPlayer = Char
							end
						end
					end
				end
			end
			return ClosestPlayer.PrimaryPart
		end
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
			_G.IsShooting = true
			coroutine.resume(coroutine.create(function()
				while _G.IsShooting == true do 
					local Closest = FetchClosest()
					if Closest ~= nil then
						GameEvent[Method]( Remote, "aim", {[1] = Closest.Position + (Closest.Velocity * (Player:GetNetworkPing() / 100 * 18.2) ) } )
						task.wait(0.1)
					end
				end
			end))
			return GameEvent[Method](Remote, "shoot", {[1] = true})
		elseif Args[1] ~= nil and Args[1] == "shoot" and Args[2][1] ~= nil and typeof(Args[2][1]) == "boolean" and Args[2][1] == false then
			_G.IsShooting = false		
			return GameEvent[Method](Remote, "shoot", {[1] = false})
		end
    end
    return Old(Remote, ...)
end)
setreadonly(MT, true)
