local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "HELL Test", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "Counter Blox",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

getgenv().TeamCheck = true
getgenv().Enabled = false
getgenv().AimlockToggled = false

function cresp(target, color)
    local highlight = Instance.new("Highlight", target)
    highlight.Name = "LickMyItchyBalls"
    highlight.FillTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Enabled = true
end

function desp()
    for i,v in pairs(game.Players:GetChildren()) do
        local chms = v.Character:WaitForChild("LickMyItchyBalls")
        if chms ~= nil then
            chms:Destoy()
        end
    end
end

Tab:AddToggle({
	Name = "Chams",
	Default = false,
	Callback = function(t)
        Enabled = t
    end    
})

while true do wait(1)
    if Enabled then
        for i,v in pairs(game.Players:GetChildren()) do
            if TeamCheck then
                if v.Team.Name == "Counter-Terrorists" then
                    cresp(v.Character, Color3.fromRGB(62, 88, 235))
                elseif v.Team.Name == "Terrorists" then
                    cresp(v.Character, Color3.fromRGB(227, 243, 87))
                end
            else
                cresp(v.Character, Color3.fromRGB(255,255,255))
            end
        end
    else
        desp()
    end
end

Tab:AddToggle({
	Name = "Aimlock",
	Default = false,
	Callback = function(t)
        AimlockToggled = t
    end    
})

getgenv().Settings = {

    closestplayer = "";
    Turn = false;
    
}

local camera = game:GetService("Workspace").Camera
local UIS = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

function GetPlayer()
    local closestDistance = math.huge
    local closestPlayer = nil
    for i, v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team and v.Character ~= nil and AimlockToggled then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = v
                Settings.closestplayer = v.Name
            end
        end
    end
end

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 and AimlockToggled then
        Settings.Turn = true
        while wait(0) do
            GetPlayer()
            local findpl = game.Players:FindFirstChild(Settings.closestplayer)
            if findpl.Character ~= nil then
                local goal = {}
                goal.CFrame = CFrame.new(camera.CFrame.Position, findpl.Character.Head.Position)
                local tweeninfo = TweenInfo.new(0.05)

                local tween = ts:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweeninfo, goal)
                camera.CFrame = CFrame.new(camera.CFrame.Position, findpl.Character.Head.Position)
            end
            if Settings.Turn == false then return end
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Settings.Turn = false
    end
end)