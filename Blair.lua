local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local InvRemotes = Remotes:WaitForChild("InventoryRemotes")
local Action = InvRemotes:WaitForChild("Action")

local Map = workspace:WaitForChild("Map")
local Zones = Map:WaitForChild("Zones")
local Prints = Map:WaitForChild("Prints")
local Orbs = Map:WaitForChild("Orbs")
local Items = Map:WaitForChild("Items")
local Van = Map:WaitForChild("Van", 2)

local FirePrompt = fireproximityprompt

print([[


///////
]])
print("1. initiating functions.")
-- searches a instance for a certain instances that have the same name as the "Name" input and has the same class as the "Class" input. the "Method" input is how the script will search for it.
local function Search(Parent, Name, Class, Method)
    if Parent ~= nil and Name ~= nil and Class ~= nil and Method ~= nil and typeof(Parent) == "Instance" and typeof(Name) == "string" and typeof(Class) == "string" and typeof(Method) == "string" then
        if Method == "GetDescendants" then
            local Table = {}
            for i, v in pairs(Parent:GetDescendants()) do 
                if v ~= nil and v.Name == Name and v:IsA(Class) then
                    table.insert(Table,  v)
                    task.wait()
                end
            end
            return Table
        elseif Method == "GetChildren" then
            local Table = {}
            for i, v in pairs(Parent:GetChildren()) do 
                if v ~= nil and v.Name == Name and v:IsA(Class) then
                    table.insert(Table,  v)
                    task.wait()
                end
            end
            return Table
        elseif Method ~= "GetChildren" and Method ~= "GetDescendants" then
            local Table = {}
            for i, v in pairs(Parent:GetDescendants()) do 
                if v ~= nil and v.Name == Name and v:IsA(Class) then
                    table.insert(Table,  v)
                    task.wait()
                end
            end
            return Table
        end
    end
end

-- tries to fetch a item from the "Items" folder.
local function GetItem(ItemName, PartialName, Toggle)
    if ItemName ~= nil and PartialName ~= nil and Toggle ~= nil then
        if typeof(ItemName) == "string" and typeof(PartialName) == "string" and typeof(Toggle) == "boolean" then
            if Toggle then
                task.wait()
                local SearchTable = Search(Items, PartialName, "Tool", "GetChildren")

                if SearchTable[1] ~= nil then
                    return SearchTable
                end
                return false
            elseif not Toggle then
                task.wait()
                local Item = Items:FindFirstChild(ItemName)

                if Item ~= nil then
                    return Item
                end
                return false
            end
        end
        return false
    end
end

-- gets lowest temperature ingame.
local function GetLowestTemp()
    local Temps = Search(Zones, "Temperature", "NumberValue", "GetDescendants")

    local LowestNum = math.huge
    local Zone = nil
    for _, Value in pairs(Temps) do
        if Value.Value < LowestNum then
            LowestNum = Value.Value
            Zone = Value.Parent
        end
    end
    print("    fetched")
    return LowestNum, Zone
end

-- gets highest emf value.
local function GetHighestEMF(Type)
    if Type == 0 then
        local EMFValues = Search(Zones, "EMF", "IntValue", "GetDescendants")

        local HighestNum = -math.huge
        local Zone = nil
        for _, Value in pairs(EMFValues) do
            if Value.Value > HighestNum then
                HighestNum = Value.Value
                Zone = Value.Parent
            end
        end
        return HighestNum, Zone
    elseif Type == 1 then
        local EMFValues = Search(Zones, "EMF", "IntValue", "GetDescendants")

        local HighestNum = -math.huge
        local Zone = nil
        for _, Value in pairs(EMFValues) do
            if Value.Value > HighestNum then
                HighestNum = Value.Value
                Zone = Value.Parent
            end
        end
        print("    fetched")
        return HighestNum, Zone
    end
end

-- checks for if orbs or prints(finger prints) exist.
local function OrbsAndPrints()
    local PrintsTable = Search(Prints, "PrintPart", "BasePart", "GetChildren")
    local OrbsTable = Search(Orbs, "OrbPart", "BasePart", "GetChildren")

    local IsThereTable = {
        ["Prints"] = false,
        ["Orbs"] = false
    }

    for i, v in pairs(PrintsTable) do 
        if v ~= nil and v.Name == "PrintPart" then
            IsThereTable["Prints"] = true
            break
        end
    end
    for i, v in pairs(OrbsTable) do 
        if v ~= nil and v.Name == "OrbPart" then
            IsThereTable["Orbs"] = true
            break
        end
    end
    print("    fetched")
    return IsThereTable
