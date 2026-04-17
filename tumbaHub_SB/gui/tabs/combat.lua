-- gui/tabs/combat.lua
-- Вкладка Combat для игры Slap Battles

local tabKey = "tab_combat"
local UI = Mega.UI

local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Name = tabKey
TabFrame.Size = UDim2.new(1, 0, 1, 0)
TabFrame.BackgroundTransparency = 1
TabFrame.BorderSizePixel = 0
TabFrame.ScrollBarThickness = 4
TabFrame.ScrollBarImageColor3 = Mega.Settings.Menu.AccentColor
TabFrame.Visible = false
TabFrame.Parent = Mega.Objects.ContentContainer

local ContentLayout = Instance.new("UIListLayout", TabFrame)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)
end)
TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)

Mega.Objects.TabFrames[tabKey] = TabFrame

-- Загружаем логику в фоне
task.spawn(function()
    pcall(function() Mega.LoadModule("features/slap_aura.lua") end)
end)

-- Создаем секцию и переключатель с настройками
UI.CreateSection(TabFrame, "COMBAT")

UI.CreateToggleWithSettings(TabFrame, "Slap Aura", "Combat.SlapAura.Enabled", function(state)
    Mega.States.Combat.SlapAura.Enabled = state
    if Mega.Features.SlapAura and Mega.Features.SlapAura.SetEnabled then Mega.Features.SlapAura.SetEnabled(state) end
end, {
    UI.CreateSlider(nil, "Радиус (Range)", "Combat.SlapAura.Range", 5, 50),
    UI.CreateSlider(nil, "Задержка (Delay ms)", "Combat.SlapAura.Delay", 0, 1000)
})