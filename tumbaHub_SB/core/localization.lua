-- core/localization.lua
-- Mega.Localization table and GetText function

Mega.Localization = {
    CurrentLanguage = "en", -- Default, will be overwritten by loaded setting
    Strings = {
        -- Loader Phases (Titan Engine v3.0)
        ["phase_network"] = { ru = "РУКОПОЖАТИЕ (СЕТЬ)", en = "HANDSHAKE (NETWORK)", es = "APRETÓN DE MANOS", pt = "APERTO DE MÃO", ko = "핸드셰이크 (네트워크)", ja = "ハンドシェイク (ネットワーク)", uk = "РУКОСТИСКАННЯ (МЕРЕЖА)" },
        ["phase_core"] = { ru = "СБОРКА ОКРУЖЕНИЯ", en = "BUILDING CORE", es = "CONSTRUYENDO NÚCLEO", pt = "CONSTRUINDO NÚCLEO", ko = "핵심 구축", ja = "コア構築", uk = "ЗБІРКА ЯДРА" },
        ["phase_features"] = { ru = "СИНХРОНИЗАЦИЯ ФУНКЦИЙ", en = "SYNCING FEATURES", es = "SINCRONIZANDO FUNCIONES", pt = "SINCRONIZANDO FUNÇÕES", ko = "기능 동기화", ja = "機能の同期", uk = "СИНХРОНІЗАЦІЯ ФУНКЦІЙ" },
        ["phase_ui"] = { ru = "ФИНАЛИЗАЦИЯ ИНТЕРФЕЙСА", en = "FINALIZING INTERFACE", es = "FINALIZANDO INTERFAZ", pt = "FINALIZANDO INTERFACE", ko = "인터페이스 마무리", ja = "インターフェース完了", uk = "ФІНАЛІЗАЦІЯ ІНТЕРФЕЙСУ" },
        ["loader_ready"] = { ru = "СИСТЕМА ГОТОВА к ЗАПУСКУ", en = "SYSTEM READY FOR LAUNCH", es = "SISTEMA LISTO", pt = "SISTEMA PRONTO", ko = "시스템 실행 준비 완료", ja = "システムの準備完了", uk = "СИСТЕМА ГОТОВА ДО ЗАПУСКУ" },

        -- Notifications

        ["Игроки (через запятую)"] = { ru = "Игроки (через запятую)", en = "Players (comma separated)" },
        ["None"] = { ru = "Выкл (Off)", en = "None" },
        ["Whitelist"] = { ru = "Белый список (Whitelist)", en = "Whitelist" },
        ["Blacklist"] = { ru = "Черный список (Blacklist)", en = "Blacklist" }
    }
}

--- Returns the localized text for a given key.
---@param key string
---@vararg any
---@return string
function Mega.GetText(key, ...)
    local lang = Mega.Localization.CurrentLanguage
    local str = Mega.Localization.Strings[key]

    if str and str[lang] then
        local text = str[lang]
        local args = {...}
        if #args > 0 then
            -- Use pcall for safety in case of formatting errors
            local success, result = pcall(string.format, text, ...)
            if success then
                return result
            else
                return text -- Return raw text on format error
            end
        else
            return text
        end
    else
        return key -- Return key if no translation is found
    end
end

function Mega.SaveLanguage(lang)
    if writefile then
        if not isfolder("tumbaHub") then pcall(makefolder, "tumbaHub") end
        if not isfolder("tumbaHub/configs") then pcall(makefolder, "tumbaHub/configs") end
        pcall(writefile, "tumbaHub/configs/Language.txt", lang)
    end
end

function Mega.LoadLanguage()
    if readfile and isfile then
        if isfile("tumbaHub/configs/Language.txt") then
            local success, lang = pcall(readfile, "tumbaHub/configs/Language.txt")
            if success and lang then return lang end
        elseif isfile("TumbaLanguage.txt") then
            local success, lang = pcall(readfile, "TumbaLanguage.txt")
            if success and lang then 
                Mega.SaveLanguage(lang) -- Переносим в новую папку
                return lang 
            end
        end
    end
    return "en" -- Default to English if loading fails
end

-- Load saved language on startup
Mega.Localization.CurrentLanguage = Mega.LoadLanguage()

function Mega.HasSavedLanguage()
    return (isfile and (isfile("tumbaHub/configs/Language.txt") or isfile("TumbaLanguage.txt")))
end