end

-- gets main ghost room.
local function GetMainRoom()
    local MainTable = Search(Zones, "IsMainRoom", "BoolValue", "GetDescendants")

    local Zone = nil
    for _, MainInstance in pairs(MainTable) do
        if MainInstance ~= nil then
            Zone = MainInstance.Parent
            break
        end
    end
    print("    fetched")
    return Zone
end

-- checks for if a EMF value is higher than 1(1.1), if so then it returns true, if not, it will return false.
local function CanContinue()
    local CanDo = false

    local Number, EMFZone = GetHighestEMF(0)
    if Number ~= nil then
        if Number > 1.1 then
            CanDo = true
        end
    end
    return CanDo
end

local function Main()
    wait(1)
    print("2. executing 'Main' function.")
    
    -- checks for if the van door has been open or hasn't been open yet, if not open, then it opens it.
    local VanPrompt = Van:WaitForChild("Van"):WaitForChild("Door"):WaitForChild("Center"):FindFirstChild("ProximityPrompt")
    if VanPrompt then
        repeat task.wait(0.1) until Player.Character ~= nil
        repeat FirePrompt(VanPrompt) task.wait(0.1) until VanPrompt == nil or VanPrompt.Parent == nil
    end

    repeat task.wait(0.1) until CanContinue() == true
    print("3. continuing.")

    -- getting information about what exist after one of the emf values reach a value higher than 1.
    print("4. fetching some basic info")
    local IsThere = OrbsAndPrints()
    local MainRoom = GetMainRoom()
    local LowestTemp, TempZone = GetLowestTemp()
    local HighestEMF, EMFZone = GetHighestEMF(1)

    -- tries to get book and spirit box from the "GetItem" function.
    print("5. trying to get book and spirit box.")
    local Book = GetItem("Ghost Writing Book", "Ghost Writing Book", true)
    local SpiritBox = GetItem("Spirit Box", "Spirit Box", true)

    if Book == nil or SpiritBox == nil then
        repeat 
            -- if book isn't in the "Items" folder, it will wait until it is parented to it.
            print("    trying again.")
            Book = GetItem("Ghost Writing Book", "Ghost Writing Book", true)
            SpiritBox = GetItem("Spirit Box", "Spirit Box", true)
            task.wait(0.1)
        until Book ~= nil and SpiritBox ~= nil and Book:IsA("Tool") and SpiritBox:IsA("Tool")
        
        local BookHandle = Book:WaitForChild("Handle")
        local BPrompt = BookHandle:WaitForChild("NewPickupPrompt")

        -- repeats trying to pickup the book up and dropping it to make it unanchored, then teleporting it to the main room from the "GetMainRoom" function. won't try to teleport if the book's handle has "AlreadyTeleported" value.
        if not BookHandle:FindFirstChild("AlreadyTeleported") then
            print("/ creating teleported book value.")
            local Val = Instance.new("IntValue", BookHandle)
            Val.Name = "AlreadyTeleported"

            repeat 
                FirePrompt(BPrompt) 
                task.wait(0.1) 
            until Player.Character:FindFirstChild(Book.Name)
            print("/ grabbed book.")
            print("/ dropping book.")
            Action:FireServer("Drop")
            repeat 
                task.wait() 
            until not Player.Character:FindFirstChild(Book.Name)
            print("/ teleporting book.")
            BookHandle.CFrame = MainRoom.CFrame
        end

        task.wait()

        -- some basic logic stuff.
        local OrbsExist = "No"
        local PrintsExist = "No"
        if IsThere["Orbs"] then
            OrbsExist = "Yes"
        end
        if IsThere["Prints"] then
            OrbsExist = "Yes"
        end

        -- string that contains analytics about what exist and stuff.
        print("6. creating analysis.")
        local AnalysisString = (tostring([[
            
            Script Analysis:
                Main Room: %s,
                Lowest Current Temp: %s, 
                Highest Current EMF Value: %s,
                Do Orbs exist?: %s,
                Do finger prints exist?: %s
        ]]):format(MainRoom.Name, tostring(LowestTemp), tostring(HighestEMF), OrbsExist, PrintsExist))
        print(AnalysisString)
    end
end

Main()
