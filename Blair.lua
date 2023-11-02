local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Zones = workspace.Map:WaitForChild("Zones")
local Prints = workspace.Map:WaitForChild("Prints")
local Orbs = workspace.Map:WaitForChild("Orbs")
local Items = workspace.Map:WaitForChild("Items")

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

local function GetItem(ItemName, PartialName, Toggle)
    if ItemName ~= nil and PartialName ~= nil and Toggle ~= nil then
        if typeof(ItemName) == "string" and typeof(PartialName) == "string" and typeof(Toggle) == "boolean" then
            if Toggle then
                local SearchTable = Search(Items, PartialName, "Tool")

                if SearchTable[1] ~= nil then
                    return SearchTable
                end
                return false
            end
        end
    end
end

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
    return LowestNum, Zone
end

local function GetHighestEMF()
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
end

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
        end
    end
    for i, v in pairs(OrbsTable) do 
        if v ~= nil and v.Name == "OrbPart" then
            IsThereTable["Orbs"] = true
        end
    end
    return IsThereTable
end

local function GetMainRoom()
    local MainTable = Search(Zones, "IsMainRoom", "BoolValue", "GetDescendants")

    local Zone = nil
    for _, MainInstance in pairs(MainTable) do
        if MainInstance ~= nil then
            Zone = MainInstance.Parent
        end
    end
    return Zone
end
