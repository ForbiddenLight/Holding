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
    end
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
            break
        end
    end
    for i, v in pairs(OrbsTable) do 
        if v ~= nil and v.Name == "OrbPart" then
            IsThereTable["Orbs"] = true
            break
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
            break
        end
    end
    return Zone
end

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

local Decimals = 4
local Clock = os.clock()
local ValueText = "Value Is Now :"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dohmai/Tokyo/main/Libraries/UI"))({
    cheatname = "Enlightment", -- watermark text
    gamename = "Blair", -- watermark text
})
Library:init()

local Window1  = Library.NewWindow({
    title = "Enlightment | Enlightment", -- Mainwindow Text
    size = UDim2.new(0, 510, 0.6, 6
)})

local Tab1 = Window1:AddTab("  Blair Stuff  ")
local SettingsTab = Library:CreateSettingsTab(Window1)

local Section1 = Tab1:AddSection("Section 1", 1)

Section1:AddButton({
    enabled = true,
    text = "Info Check",
    tooltip = "Checks for some current evidence.",
    confirm = true,
    risky = false,
    callback = function()
        local IsThere = OrbsAndPrints()
        local MainRoom = GetMainRoom()
        local LowestTemp, TempZone = GetLowestTemp()
        local HighestEMF, EMFZone = GetHighestEMF()

        local OrbsExist = "No"
        local PrintsExist = "No"
        if IsThere["Orbs"] then
            OrbsExist = "Yes"
        end
        if IsThere["Prints"] then
            OrbsExist = "Yes"
        end

        local AnalysisString = (tostring([[
            Script Analysis:
                Main Room: %s,
                Lowest Current Temp: %s, 
                Highest Current EMF Value: %s,
                Do Orbs exist currently?: %s,
                Do finger prints exist currently?: %s
        ]]):format(MainRoom.Name, tostring(LowestTemp), tostring(HighestEMF), OrbsExist, PrintsExist))

        Library:SendNotification(AnalysisString, 10)
    end
})

local Time = (string.format("%."..tostring(Decimals).."f", os.clock() - Clock))
Library:SendNotification(("Loaded In "..tostring(Time)), 5)
