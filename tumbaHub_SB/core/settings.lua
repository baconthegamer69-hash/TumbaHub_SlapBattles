-- core/settings.lua
-- Contains all default settings, states, and database structures.

Mega.VERSION = "5.0.1" -- Refactored version
Mega.BUILD_DATE = "2024.03.02"
Mega.DEVELOPER = "I.S.-1"
Mega.SPECIAL_THANKS = "N.User-1"

Mega.Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(12, 12, 18),
        SidebarColor = Color3.fromRGB(15, 15, 22),
        ElementColor = Color3.fromRGB(20, 20, 30), 
        ElementHoverColor = Color3.fromRGB(35, 35, 45),
        ToggleOffColor = Color3.fromRGB(60, 60, 80),
        AccentColor = Color3.fromRGB(200, 70, 255),
        SecondaryColor = Color3.fromRGB(0, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextMutedColor = Color3.fromRGB(150, 150, 170),
        IconColor = Color3.fromRGB(150, 150, 170),
        IconActiveColor = Color3.new(1, 1, 1),
        SectionGradient1 = Color3.fromRGB(15, 15, 25),
        SectionGradient2 = Color3.fromRGB(10, 10, 20)
    },
    Vanilla = {
        BackgroundColor = Color3.fromRGB(245, 245, 248),
        SidebarColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(230, 230, 235),
        ElementHoverColor = Color3.fromRGB(215, 215, 220),
        ToggleOffColor = Color3.fromRGB(200, 200, 205),
        AccentColor = Color3.fromRGB(80, 160, 255), -- Pastel blue
        SecondaryColor = Color3.fromRGB(255, 130, 130),
        TextColor = Color3.fromRGB(40, 40, 45),
        TextMutedColor = Color3.fromRGB(130, 130, 140),
        IconColor = Color3.fromRGB(130, 130, 140),
        IconActiveColor = Color3.fromRGB(30, 30, 35),
        SectionGradient1 = Color3.fromRGB(240, 240, 245),
        SectionGradient2 = Color3.fromRGB(230, 230, 235)
    }
}

Mega.Settings = {
    Menu = {
        Width = 950,
        Height = 550,
        CurrentTheme = "Dark",
        Transparency = 0.1,
        CornerRadius = 12,
        AnimationSpeed = 0.25
    },
    System = {
        AntiAFK = true,
        AutoSave = true,
        PerformanceMode = false,
        DebugMode = false,
        Logging = true,
        ShowStatusIndicator = true
    },
    StatusIndicator = {
        RainbowMode = true,
        Scale = 14
    }
}

Mega.States = {
    Keybinds = {
        Menu = "RightShift"
    }
}

function Mega.SetTheme(themeName)
    local theme = Mega.Themes[themeName] or Mega.Themes.Dark
    Mega.Settings.Menu.CurrentTheme = themeName
    for k, v in pairs(theme) do
        Mega.Settings.Menu[k] = v
    end
end

-- Инициализируем стандартную тему
Mega.SetTheme(Mega.Settings.Menu.CurrentTheme)

Mega.Database = {
    Stats = {
        Kills = 0,
        Deaths = 0,
        Headshots = 0,
        PlayTime = 0
    }
}
