local MT = getrawmetatable(game)
local Old = MT.__namecall
setreadonly(MT, false)
MT.__namecall = newcclosure(function(Remote, ...) 
    local Args = {...}
    local Method = getnamecallmethod()
    if Remote.Name == "InflictTarget" and Method == "InvokeServer" then
        local Parent = Args[9].Parent
        if Parent ~= nil and Parent:FindFirstChild("Head") and Args[9].Name ~= "Head" then
            Args[9] = Parent:FindFirstChild("Head") -- Hit
        end

        Args[10][2][1] = 149403223 -- SoundID // Original Audio: 1930359546

        Args[6][1] = 1000 -- Damage

        Args[10][1] = true -- Toggle Gore
        Args[10][3] = 1
        Args[10][4] = 1.5
        Args[10][5] = 1 -- Loudness
        Args[10][7] = 1000 -- Chance
        return Remote.InvokeServer(Remote, unpack(Args))
    end
    return Old(Remote, ...)
end)
setreadonly(MT, true)
