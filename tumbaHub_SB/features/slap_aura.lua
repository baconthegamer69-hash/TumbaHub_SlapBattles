-- features/slap_aura.lua
-- Slap Aura logic for Slap Battles

if not Mega.Features then Mega.Features = {} end
Mega.Features.SlapAura = {}

local Services = Mega.Services
local LocalPlayer = Services.LocalPlayer
local States = Mega.States

-- Защита от отсутствующих настроек
if not States.Combat then States.Combat = {} end
if type(States.Combat.SlapAura) ~= "table" then
    States.Combat.SlapAura = { Enabled = false, Range = 15, Delay = 100 }
end

if not Mega.Objects.Connections then Mega.Objects.Connections = {} end
local connections = Mega.Objects.Connections

-- Функция для получения нужного ремоута
local function getHitRemote()
    local gloveName = nil
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Glove") then
        gloveName = leaderstats.Glove.Value
    end
    
    if not gloveName and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then gloveName = tool.Name end
    end
    
    if not gloveName or gloveName == "Default" then
        return Services.ReplicatedStorage:FindFirstChild("b")
    end
    
    local formattedGloveName = string.gsub(gloveName, " ", "")
    local possibleNames = {
        formattedGloveName .. "hit",
        string.lower(formattedGloveName) .. "hit",
        "b"
    }
    
    for _, name in ipairs(possibleNames) do
        local remote = Services.ReplicatedStorage:FindFirstChild(name)
        if remote and remote:IsA("RemoteEvent") then return remote end
    end
    return Services.ReplicatedStorage:FindFirstChild("b")
end

-- Главный цикл Ауры
local lastSlapTime = 0

local function SlapAuraLoop()
    if not States.Combat.SlapAura.Enabled then return end
    
    local delaySec = (States.Combat.SlapAura.Delay or 100) / 1000
    if tick() - lastSlapTime < delaySec then return end
    
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local range = States.Combat.SlapAura.Range or 15
    local hitRemote = getHitRemote()
    if not hitRemote then return end
    
    local hasSlapped = false
    
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hum = player.Character:FindFirstChild("Humanoid")
            local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and targetPart then
                local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist <= range then
                    hitRemote:FireServer(targetPart)
                    hasSlapped = true
                end
            end
        end
    end
    
    if hasSlapped then
        lastSlapTime = tick()
    end
end

function Mega.Features.SlapAura.SetEnabled(state)
    States.Combat.SlapAura.Enabled = state
    if state then
        if not connections.SlapAuraLoop then
            connections.SlapAuraLoop = Services.RunService.Heartbeat:Connect(SlapAuraLoop)
        end
    else
        if connections.SlapAuraLoop then
            connections.SlapAuraLoop:Disconnect()
            connections.SlapAuraLoop = nil
        end
    end
end

if States.Combat.SlapAura.Enabled then
    Mega.Features.SlapAura.SetEnabled(true)
end