local themeManager = {}

themeManager.themes = {
    luau = {
        primary = {0.5, 0.2, 0.8}, -- Purple
        secondary = {0.3, 0.1, 0.5},
        accent = {0.7, 0.4, 1.0},
        text = {1, 1, 1},
        background = {0.1, 0.05, 0.15}
    },
    csharp = {
        primary = {0.2, 0.5, 0.8}, -- Blue
        secondary = {0.1, 0.3, 0.5},
        accent = {0.4, 0.7, 1.0},
        text = {1, 1, 1},
        background = {0.05, 0.1, 0.15}
    },
    ui = {
        theory = {0.15, 0.15, 0.2},
        example = {0.1, 0.2, 0.1},
        correct = {0.2, 0.8, 0.2},
        incorrect = {0.8, 0.2, 0.2},
        panel = {0.1, 0.1, 0.1, 0.9},
        button = {0.2, 0.2, 0.2},
        button_hover = {0.3, 0.3, 0.3}
    }
}

themeManager.currentTheme = themeManager.themes.luau

function themeManager.setTheme(name)
    if themeManager.themes[name] then
        themeManager.currentTheme = themeManager.themes[name]
    end
end

function themeManager.getColor(key)
    return themeManager.currentTheme[key] or themeManager.themes.ui[key] or {1, 1, 1}
end

return themeManager
