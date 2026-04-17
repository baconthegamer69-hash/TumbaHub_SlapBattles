-- features/fly.lua
if not Mega.Features then Mega.Features = {} end
Mega.Features.Fly = {}

local Services = Mega.Services
local LocalPlayer = Services.LocalPlayer
local connections = Mega.Objects.Connections

local bodyVelocity = nil

local function getMoveDirection()
    local moveDir = Vector3.new()
    local cam = workspace.CurrentCamera
    if not cam then return moveDir end

    local uis = Services.UserInputService
    local w = uis:IsKeyDown(Enum.KeyCode.W)
    local s = uis:IsKeyDown(Enum.KeyCode.S)
    local a = uis:IsKeyDown(Enum.KeyCode.A)
    local d = uis:IsKeyDown(Enum.KeyCode.D)
    
    if w then moveDir = moveDir + cam.CFrame.LookVector end
    if s then moveDir = moveDir - cam.CFrame.LookVector end
    if a then moveDir = moveDir - cam.CFrame.RightVector end
    if d then moveDir = moveDir + cam.CFrame.RightVector end
    
    return moveDir
end

local function FlyLoop(dt)
    if not Mega.States.Player.Fly or not Mega.States.Player.Fly.Enabled then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local speed = Mega.States.Player.Fly.Speed or 50
    local moveDir = getMoveDirection()
    
    if not bodyVelocity or not bodyVelocity.Parent then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "TumbaFly"
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = hrp
    end
    
    local finalVelocity = Vector3.new(0, 0, 0)
    if moveDir.Magnitude > 0 then finalVelocity = moveDir.Unit * speed end
    bodyVelocity.Velocity = finalVelocity
    
    if Mega.States.Player.Fly.Mode == "CFrame" and moveDir.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (moveDir.Unit * (speed * dt))
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        hrp.Velocity = Vector3.new(0,0,0)
    end
end

function Mega.Features.Fly.SetEnabled(state)
    if state then if not connections.FlyLoop then connections.FlyLoop = Services.RunService.Heartbeat:Connect(FlyLoop) end
    else if connections.FlyLoop then connections.FlyLoop:Disconnect() connections.FlyLoop = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end end
end