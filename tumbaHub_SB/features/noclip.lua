-- features/noclip.lua
if not Mega.Features then Mega.Features = {} end
Mega.Features.NoClip = {}

local Services = Mega.Services
local LocalPlayer = Services.LocalPlayer
local connections = Mega.Objects.Connections

local function NoClipLoop()
    if not Mega.States.Player.NoClip then return end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

function Mega.Features.NoClip.SetEnabled(state)
    if state then
        if not connections.NoClipLoop then
            connections.NoClipLoop = Services.RunService.Stepped:Connect(NoClipLoop)
        end
    else
        if connections.NoClipLoop then
            connections.NoClipLoop:Disconnect()
            connections.NoClipLoop = nil
        end
    end
end